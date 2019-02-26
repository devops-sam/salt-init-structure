back-repo:
  file.copy:
    - name: /etc/yum.repos.d/CentOS-Base.repo.bak
    - source: /etc/yum.repos.d/CentOS-Base.repo
    - user: root

/etc/yum.repos.d/CentOS-Base.repo:
  file.managed:
    {% if grains['osmajorrelease'][0] == '7' %}
    - source: salt://salt-confs/base/Centos-7.repo
    {% endif %}
    {% if grains['osmajorrelease'][0] == '6' %}
    - source: salt://salt-confs/base/Centos-6.repo
    {% endif %}
    - user: root
    - group: root
    - 644

