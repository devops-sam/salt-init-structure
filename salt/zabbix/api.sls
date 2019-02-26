include:
  - sync

python3:
  pkg.installed:
    - name: python34
    - require_in:
      - file: python-pyzabbix
      - file: python-requests 

python-pyzabbix:
  file.recurse:
    - name: {{ pillar['python']['VERSION'] }}/pyzabbix
    - source: salt://salt-confs/zabbix/api/pyzabbix
    - include_empty: True
    - unless: test -d {{ pillar['python']['VERSION'] }}/pyzabbix

python-requests:
  file.recurse:
    - name: {{ pillar['python']['VERSION'] }}/requests
    - source: salt://salt-confs/zabbix/api/pyzabbix
    - include_empty: True
    - unless: test -d {{ pillar['python']['VERSION'] }}/requests

zbxapi-config:
  file.managed:
    - name: /etc/zabbix/api/config.yaml
    - source: salt://salt-confs/zabbix/api/config.yaml
    - makedirs: True
    - template: jinja

zabbix-templates:
  file.recurse:
    - name: {{pillar['zabbix-api']['Templates_DIR']}}
    - source: salt://salt-confs/zabbix/api/templates
    - require:
      - file: python-pyzabbix
      - file: zbxapi-config

zbx_mine_flush:
  cmd.run:
    - name: echo 'Flush Mine data...'
    - watch_in:
      - module: mine_flush
      - module: mine.send
      - module: pillar_refresh
      - module: mine_update
    - order: last
