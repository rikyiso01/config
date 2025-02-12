FROM docker.io/archlinux:base-devel

RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -Sy meson ninja git
RUN git clone https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw
WORKDIR /pam_fde_boot_pw
RUN meson setup build
RUN ninja -C build
