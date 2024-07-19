# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools findlib toolchain-funcs

DESCRIPTION="Value analysis (EVA) plugin for frama-c"
HOMEPAGE="https://frama-c.com"
NAME="Chromium"
SRC_URI="https://frama-c.com/download/frama-c-${PV}-${NAME}.tar.gz"

S="${WORKDIR}/frama-c-${PV}-${NAME}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk +ocamlopt"
RESTRICT="strip"

RDEPEND="~sci-mathematics/frama-c-${PV}:=[gtk=,ocamlopt?]
	~sci-mathematics/frama-c-callgraph-${PV}:=[gtk=,ocamlopt?]
	~sci-mathematics/frama-c-loopanalysis-${PV}:=[ocamlopt?]
	~sci-mathematics/frama-c-rtegen-${PV}:=[ocamlopt?]
	~sci-mathematics/frama-c-server-${PV}:=[ocamlopt?]"
DEPEND="${RDEPEND}"
# Eva needs the "scope" plugin at runtime, which provides rm_assert
# But it is not needed for compilation, and would introduce a mutual dependency
PDEPEND="~sci-mathematics/frama-c-scope-${PV}:=[ocamlopt?]"

p="src/plugins/value/Makefile"

src_prepare() {
	mv configure.in configure.ac || die
	sed -i 's/configure\.in/configure.ac/g' Makefile.generating Makefile || die
	touch config_file || die
	eautoreconf
	eapply_user
}

src_configure() {
	econf \
		--disable-landmarks \
		--with-no-plugin \
		$(use_enable gtk gui) \
		--enable-callgraph \
		--enable-server \
		--enable-eva
	printf 'include share/Makefile.config\n' > ${p} || die
	sed -e '/^# *Evolved Value Analysis/bl;d' -e ':l' -e '/^\$(eval/Q;n;bl' < Makefile >> ${p} || die
	printf 'include share/Makefile.dynamic\n' >> ${p} || die
	export FRAMAC_SHARE="${ESYSROOT}/usr/share/frama-c"
	export FRAMAC_LIBDIR="${EPREFIX}/usr/$(get_libdir)/frama-c"
}

src_compile() {
	tc-export AR
	emake -f ${p} FRAMAC_SHARE="${FRAMAC_SHARE}" FRAMAC_LIBDIR="${FRAMAC_LIBDIR}"
}

src_install() {
	emake -f ${p} FRAMAC_SHARE="${FRAMAC_SHARE}" FRAMAC_LIBDIR="${FRAMAC_LIBDIR}" DESTDIR="${ED}" install
}
