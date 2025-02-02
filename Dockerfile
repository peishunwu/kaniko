###############################################################################
#
#IMAGE:   Android SDK
#VERSION: 26.1.1
#
###############################################################################
FROM openjdk:8

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ENVIRONMENT VARS
###############################################################################
ENV ANDROID_HOME /usr/local/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

###############################################################################
# install gradle
###############################################################################
ARG SDK_ZIP_FILE=sdk-tools-linux-4333796.zip
ARG SDK_TOOLS_URL=https://dl.google.com/android/repository/${SDK_ZIP_FILE}
RUN set -o errexit -o nounset       \
    && wget ${SDK_TOOLS_URL}        \
    && unzip ${SDK_ZIP_FILE}        \
    && mkdir -p ${ANDROID_HOME}     \
    && mv tools ${ANDROID_HOME}     \
    && cd ${ANDROID_HOME}/tools/bin \
    && mkdir -p /root/.android      \
    && touch /root/.android/repositories.cfg \
    && yes | sdkmanager --licenses  \
    && ./sdkmanager platform-tools "platforms;android-29" "build-tools;29.0.2"
