#!/bin/bash -x
# Set up uid, key, and endpoint
#
####################
#CREATE A DIRECTORY
####################
#
#basically, create a populated dir, then remove dummy file
#

uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"

# Choose the file to upload
file_to_upload=./dummyfile.txt

# Choose the Atmos directory to upload the file
atmos_dir="/$1/"

# Build and send the Atmos request
filename=`basename $file_to_upload`
atmos_path="/rest/namespace${atmos_dir}$filename"
contentType="text/plain"
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`
signstr="POST\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X POST \
     -H "Content-Type:$contentType" \
     -H "x-emc-date:$date" \
     -H "x-emc-uid:$uid" \
     -H "x-emc-signature:$sig" \
     --data-binary @${file_to_upload} ${endpoint}${atmos_path}

# Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`

# Choose the file to upload
file_to_delete=./dummyfile.txt

# Choose the Atmos directory

# Build and send the Atmos request
filename=`basename $file_to_delete`
atmos_path="/rest/namespace${atmos_dir}$filename"

contentType="application/octet-stream"

signstr="DELETE\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X DELETE  \
     -H "Content-Type:$contentType"   \
     -H "x-emc-date:$date"     \
     -H "x-emc-uid:$uid"    \
     -H "x-emc-signature:$sig"    \
     --data-binary @${file_to_delete} ${endpoint}${atmos_path}


