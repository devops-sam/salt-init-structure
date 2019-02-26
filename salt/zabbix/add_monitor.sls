include:
  - zabbix.agent
  - zabbix.api

zbx-add-monitors-script:
  file.managed:
    - name: /etc/zabbix/api/add_monitors.py
    - source: salt://salt-confs/zabbix/api/add_monitors.py
    - makedirs: True
    - mode: 755
    - require:
      - pkg: zabbix-agent
      - file: python-pyzabbix
      - file: python-requests


{% for each_minion, each_mine in salt['mine.get']('*', 'grains.item').iteritems() %}
{% if each_minion == grains['id'] %}
monitor-{{each_minion}}:
  file.managed:
    - name: {{pillar['zabbix-api']['Monitors_DIR']}}/{{each_minion}}
    - source: salt://salt-confs/zabbix/api/minions
    - makedirs: True
    - template: jinja
    - defaults:
        IP: {{each_mine.ipv4[1]}}
        Hostgroup: {{each_mine.zbx_monitor_group}}
        Roles: {{each_mine.roles}}
        Templates: {{pillar['zabbix-templates']}}
    - order: last
  cmd.wait:
    - names: 
      - sed -i '/^[ ][ ]*$/d' {{pillar['zabbix-api']['Monitors_DIR']}}/{{each_minion}}
      - {{salt['pillar.get']('python:PY','python')}} /etc/zabbix/api/add_monitors.py {{each_minion}}
    - require:
      - file: zbx-add-monitors-script
    - watch:
       - file: monitor-{{each_minion}}
{% endif %}
{% endfor %}
