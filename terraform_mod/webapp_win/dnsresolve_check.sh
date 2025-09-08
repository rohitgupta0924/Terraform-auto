#!/bin/bash

domain_name="$1"
max_attempts=120
interval=5

for attempt in $(seq "$max_attempts"); do
    resolved_ip=$(nslookup "$domain_name" | awk -v domain="$domain_name" '
        BEGIN { matched = 0 }
        /^Name:/ { if ($2 == domain) matched = 1 }
        matched && /^Address:/ { print $2; exit }
    ' | xargs)
    
    if [[ -n "$resolved_ip" ]]; then
        echo "A Record created for $domain_name with IP $resolved_ip"
        exit 0
    fi
    
    echo "A Record not yet created for $domain_name"
    sleep "$interval"
done

exit 1
