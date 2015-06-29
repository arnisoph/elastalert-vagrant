repos:
  lookup:
    repos:
      logstash:
        url: http://packages.elasticsearch.org/logstash/1.5/debian
        dist: stable
        comps:
          - main
        keyurl: http://packages.elasticsearch.org/GPG-KEY-elasticsearch


logstash:
  lookup:
    defaults:
    #  JAVA_HOME: /usr/lib/jvm/java-7-openjdk-amd64/jre/
      JAVACMD: /usr/bin/java
      LS_CONF_DIR: /etc/logstash/conf.d
      LS_GROUP: adm
      LS_HEAP_SIZE: 500m
      LS_HOME: /var/lib/logstash
      LS_JAVA_OPTS: '-Djava.io.tmpdir=${LS_HOME}'
      LS_LOG_FILE: /var/log/logstash/logstash.log
      LS_NICE: 19
      LS_OPEN_FILES: 16384
      LS_OPTS: '-vvv'
      LS_PIDFILE: /var/run/logstash.pid
      LS_USE_GC_LOGGING: 'true'
      LS_USER: logstash
    #plugins:
    #  - name: contrib
    #    installed_name: 'logstash-contrib-*'
    config:
      manage:
        - defaults_file
        #- comp_test_file
        - collectd
      comp_test_file:
        contents: |
          input {
            file {
              type => "syslog"

              # Wildcards work here
              path => [ "/var/log/messages", "/var/log/syslog", "/var/log/*.log" ]
            }
          }

          output {
            file {
              path => "/tmp/logstash-output-%{+YYYY-MM-dd}.log"
              }
          }
      collectd:
        contents: |
          input {
            udp {
              port => 25826         # 25826 matches port specified in collectd.conf
              buffer_size => 1452   # 1452 is the default buffer size for Collectd
              codec => collectd { } # specific Collectd codec to invoke
              type => collectd
            }
          }
          output {
            elasticsearch {
              cluster  => 'cluster1' # this matches out elasticsearch cluster.name
              protocol => http
              host     => '127.0.0.1'
              port     => '9200'
              index    => 'collectd-%{collectd_type}'
              document_type   => 'collectd-%{collectd_type}'
              manage_template => false
            }
            file {
              path => "/tmp/logstash-output-%{+YYYY-MM-dd}.log"
            }
          }
