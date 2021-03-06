# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://github.com/thestinger/vte-ng"

SRC_URI="https://github.com/thestinger/vte-ng/archive/$PV.b.tar.gz -> $P.tar.gz"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug glade +introspection vala"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.8:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
# need gtk-doc, not just -am, for gtk-doc.make
DEPEND="${RDEPEND}
    dev-util/gtk-doc
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	crypt?  ( >=net-libs/gnutls-3.2.7 )
	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
	!x11-libs/vte:2.91
"

S="${WORKDIR}/vte-ng-${PV}.b"

src_prepare() {
	use vala && vala_src_prepare

	# build fails because of -Werror with gcc-5.x
	sed -e 's#-Werror=format=2#-Wformat=2#' -i configure.ac || die "sed failed"

    eautoreconf
	gnome2_src_prepare
}

src_configure() {

	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	# FIXME: add USE for pcre
	gnome2_src_configure \
		--disable-test-application \
		--disable-static \
		$(use_enable debug) \
		$(use_enable glade glade-catalogue) \
		$(use_with crypt gnutls) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_install() {
    
	emake DESTDIR="${D}" install
	mv "${D}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
