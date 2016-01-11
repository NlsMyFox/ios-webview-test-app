#!/usr/bin/env bash

if [ -z "${JENKINS_HOME}" ] && [ -z "${TRAVIS}" ]; then
  echo "FAIL: only run this script on Jenkins or Travis"
  exit 1
fi

bin/ci/install-keychain.sh

CODE_SIGN_DIR="${HOME}/.calabash/calabash-codesign"
KEYCHAIN="${CODE_SIGN_DIR}/ios/Calabash.keychain"

# cucumber/.env must exist or "make ipa-cal" will not stage for submit
DOTENV="CalWebViewApp/.env"

STAGING="${HOME}/.calabash/xtc/calabash-ios-server/submit"
echo "XTC_STAGING_DIR=\"${STAGING}\"" > "${DOTENV}"
echo "IPA=\"${STAGING}/LPTestTarget.ipa\"" >> "${DOTENV}"
echo "XTC_OTHER_GEMS_FILE=config/xtc-other-gems" >> "${DOTENV}"
echo "XTC_CALABASH_GEM_DEV=1" >> "${DOTENV}"
echo "XTC_RUN_LOOP_GEM_DEV=1" >> "${DOTENV}"
echo "XTC_SERIES=master" >> "${DOTENV}"
echo "XTC_DSYM=\"${STAGING}/LPTestTarget.app.dSYM\"" >> "${DOTENV}"
echo "XTC_WAIT_FOR_RESULTS=0" >> "${DOTENV}"
echo "XTC_LOCALE=en_US" >> "${DOTENV}"
echo "XTC_ACCOUNT=calabash-ios-ci" >> "${DOTENV}"
echo "XTC_USER=joshua.moody@xamarin.com" >> "${DOTENV}"

OUT=`xcrun security find-identity -p codesigning -v "${KEYCHAIN}"`
IDENTITY=`echo $OUT | grep -E -o "iPhone Developer: Karl Krukow \([0-9A-Z]{10}\)" | tr -d '\n'`
(cd CalWebViewApp && CODE_SIGN_IDENTITY="${IDENTITY}" make ipa-cal)

