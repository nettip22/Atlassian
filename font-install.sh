#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo -e "$# is Illegal number of parameters.\n"
    echo -e "Usage: $0 confluence-installed-dir\n"
    echo "Example: $0 /var/atlassian/atlassian-confluence-6.7.0"
    exit 1
fi

CONF_DIR=$1

if [ ! -f "${CONF_DIR}/bin/setenv.sh" ]; then
    echo "${CONF_DIR}/bin/setenv.sh does not exist.!";
    exit 1;
fi

SETENV_SH=${CONF_DIR}/bin/setenv.sh

if [ -z ${JAVA_HOME+x} ]; then
    echo "JAVA_HOME env is unset.";
    echo "exiting...";
    exit 1;
else·
    echo "JAVA_HOME is set to '$JAVA_HOME'";
fi

## create fallback font dir
FONT_DIR=${JAVA_HOME}/jre/lib/fonts/fallback
mkdir -p ${FONT_DIR}

## download nanum font
curl -o nanumfont.zip http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip

## extract to font dir
unzip nanumfont.zip -d ${FONT_DIR}
ln -s ${FONT_DIR} /usr/share/fonts/nanum
fc-cache -f -v

## append JVM paramter
echo "### See https://jira.atlassian.com/browse/CONFSERVER-36557 " >> ${SETENV_SH}

echo "CATALINA_OPTS=\"-Dconfluence.document.conversion.fontpath=${JAVA_HOME}/jre/lib/fonts/fallback \${CATALINA_OPTS}\"" >> ${SETENV_SH}
echo "CATALINA_OPTS=\"-Dconfluence.document.conversion.words.defaultfontname=NanumGothic \${CATALINA_OPTS}\"" >> ${SETENV_SH}
echo "CATALINA_OPTS=\"-Dconfluence.document.conversion.slides.defaultfontname.regular=NanumGothic \${CATALINA_OPTS}\"" >> ${SETENV_SH}
echo "CATALINA_OPTS=\"-Dconfluence.document.conversion.slides.defaultfontname.asian=NanumGothic \${CATALINA_OPTS}\"" >> ${SETENV_SH}
echo "CATALINA_OPTS=\"-Dconfluence.document.conversion.slides.defaultfontname.symbol=NanumGothic \${CATALINA_OPTS}\"" >> ${SETENV_SH}

echo -e "\n\n\n" >> ${SETENV_SH}
echo "export CATALINA_OPTS" >> ${SETENV_SH}

##·
echo "You need to restart Confluence!!"
