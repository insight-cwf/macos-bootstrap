#!/bin/sh

##############################################################################
#
#   A post installation script for Jamf Connect Login
#
#   DESCRIPTION
#
#       This script installs the following elements of Jamf Connect
#
#           - Moves the JCL preference file into place
#           - Installs the JCL Package
#           - Enables the Notify mechanism
#
##############################################################################


HERE=$(/usr/bin/dirname "$0")

PLIST="$HERE/com.jamf.connect.login.plist"
ROOT_PREFS="/Library/Preferences"
PKG_NAME="JamfConnectLogin-1.5.0.pkg"
PKG_PATH="$HERE/$PKG_NAME"

# Move preferences file
/bin/cp -a "$PLIST" "$ROOT_PREFS"

# Install Jamf Connect Login
/usr/sbin/installer -pkg "$PKG_PATH" -target /

# Enabled Jamf Connect Login
/usr/local/bin/authchanger -reset -OIDC \
    -preAuth JamfConnectLogin:RunScript,privileged JamfConnectLogin:Notify

# Kill the login window to make sure JCL launches
/usr/bin/killall loginwindow

exit 0
