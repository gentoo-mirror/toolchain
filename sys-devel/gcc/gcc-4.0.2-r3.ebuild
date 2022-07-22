# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="1.6"
PATCH_GCC_VER="4.0.2"
UCLIBC_VER="1.0"
UCLIBC_GCC_VER="4.0.0"
HTB_VER="1.00"

inherit toolchain-legacy

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.15.94"

src_prepare() {
	toolchain-legacy_src_prepare

	use vanilla && return 0

	# Fix cross-compiling
	eapply "${FILESDIR}"/4.0.2/gcc-4.0.2-cross-compile.patch
}
