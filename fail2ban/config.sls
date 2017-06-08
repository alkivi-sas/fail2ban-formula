{% from "fail2ban/map.jinja" import fail2ban with context %}

include:
  - fail2ban

fail2ban-local:
  file.managed:
    - name: {{ fail2ban.prefix }}/etc/fail2ban/fail2ban.local
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - context:
        config:
            Definition: {{ fail2ban.config|yaml }}
    - watch_in:
      - service: {{ fail2ban.service }}

fail2ban-jails:
  file.managed:
    - name: {{ fail2ban.prefix }}/etc/fail2ban/jail.local
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - context:
        config: {{ fail2ban.jails|yaml }}
    - watch_in:
      - service: {{ fail2ban.service }}

{% for name, config in fail2ban.actions|dictsort %}
action-{{ name }}:
  file.managed:
    - name: {{ fail2ban.prefix }}/etc/fail2ban/action.d/{{ name }}.local
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - watch_in:
      - service: {{ fail2ban.service }}
    - context:
        config: {{ config|yaml }}
{% endfor %}

{% for name, config in fail2ban.filters|dictsort %}
filter-{{ name }}:
  file.managed:
    - name: {{ fail2ban.prefix }}/etc/fail2ban/filter.d/{{ name }}.local
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - watch_in:
      - service: {{ fail2ban.service }}
    - context:
        config: {{ config|yaml }}
{% endfor %}
