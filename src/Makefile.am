## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(SPACEFIGHT_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = spacefight

spacefight_SOURCES = \
	spacefight.vala config.vapi actor.vala game.vala shot.vala sprite.vala

spacefight_VALAFLAGS =  --pkg sdl2-image --pkg sdl2-mixer --pkg sdl2  \
	--pkg gtk+-3.0


spacefight_LDFLAGS =

spacefight_LDADD = $(SPACEFIGHT_LIBS)


if PLATFORM_WIN32
spacefight_LDFLAGS += -Wl,--export-all-symbols
else
spacefight_LDFLAGS += -Wl,--export-dynamic
endif

if NATIVE_WIN32
spacefight_LDFLAGS += -mwindows
endif


