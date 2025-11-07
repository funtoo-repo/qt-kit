# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="c23069351ec31563c9ea9fcdce42ccdba95ea518"

inherit qt5-build

DESCRIPTION="Qt module to access CAN, ModBus, and other industrial serial buses and protocols"
SRC_URI="https://invent.kde.org/qt/qt/qtserialbus/-/archive/c23069351ec31563c9ea9fcdce42ccdba95ea518/qtserialbus-c23069351ec31563c9ea9fcdce42ccdba95ea518.tar.bz2 -> qtserialbus-c23069351ec31563c9ea9fcdce42ccdba95ea518.tar.bz2"

KEYWORDS="*"

IUSE=""

DEPEND="
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtnetwork-5.15.2*
	=dev-qt/qtserialport-5.15.2*
"
RDEPEND="${DEPEND}"