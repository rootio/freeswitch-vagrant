
prerequisites:
  pkg.installed:
    - pkgs:
      - build-essential
      - autoconf
      - git
      - unixodbc-dev
      - zlib1g-dev
      - zlib1g
      - libjpeg-dev
      - libncurses5-dev
      - libssl-dev
      - libsqlite3-dev
      - libspeexdsp-dev
      - libspeex-dev
      - libldns-dev
      - libedit-dev
      - pkg-config
      - libcurl4-nss-dev
      - libpcre3-dev
      - python-dev
# below necessary for libshout
      - libogg0
      - libogg-dev
      - libvorbis0a

freeswitch-src:
  git.latest:
    - name: https://stash.freeswitch.org/scm/fs/freeswitch.git
    - target: /usr/local/src/freeswitch
    - rev: 8e47f3c660276bc653f6cb1ac2611d5345244bd9

freeswitch-bootstrap:
  cmd.run:
    - name: /usr/local/src/freeswitch/bootstrap.sh
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-select_modules:
  cmd.run:
    - name: /bin/sed -i 's/^#formats\/mod_shout/formats\/mod_shout/' modules.conf
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-fix_configure:
  cmd.run:
    - name: wget http://people.apache.org/~rjung/patches/expat-libtool2.patch 
    - cwd: /usr/src/freeswitch/libs/apr-util
    - unless: freeswitch -v
  cmd.run:
    - name: patch -p1 < expat-libtool2.patch 
    - cwd: /usr/local/src/freeswitch/libs/apr-util
    - unless: freeswitch -v
  cmd.run:
    - name: sh buildconf.sh
    - cwd:  /usr/local/src/freeswitch/libs/apr-util/xml/expat/
    - unless: freeswitch -v

freeswitch-configure:
  cmd.run:
    - name: /usr/local/src/freeswitch/configure
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-make_prep:
  cmd.run:
    - name: /bin/sed -i 's/^ sed -i "s/\$(am__ppend_15) \$(am__append_16)/\$(am__append_15) \$(am__append_16) -lz/" Makefile.in
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-make:
  cmd.run:
    - name: /usr/bin/make
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-make_install:
  cmd.run:
    - name: /usr/bin/make install
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v

freeswitch-install_sounds:
  cmd.run:
    - name: /usr/bin/make cd-sounds-install cd-moh-install
    - cwd: /usr/local/src/freeswitch
    - unless: freeswitch -v



