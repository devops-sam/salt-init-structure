include:
  - sync

php-fpm:  
  pkg:  
    - name: php-fpm  
    - pkgs:  
      - {{ pillar['php']['version'] }}-fpm  
      - {{ pillar['php']['version'] }}-common  
      - {{ pillar['php']['version'] }}-cli  
      - {{ pillar['php']['version'] }}-devel  
      - {{ pillar['php']['version'] }}-pecl-memcache  
      - {{ pillar['php']['version'] }}-gd  
      - {{ pillar['php']['version'] }}-pear  
      - {{ pillar['php']['version'] }}-mbstring  
      - {{ pillar['php']['version'] }}-mysqlnd 
      - {{ pillar['php']['version'] }}-xml  
      - {{ pillar['php']['version'] }}-bcmath  
      - {{ pillar['php']['version'] }}-pdo  
    - installed  

  service:  
    - running  
    - require:  
      - pkg: php-fpm  
    - watch:  
      - pkg: php-fpm  
      - file: /etc/php-fpm.conf  
      - file: /etc/php-fpm.d/  

#/etc/php.ini:  
#  file.managed:  
#    - source: salt://salt-confs/nginx-php/php/php.ini  
#    - user: root  
#    - group: root  
#    - mode: 644


/etc/php-fpm.conf:  
  file.managed:  
    - source: salt://salt-confs/nginx-php/php/php-fpm.conf  
    - user: root  
    - group: root  
    - mode: 644  

/etc/php-fpm.d/:  
  file.recurse:  
    - source: salt://salt-confs/nginx-php/php/php-fpm.d/  
    - user: root  
    - group: root  
    - dir_mode: 755  
    - file_mode: 644  

{% if grains['fqdn_ip4'][0] != '192.168.56.5' %}
php-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - content: '- php'
    - after: 'roles:'
    - unless: egrep "\- php[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send
{% endif %}
