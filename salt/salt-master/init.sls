include:
  - sync

salt-master:
  pkg.installed:
    - name: salt-master

  file.managed:
    - name: /etc/salt/master
    - require:
      - pkg: salt-master

  service.running:
    - enable: True
    - watch:
      - pkg: salt-master
      - file: salt-master
      - file: /etc/salt/master.d/


/etc/salt/master.d/:
  file.recurse:
    - source: salt://salt-confs/master.d/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

saltmaster-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: "- salt_master"
    - after: 'roles:'
    - unless: egrep "\- salt_master[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send

