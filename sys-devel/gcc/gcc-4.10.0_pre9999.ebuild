# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

GCC_FILESDIR="${PORTDIR}/sys-devel/gcc/files"
gcc_LIVE_BRANCH="master"

inherit multilib toolchain

KEYWORDS=""

SLOT="${GCC_BRANCH_VER}-vcs"
IUSE="nobootstrap offline"

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.12 )"
fi

src_unpack() {
	# use the offline USE flag to prevent the ebuild from trying to update from
	# the repo.  the current sources will be used instead.
	use offline && EVCS_OFFLINE="yes"

	toolchain_src_unpack

	echo "commit ${EGIT_VERSION}" > "${S}"/gcc/REVISION
}

src_prepare() {
	toolchain_src_prepare

	if ! use vanilla ; then
		# drop-in patches
		if [[ -e ${FILESDIR}/${GCC_RELEASE_VER} ]]; then
			EPATCH_SOURCE="${FILESDIR}/${GCC_RELEASE_VER}" \
			EPATCH_EXCLUDE="${FILESDIR}/${GCC_RELEASE_VER}/exclude" \
			EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch
		fi

		[[ ${CHOST} == ${CTARGET} ]] && epatch "${GCC_FILESDIR}"/gcc-spec-env-r1.patch
	fi

	# single-stage build for quick patch testing
	if use nobootstrap; then
		GCC_MAKE_TARGET="all"
		EXTRA_ECONF+=" --disable-bootstrap"
	fi
}
