# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/Attic/gcc-4.4.0-r1.ebuild,v 1.3 2009/08/13 19:40:11 halcy0n dead $

EAPI="2"

PATCH_VER="1.2"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_unpack() {
	toolchain_src_unpack

	use vanilla && return 0

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.4.0/gcc-4.4.0-softfloat.patch
}
