# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

PATCHVER="1.3"
UCLIBC_PATCHVER=""
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="-* ~x86-fbsd"

src_unpack() {
	tc-binutils_unpack

	cd "${WORKDIR}"/patch
	# *BSD patches are not safe
	[[ ${CTARGET} != *-freebsd* ]] && mv 00_all_freebsd* skip/
	[[ ${CTARGET} != *-openbsd* ]] && mv 00_all_openbsd* skip/

	tc-binutils_apply_patches
}
