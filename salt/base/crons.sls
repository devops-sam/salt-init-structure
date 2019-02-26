ntp-pkg:
  pkg.installed:
    - name: ntpdate
    - watch_in:
      - cron: ntp-cron

ntp-cron:
  cron.present:
    - name: /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1
    - user: root
    - hour: 2
    - minute: 0

