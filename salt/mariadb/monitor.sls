include:
  - zabbix.agent
  - sync

my.cnf:
  file.managed:
    - name: /etc/zabbix/.my.cnf
    - source: salt://salt-confs/zabbix/.my.cnf
    - template: jinja
    - watch_in:
      - service: zabbix-agent

mysql-monitor-config:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
    - source: salt://salt-confs/zabbix/zabbix_agentd.d/userparameter_mysql.conf 
    - template: jinja
    - require:
      - file: my.cnf
    - watch_in:
      - service: zabbix-agent

mysql-monitor-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- db'
    - after: 'zbx_monitor_group:'
    - unless: egrep "\- db[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send
