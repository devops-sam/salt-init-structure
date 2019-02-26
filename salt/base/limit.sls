/etc/security/limits.conf:
  file.managed:
    - requir_in:
      - file: all-limits

all-limits:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - '* - nproc  65535'
      - '* - nofile  65535'
