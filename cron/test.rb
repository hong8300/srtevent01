

# curl_cmd = "curl -X PUT -H 'Content-Type:application/json' -d '{ ¥"status¥":2 }' http://0.0.0.0:3000/api/v1/events/1"
event_status = 10
event_id = 1
curl_cmd = "curl -X PUT -H \'Content-Type:application/json\' -d \'{ \"status\":#{event_status} }\' http://0.0.0.0:3000/api/v1/events/#{event_id}"
system(curl_cmd)