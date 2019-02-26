# 代码发布目录 ( default: /var/www/html )
#vhostsdir: /data/nginx/vhosts
# 日志目录 ( default: /var/log/nginx )
#logdir: /data/nginx/logs

vhosts:
  # www.huobi.com
  - /var/www/html
  # static.huobi.com
  - /var/www/html/static 

php:
  {% if grains['localhost'] == 'vm3.lq.com' %}
  version: php56w
  {% else %}
  version: php
  {% endif %}
