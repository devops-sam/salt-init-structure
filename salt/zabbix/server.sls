include:
  - mariadb
  - sync


zabbix-server:
  pkg.installed:
    - pkgs:
      - zabbix-server-mysql
      - zabbix-sender
      - zabbix-web
      - zabbix-web-mysql
      - zabbix-get

  file.managed:
    - name: /etc/zabbix/zabbix_server.conf
    - source: salt://salt-confs/zabbix/zabbix_server.conf
    - template: jinja
    - defaults:
        DBHost: localhost
        DBName: zabbix
        DBUser: zbxuser
        DBPassword: zbxpass
        DBPort: 3306
    - require:
      - pkg: zabbix-server

  service.running:
    - enable: True
    - watch:
      - file: zabbix-server

zbxserver-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- zbx_server'
    - after: 'roles:'
    - unless: egrep "\- zbx_server[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send


zbx_mysql:
  pkg.installed:
    - name: MySQL-python

  mysql_database.present:
    - name: zabbix
    - character_set: utf8
    - collate: utf8_general_ci
    - connection_host: {{ salt.pillar.get('Zbx-Mysql:SQL_HOST', 'localhost') }}
    - connection_user: {{ salt.pillar.get('Zbx-Mysql:SQL_ROOT_USER', 'root') }}
    - connection_pass: '{{ salt.pillar.get('Zbx-Mysql:SQL_ROOT_PASS', '123456') }}'
    - require:
      - pkg: zbx_mysql
      - service: MariaDB

  mysql_user.present:
    - name: zbxuser
    - host: localhost
    - password: zbxpass
    - require:
      - mysql_database: zbx_mysql
    - use:
      - mysql_database: zbx_mysql

  mysql_grants.present:
    - grant: all
    - database: zabbix.*
    - user: zbxuser
    - host: localhost
    - require:
      - mysql_user: zbx_mysql
    - use:
      - mysql_database: zbx_mysql
    - require_in:
      - service: zabbix-server


zbx_mysql-init:
  cmd.run:
    - names: 
      - cd  {{ pillar['Zbx-Mysql']['INIT_DIR'] }} && zcat create.sql.gz | mysql -uzbxuser -pzbxpass zabbix
    - unless: mysql -uzbxuser -pzbxpass -e "SELECT COUNT(*) from zabbix.users"
    - require:
      - pkg: zabbix-server
      - mysql_grants: zbx_mysql
    - require_in:
      - file: zabbix-server
      - service: zabbix-server
