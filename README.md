## docker-ossecserver-wgui
[![](https://images.microbadger.com/badges/version/fabriziogaliano/docker-ossecserver-wgui.svg)](https://microbadger.com/images/fabriziogaliano/docker-ossecserver-wgui "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/fabriziogaliano/docker-ossecserver-wgui.svg)](https://microbadger.com/images/fabriziogaliano/docker-ossecserver-wgui "Get your own image badge on microbadger.com")

Docker OSSEC Server image with Web Interface

## Available Configuration Parameters

* __AUTO_ENROLLMENT_ENABLED__: Specifies whether or not to enable auto-enrollment via ossec-authd. Defaults to `true`;
* __AUTHD_OPTIONS__: Options to passed ossec-authd, other than -p and -g. Defaults to empty;
* __SMTP_ENABLED__: Whether or not to enable SMTP notifications. Defaults to `true` if ALERTS_TO_EMAIL is specified, otherwise `false`
* __SMTP_RELAY_HOST__: The relay host for SMTP messages, required for SMTP notifications. This host must support non-authenticated SMTP ([see this thread](https://ossec.uservoice.com/forums/18254-general/suggestions/803659-allow-full-confirguration-of-smtp-service-in-ossec)). No default.
* __ALERTS_FROM_EMAIL__: The email address the alerts should come from. Defaults to `ossec@$HOSTNAME`.
* __ALERTS_TO_EMAIL__: The destination email address for SMTP notifications, required for SMTP notifications. No default.
* __SYSLOG_FORWADING_ENABLED__: Specify whether syslog forwarding is enabled or not. Defaults to `false`.
* __SYSLOG_FORWARDING_SERVER_IP__: The IP for the syslog server to send messagse to, required for syslog fowarding. No default.
* __SYSLOG_FORWARDING_SERVER_PORT__: The destination port for syslog messages. Default is `514`.
* __SYSLOG_FORWARDING_FORMAT__: The syslog message format to use. Default is `default`.

## Quick Start

To get an up and running ossec server that supports auto-enrollment and sends HIDS notifications a syslog server, use.

```
 docker run --name ossec-server -d -p 80:80 -p 1514:1514/udp -p 1515:1515\
  -e SYSLOG_FORWADING_ENABLED=true -e SYSLOG_FORWARDING_SERVER_IP=X.X.X.X\
  -v /dirpath/ossec_mnt:/var/ossec/data fabriziogaliano/docker-ossecserver-wgui
```

Once the system starts up, you can execute the standard ossec commands using docker. For example, to list active agents.

```
docker exec -ti ossec-server /var/ossec/bin/list_agents -a
```

## Warnings

#### The WebGui has not authentication, so... carefull!

#### ossec-execd is not enabled

Since this is a docker container, ossec-execd really isn't a great idea anyway. Having a log server, such as graylog, react based on log entries is the recommended approach.

#### A default localhost agent is added

On first launch, the ossec server will not start up properly and bind to port 1514, unless at least one agent to be present in the client.keys file. To avoid that issue, a local agent is setup by default. See [this bug](https://groups.google.com/forum/#!topic/ossec-list/qeC_h3EZCxQ) with OSSEC.

