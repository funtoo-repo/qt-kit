# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="510687fa4fdee84dd3d6d166e8f080c484016199"

inherit qt5-build

DESCRIPTION="Network authorization library for the Qt5 framework"
SRC_URI="https://invent.kde.org/qt/qt/qtnetworkauth/-/archive/510687fa4fdee84dd3d6d166e8f080c484016199/qtnetworkauth-510687fa4fdee84dd3d6d166e8f080c484016199.tar.bz2 -> qtnetworkauth-510687fa4fdee84dd3d6d166e8f080c484016199.tar.bz2"
LICENSE="GPL-3"

KEYWORDS="*"

IUSE=""

DEPEND="
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtnetwork-5.15.2*
"
RDEPEND="${DEPEND}"