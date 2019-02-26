{% set datadir = salt['pillar.get']('mysql:datadir', '/var/lib/mysql') %}
include:
  - sync

MariaDB:
  pkg.installed:
    - pkgs:
      - MariaDB-server
      - MariaDB-client
    - require:
      - file: MariaDB
      - cmd: remove-mysql-libs

  service.running:
    - name: mysql
    - enable: True
    - require:
      - pkg: MariaDB
    - watch:
      - pkg: MariaDB
      - file: /etc/my.cnf

  file.managed:
    - name: /etc/yum.repos.d/MariaDB.repo
    {% if grains['osmajorrelease'][0] == '6' %}
    - source: salt://salt-confs/mariadb/MariaDB-OS6.repo
    {% elif grains['osmajorrelease'][0] == '7' %}
    - source: salt://salt-confs/mariadb/MariaDB-OS7.repo
    {% endif %}

  cmd.wait:
    - name: mkdir -p {{datadir}} && cp -r /var/lib/mysql/* {{datadir}}/ && chown -R mysql.mysql {{datadir}}
    - unless: test -d {{datadir}}
    - watch:
       - pkg: MariaDB

# 解决软件冲突
remove-mysql-libs:
  cmd.run:
    - name: rpm -e --nodeps mysql-libs && chkconfig  postfix off
    - onlyif: rpm -qa |grep mysql-libs


/etc/my.cnf:
  file.managed:
    - source: salt://salt-confs/mariadb/{{salt['pillar.get']('mysql:conf_template', 'my.cnf')}}
    - template: jinja
    - user: root
    - group: root
    - mode: 644

MariaDB-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: "- {{ salt['pillar.get']('mysql:role', 'mysql') }}"
    - after: 'roles:'
    - unless: egrep "\- {{ salt['pillar.get']('mysql:role', 'mysql') }}[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send
