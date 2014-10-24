# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCC_FILESDIR="${PORTDIR}/sys-devel/gcc/files"

inherit eutils toolchain

KEYWORDS=""
IUSE="debug"

RDEPEND=""
DEPEND="${RDEPEND}
	amd64? ( multilib? ( gcj? ( app-emulation/emul-linux-x86-xlibs ) ) )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.12 )"
fi

src_prepare() {
	toolchain_src_prepare

	use debug && GCC_CHECKS_LIST="yes"

	use vanilla && return 0
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${GCC_FILESDIR}"/gcc-spec-env-r1.patch
}
