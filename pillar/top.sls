base:
  '*':
    - roles.common
    - salt.mine

  'zbx-server':
    - match: nodegroup
    - roles.zbx-server

  'db':
    - match: nodegroup
    - roles.db

  'web2':
    - match: nodegroup
    - roles.web
   
  'monitors':
    - match: nodegroup
    - roles.monitors
