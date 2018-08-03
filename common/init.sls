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

include:
  - .pacman
  - .dev_env
