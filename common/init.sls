{% if grains['os_family'] == 'Arch' %}
updates:
  pkg.uptodate

general_packages:
  pkg.installed:
    - pkgs:
      - rxvt-unicode-terminfo
      - sed
      - tmux
    - requires:
      - updates
{% endif %}

bin_dir:
  file.directory:
    - name: /home/{{ pillar["user"] }}/bin
    - user: {{ pillar["user"] }}

salt_update:
  file.managed:
    - name: /home/{{ pillar["user"] }}/bin/salt-update
    - source: salt://common/files/bin/salt-update
    - user: {{ pillar["user"] }}
    - mode: 744
    - template: jinja

include:
{% if grains['os_family'] == 'Arch' %}
  - .pacman
{% endif %}
  - .dev_env
