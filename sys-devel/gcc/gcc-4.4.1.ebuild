# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.0"
UCLIBC_VER="1.1"

inherit toolchain

KEYWORDS=""

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
