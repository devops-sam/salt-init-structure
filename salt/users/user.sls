include:
  - users.sudo

{% for user, args in pillar['users'].iteritems() %}
{{user}}:
  group.present:
    - name: {{user}}
  user.present:
    - home: /home/{{user}}
    - groups:
      - admin
    {% if 'password' in args %}
    - password: {{args['password']}}
    {% endif %}
    - require:
      - group: {{user}}

{% if 'sudo' in args %}
{% if args['sudo'] %}
sudoer-{{user}}:
  file.append:
    - name: /etc/sudoers
    - text:
      - '{{user}}  ALL=(ALL)       NOPASSWD: ALL'
    - require:
      - file: sudoers
      - user: {{user}}
{% endif %}
{% endif %}

{% if 'ssh_auth' in args %}
/home/{{user}}/.ssh:
  file.directory:
    - user: {{user}}
    - group: {{args['group']}}
    - mode: 700
    - require:
      - user: {{user}}

/home/{{user}}/.ssh/authorized_keys:
  file.managed:
    - user: {{user}}
    - group: {{args['group']}}
    - mode: 600
    - require:
      - file: /home/{{user}}/.ssh

{{ args['ssh_auth']['key'] }}:
  ssh_auth.present:
    - enc: ssh-rsa
    - user: {{user}}
    - comment: {{args['ssh_auth']['comment']}}
    - require:
      - file: /home/{{user}}/.ssh/authorized_keys
{% endif %}
{% endfor %}
