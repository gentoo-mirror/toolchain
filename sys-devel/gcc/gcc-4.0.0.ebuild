# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="1.1"
UCLIBC_VER="1.0"
HTB_VER="1.00"

inherit toolchain-legacy

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/binutils-2.15.97"
