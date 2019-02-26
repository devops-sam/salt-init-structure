include:
  - sync

salt-minion:
  pkg.installed:
    - name: salt-minion
    - require_in:
      - file: grains

  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt-confs/etc-salt-minion
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      MASTER_IP: 192.168.56.5 
    - require:
      - pkg: salt-minion
        
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion

saltminion-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: "- salt_minion"
    - after: 'roles:'
    - unless: egrep "\- salt_minion[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send
