### Makefile.inc                                 -*- Makefile-gmake -*-

## Copyright (C) 2005, 2006, 2007, 2008 Michaël Cadilhac, Johan Oudinet

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## A copy of the license is provided in the file COPYING.DOC.

##################################################### List all sources

SOURCES_doc=		rapportM2R.pdf

SOURCES_src=		rapportM2R.tex rapportM2R.bib	\
	  		intro.tex conclu.tex

SOURCES_img=            lri.png ups.png cnrs.png inria.png limsi.png

SOURCES_dirs=		src img

################################################## Compilation details

SOURCES_comp :=		src/rapportM2R.tex
GLOSSARY_comp :=	src/glossaire.gdf
DISTCHECK_rules :=	pdf

################################# Project/distribution related details

PROJECT :=		rapportM2R
EXTRA_DIST :=		float.sty
TARNAME :=		$(PROJECT).tgz
COMPRESS :=		gzip
DEFAULT_FORMAT :=	pdf

################################################## Compilation details

TEXI2DVI :=		texi2dvi
TEXI2PDF :=		texi2dvi --pdf
TEXI2DVI_flags :=	-I .:$(TEXINPUTS):$(subst $(NULL) $(NULL),:,$(SOURCES_dirs))

PS2PDF :=		ps2pdf
DVI2PS :=		dvips

PDF_view :=		evince
DVI_view :=		xdvi
PS_view :=		gv

GLOSSTEX :=		glosstex
MAKEINDEX :=		makeindex

## This file is to be included by a Makefile.
