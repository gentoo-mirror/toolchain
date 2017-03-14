# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.10"
UCLIBC_VER="1.1"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	# Fix cross-compiling
	epatch "${FILESDIR}"/4.1.0/gcc-4.1.0-cross-compile.patch

	epatch "${FILESDIR}"/4.1.0/gcc-4.1.0-fast-math-i386-Os-workaround.patch
}
