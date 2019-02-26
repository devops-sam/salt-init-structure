python:
  # pyzabbix 0.7.5
  VERSION: /usr/lib/python3.4/site-packages
  PY: /usr/bin/python3

zabbix-api:
  Zabbix_URL: http://192.168.56.5/zabbix
  Zabbix_User: admin
  Zabbix_Pass: zabbix
  Monitors_DIR: /etc/zabbix/api/monitors/
  Templates_DIR: /etc/zabbix/api/templates/
 
zabbix-base-templates:
  {% if grains['os_family'] == 'RedHat' or grains['os_family'] == 'Debian' %}
  - 'Template OS Linux'
  {% endif %}

zabbix-templates:
  memcached: 'Template App Memcached'
  zbx_server: 'Template App Zabbix Server'
  web_server: 'Template App HTTP Service'
  mysql: 'Template App MySQL'
  mysql_master: 'Template App MySQL'
  mysql_slave: 'Template App MySQL Slave'
  php: 'Template App PHP FPM'
  nginx: 'Template App Nginx'
  varnish: 'Template App Varnish'
  redis: 'Template App Redis'
