#!/usr/bin/env bash

# usage:
# ./upload.sh theme-name user:pass http://yourserver.org

THEMENAME=$1
USER_PASS=$2
SERVER=$3

[[ -z $1 ]] && echo "File name required." && exit 1;
[[ -z $2 ]] && echo "Username (and optional password) required." && exit 1;
# [[ $2 != *:* ]] && echo "Please enter username and password in the format 'username:password'." && exit
[[ -z $3 ]] && echo "Server hostname required. ['http://server.org']" && exit 1;

# strip '.zip' from THEMENAME argument if entered
[[ ${THEMENAME} == *.zip ]] && THEMENAME=${THEMENAME%.zip}

# strip 'themes/' if entered
[[ ${THEMENAME} =~ themes/* ]] && THEMENAME=${THEMENAME##*themes/}

cd ./themes

echo ""
echo "Getting '${THEMENAME}' theme..."
echo ""

[[ -e "${THEMENAME}.zip" ]] && PACKAGE="${THEMENAME}.zip"
[[ -z ${PACKAGE} && -e "${THEMENAME}" ]] \
    && zip -r ${THEMENAME} ${THEMENAME} -x \*__MAC* \*.DS_Store \
    && PACKAGE="${THEMENAME}.zip"

[[ -z ${PACKAGE} || ! -e ${PACKAGE} ]] && echo "Theme package '${THEMENAME}' not found." && exit 1;

# add XAPI endpoint for URL
URL="${SERVER}/xapi/theme"

# NAME_PARAM="name=\"themePackage\""
# FILE_PARAM="filename=\"${PACKAGE}\""
# FILE_PARAM="filename='${PACKAGE}';type='application/zip'"

# Complex file data upload via curl
# https://stackoverflow.com/questions/10765243/

delim="-----MultipartDelimeter$$$RANDOM$RANDOM$RANDOM"
nl=$'\r\n'
mime="application/zip"

# This is the "body" of the request.
formData() {
    # Also make sure to set the fields you need.
    printf %s "--${delim}${nl}"
    printf %s "Content-Disposition: form-data; name=\"themePackage\"; filename=\"${PACKAGE}\"${nl}"
    printf %s "Content-Type: application/zip${nl}${nl}"
    cat "${PACKAGE}"
    printf %s "${nl}--${delim}--${nl}"
}

response=`formData | curl -v -X POST "${URL}" -u "${USER_PASS}" -H "content-type: multipart/form-data; boundary=${delim}" --data-binary @-`

if [[ ! -z ${response} ]]; then
    echo ""
    echo "Theme uploaded."
    echo "response: ${response}"
    echo ""
    read -p "Would you like to set the active theme to '${THEMENAME}'? [y/N] " YN
    echo ""
    [[ ${YN} =~ [Yy] ]] && activeTheme=`curl -v -X PUT ${URL}/${THEMENAME} -u "${USER_PASS}"`
    echo ""
    echo "Theme activated."
    echo "response: ${activeTheme}"
    echo ""
else
    echo ""
    echo "Upload failed."
    echo ""
fi

cd - >/dev/null

exit 0
