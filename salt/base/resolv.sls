/etc/resolv.conf:
  file.managed:
    - source: salt://salt-confs/base/resolv.conf
    - user: root
    - group: root
    - mode: 644
