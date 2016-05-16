#!/bin/bash -x

################################
#read an object on object store
################################

# Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"





#force pass in of 1 runtime parameter
if [ $# -ne 1 ]
then
  echo "i need a filename passing in as a runtime parameter"
  exit
else
  file_to_read="$1"
fi


# Choose the Atmos directory to upload the file
atmos_dir="/postgres/"


# Build and send the Atmos request
filename=`basename $file_to_read`

atmos_path="/rest/namespace${atmos_dir}$filename"

contentType="text/plain"


date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`
signstr="GET\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X GET \
     -H "Content-Type:$contentType" \
     -H "x-emc-date:$date" \
     -H "x-emc-uid:$uid" \
     -H "x-emc-signature:$sig" \
     --data-binary @${file_to_read} ${endpoint}${atmos_path}

