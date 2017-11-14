confluentrepo:
  pkgrepo.managed:
    - humanname: Confluent repository
    - baseurl: http://packages.confluent.io/rpm/3.3
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: http://packages.confluent.io/rpm/3.3/archive.key

privaterepo:
  pkgrepo.managed:
    - humanname: Build01 repository
    - baseurl: {{ pillar['kafka:config:private_repo_url'] }}
    - enabled: 1
    - gpgcheck: 0
{% for package in ['confluent-kafka-2.11',
  'confluent-kafka-connect-s3',
  'confluent-kafka-connect-jdbc',
  'confluent-kafka-connect-storage-common',
  'confluent-kafka-connect-hdfs',
  'confluent-kafka-connect-elasticsearch',
  'confluent-kafka-rest'] %}
{{ package }}:
  pkg.installed:
    - refresh: True
    - require:
      - confluentrepo
{% endfor %}

kafka-manager:
  pkg.installed:
    - refresh: True
    - require:
      - privaterepo:

kafka-user:
  user.present:
    - name: kafka
    - shell: /bin/false
    - gid_from_name: True
    - createhome: False
    - system: True

/var/log/kafka:
  file.directory:
    - user: kafka
    - group: kafka
