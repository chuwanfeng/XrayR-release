# XRayR
A Xray backend framework that can easily support many panels.

一个基于Xray的后端框架，支持V2ay,Trojan,Shadowsocks协议，极易扩展，支持多面板对接

Find the source code here: [chuwwanfeng/XrayR](https://github.com/chuwanfeng/XrayR)

# 详细使用教程

[教程](https://xrayr-project.github.io/XrayR-doc/)

# 一键安装

```
bash <(curl -Ls https://raw.githubusercontent.com/chuwanfeng/XrayR-release/master/install.sh)

```

# 更新到vless+Reality

```
bash <(curl -Ls https://raw.githubusercontent.com/chuwanfeng/XrayR-release/master/install_vless.sh)

```

# 数据服务器配置
1.[重要]在“节点”填写通讯密钥，这将是v2board和xrayr后端对接的凭据

![](https://img2023.cnblogs.com/blog/2318738/202301/2318738-20230130100746425-1961829653.png)

2.再新建节点
![Trojan](https://img2023.cnblogs.com/blog/2318738/202301/2318738-20230130100654830-623083712.png)

# Docker 安装

```
docker pull ghcr.io/xrayr-project/xrayr:latest && docker run --restart=always --name xrayr -d -v ${PATH_TO_CONFIG}/config.yml:/etc/XrayR/config.yml --network=host ghcr.io/xrayr-project/xrayr:latest
```

# Docker compose 安装
0. 安装docker-compose: 
```
curl -fsSL https://get.docker.com | bash -s docker
curl -L "https://github.com/docker/compose/releases/download/1.26.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
1. `git clone https://github.com/chuwanfeng/XrayR-release`
2. `cd XrayR-release`
3. 编辑config。
配置文件基本格式如下，Nodes下可以同时添加多个面板，多个节点配置信息，只需添加相同格式的Nodes item即可。
4. 启动docker：`docker-compose up -d`
```
Log:
  Level: warning # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  - PanelType: "NewV2board" # 面板类型: SSpanel, NewV2board, PMpanel, Proxypanel, V2RaySocks, GoV2Panel
    ApiConfig:
      ApiHost: "https://www.baidu,com/" # v2board面板域名
      ApiKey: "123" #中心服务器设置的通讯密匙
      NodeID: 1111 #节点ID
      NodeType: Trojan # 节点类型: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # 联连中心服务器超时
      EnableVless: false # 是否启用 Vless(对于V2ray 节点类型)
      SpeedLimit: 0 # Mbps, 本地设置将取代远程设置，0表示禁用
      DeviceLimit: 0 # 本地设置将取代远程设置，0表示禁用
      RuleListPath: # /etc/XrayR/rulelist 本地规则列表文件的路径
      DisableCustomConfig: false # 禁用sspanel的自定义配置
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      DeviceOnlineMinTraffic: 100 # V2board面板设备数限制统计阈值，大于此流量时上报设备数在线，单位kB，不填则默认上报
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # 警告速度。设置为0禁用限速(mbps)
        WarnTimes: 0 # 在（警告次数）连续警告之后，用户将受到限制。设置为0可立即惩罚超速用户。
        LimitSpeed: 0 # 受限用户的速度限制（单位：mbps）
        LimitDuration: 0 # 限制将持续多少分钟（单位：分钟）
      GlobalDeviceLimitConfig:
        Enable: false # 是否启用用户的全局设备限制(全局设备限制需所有节点服务器连接到同一个 redis 服务器)
        RedisAddr: 127.0.0.1:6379 # redis服务器地址
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # 仅支持Trojan和 Vless
      FallBackConfigs:  # Support multiple fallbacks
        - SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
      EnableREALITY: false # 是否开启 REALITY
      DisableLocalREALITYConfig: false  # 直接从面板下发reality节点配置，启用了这个就可以忽略掉EnableREALITY、REALITYConfigs。
      REALITYConfigs: # 本地 REALITY 配置
        Show: false # Show REALITY debug
        Dest: m.media-amazon.com:443 # REALITY 目标地址
        ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
        ServerNames: # Required, list of available serverNames for the client, * wildcard is not supported at the moment.
          - m.media-amazon.com
        PrivateKey: # 可不填
        MinClientVer: # Optional, minimum version of Xray client, format is x.y.z.
        MaxClientVer: # Optional, maximum version of Xray client, format is x.y.z.
        MaxTimeDiff: 0 # Optional, maximum allowed time difference, unit is in milliseconds.
        ShortIds: # 可不填
          - ""
      CertConfig:
        CertMode: file # 关于如何获得证书的选项: none, file, http, tls, dns. 选择 "none" 将强制禁用 tls 配置.
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: /etc/XrayR/cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: /etc/XrayR/cert/node1.test.com.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
```

## Docker compose升级
在docker-compose.yml目录下执行：
```
docker-compose pull
docker-compose up -d
```
