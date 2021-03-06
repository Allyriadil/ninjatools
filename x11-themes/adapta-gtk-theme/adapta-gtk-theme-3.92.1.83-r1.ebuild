# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2 autotools

DESCRIPTION="An adaptive GTK+ theme based on Material Design Guidelines"
SRC_URI="https://github.com/adapta-project/adapta-gtk-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="~*"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="parallel gnome-shell mate cinnamon xfce"
RESTRICT="mirror"

CDEPEND="
	parallel? ( sys-process/parallel )
	gnome-shell? ( >=gnome-base/gnome-shell-3.18 )
	mate? ( >=mate-base/mate-1.14 )
	cinnamon? ( >=gnome-extra/cinnamon-2.8.6 )
	xfce? ( >=xfce-base/xfwm4-4.12 )
"

RDEPEND="
	${CDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	>=media-gfx/inkscape-0.91
	>=x11-libs/gdk-pixbuf-2.32.2
	>=dev-libs/glib-2.48
	>=dev-libs/libsass-3.3
	dev-libs/libxml2:2
	dev-util/pkgconfig
	>=dev-lang/sassc-3.3
"

DEPEND="
	${CDEPEND}
"

S="${WORKDIR}/${P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable parallel) \
		$(use_enable gnome-shell) \
		$(use_enable mate) \
		$(use_enable cinnamon) \
		$(use_enable xfce) \
		--enable-openbox \
	 	--enable-plank \
		--disable-flashback \
		--disable-unity \
	 	--disable-telegram \
		--disable-chrome
}

src_compile() {
	emake DESTDIR="${D}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
