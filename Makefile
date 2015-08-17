### Makefile                                     -*- Makefile-gmake -*-

## Copyright (C) 2005, 2006, 2007 Michaël Cadilhac, Johan Oudinet - LRDE.

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## A copy of the license is provided in the file COPYING.DOC.

include Makefile.inc

################# You should not modify this Makefile but the inc one.
######################################################################
#################################################### Compute variables

$(foreach dir,$(SOURCES_dirs),		\
  $(eval SOURCES += $(addprefix $(dir)/,$($(subst /,_,SOURCES_$(dir))))))

######################################################### Global rules

all: $(PROJECT).$(DEFAULT_FORMAT)

view: view-$(DEFAULT_FORMAT)


#################################################### Compilation rules

pdf: $(PROJECT).pdf

dvi: $(PROJECT).dvi

ps:  $(PROJECT).ps

pspdf: $(PROJECT).ps
	[ $(PROJECT).pdf -nt $(PROJECT).ps ] || $(PS2PDF) $(PROJECT).ps

$(PROJECT).pdf: $(SOURCES)
	$(TEXI2PDF) $(TEXI2DVI_flags) $(SOURCES_comp)
	newname=$(notdir $(SOURCES_comp:.tex=.pdf));		\
	test "$$newname" = $(PROJECT).pdf || mv -f "$$newname" $(PROJECT).pdf


$(PROJECT).dvi: $(SOURCES)
	$(TEXI2DVI) $(TEXI2DVI_flags) $(SOURCES_comp)
	newname=$(notdir $(SOURCES_comp:.tex=.dvi));		\
	test "$$newname" = $(PROJECT).dvi || mv -f "$$newname" $(PROJECT).dvi

$(PROJECT).ps: $(PROJECT).dvi
	$(DVI2PS) $(PROJECT).dvi -o $(PROJECT).ps


################################################### Glossary and index

GLOSSARY_file := $(notdir $(SOURCES_comp:.tex=.glx))

gloss: $(GLOSSARY_file)
glosstex: $(GLOSSARY_file)
glossary: $(GLOSSARY_file)

$(GLOSSARY_file): $(PROJECT).dvi
	$(GLOSSTEX) $(SOURCE_comp:.tex=) $(GLOSSARY_comp)
	$(MAKEINDEX) $(SOURCE_comp:.tex=.gxs) -o $@ -s glosstex.ist

######################################################## Viewing rules

view-pdf: $(PROJECT).pdf
	$(PDF_view) $(PROJECT).pdf

view-dvi: $(PROJECT).dvi
	$(DVI_view) $(PROJECT).dvi

view-ps: $(PROJECT).ps
	$(PS_view) $(PROJECT).ps

####################################################### Cleaning rules

clean:
	find . -name '*.log'	\
		-o -name '*.aux' \
		-o -name '*.toc' \
		-o -name '*.snm' \
		-o -name '*.nav' \
		-o -name '*.out' \
		-o -name '*.bbl' \
		-o -name '*.idx' \
		-o -name '*.ilg' \
		-o -name '*.ind' \
		-o -name '*.lof' \
		-o -name '*.blg' \
		-o -name '*~' | xargs rm -f
	rm -fR $(PROJECT)
	rm -f initial_files final_files

distclean: clean
	rm -f $(PROJECT).pdf $(PROJECT).dvi $(PROJECT).ps $(TARNAME)

####################################################### Distcheck rule

distcheck: dist
	rm -rf $(PROJECT)
	tar --extract --use-compress-program $(COMPRESS) --file $(TARNAME)
	find $(PROJECT) > initial_files 2> /dev/null
	cd $(PROJECT) && $(MAKE) $(MFLAGS) all $(DISTCHECK_rules) distclean
	find $(PROJECT) > final_files 2> /dev/null
	diff initial_files final_files || \
	  (echo 'Invalid clean rule.' >&2 ; false)
	rm -f initial_files final_files
	rm -fR $(PROJECT)
	@echo $(TARNAME) is ready for distribution.


########################################################### Dist rules

dist: $(TARNAME)

$(TARNAME): $(EXTRA_DIST) $(SOURCES)
	rm -rf $(PROJECT)
	mkdir -p $(PROJECT)
	$(foreach dir,$(SOURCES_dirs),	\
	   mkdir -p $(PROJECT)/$(dir);	\
	   cp -pR $(addprefix $(dir)/,$(SOURCES_$(subst /,_,$(dir)))) $(PROJECT)/$(dir);)
	cp -pR Makefile Makefile.inc $(EXTRA_DIST) $(PROJECT)
	tar --create --use-compress-program $(COMPRESS) \
	    --file $(TARNAME) $(PROJECT)
	rm -fR $(PROJECT)

####################### arch-tag: f0cace50-0184-4b78-b331-8305791bffa0
