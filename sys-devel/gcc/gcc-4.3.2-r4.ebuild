# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="1.8"
UCLIBC_VER="1.0"

inherit toolchain-legacy

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	amd64? (
		>=sys-libs/glibc-2.7-r2
	)
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

src_prepare() {
	toolchain-legacy_src_prepare

	use vanilla && return 0

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200
}
