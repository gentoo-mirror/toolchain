# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/Attic/gcc-4.0.2-r3.ebuild,v 1.20 2006/12/30 11:33:36 vapier dead $

PATCH_VER="1.6"
PATCH_GCC_VER="4.0.2"
UCLIBC_VER="1.0"
UCLIBC_GCC_VER="4.0.0"
HTB_VER="1.00"

inherit toolchain

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.15.94"

src_unpack() {
	toolchain_src_unpack

	use vanilla && return 0

	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# Fix cross-compiling
	epatch "${FILESDIR}"/4.0.2/gcc-4.0.2-cross-compile.patch

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.0.2/gcc-4.0.2-softfloat.patch
}
