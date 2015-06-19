# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCC_FILESDIR="${PORTDIR}/sys-devel/gcc/files"

inherit eutils toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	# Fix cross-compiling
	epatch "${GCC_FILESDIR}"/4.1.0/gcc-4.1.0-cross-compile.patch
}
