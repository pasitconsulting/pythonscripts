#!/bin/bash -x

##############################################
#anonymous download of object on object store
##############################################

# Set up uid, key, and endpoint
uid="0d5f8c93737d4e82b95254083f30594d/A6352552154f0b04a38c"
uid_corrected=`echo $uid | sed 's/\//%2F/g' | sed 's/\=/%3D/g'  | sed 's/\+/%2B/g' `

key="9+DFQyvChotHSCFrjJaWLAYh/A8="
#remove forward slash and = from key
key_adjusted=`echo $key | sed 's/\//%2F/g' | sed 's/\=/%3D/g' | sed 's/\+/%2B/g' `

endpoint="https://cas00003.skyscapecloud.com"

download_dir="/opt/backup/downloads"



#force pass in of 1 runtime parameter
if [ $# -ne 1 ]
then
  echo "i need a filename passing in as a runtime parameter"
  exit
else
  pathname="$1"
fi


# Build and send the Atmos request
filename=`basename $pathname`

#calculate signature
date=`date -u +"%a, %d %b %Y %H:%M:%S GMT"`


#datein24hours
#expires=`date '+%s' -d '+24 hour' `
expires=1463661414
signstr="GET\nrequested-resource:${pathname}\nuid:${uid}\nexpires:${expires}"
sig=$(python -c "import base64, hmac, sha; print base64.b64encode(hmac.new(base64.b64decode(\"$key\"), \"$signstr\", sha).digest())")


signature_corrected=`echo $sig | sed 's/\//%2F/g' | sed 's/\=/%3D/g' | sed 's/\+/%2B/g' `


#get public url
public_url="$endpoint/rest/namespace$pathname?uid=$uid&expires=$expires&signature=$sig"

cd $download_dir


#rename file to original name

#call md5check api core script


#run md5check against downloaded file and compare

curl -i -X GET \
     -H "requested-resource:$public_url" \
     -H "uid:$uid" \
     -H "expires:$expires" \
     -H "signature:$sig" \
     -o ./restored-file \
     -vvv \
     https://cas00003.skyscapecloud.com/rest/namespace/postgres/postgresbackup180516_2729.tar.gz?uid=0d5f8c93737d4e82b95254083f30594d%2FA6352552154f0b04a38c&expires=1463661414&signature=ZE0f%2B3aL6PYzstsDvCXXO3leLsM%3D
#     $public_url
#     --data-urlencode name=$public_url
#     --data-binary @${filename} ${endpoint}${pathname}


# curl --data-urlencode "requested-resource:$public_url, uid=$uid" $public_url

