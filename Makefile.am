## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

spacefightdocdir = ${prefix}/doc/spacefight
spacefightdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(spacefightdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(spacefightdocdir)
