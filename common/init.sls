updates:
  pkg.uptodate

general_packages:
  pkg.installed:
    - pkgs:
      - rxvt-unicode-terminfo
      - sed
      - screen
    - requires:
      - updates

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

arch_feed:
  file.managed:
    - name: /home/{{ pillar["user"] }}/bin/archfeed.py
    - source: salt://common/files/bin/archfeed.py
    - user: {{ pillar["user"] }}
    - mode: 644

include:
  - .pacman
  - .dev_env
