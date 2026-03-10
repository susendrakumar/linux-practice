#!/bin/bash
status_code=$(curl -L -o /dev/null -s -w "%{http_code}" https://guvi.in)
echo "HTTP Status Code: $status_code"
if [ $status_code -eq 200 ]
then
    echo "Success: guvi.in website is reachable"
else
    echo "Failure: guvi.in website is not reachable"
fi
