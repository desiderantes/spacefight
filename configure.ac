dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(spacefight, 0.1, https://bugs.launchpad.net/spacefight, spacefight, https://launchpad.net/spacefight)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC


dnl ***************************************************************************
dnl Check for Windows
dnl ***************************************************************************
AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    ;;
  *)
    platform_win32=no
    native_win32=no
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")


LT_INIT([win32-dll])

dnl Check for vala
AM_PROG_VALAC([0.10.0])


PKG_CHECK_MODULES(SPACEFIGHT, [gtk+-3.0 SDL2_image SDL2_mixer sdl2])


AC_OUTPUT([
Makefile
src/Makefile

])
