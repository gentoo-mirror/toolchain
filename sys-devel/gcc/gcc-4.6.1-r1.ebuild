# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="1.1"
UCLIBC_VER="1.0"

inherit toolchain-legacy

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	if has_version '<sys-libs/glibc-2.12' ; then
		ewarn "Your host glibc is too old; disabling automatic fortify."
		ewarn "Please rebuild gcc after upgrading to >=glibc-2.12 #362315"

		rm "${WORKDIR}"/patch/10_all_default-fortify-source.patch || die
	fi

	toolchain-legacy_src_prepare
}
