# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.3.0_alpha20070112.ebuild,v 1.1 2007/01/18 05:13:42 vapier Exp $

GCC_FILESDIR=${PORTDIR}/sys-devel/gcc/files

inherit toolchain

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"
LICENSE="GPL-3 LGPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1"
KEYWORDS=""

IUSE="debug"

RDEPEND=""
DEPEND="${RDEPEND}
	amd64? ( multilib? ( gcj? ( app-emulation/emul-linux-x86-xlibs ) ) )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

pkg_setup() {
	if [[ -z ${I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS} ]] ; then
		die "Please \`export I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS=1\` or define it in your make.conf if you want to use this ebuild.  This is to try and cut down on people filing bugs for a compiler we do not currently support."
	fi
	toolchain_pkg_setup
}

src_unpack() {
	toolchain_src_unpack

	use vanilla && return 0

	[[ ${CHOST} == ${CTARGET} ]] && epatch "${GCC_FILESDIR}"/gcc-spec-env.patch
	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${GCC_FILESDIR}"/4.4.0/gcc-4.4.0-softfloat.patch

	use debug && GCC_CHECKS_LIST="yes"
}

pkg_postinst() {
	toolchain_pkg_postinst

	einfo "This gcc-4 ebuild is provided for your convenience, and the use"
	einfo "of this compiler is not supported by the Gentoo Developers."
	einfo "Please file bugs related to gcc-4 with upstream developers."
	einfo "Compiler bugs should be filed at http://gcc.gnu.org/bugzilla/"
}
