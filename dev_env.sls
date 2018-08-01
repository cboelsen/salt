dev_packages:
  pkg.installed:
    - pkgs:
      - gvim
      - git
      - python
      - python-virtualenvwrapper
      - gcc
      - clang
      - ninja
      - cmake
      - ctags
      - npm
      - rubygems
    - requires:
      - updates

vimfiles_clone:
  git.latest:
    - name: https://github.com/cboelsen/vimfiles
    - target: /home/{{ pillar["user"] }}/.vim
    - user: {{ pillar["user"] }}
    - require:
      - dev_packages

vimrc:
  file.symlink:
    - name: /home/{{ pillar["user"] }}/.vimrc
    - target: /home/{{ pillar["user"] }}/.vim/vimrc
    - user: {{ pillar["user"] }}
    - require:
      - vimfiles_clone

vundle_clone:
  git.latest:
    - name: https://github.com/VundleVim/Vundle.vim.git
    - target: /home/{{ pillar["user"] }}/.vim/bundle/Vundle.vim
    - user: {{ pillar["user"] }}
    - require:
      - vimrc

vundle_update:
  cmd.run:
    - name: vim -i NONE -c VundleInstall -c VundleUpdate -c quitall
    - runas: {{ pillar["user"] }}
    - use_vt: true
    - require:
      - vundle_clone

ycm_install:
  cmd.run:
    - name: /home/{{ pillar["user"] }}/.vim/bundle/YouCompleteMe/install.py --clang-completer --system-libclang --ninja
    - runas: {{ pillar["user"] }}
    - require:
      - vundle_update

projects_dir:
  file.directory:
    - name: /home/{{ pillar["user"] }}/projects
    - user: {{ pillar["user"] }}

gitconfig:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.gitconfig
    - source: salt://files/rc/gitconfig
    - user: {{ pillar["user"] }}
    - template: jinja

bashrc:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.bashrc
    - source: salt://files/rc/bashrc
    - user: {{ pillar["user"] }}

npmrc:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.npmrc
    - source: salt://files/rc/npmrc
    - user: {{ pillar["user"] }}
