#!/Library/installapplications/Python.framework/Versions/3.8/bin/python3

from distutils.version import LooseVersion
from Foundation import NSLog
from SystemConfiguration import SCDynamicStoreCopyConsoleUser
import hashlib
import json
import optparse
import os
import plistlib
import re
import shutil
import subprocess
import sys
import time
import urllib.request, urllib.parse, urllib.error

sys.path.append(
    "/Users/captam3rica/OneDrive - Insight/Git Repos/macos-bootstrap/packages/tools/installapplications-2.0rc4"
)
# PEP8 can really be annoying at times.
import gurl  # noqa


def pkgregex(pkgpath):
    try:
        # capture everything after last / in the pkg filepath
        pkgname = re.compile(r"[^/]+$").search(pkgpath).group(0)
        return pkgname
    except AttributeError as IndexError:
        return pkgpath


def downloadfile(options):
    connection = gurl.Gurl.alloc().initWithOptions_(options)
    percent_complete = -1
    bytes_received = 0
    connection.start()
    try:
        filename = options["name"]
    except KeyError:
        print("No 'name' key defined in json for %s" % pkgregex(options["file"]))
        sys.exit(1)

    try:
        while not connection.isDone():
            if connection.destination_path:
                # only print progress info if we are writing to a file
                if connection.percentComplete != -1:
                    if connection.percentComplete != percent_complete:
                        percent_complete = connection.percentComplete
                        print(
                            "Downloading %s - Percent complete: %s "
                            % (filename, percent_complete)
                        )
                elif connection.bytesReceived != bytes_received:
                    bytes_received = connection.bytesReceived
                    print(
                        "Downloading %s - Bytes received: %s "
                        % (filename, bytes_received)
                    )

    except (KeyboardInterrupt, SystemExit):
        # safely kill the connection then fall through
        connection.cancel()
    except Exception:  # too general, I know
        # Let us out! ... Safely! Unexpectedly quit dialogs are annoying ...
        connection.cancel()
        # Re-raise the error
        raise

    if connection.error is not None:
        print(
            "Error: %s %s "
            % (
                str(connection.error.code()),
                str(connection.error.localizedDescription()),
            )
        )
        if connection.SSLerror:
            print("SSL error: %s " % (str(connection.SSLerror)))
    if connection.response is not None:
        print("Status: %s " % (str(connection.status)))
        print("Headers: %s " % (str(connection.headers)))
    if connection.redirection != []:
        print(f"Redirection: %s " % (str(connection.redirection)))


jsonurl = "https://raw.githubusercontent.com/captam3rica/macos-bootstrap/master/payload/setupassistant/01-jamf-connect-login-bootstrap.pkg"
jsonpath = "/Library/installapplications/01-jamf-connect-login-bootstrap.pkg"

# json data for gurl download
json_data = {"url": jsonurl, "file": jsonpath, "name": "Bootstrap.json"}

downloadfile(options=json_data)
