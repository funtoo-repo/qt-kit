# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="b64a7eeda9b6a65b5ed01b1b40b07177f0aa4c0f"

inherit qt5-build

DESCRIPTION="Serial port abstraction library for the Qt5 framework"
SRC_URI="https://invent.kde.org/qt/qt/qtserialport/-/archive/b64a7eeda9b6a65b5ed01b1b40b07177f0aa4c0f/qtserialport-b64a7eeda9b6a65b5ed01b1b40b07177f0aa4c0f.tar.bz2 -> qtserialport-b64a7eeda9b6a65b5ed01b1b40b07177f0aa4c0f.tar.bz2"

KEYWORDS="*"

IUSE=""

DEPEND="
	=dev-qt/qtcore-5.15.2*
	virtual/libudev:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	# make sure we link against libudev
	sed -i -e 's/:qtConfig(libudev)//' \
		src/serialport/serialport-lib.pri || die

	qt5-build_src_prepare
}