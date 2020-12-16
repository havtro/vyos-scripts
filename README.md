# vyos-scripts
Script utilities for VyOS

## Install
put scripts under /config/scripts and make it excecutable
```
chmod +x /config/scripts/<script_name>
```

## VyOS config
```
set system task-scheduler task <label> executable arguments '<script_arguments>'
set system task-scheduler task <label> executable path '/config/scripts/<script_name>'
set system task-scheduler task <label> interval '15m'
```

## Arguments
### checkInternetConnection.sh
arg1 dhcpPublicInterface arg2, ping-internet-ip
```
set system task-scheduler task <label> executable arguments 'eth0 8.8.8.8'
```
