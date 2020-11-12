# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils qmake-utils xdg

DESCRIPTION="A Qt based archiving solution with libarchive backend"
HOMEPAGE="https://gitlab.com/marcusbritanicus/libarchive-qt"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/marcusbritanicus/${PN}.git"
else
	SRC_URI="https://gitlab.com/marcusbritanicus/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

RESTRICT="mirror"
LICENSE="LGPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/libarchive[lzma,bzip2,zlib]
	app-arch/lrzip
	app-arch/lzip
	app-arch/lzop
	dev-qt/qtgui:5
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local lib="$(get_libdir)"
	# '^^' because we need to upcase the definition
	eqmake5 DEFINES+="${lib^^}"
}

src_install() {
	einstalldocs

	emake INSTALL_ROOT="${D}" install
}
