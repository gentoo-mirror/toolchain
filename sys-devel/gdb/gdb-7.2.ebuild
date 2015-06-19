# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-7.2.ebuild,v 1.18 2015/02/27 08:14:05 vapier Exp $

EAPI="3"

inherit flag-o-matic eutils

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

MY_PV=${PV}

PATCH_VER="1"
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sourceware.org/gdb/"
SRC_URI="mirror://gnu/gdb/${P}.tar.bz2
	ftp://sourceware.org/pub/gdb/releases/${P}.tar.bz2
	${PATCH_VER:+mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~x64-macos ~x86-macos"
IUSE="expat multitarget nls python test vanilla"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	sys-libs/readline
	expat? ( dev-libs/expat )
	python? ( =dev-lang/python-2* )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/yacc
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	! use vanilla && [[ -n ${PATCH_VER} ]] && EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	strip-linguas -u bfd/po opcodes/po
}

gdb_branding() {
	printf "Gentoo ${PV} "
	if [[ -n ${PATCH_VER} ]] ; then
		printf "p${PATCH_VER}"
	else
		printf "vanilla"
	fi
}

src_configure() {
	strip-unsupported-flags
	econf \
		--with-pkgversion="$(gdb_branding)" \
		--with-bugurl='http://bugs.gentoo.org/' \
		--disable-werror \
		--enable-64-bit-bfd \
		--with-system-readline \
		$(is_cross && echo --with-sysroot="${EPREFIX}"/usr/${CTARGET}) \
		$(use_with expat) \
		$(use_enable nls) \
		$(use multitarget && echo --enable-targets=all) \
		$(use_with python python "${EPREFIX}/usr/bin/python2")
}

src_test() {
	emake check || ewarn "tests failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		libdir=/nukeme/pretty/pretty/please includedir=/nukeme/pretty/pretty/please \
		install || die
	rm -r "${D}"/nukeme || die

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -r "${ED}"/usr/share
		return 0
	fi

	dodoc README
	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
		gdb/NEWS gdb/ChangeLog gdb/PROBLEMS
	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING

	dodoc "${WORKDIR}"/extra/gdbinit.sample

	# Remove shared info pages
	rm -f "${ED}"/usr/share/info/{annotate,bfd,configure,standards}.info*
}
