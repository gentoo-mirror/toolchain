# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.3.2-r4.ebuild,v 1.9 2010/01/09 12:58:57 ulm Exp $

EAPI="2"

PATCH_VER="1.8"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	amd64? (
		>=sys-libs/glibc-2.7-r2
	)
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

src_unpack() {
	toolchain_src_unpack

	use vanilla && return 0

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.3.2/gcc-4.3.2-softfloat.patch
}
