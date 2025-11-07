# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="bebdfd54917e25d1c100e6bd9f5dd53c2e645fd8"

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"
SRC_URI="https://invent.kde.org/qt/qt/qtbase/-/archive/bebdfd54917e25d1c100e6bd9f5dd53c2e645fd8/qtbase-bebdfd54917e25d1c100e6bd9f5dd53c2e645fd8.tar.bz2 -> qtbase-bebdfd54917e25d1c100e6bd9f5dd53c2e645fd8.tar.bz2"

KEYWORDS="*"

IUSE=""

RDEPEND="
	=dev-qt/qtcore-5.15.2*:5=
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtnetwork-5.15.2* )
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:xml
)