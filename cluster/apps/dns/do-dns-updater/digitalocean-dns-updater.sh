#!/bin/sh

#################### CHANGE THE FOLLOWING VARIABLES ####################
TOKEN="${SECRET_DIGITALOCEAN_API_TOKEN}"
DOMAIN="${SECRET_DOMAIN}"
RECORD_ID="${SECRET_DIGITALOCEAN_RECORD_ID}"
LOG_FILE="/data/digital-ocean-dns-updater-log.txt"
########################################################################

CURRENT_IPV4="$(dig +short myip.opendns.com @resolver1.opendns.com)"
LAST_IPV4="$(tail -1 $LOG_FILE | awk -F, '{print $2}')"

if [ "$CURRENT_IPV4" = "$LAST_IPV4" ]; then
    echo "IP has not changed ($CURRENT_IPV4)"
else
    echo "IP has changed: $CURRENT_IPV4"
    echo "$(date),$CURRENT_IPV4" >> "$LOG_FILE"
    curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"data":"'"$CURRENT_IPV4"'"}' "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"
fi

# https://salvatorelab.com/2020/10/how-to-point-a-domain-to-your-dynamic-home-ip-address/

# curl GET -H "Content-Type: application/json" \
#     -H "Authorization: Bearer <TOKEN>" \
#     https://api.digitalocean.com/v2/domains/<DOMAIN>/records | json_pp
