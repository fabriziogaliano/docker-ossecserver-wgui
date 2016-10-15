# docker-bind-gui

Docker OSSEC Server image with Web Interface

# Available Configuration Parameters

```
AUTO_ENROLLMENT_ENABLED: Specifies whether or not to enable auto-enrollment via ossec-authd. Defaults to true;
AUTHD_OPTIONS: Options to passed ossec-authd, other than -p and -g. Defaults to empty;
SMTP_ENABLED: Whether or not to enable SMTP notifications. Defaults to true if ALERTS_TO_EMAIL is specified, otherwise false
SMTP_RELAY_HOST: The relay host for SMTP messages, required for SMTP notifications. This host must support non-authenticated SMTP (see this thread). No default.
ALERTS_FROM_EMAIL: The email address the alerts should come from. Defaults to ossec@$HOSTNAME.
ALERTS_TO_EMAIL: The destination email address for SMTP notifications, required for SMTP notifications. No default.
SYSLOG_FORWADING_ENABLED: Specify whether syslog forwarding is enabled or not. Defaults to false.
SYSLOG_FORWARDING_SERVER_IP: The IP for the syslog server to send messagse to, required for syslog fowarding. No default.
SYSLOG_FORWARDING_SERVER_PORT: The destination port for syslog messages. Default is 514.
SYSLOG_FORWARDING_FORMAT: The syslog message format to use. Default is default.
Please note: All the SMTP and SYSLOG configuration variables are only applicable to the first time setup. Once the container's data volume has been initialized, all the configuration options for OSSEC can be changed.
```

# Quick Start

To get an up and running ossec server that supports auto-enrollment and sends HIDS notifications a syslog server, use.

```
 docker run --name ossec-server -d -p 1514:1514/udp -p 1515:1515\
  -e SYSLOG_FORWADING_ENABLED=true -e SYSLOG_FORWARDING_SERVER_IP=X.X.X.X\
  -v /dirpath/ossec_mnt:/var/ossec/data fabriziogaliano/docker-ossecserver-wgui
Once the system starts up, you can execute the standard ossec commands using docker. For example, to list active agents.
```

docker exec -ti ossec-server /var/ossec/bin/list_agents -a

# Warnings

ossec-execd is not enabled

Since this is a docker container, ossec-execd really isn't a great idea anyway. Having a log server, such as graylog, react based on log entries is the recommended approach.

A default localhost agent is added

On first launch, the ossec server will not start up properly and bind to port 1514, unless at least one agent to be present in the client.keys file. To avoid that issue, a local agent is setup by default. See this bug with OSSEC.
