# Copyright 2022, 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Cross-development package for 65(C)02 systems"
HOMEPAGE="https://cc65.github.io/"
EGIT_REPO_URI="https://github.com/cc65/cc65.git"

LICENSE="ZLIB"
SLOT="0"

src_compile() {
	ewarn "According to an upstream maintainer, cc65 has a tendency to"
	ewarn "\"fail randomly\" when using \`make -j' to build in parallel."
	ewarn "If compiling this package fails, and you have parallel jobs"
	ewarn "enabled, try again with \`MAKEOPTS+=-j1' to disable them."

	emake CC="$(tc-getCC)" AR="$(tc-getAR)" PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README.md
}
