# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit flag-o-matic eutils

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

PATCH_VER="1.5"
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sourceware.org/gdb/"
SRC_URI="mirror://gnu/gdb/${P}.tar.bz2
	ftp://sourceware.org/pub/gdb/releases/${P}.tar.bz2
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.lzma"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd"
IUSE="expat multitarget nls test vanilla"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	sys-libs/readline
	expat? ( dev-libs/expat )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	! use vanilla && EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	strip-linguas -u bfd/po opcodes/po
}

src_compile() {
	strip-unsupported-flags
	econf \
		--disable-werror \
		$(has_version '=sys-libs/readline-5*:0' && echo --with-system-readline) \
		$(use_enable nls) \
		$(use multitarget && echo --enable-targets=all) \
		$(use_with expat) \
		|| die
	emake || die
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
		rm -r "${D}"/usr/share
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
	rm -f "${D}"/usr/share/info/{annotate,bfd,configure,standards}.info*
}
