include:
  - zabbix.agent
  - nginx-php.nginx
  - nginx-php.php
  - sync


php-fpm-monitor-script:  # 管理监控脚本，如果脚本存放目录不存在自动创建  
  cmd.run:  
    - name: mkdir -p /etc/zabbix/ExternalScripts  
    - unless: test -d /etc/zabbix/ExternalScripts  

  file.managed:  
    - name: /etc/zabbix/ExternalScripts/php-fpm_status.sh
    - source: salt://salt-confs/zabbix/ExternalScripts/php-fpm_status.sh
    - user: root  
    - group: root  
    - mode: 755  
    - require:  
      - service: php-fpm  
      - cmd: php-fpm-monitor-script  

php-fpm-monitor-config:  # 定义zabbix客户端用户配置文件  
  file.managed:  
    - name: /etc/zabbix/zabbix_agentd.d/php-fpm.conf  
    - source: salt://salt-confs/zabbix/zabbix_agentd.d/php-fpm.conf
    - require:  
      - file: php-fpm-monitor-script  
      - service: php-fpm  
    - watch_in:  
      - service: zabbix-agent  

nginx-monitor-config:  # 定义zabbix客户端用户配置文件  
  file.managed:  
    - name: /etc/zabbix/zabbix_agentd.d/nginx.conf  
    - source: salt://salt-confs/zabbix/zabbix_agentd.d/nginx.conf  
    - require:  
      - service: nginx 
    - watch_in:  
      - service: zabbix-agent 


zbxmonitor-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- web'
    - after: 'zbx_monitor_group:'
    - unless: egrep "\- web[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send

