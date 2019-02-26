base:
  '*':
    - roles.common
    - roles.zbx-agent

  'salt-master':
    - match: nodegroup
    - roles.admin

  'zbx-server':
    - match: nodegroup
    - roles.zbx-server

  'db':
    - match: nodegroup
    - roles.mariadb

  'ha':
    - match: nodegroup
    - roles.haproxy

  'web2':
    - match: nodegroup
    - roles.web
   
  'monitors':
    - match: nodegroup
    - roles.add_api
