#!/bin/sh
#KEY="COMPLETEHERE"
KEY="USER_API_KEY_GOES_HERE"
DID="DOMAIN_ID_GOES_HERE"
RID="RESOURCE_ID_GOES_HERE"

HOST="https://api.linode.com/"
ACTION="domain.resource.update"
URL="${HOST}?api_key=${KEY}&api_action=${ACTION}&domainid=${DID}&resourceid=${RID}&target=[remote_addr]"

LOGFILE=/var/log/linode_dyndns.log
echo "Updated $(date): " >>$LOGFILE
wget -qO- --no-check-certificate "$URL" >>$LOGFILE

