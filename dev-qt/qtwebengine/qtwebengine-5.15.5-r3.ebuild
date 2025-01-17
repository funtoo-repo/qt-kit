# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
QTVER="5.15.2"
C_COMMIT="eaffb82d5ee99ea1db8c0d4d359bbc72e77f065b"

inherit multiprocessing python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"
HOMEPAGE="https://www.qt.io/"
SRC_URI="https://github.com/qt/${PN}/archive/refs/tags/v${PV}-lts.tar.gz -> ${P}.tar.gz
	https://github.com/qt/${PN}-chromium/archive/${C_COMMIT}.tar.gz -> ${PN}-chromium-${PV}.tar.gz"

# patchset based on https://github.com/chromium-ppc64le releases
SRC_URI+=" ppc64? ( https://dev.gentoo.org/~gyakovlev/distfiles/${PN}-5.15.2-chromium87-ppc64le.tar.xz )"

KEYWORDS="*"
IUSE="alsa bindist designer geolocation kerberos pulseaudio +memsaver +system-ffmpeg +system-icu widgets"
REQUIRED_USE="designer? ( widgets )"

RDEPEND="
	app-arch/snappy:=
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/re2:=
	=dev-qt/qtcore-${QTVER}*
	=dev-qt/qtdeclarative-${QTVER}*
	=dev-qt/qtgui-${QTVER}*
	=dev-qt/qtnetwork-${QTVER}*
	=dev-qt/qtprintsupport-${QTVER}*
	=dev-qt/qtwebchannel-${QTVER}*[qml]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc(+)]
	media-libs/libwebp:=
	media-libs/mesa[egl,X(+)]
	media-libs/opus
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib[minizip]
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	designer? ( =dev-qt/designer-${QTVER}* )
	geolocation? ( =dev-qt/qtpositioning-${QTVER}* )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( >=dev-libs/icu-67.1:= )
	widgets? (
		=dev-qt/qtdeclarative-${QTVER}*[widgets]
		=dev-qt/qtwidgets-${QTVER}*
	)
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	net-libs/nodejs[ssl(+)]
	sys-devel/bison
	ppc64? ( >=dev-util/gn-0.1807 )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.15.0-disable-fatal-warnings.patch" # bug 695446
	"${FILESDIR}/${PN}-5.15.2_p20210224-chromium-87-v8-icu68.patch" # downstream, bug 757606
	"${FILESDIR}/${PN}-5.15.2_p20210224-disable-git.patch" # downstream snapshot fix
	"${FILESDIR}/${PN}-5.15.2_p20210406-glibc-2.33.patch" # by Fedora, bug 769989
	"${FILESDIR}/${PN}-5.15.2_p20210521-gcc11.patch" # by Fedora, bug 768261
	"${FILESDIR}/${PN}-5.15.5-harfbuzz-7.2.0.patch" # FL-11265 (harfbuzz-7.2.0)
)

S="${WORKDIR}/${P}-lts"

src_unpack() {
	default
	rm -rf "${S}"/src/3rdparty
	mv qtwebengine-chromium-* "${S}"/src/3rdparty || die
}

