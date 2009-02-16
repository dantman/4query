SRC_DIR = src
BUILD_DIR = build

PREFIX = .
DOCS_DIR = ${PREFIX}/docs
TEST_DIR = ${PREFIX}/test
DIST_DIR = ${PREFIX}/dist
SPEED_DIR = ${PREFIX}/speed
#PLUG_DIR = ../plugins

BASE_FILES = ${SRC_DIR}/core.js\
	${SRC_DIR}/data.js\
	${SRC_DIR}/selector.js\
	${SRC_DIR}/event.js\
	${SRC_DIR}/support.js\
	${SRC_DIR}/ajax.js\
	${SRC_DIR}/fx.js\
	${SRC_DIR}/offset.js\
	${SRC_DIR}/dimensions.js

#PLUGINS = ${PLUG_DIR}/button/*\
#	${PLUG_DIR}/center/*\
#	${PLUG_DIR}/cookie/*\
#	${PLUG_DIR}/dimensions/*\
#	${PLUG_DIR}/metadata/*\
#	${PLUG_DIR}/form/*\
#	${PLUG_DIR}/greybox/greybox.js\
#	${PLUG_DIR}/interface/*\
#	${PLUG_DIR}/pager/*\
#	${PLUG_DIR}/tablesorter/*\
#	${PLUG_DIR}/tabs/*\
#	${PLUG_DIR}/tooltip/jquery.tooltip.js\
#	${PLUG_DIR}/accordion/jquery.accordion.js

MODULES = ${SRC_DIR}/intro.js\
	${BASE_FILES}\
	${SRC_DIR}/outro.js

#MODULES_WITH_PLUGINS = ${SRC_DIR}/intro.js\
#	${BASE_FILES}\
#	${PLUGINS}\
#	${SRC_DIR}/outro.js

FQ = ${DIST_DIR}/4query.js
FQ_LITE = ${DIST_DIR}/4query.lite.js
FQ_MIN = ${DIST_DIR}/4query.min.js
#FQ_PACK = ${DIST_DIR}/4query.pack.js

JQ_VER = `cat jversion.txt`
FQ_VER = `cat 4version.txt`
VER = sed "s/@4VERSION/${FQ_VER}/;s/@JVERSION/${JQ_VER}/"

JAR = java -jar ${BUILD_DIR}/js.jar
MINJAR = java -jar ${BUILD_DIR}/yuicompressor-2.4.2.jar

#DATE=`svn info . | grep Date: | sed 's/.*: //g'`
#REV=`svn info . | grep Rev: | sed 's/.*: //g'`

all: 4query lite min speed
	@@echo "4query build complete."

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

4query: ${DIST_DIR} ${FQ}

${FQ}: ${MODULES}
	@@echo "Building" ${FQ}

	@@mkdir -p ${DIST_DIR}
	@@cat ${MODULES} | \
#		sed 's/Date:./&'"${DATE}"'/' | \
#		sed 's/Revision:./&'"${REV}"'/' | \
		${VER} > ${FQ};

	@@echo ${FQ} "Built"
	@@echo

#with_plugins: ${MODULES_WITH_PLUGINS}
#	@@echo "Building" ${FQ}
#
#	@@mkdir -p ${DIST_DIR}
#	@@cat ${MODULES_WITH_PLUGINS} | ${VER} > ${FQ};
#
#	@@echo ${FQ} "Built"
#	@@echo

lite: ${FQ_LITE}

${FQ_LITE}: ${FQ}
	@@echo "Building" ${FQ_LITE}

	@@cp ${FQ} ${FQ_LITE}

	@@echo ${FQ_LITE} "Built"
	@@echo

#pack: ${FQ_PACK}

#${FQ_PACK}: ${FQ}
#	@@echo "Building" ${FQ_PACK}
#
#	@@echo " - Compressing using Packer"
#	@@${JAR} ${BUILD_DIR}/build/pack.js ${FQ} ${FQ_PACK}
#
#	@@echo ${FQ_PACK} "Built"
#	@@echo

min: ${FQ_MIN}

${FQ_MIN}: ${FQ}
	@@echo "Building" ${FQ_MIN}

	@@echo " - Compressing using Minifier"
	@@${MINJAR} ${FQ} > ${FQ_MIN}

	@@echo ${FQ_MIN} "Built"
	@@echo

test: ${FQ}
	@@echo "Building Test Suite"
	@@echo "Test Suite Built"
	@@echo

runtest: ${FQ} test
	@@echo "Running Automated Test Suite"
	@@${JAR} ${BUILD_DIR}/runtest/test.js

	@@echo "Test Suite Finished"
	@@echo

speed: ${FQ}
	@@echo "Building Speed Test Suite"

	@@echo " - Making Speed Test Suite Directory:" ${SPEED_DIR}
	@@mkdir -p ${SPEED_DIR}

	@@echo " - Copying over script files."
	@@cp -f ${BUILD_DIR}/speed/index.html ${SPEED_DIR}
	@@cp -f ${BUILD_DIR}/speed/benchmarker.css ${SPEED_DIR}
	@@cp -f ${BUILD_DIR}/speed/benchmarker.js ${SPEED_DIR}
	@@cp -f ${BUILD_DIR}/speed/jquery-basis.js ${SPEED_DIR}

	@@echo "Speed Test Suite Built"
	@@echo

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

	@@echo "Removing Documentation directory:" ${DOCS_DIR}
	@@rm -rf ${DOCS_DIR}

	@@echo "Removing Speed Test Suite directory:" ${SPEED_DIR}
	@@rm -rf ${SPEED_DIR}
