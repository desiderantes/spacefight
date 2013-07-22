## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	$(SPACEFIGHT_CFLAGS) \
	$(sdl_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

VALAFLAGS =  --pkg SDL_gfx  \
	--pkg gtk+-3.0

bin_PROGRAMS = spacefight

spacefight_SOURCES = \
	spacefight.vala config.vapi sprite.vala game.vala shot.vala actor.vala

spacefight_LDFLAGS = \
	-Wl,--export-dynamic

spacefight_LDADD = $(SPACEFIGHT_LIBS) \
	$(sdl_LIBS)