src_prepare() {

	if use memsaver; then

		# limit number of jobs based on available memory:

		mem=$(grep ^MemTotal /proc/meminfo | awk '{print $2}')
		jobs=$((mem/1750000))

		# don't use more jobs than physical cores:
		if [ -e /sys/devices/system/cpu/possible ]; then
			physical_cores=$(lscpu | grep 'Core(s) per socket:' | awk '{ print $NF }')
			cpus=$(lscpu | grep '^Socket(s):' | awk '{ print $NF }')
			# actual physical cores, without considering hyperthreading:
			max_parallelism=$(( $physical_cores * $cpus ))
		else
			max_parallelism=999
		fi

		if [ ${jobs} -lt 1 ]; then
			einfo "Using jobs setting of 1 (limited by memory)"
			jobs=-j1
		elif [ ${jobs} -gt ${max_parallelism} ]; then
			einfo "Using jobs setting of ${max_parallelism} (limited by physical cores)"
			jobs=-j${max_parallelism}
		else
			einfo "Using jobs setting of ${jobs} (limited by memory)"
			jobs=-j${jobs}
		fi
	else
		jobs="-j$(makeopts_jobs)"
		einfo "Using default Portage jobs setting."
	fi
	# Final link uses lots of file descriptors.
	ulimit -n 2048


	# This is made from git, and for some reason will fail w/o .git directories.
	mkdir -p .git src/3rdparty/chromium/.git || die

	# We need to make sure this integrates well into Qt 5.15.2 installation.
	# Otherwise revdeps fail w/o heavy changes. This is the simplest way to do it.
	sed -e "/^MODULE_VERSION/s/5.*/${QTVER}/" -i .qmake.conf || die

	# QTBUG-88657 - jumbo-build is broken
	#if ! use jumbo-build; then
		sed -i -e 's|use_jumbo_build=true|use_jumbo_build=false|' \
			src/buildtools/config/common.pri || die
	#fi

	# bug 630834 - pass appropriate options to ninja when building GN
	sed -e "s/\['ninja'/&, '${jobs}', '-l$(makeopts_loadavg "${MAKEOPTS}" 0)', '-v'/" \
		-i src/3rdparty/chromium/tools/gn/bootstrap/bootstrap.py || die

	# bug 620444 - ensure local headers are used
	find "${S}" -type f -name "*.pr[fio]" | \
		xargs sed -i -e 's|INCLUDEPATH += |&$${QTWEBENGINE_ROOT}_build/include $${QTWEBENGINE_ROOT}/include |' || die

	if use system-icu; then
		# Sanity check to ensure that bundled copy of ICU is not used.
		# Whole src/3rdparty/chromium/third_party/icu directory cannot be deleted because
		# src/3rdparty/chromium/third_party/icu/BUILD.gn is used by build system.
		# If usage of headers of bundled copy of ICU occurs, then lists of shim headers in
		# shim_headers("icui18n_shim") and shim_headers("icuuc_shim") in
		# src/3rdparty/chromium/third_party/icu/BUILD.gn should be updated.
		local file
		while read file; do
			echo "#error This file should not be used!" > "${file}" || die
		done < <(find src/3rdparty/chromium/third_party/icu -type f "(" -name "*.c" -o -name "*.cpp" -o -name "*.h" ")" 2>/dev/null)
	fi

	qt_use_disable_config alsa webengine-alsa src/buildtools/config/linux.pri
	qt_use_disable_config pulseaudio webengine-pulseaudio src/buildtools/config/linux.pri

	qt_use_disable_mod designer webenginewidgets src/plugins/plugins.pro

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare

	# we need to generate ppc64 stuff because upstream does not ship it yet
	if use ppc64; then
		einfo "Patching for ppc64le and generating build files"
		eapply "${FILESDIR}/qtwebengine-5.15.2-enable-ppc64.patch"
		pushd src/3rdparty/chromium > /dev/null || die
		eapply -p0 "${WORKDIR}/${PN}-ppc64le"
		popd > /dev/null || die
		pushd src/3rdparty/chromium/third_party/libvpx > /dev/null || die
		mkdir -vp source/config/linux/ppc64 || die
		mkdir -p source/libvpx/test || die
		touch source/libvpx/test/test.mk || die
		./generate_gni.sh || die
		popd >/dev/null || die
	fi
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:-${jobs} -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		--
		-no-build-qtpdf
		-printing-and-pdf
		-system-opus
		-system-webp
		$(usex alsa '-alsa' '-no-alsa')
		$(usex bindist '-no-proprietary-codecs' '-proprietary-codecs')
		$(usex geolocation '-webengine-geolocation' '-no-webengine-geolocation')
		$(usex kerberos '-webengine-kerberos' '-no-webengine-kerberos')
		$(usex pulseaudio '-pulseaudio' '-no-pulseaudio')
		$(usex system-ffmpeg '-system-ffmpeg' '-qt-ffmpeg')
		$(usex system-icu '-webengine-icu' '-no-webengine-icu')
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	# bug 601472
	if [[ ! -f ${D}${QT5_LIBDIR}/libQt5WebEngine.so ]]; then
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"
	fi
}
