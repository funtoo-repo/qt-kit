# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="dfb2e7b2c98a9b7185c300d0b92b4048f5d89ba5"

VIRTUALX_REQUIRED="test"
inherit qt5-build

DESCRIPTION="Set of QML types for adding visual effects to user interfaces"
SRC_URI="https://invent.kde.org/qt/qt/qtgraphicaleffects/-/archive/dfb2e7b2c98a9b7185c300d0b92b4048f5d89ba5/qtgraphicaleffects-dfb2e7b2c98a9b7185c300d0b92b4048f5d89ba5.tar.bz2 -> qtgraphicaleffects-dfb2e7b2c98a9b7185c300d0b92b4048f5d89ba5.tar.bz2"

KEYWORDS="*"

IUSE=""

RDEPEND="
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtdeclarative-5.15.2*
	=dev-qt/qtgui-5.15.2*
"
DEPEND="${RDEPEND}"