#!/usr/bin/env sh

#################################################################################
####  CONFIG VARIABLES
#################################################################################

# URL from which to download felix bundles listed in `FELIX_BUNDLES` variable. Must end with `/`
FELIX_MIRROR="https://www-us.apache.org/dist/felix/"
# Maven repo URL from which to download bundles listed in `MAVEN_BUNDLES` variable.  Must end with `/`
MAVEN_REPO="https://repo1.maven.org/maven2/"
# The temp folder this script creates where the felix installation will reside.
DIST=".felix"
# the main felix distro, downloaded from `FELIX_MIRROR`
MAIN="org.apache.felix.main.distribution-6.0.3.zip"
# Port to run felix on.
PORT=8080
# Bundles to be downloaded from `FELIX_MIRROR`
# What I have below are just examples, You can see other available mirrors 
# and bundles here: https://felix.apache.org/downloads.cgi#mirrors
# for each "bundle" below, the download URL is `${FELIX_MIRROR}${bundle}`
FELIX_BUNDLES=(
  org.apache.felix.http.api-3.0.0.jar
  org.apache.felix.http.jetty-4.0.14.jar
  org.apache.felix.http.servlet-api-1.1.2.jar
  org.apache.felix.scr-2.1.16.jar
  org.apache.felix.utils-1.11.0.jar
  org.apache.felix.webconsole-4.3.16-all.jar
  org.apache.felix.webconsole.plugins.ds-2.1.0.jar
)
# Bundles to be downloaded from `MAVEN_REPO`
# What I have below are just example bundles, you can add any bundle you want!
# for each "bundle" below, the download URL is `${MAVEN_REPO}${bundle}`
# so make sure to include the full path after the $MAVEN_REPO URL.
MAVEN_BUNDLES=(
  org/osgi/org.osgi.service.cm/1.6.0/org.osgi.service.cm-1.6.0.jar
  org/osgi/org.osgi.util.function/1.1.0/org.osgi.util.function-1.1.0.jar
  org/osgi/org.osgi.util.promise/1.1.1/org.osgi.util.promise-1.1.1.jar
)

#################################################################################
####  HELPER FUNCTIONS
#################################################################################
# print in blue color
info () {
  printf "\e[1;34m[INFO]:: %s ::\e[0m\n" "$*"
}
warn () {
  printf "\e[1;33m[INFO]:: %s ::\e[0m\n" "$*"
}
# print in red color
error () {
  printf "\e[1;31m[ERROR]:: %s ::\e[0m\n" "$*"
}

# download and show progress indicator
# first param [required] is the full URL
# second param [required] is the file output name
DOWNLOADED=""
download () {
  local out="./$DIST/$2"
  curl $1 --output $out --fail -#
  local res=$?
  if test "$res" != "0"; then
    error "Failed to download: $1. Exit Code: $res"
  fi
  DOWNLOADED="$out" # for later use as return value
}

# download from felix 
# first param [required] is the file name in felix mirror (see: https://www-us.apache.org/dist/felix/)
# second param [optional] is the file output name
downloadFromFelixMirror () {
  local downloadUrl=${FELIX_MIRROR}$1
  local out=${2:-$1} 
  info "[Felix Mirror] Downloading: $1"
  download $downloadUrl $out
}

# download from felix 
# first param [required] is the file name in felix mirror (see: https://www-us.apache.org/dist/felix/)
# second param [optional] is the file output name
downloadFromMavenRepo () {
  local downloadUrl=${MAVEN_REPO}$1
  local out=${2:-$1} 
  info "[Maven Repo] Downloading: $1"
  download $downloadUrl $out
}

# https://superuser.com/a/573624/1055680
unzipStrip() (
    local zip=$1
    local dest=${2:-.}
    info "unzipping $zip into $dest" 
    local temp=$(mktemp -d) && unzip -d "$temp" "$zip" | awk 'BEGIN {ORS=""} {print "."}' && mkdir -p "$dest" &&
    shopt -s dotglob && local f=("$temp"/*) &&
    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi && rmdir "$temp"/* "$temp"
    echo "" # new line
    info "Unzipped!"
)

#################################################################################
####  MAIN
#################################################################################
info "Felix Mirror is set to: $FELIX_MIRROR"
info "OSGI Mirror is set to: $MAVEN_REPO"
info "Cleaning $DIST Folder..."
rm -rf $DIST
mkdir $DIST
info "Cleaned."

info "Downloading Felix Main Distribution: ${MAIN}"
downloadFromFelixMirror $MAIN
unzipStrip $DOWNLOADED ./$DIST

for bundle in "${FELIX_BUNDLES[@]}"; do
  downloadFromFelixMirror $bundle "bundle/$bundle"
done

for bundle in "${MAVEN_BUNDLES[@]}"; do
  downloadFromMavenRepo $bundle "bundle/${bundle##*/}" # see: https://unix.stackexchange.com/a/325492
done

info "Updating port to $PORT"
sed -i '' "s/\(org\.osgi\.service\.http\.port=\).*\$/\1${PORT}/" $DIST/conf/config.properties 

warn "RUNNING FELIX!!!"
warn "Felix will open interactive GOGO Shell below. Type 'system:exit 0' to terminate felix"
warn "You can now go to http://localhost:$PORT/system/console and use creds admin:admin"

cd ./$DIST
java -jar -Djetty.port=9999 bin/felix.jar 
