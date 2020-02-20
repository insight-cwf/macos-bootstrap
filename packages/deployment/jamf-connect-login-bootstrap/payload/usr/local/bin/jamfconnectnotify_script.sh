#!/bin/sh

VERSION=0.2

#
#   jcl-enrollment.sh
#
#   An enrollment script used with Jamf Connect Login
#
#   This particular version has been modified for deployment with WSO UEM.
#


SCRIPT_NAME=$(/usr/bin/basename "$0" | /usr/bin/awk -F "." '{print $1}')
DEPNOTIFY_LOG="/var/tmp/depnotify.log"
IMAGES_DIR="/usr/local/images/"
# String that comes after the date in the log file and before the log
# information.
LOG_DECARATOR="Notify Enrollment"

# Set the name of the computer
# In this case we are using the Serial Number.
COMPUTER_NAME=$(/usr/sbin/system_profiler SPHardwareDataType | \
        /usr/bin/awk '/Serial\ Number\ \(system\)/ {print $NF}')

# Download URL for the WorkspaceONE Intelligence HUB Agent
WSO_AGENT_URL="https://storage.googleapis.com/getwsone-com-prod/downloads/VMwareWorkspaceONEIntelligentHub.pkg"


# The stuff AirWatch needs
# AuthHeader uses Svc Acct
# AuthString='Basic PASSWORD'
# # TenantCode is Unique to MacOS
# TenantCodeString='STRING GOES HERE'
# # SerialNumber Of Device
# DeviceSerialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
# # URI for apps
# APP1="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber1/install"
# APP2="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# APP3="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# APP4="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# APP5="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# APP6="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# APP7="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"
# RequestURIOffice="https://000.awmdm.com/api/mam/apps/internal/YourAppNumber/install"


logging() {
    # Logging function
    LOG_FILE="$SCRIPT_NAME-$(date +"%Y-%m-%d").log"
    LOG_PATH="/Library/Logs/$LOG_FILE"
    DATE=$(date +"[%b %d, %Y %Z %T INFO]")
    /bin/echo "$DATE: $LOG_DECARATOR: $1" >> $LOG_PATH
}


current_user() {
    printf '%s' "show State:/Users/ConsoleUser" | \
        /usr/sbin/scutil | \
        /usr/bin/awk '/Name :/ && ! /loginwindow/ {print $3}'
}


software_update() {
    # Disable Software Updates during imaging and wait for user to be fully
    # logged on
    # Pass on or off to this function if you want to enable or disable
    # softwareupdates respectively.
    logging "softwareupdate set to $1 ..."
    softwareupdate --schedule $1
}


set_computer_name() {
    # Set the computer name by passing in the COMPUTER_NAME variable.
    # Store device serial number
    logging "Setting computer name to: $1"
    # Set device name using scutil
    /usr/sbin/scutil --set ComputerName "${1}"
    /usr/sbin/scutil --set LocalHostName "${1}"
    /usr/sbin/scutil --set HostName "${1}"
    /usr/bin/dscacheutil -flushcache
}


cleanup() {
    # Remove all the things that the Notify mechinism leaves behind.
    /bin/sleep 1
    /bin/echo "Command: Quit" >> "$DEPNOTIFY_LOG"
    /bin/sleep 1
    /bin/rm -rf "$DEPNOTIFY_LOG"
}


main() {
    # Runs the script

    logging ""
    logging "--- Starting $SCRIPT_NAME log ---"
    logging ""
    logging "Version: $VERSION"
    logging ""

    CURRENT_USER="$(current_user)"

    /bin/echo "STARTING RUN" >> /tmp/output.txt

    # Disable softwareupdate while configuring the Mac
    software_update off

    # Set a main image
    # Image can be up to 660x105 it will scale up or down proportionally to fit
    /bin/echo "Command: Image: $IMAGES_DIR/bootstrap-icon-small.png" >> "$DEPNOTIFY_LOG"

    # Set the Main Title at the top of the window
    /bin/echo "Command: MainTitle: Welcome to your new Mac!" >> "$DEPNOTIFY_LOG"

    # Set the Body Text
    /bin/echo "Command: MainText: We are so excited that you are here $CURRENT_USER!\\n To jumpstart your Mac we are setting up a few things for you automatically.\\nJust grab a coffee! It won't take long!." >> "$DEPNOTIFY_LOG"
    /bin/echo "Status: Preparing new machine" >> "$DEPNOTIFY_LOG"
    /bin/sleep 5

    /bin/echo "Command: Determinate: 5" >> "$DEPNOTIFY_LOG"
    /bin/sleep 5
    /bin/echo "Status: Checking some Magic for you..." >> "$DEPNOTIFY_LOG"

    ### Application installation
    # Add the API calls to install the applications from WSO.
    /bin/echo "Command: Image: $IMAGES_DIR/vmware-wso-uem-hub-icon.png" \
        >> "$DEPNOTIFY_LOG"
    /bin/echo "Status: Installing WorkspaceONE Intelligence Hub" \
        >> "$DEPNOTIFY_LOG"

    # Download the WSO agent and install it.
    /usr/bin/curl -L "$WSO_AGENT_URL" \
        -o "/tmp/VMwareWorkspaceONEIntelligentHub.pkg"
    /usr/sbin/installer \
        -pkg "/tmp/VMwareWorkspaceONEIntelligentHub.pkg" -target /

    /bin/echo "Command: Image: $IMAGES_DIR/jamf_connect_icon.png" \
        >> "$DEPNOTIFY_LOG"
    /bin/echo "Status: Installing Jamf Connect Verify" >> "$DEPNOTIFY_LOG"
    /bin/sleep 5

    # Doing some other stuff ...
    /bin/echo "Status: Doing more fancy stuff... you don't want to know..." \
        >> "$DEPNOTIFY_LOG"

    /bin/echo "Command: Image: $IMAGES_DIR/com.apple.macbook-retina-space-gray.png" \
        >> "$DEPNOTIFY_LOG"
    /bin/sleep 5

    /bin/echo "Status: Almost done!" >> "$DEPNOTIFY_LOG"
    /bin/sleep 5

    # Set the computer name
    set_computer_name "$COMPUTER_NAME"

    # Re-enable software update
    software_update on

    ### Clean Up
    cleanup

    logging ""
    logging "--- End $SCRIPT_NAME log ---"
    logging ""
}

# Call main
main
