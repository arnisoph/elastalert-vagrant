include:
  - elasticsearch.index_templates

repos:
  lookup:
    repos:
      elasticsearch:
        url: http://packages.elasticsearch.org/elasticsearch/1.5/debian
        dist: stable
        comps:
          - main
        keyurl: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

elasticsearch:
  lookup:
    defaults:
      JAVA_HOME: /opt/java/jdk/current/src
      ES_HEAP_SIZE: 512m
    settings:
      cluster:
        name: cluster1
      node:
        name: {{ salt['grains.get']('fqdn') }}
        master: true
        data: true
      index:
        number_of_replicas: 0
      gateway:
        expected_nodes: 1
      discovery:
        zen:
          ping:
            multicast:
              enabled: false
    plugins:
      - name: lmenezes/elasticsearch-kopf
        installed_name: kopf
#        url: 'https://github.com/lmenezes/elasticsearch-kopf'
      - name: karmi/elasticsearch-paramedic
        installed_name: paramedic
#        url: 'https://github.com/karmi/elasticsearch-paramedic'
#    indices:
#      lalilu: {}


java:
  lookup:
    manage:
      jdk:
        current_ver: 8u45
        versions:
          8u45:
            source: file:///vagrant/share/misc/jdk-8u45-linux-x64.tar.gz
            source_hash: md5=1ad9a5be748fb75b31cd3bd3aa339cac
            version: jdk1.8.0_45

sysctl:
  lookup:
    params:
      - name: vm.swappiness
        value: 1
      - name: vm.max_map_count
        value: 262144
