# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="fa40a2d3373b89be0cd0a43fe0c1d047e3d34058"

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt screen magnifier"
SRC_URI="https://invent.kde.org/qt/qt/qttools/-/archive/fa40a2d3373b89be0cd0a43fe0c1d047e3d34058/qttools-fa40a2d3373b89be0cd0a43fe0c1d047e3d34058.tar.bz2 -> qttools-fa40a2d3373b89be0cd0a43fe0c1d047e3d34058.tar.bz2"

KEYWORDS="*"

IUSE=""

DEPEND="
	=dev-qt/qtcore-5.15.2*:5=
	=dev-qt/qtgui-5.15.2*:5=[png]
	=dev-qt/qtwidgets-5.15.2*
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/pixeltool
)