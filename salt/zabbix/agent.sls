include:
  - sync


zabbix-agent:
  pkg.installed:
    - pkgs: 
      - zabbix-agent
      - zabbix-sender
    
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://salt-confs/zabbix/zabbix_agentd.conf
    - template: jinja
    - defaults:
        zabbix_server: {{ pillar['zabbix-agent']['Zabbix_Server'] }}
    - require:
      - pkg: zabbix-agent

  service.running:
    - enable: True
    - watch:
      - pkg: zabbix-agent
      - file: zabbix-agent

zbxagent-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- zbx_agent'
    - after: 'roles:'
    - unless: egrep "\- zbx_agent[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send

    
zbx_agentd.conf.d:
  file.recurse:
    - name: /etc/zabbix/zabbix_agentd.d/
    - source: salt://salt-confs/zabbix/zabbix_agentd.d/
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - watch_in:
      - service: zabbix-agent
    - require:
      - pkg: zabbix-agent
      - file: zabbix-agent
