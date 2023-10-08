AC_INIT([echfs-utils], [m4_esyscmd([./version.sh])], [https://github.com/echfs/echfs/issues], [echfs-utils])

AC_PREREQ([2.69])

AC_CONFIG_AUX_DIR([build-aux])

SRCDIR="$(cd "$srcdir" && pwd -P)"

AC_SUBST([SRCDIR])

AC_DEFUN([PROG_ABSPATH], [
    case "$$1" in
        .*) $1="$(cd "$(dirname "$$1")" && pwd -P)/$(basename "$$1")" ;;
    esac
])

test "x$CFLAGS" = "x" && CFLAGS='-g -O2 -pipe'

AC_LANG([C])
AC_PROG_CC
PROG_ABSPATH([CC])

werror_state="no"
AC_ARG_ENABLE([werror],
    [AS_HELP_STRING([--enable-werror], [treat warnings as errors])],
    [werror_state="$enableval"])
if test "$werror_state" = "yes"; then
    AC_SUBST([WERROR_FLAG], [-Werror])
else
    AC_SUBST([WERROR_FLAG], [-Wno-error])
fi

AC_PROG_MKDIR_P
PROG_ABSPATH([MKDIR_P])
AC_PROG_INSTALL
PROG_ABSPATH([INSTALL])

AC_CHECK_PROG([FIND_FOUND], [find], [yes])
if ! test "x$FIND_FOUND" = "xyes"; then
    AC_MSG_ERROR([find not found, please install find before configuring])
fi

STRIP="$($CC -dumpmachine)"-strip
AC_CHECK_PROG([STRIP_FOUND], [$STRIP], [yes])
if ! test "x$STRIP_FOUND" = "xyes"; then
    STRIP=strip
fi
AC_SUBST([STRIP])

PKGCONFIG="$($CC -dumpmachine)"-pkg-config
AC_CHECK_PROG([PKGCONFIG_FOUND], [$PKGCONFIG], [yes])
if ! test "x$PKGCONFIG_FOUND" = "xyes"; then
    PKGCONFIG=pkg-config
fi

PKGCONFIG_LIBS="uuid"

CFLAGS="$CFLAGS $($PKGCONFIG --cflags-only-other $PKGCONFIG_LIBS 2>/dev/null)"
CPPFLAGS="$($PKGCONFIG --cflags-only-I $PKGCONFIG_LIBS 2>/dev/null) $CPPFLAGS"
LIBS="$LIBS $($PKGCONFIG --libs $PKGCONFIG_LIBS 2>/dev/null)"

AC_CHECK_HEADERS([stdio.h stdint.h stdlib.h string.h getopt.h inttypes.h sys/types.h sys/stat.h unistd.h time.h uuid.h],
    [], [AC_MSG_ERROR([required header not found])])

AC_PREFIX_DEFAULT([/usr/local])

AC_CONFIG_FILES([GNUmakefile])
AC_OUTPUT
