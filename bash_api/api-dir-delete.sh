#!/bin/bash -x
# Set up uid, key, and endpoint
###################
#DELETE A DIRECTORY
###################
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`

# Choose the file to upload
#file_to_delete=/etc/passwd

# Choose the Atmos directory
atmos_dir="/$1"

# Build and send the Atmos request
filename=`basename $atmos_dir`
atmos_path="/rest/namespace${atmos_dir}/"

contentType="application/octet-stream"

signstr="DELETE\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X DELETE  \
     -H "Content-Type:$contentType"   \
     -H "x-emc-date:$date"     \
     -H "x-emc-uid:$uid"    \
     -H "x-emc-signature:$sig"    \
     --data-binary @${atmos_dir} ${endpoint}${atmos_path}

