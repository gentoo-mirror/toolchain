# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/Attic/gcc-4.0.0.ebuild,v 1.7 2005/07/08 19:07:22 eradicator dead $

EAPI="2"

PATCH_VER="1.1"
UCLIBC_VER="1.0"
HTB_VER="1.00"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/binutils-2.15.97"

pkg_postinst() {
	toolchain_pkg_postinst

	einfo "This gcc-4 ebuild is provided for your convenience, and the use"
	einfo "of this compiler is not supported by the Gentoo Developers."
	einfo "Please file bugs related to gcc-4 with upstream developers."
	einfo "Compiler bugs should be filed at http://gcc.gnu.org/bugzilla/"
}
