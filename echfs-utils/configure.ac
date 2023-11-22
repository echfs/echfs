AC_INIT([echfs-utils], [m4_esyscmd([./version.sh])], [https://github.com/echfs/echfs/issues], [echfs-utils])

AC_PREREQ([2.69])

AC_CONFIG_AUX_DIR([build-aux])

SRCDIR="$(cd "$srcdir" && pwd -P)"

AC_SUBST([SRCDIR])

AC_CANONICAL_HOST

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

AC_ARG_VAR([STRIP], [strip command])

if ! test -z "$STRIP"; then
    AC_CHECK_PROG([STRIP_USER_FOUND], [$STRIP], [yes])
    if ! test "x$STRIP_USER_FOUND" = "xyes"; then
        AC_MSG_ERROR([$STRIP not found, please install $STRIP before configuring])
    fi
else
    STRIP="$($CC -dumpmachine)"-strip
    AC_CHECK_PROG([STRIP_FOUND], [$STRIP], [yes])
    if ! test "x$STRIP_FOUND" = "xyes"; then
        STRIP=strip
        AC_CHECK_PROG([STRIP_DEFAULT_FOUND], [$STRIP], [yes])
        if ! test "x$STRIP_DEFAULT_FOUND" = "xyes"; then
            AC_MSG_ERROR([$STRIP not found, please install $STRIP before configuring])
        fi
    fi
fi

AC_SUBST([STRIP])

PKGCONF_LIBS_LIST="uuid"

PKG_PROG_PKG_CONFIG

for lib in $PKGCONF_LIBS_LIST; do
    set -e
    $PKG_CONFIG --exists --print-errors "$lib"
    set +e
done

PKGCONF_CFLAGS="$($PKG_CONFIG --cflags-only-other $PKGCONF_LIBS_LIST 2>/dev/null)"
PKGCONF_CPPFLAGS="$($PKG_CONFIG --cflags-only-I $PKGCONF_LIBS_LIST 2>/dev/null)"
PKGCONF_LIBS="$($PKG_CONFIG --libs $PKGCONF_LIBS_LIST 2>/dev/null)"

AC_SUBST([PKGCONF_CFLAGS])
AC_SUBST([PKGCONF_CPPFLAGS])
AC_SUBST([PKGCONF_LIBS])

OLD_CFLAGS="$CFLAGS"
OLD_CPPFLAGS="$CPPFLAGS"
OLD_LIBS="$LIBS"

CFLAGS="$CFLAGS $PKGCONF_CFLAGS"
CPPFLAGS="$PKGCONF_CPPFLAGS $CPPFLAGS"
LIBS="$LIBS $PKGCONF_LIBS"

AC_CHECK_HEADERS([stdio.h stdint.h stdlib.h string.h getopt.h inttypes.h sys/types.h sys/stat.h unistd.h time.h uuid.h],
    [], [AC_MSG_ERROR([required header not found])])

CFLAGS="$OLD_CFLAGS"
CPPFLAGS="$OLD_CPPFLAGS"
LIBS="$OLD_LIBS"

AC_PREFIX_DEFAULT([/usr/local])

AC_CONFIG_FILES([GNUmakefile])
AC_OUTPUT
