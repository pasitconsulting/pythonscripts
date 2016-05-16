#!/bin/bash -x

##################
#USER METADATA ADD
################## 

Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
key="9+DFQyvChotHSCFrjJaWLAYh/A8="
endpoint="https://cas00003.skyscapecloud.com"

# Choose the file to upload
pgbackupdir="/opt/postgresqlbkdumps"
latestpgbackup="`ls -at $pgbackupdir | head -n 1`"
file_to_upload="$pgbackupdir/$latestpgbackup"
md5check=$(/usr/bin/md5sum $file_to_upload | awk '{print $1}' )
md5file="md5check=$md5check"

# Choose the Atmos directory to upload the file
atmos_dir="/postgres/"

# Build and send the Atmos request
filename=`basename $file_to_upload`
atmos_path="/rest/namespace${atmos_dir}$filename?metadata/user"

contentType="text/plain"
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`
signstr="POST\n${contentType}\n\n\n${atmos_path}\nx-emc-date:${date}\nx-emc-listable-meta:${md5file}\nx-emc-uid:${uid}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")

curl -i -X POST \
     -H "Content-Type:$contentType" \
     -H "x-emc-date:$date" \
     -H "x-emc-listable-meta:$md5file"  \
     -H "x-emc-uid:$uid" \
     -H "x-emc-signature:$sig" \
     --data-binary @${file_to_upload} ${endpoint}${atmos_path}

