# nginx
=========

A simple role to install nginx as a proxy

```
- name: Install Nginx
  include_role:
    name: gg.nginx
  vars:
    enable_php: true

    gg_local_proxies:
      - server_name: convert.greenlight.guru
        proxy_url: http://localhost:8099

    gg_proxies:
      - server_name: matthew.greenlight.guru
        proxy_url: http://www.bible.com:8099
      - listen_port: 443
        server_name: john.greenlight.guru
        proxy_url: https://www.readme.com:8081
      - listen_port: 80
        server_name: luke.greenlight.guru
        proxy_url: http://www.bible.com:8055

    gg_ondisk_sites:
      - nginx_listen_port: 80
        nginx_server_name: test.local.com
        custom_additions: |
          location /downloads {
            autoindex on;
            add_header Content-Type: text/plain;
          }
```

# Additional Proxy Options

* custom_additions - appended to end of server block, defaults to null, not included by default
* grpc - is this a grpc proxy, defaults to false.
* local_timeout - defaults to null, not included by default
* location - location path, defaults to '/'
* websocket - defaults to false
* ssl - defaults to on, options "on" or "off"
