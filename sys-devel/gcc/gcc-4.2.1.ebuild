# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.0"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
