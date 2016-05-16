#!/bin/bash -x

##################
#USER METADATA GET
################## 

#Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"

if [ $# -eq 1 ]
then
  echo "get metadata for $1"
  filepath="$1"
  echo ""
  echo "filepath is $filepath"
  echo ""
else
  echo "please supply a runtime parameter"
  exit
fi

md5check=md5check

# Choose the Atmos directory to upload the file
atmos_dir="/postgres/"

# Build and send the Atmos request
filename=`basename $filepath`
atmos_path="/rest/namespace${atmos_dir}${filename}?metadata/user"

contentType="application/octet-stream"
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`
signstr="GET\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-listable-meta:${md5check}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X GET \
     -H "Content-Type:$contentType" \
     -H "x-emc-date:$date" \
     -H "x-emc-listable-meta:$md5check"  \
     -H "x-emc-uid:$uid" \
     -H "x-emc-signature:$sig" \
     --data-binary @${filepath} ${endpoint}${atmos_path}

