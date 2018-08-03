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

minion_file:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://minion
    - user: root

include:
  - .pacman
  - .dev_env
