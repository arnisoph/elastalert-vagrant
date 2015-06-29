base:
  '*':
    - bash
    - users
    - zsh
    - common
    - schedule
    - logstash
    - collectd
  'master1.*':
    - elasticsearch
