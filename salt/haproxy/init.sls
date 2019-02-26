include:
  - sync

haproxy:
  pkg.installed:
    - name: haproxy

  service.running:
    - name: haproxy
    - enable: True
    - require:
      - pkg: haproxy
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg 

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://salt-confs/haproxy/haproxy.cfg
    - template: jinja
    - user: root
    - group: root
    - mode: 644

haproxy-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- haproxy'
    - after: 'roles:'
    - unless: egrep "\- haproxy[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send
