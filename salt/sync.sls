grains:
  file.managed:
    - name: /etc/salt/grains
    - user: root
    - grou: root
    - mode: 644

hostgroup-title:
  file.append:
    - name: /etc/salt/grains
    - text:
      - 'roles:'
      - 'zbx_monitor_group:'

mine_flush:
  module.wait:
    - name: mine.flush
    - watch_in:
      - module: mine.send
      - module: pillar_refresh
      - module: mine_update

mine.send:
  module.wait:
    - name: saltutil.sync_grains

pillar_refresh:
  module.wait:
    - name: saltutil.refresh_pillar

mine_update:
  module.wait:
    - name: mine.update


