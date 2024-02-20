# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

COMMIT="158c52c4a76cff7a1635be8ec1a4a369bc8674ed"
DESCRIPTION="Hyprland's idle daemon"
HOMEPAGE="https://github.com/hyprwm/hypridle"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	#When releases start to happen
	#SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	#S="${WORKDIR}/${PN}-source"

	SRC_URI="https://github.com/hyprwm/${PN^}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-libs/wayland
	gui-libs/egl-wayland
	media-libs/mesa[egl(+),gles2]
	>=gui-wm/hyprland-0.35.0
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

BDEPEND="
	>=dev-libs/hyprlang-0.4.0
	dev-cpp/sdbus-c++
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE:STRING=Release
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
