# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.4.5.ebuild,v 1.17 2013/10/05 04:08:32 dirtyepic Exp $

EAPI="5"

PATCH_VER="1.3"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.4.0/gcc-4.4.0-softfloat.patch
}
