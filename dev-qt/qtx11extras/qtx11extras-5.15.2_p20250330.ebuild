# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="c44c4fa86fa0794c25baef4ee1f6272aca8c511a"

inherit qt5-build

DESCRIPTION="Linux/X11-specific support library for the Qt5 framework"
SRC_URI="https://invent.kde.org/qt/qt/qtx11extras/-/archive/c44c4fa86fa0794c25baef4ee1f6272aca8c511a/qtx11extras-c44c4fa86fa0794c25baef4ee1f6272aca8c511a.tar.bz2 -> qtx11extras-c44c4fa86fa0794c25baef4ee1f6272aca8c511a.tar.bz2"

KEYWORDS="*"

IUSE=""

RDEPEND="
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtgui-5.15.2*[X]
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtwidgets-5.15.2* )
"