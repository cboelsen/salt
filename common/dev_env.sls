{% if grains['os_family'] == 'Arch' %}
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
      - ripgrep
    - requires:
      - updates
{% endif %}

vimfiles_clone:
  git.latest:
    - name: https://github.com/cboelsen/vimfiles
    - target: /home/{{ pillar["user"] }}/.vim
    - user: {{ pillar["user"] }}
    - require:
      - dev_packages

vundle_clone:
  git.latest:
    - name: https://github.com/VundleVim/Vundle.vim.git
    - target: /home/{{ pillar["user"] }}/.vim/bundle/Vundle.vim
    - user: {{ pillar["user"] }}
    - require:
      - vimfiles_clone

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

fzf_install:
  cmd.run:
    - name: /home/{{ pillar["user"] }}/.vim/bundle/fzf/install --all
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
    - source: salt://common/files/rc/gitconfig
    - user: {{ pillar["user"] }}
    - template: jinja

bashrc:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.bashrc
    - source: salt://common/files/rc/bashrc
    - user: {{ pillar["user"] }}
    - template: jinja

inputrc:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.inputrc
    - source: salt://common/files/rc/inputrc
    - user: {{ pillar["user"] }}
    - template: jinja

npmrc:
  file.managed:
    - name: /home/{{ pillar["user"] }}/.npmrc
    - source: salt://common/files/rc/npmrc
    - user: {{ pillar["user"] }}
    - template: jinja
