#!/bin/sh

python generatejson.py --base-url https://github.com --output ~/Desktop \
--item \
item-name='JamfConnectLogin' \
item-path='/Users/captam3rica/OneDrive - Insight/Git Repos/macos-bootstrap/payload/setupassistant/jamf-connect-login-bootstrap.pkg' \
item-stage='setupassistant' \
item-type='package' \
item-url='https://raw.githubusercontent.com/captam3rica/macos-bootstrap/master/payload/setupassistant/jamf-connect-login-bootstrap.pkg' \
script-do-not-wait=False
