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
	"inbounds": [{
			"port": $PORT,
			"protocol": "vmess",
			"settings": {
				"clients": [{
					"id": "$UUID",
					"level": 1,
					"alterId": 0
				}]
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

	],
	"outbounds": [{
			"protocol": "freedom",
			"settings": {
				"domainStrategy": "UseIP"
			},
			"tag": "direct"
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
		},
		{
			"protocol": "mtproto",
			"settings": {},
			"tag": "tg-out"
		}

	],
	"dns": {
		"servers": [
			"https+local://8.8.8.8/dns-query",
			"8.8.8.8",
			"1.1.1.1",
			"localhost"
		]
	},
	"routing": {
		"domainStrategy": "IPOnDemand",
		"rules": [{
				"type": "field",
				"ip": [
					"0.0.0.0/8",
					"10.0.0.0/8",
					"100.64.0.0/10",
					"127.0.0.0/8",
					"169.254.0.0/16",
					"172.16.0.0/12",
					"192.0.0.0/24",
					"192.0.2.0/24",
					"192.168.0.0/16",
					"198.18.0.0/15",
					"198.51.100.0/24",
					"203.0.113.0/24",
					"::1/128",
					"fc00::/7",
					"fe80::/10"
				],
				"outboundTag": "blocked"
			},
			{
				"type": "field",
				"inboundTag": ["tg-in"],
				"outboundTag": "tg-out"
			},
			{
				"type": "field",
				"domain": [
					"domain:epochtimess.com",
					"domain:shenyuns.com"
				],
				"outboundTag": "blocked"
			},
			{
				"type": "field",
				"protocol": [
					"bittorrent"
				],
				"outboundTag": "blocked"
			}
		]
	},
	"transport": {
		"kcpSettings": {
			"uplinkCapacity": 100,
			"downlinkCapacity": 100,
			"congestion": true
		}
	}
}
EOF

# Run V2Ray
/usr/bin/v2ray -config /etc/v2ray/config.json
