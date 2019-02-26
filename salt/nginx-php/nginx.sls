include:
  - sync

nginx:
  pkg:
    - installed
  service:
    - name: nginx
    - running
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://salt-confs/nginx-php/nginx/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - backup: minion

/etc/nginx/conf.d/:
  file.recurse:
    - source: salt://salt-confs/nginx-php/nginx/conf.d/
    - template: jinja
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

{% set logdir = salt['pillar.get']('logdir', '/var/log/nginx') %}
{{logdir}}:
  cmd.run:
    - name: mkdir -p {{logdir}}
    - unless: test -d {{logdir}}
    - require:
      - pkg: nginx

{% set root_dir = salt['pillar.get']('vhostsdir', '/var/www/html') %}
{{root_dir}}:
  cmd.run:
    - name: mkdir -p {{root_dir}} && chown -R nginx.nginx {{root_dir}}
    - unless: test -d {{root_dir}}
    - require:
      - pkg: nginx

{% if salt['pillar.get']('vhosts',false) %}
{% for v_dir in pillar['vhosts'] %}
{% if v_dir != '/var/www/html' %}
{{v_dir}}:
  cmd.run:
    - names:
      - mkdir -p {{v_dir}} && chown -R nginx.nginx {{v_dir}}
    - unless: test -d {{v_dir}}
    - require:
      - pkg: nginx
{% endif %}
{% endfor %}
{% endif %}


nginx-grains:
  file.line:
    - name: /etc/salt/grains
    - mode: insert
    - match: after
    - after: 'roles:'
    - content: '- nginx'
    - unless: egrep "\- nginx[ ]*$" /etc/salt/grains
    - require:
      - file: grains
      - file: hostgroup-title
    - watch_in:
      - module: mine.send

