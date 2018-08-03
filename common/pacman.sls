pacman_packages:
  pkg.installed:
    - pkgs:
      - pacman-contrib
    - requires:
      - updates

hooks_dir:
  file.directory:
    - name: /etc/pacman.d/hooks
    - user: root
    - mode: 0755

hooks.orphans:
  file.managed:
    - name: /etc/pacman.d/hooks/orphans.hook
    - source: salt://files/hooks/orphans.hook
    - user: root
    - mode: 0640
    - requires:
      - hooks_dir
      - pacman_packages

hooks.pkg-clean:
  file.managed:
    - name: /etc/pacman.d/hooks/pkg-clean.hook
    - source: salt://files/hooks/pkg-clean.hook
    - user: root
    - mode: 0640
    - requires:
      - hooks_dir
      - pacman_packages
