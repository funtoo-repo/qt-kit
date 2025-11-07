# Distributed under the terms of the GNU General Public License v2

EAPI=7
KDE_ORG_COMMIT="43130f2681b76a8d743a04704465b716b6b2faee"

inherit qt5-build

DESCRIPTION="Qt module for keyframe-based timeline construction"
SRC_URI="https://invent.kde.org/qt/qt/qtquicktimeline/-/archive/43130f2681b76a8d743a04704465b716b6b2faee/qtquicktimeline-43130f2681b76a8d743a04704465b716b6b2faee.tar.bz2 -> qtquicktimeline-43130f2681b76a8d743a04704465b716b6b2faee.tar.bz2"

KEYWORDS="*"

DEPEND="
	=dev-qt/qtcore-5.15.2*
	=dev-qt/qtdeclarative-5.15.2*
"
RDEPEND="${DEPEND}"