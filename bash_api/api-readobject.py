#!/usr/bin/python

import base64
import hmac
import sha

import json
import pycurl

# Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"

# Choose the file to read
file_to_read="/opt/postgresqlbkdumps/postgresbackup050516_1115"

# Choose the Atmos directory to upload the file
atmos_dir="/postgres/"

# Build and send the Atmos request
#filename=`basename $file_to_read`


atmos_path="/rest/namespace${atmos_dir}$filename"



contentType="text/plain"


date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`
signstr="GET\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-uid:${uid}"
#sig=base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest() )

curl -i -X GET \
     -H "Content-Type:$contentType" \
     -H "x-emc-date:$date" \
     -H "x-emc-uid:$uid" \
     -H "x-emc-signature:$sig" \
     --data-binary @${file_to_read} ${endpoint}${atmos_path}

