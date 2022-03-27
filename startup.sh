#!/bin/sh

cat << EOF > /etc/v2ray/config.json
{
    "policy": {
        "levels": {
            "0": {
                "handshake": 5,
                "connIdle": 300,
                "uplinkOnly": 2,
                "downlinkOnly": 5,
                "statsUserUplink": false,
                "statsUserDownlink": false,
                "bufferSize": 10240
            }
        },
        "system": {
            "statsInboundUplink": false,
            "statsInboundDownlink": false,
            "statsOutboundUplink": false,
            "statsOutboundDownlink": false
        }
    },
//    "inbounds": [
//        {
//           "port": $PORT,
//            "protocol": "vless",
//            "settings": {
//                "clients": [
//                    {
//                        "id": "$UUID",
//                        "level": 0
//                    }
//                ],
//                 "decryption": "none"
//            },
//            "streamSettings": {
//                "network": "ws",
//                "security": "none"
//            }
//        }
//    ],
    
    
    	"inbounds": [
		{
			"port": $PORT,
			"protocol": "vmess",
			"settings": {
				"clients": [
					{
						"id": "$UUID",
						"level": 1,
						"alterId": 0
					}
				]
			},
			"streamSettings": {
				"network": "tcp",
				"tcpSettings": {
					"header": {
						"type": "http",
						"response": {
							"version": "1.1",
							"status": "200",
							"reason": "OK",
							"headers": {
								"Content-encoding": [
									"gzip"
								],
								"Content-Type": [
									"text/html; charset=utf-8"
								],
								"Cache-Control": [
									"no-cache"
								],
								"Vary": [
									"Accept-Encoding"
								],
								"X-Frame-Options": [
									"deny"
								],
								"X-XSS-Protection": [
									"1; mode=block"
								],
								"X-content-type-options": [
									"nosniff"
								]
							}
						}
					}
				}
			},
			"sniffing": {
				"enabled": true,
				"destOverride": [
					"http",
					"tls"
				]
			}
		}
		//include_ss
		//include_socks
		//include_mtproto
		//include_in_config
		//
	],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run V2Ray
/usr/bin/v2ray -config /etc/v2ray/config.json
