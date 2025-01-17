# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="1eecf07a4d5dadd1b5aaf785fc2a5ed03565599d"

inherit qt5-build

DESCRIPTION="3D rendering module for the Qt5 framework"
SRC_URI="https://invent.kde.org/qt/qt/qt3d/-/archive/1eecf07a4d5dadd1b5aaf785fc2a5ed03565599d/qt3d-1eecf07a4d5dadd1b5aaf785fc2a5ed03565599d.tar.bz2 -> qt3d-1eecf07a4d5dadd1b5aaf785fc2a5ed03565599d.tar.bz2"

KEYWORDS="*"

# TODO: tools
IUSE="gamepad gles2-only qml vulkan"

RDEPEND="
	=dev-qt/qtconcurrent-5.15.2*
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtgui-5.15.2*:5=[vulkan=]
	=dev-qt/qtnetwork-5.15.2*
	>=media-libs/assimp-4.0.0
	gamepad? ( =dev-qt/qtgamepad-5.15.2* )
	qml? ( =dev-qt/qtdeclarative-5.15.2*[gles2-only=] )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

src_configure() {
	local myqmakeargs=(
		--
		-system-assimp
	)
	qt5-build_src_configure
}

src_prepare() {
	rm -r src/3rdparty/assimp/{code,contrib,include} || die

	qt_use_disable_mod gamepad gamepad src/input/frontend/frontend.pri
	qt_use_disable_mod qml quick src/src.pro

	qt5-build_src_prepare
}