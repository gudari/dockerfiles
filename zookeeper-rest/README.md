# Apache Zookeeper rest api

## basic test

```bash

#get the root node data
curl http://zookeeper-rest:9998/znodes/v1/

#get children of the root node
curl http://zookeeper-rest:9998/znodes/v1/?view=children

#get "/cluster1/leader" as xml (default is json)
curl -H'Accept: application/xml' http://zookeeper-rest:9998/znodes/v1/cluster1/leader

#get the data as text
curl -w "\n%{http_code}\n" "http://zookeeper-rest:9998/znodes/v1/cluster1/leader?dataformat=utf8"

#set a node (data.txt contains the ascii text you want to set on the node)
curl -T data.txt -w "\n%{http_code}\n" "http://zookeeper-rest:9998/znodes/v1/cluster1/leader?dataformat=utf8"

#create a node
curl -d "data1" -H'Content-Type: application/octet-stream' -w "\n%{http_code}\n" "http://zookeeper-rest:9998/znodes/v1/?op=create&name=cluster2&dataformat=utf8"

curl -d "data2" -H'Content-Type: application/octet-stream' -w "\n%{http_code}\n" "http://zookeeper-rest:9998/znodes/v1/cluster2?op=create&name=leader&dataformat=utf8"

#create a new session
curl -d "" -H'Content-Type: application/octet-stream' -w "\n%{http_code}\n" "http://zookeeper-rest:9998/sessions/v1/?op=create&expire=10"

#session heartbeat
curl -X "PUT" -H'Content-Type: application/octet-stream' -w "\n%{http_code}\n" "http://zookeeper-rest:9998/sessions/v1/02dfdcc8-8667-4e53-a6f8-ca5c2b495a72"

#delete a session
curl -X "DELETE" -H'Content-Type: application/octet-stream' -w "\n%{http_code}\n" "http://zookeeper-rest:9998/sessions/v1/02dfdcc8-8667-4e53-a6f8-ca5c2b495a72"

```
