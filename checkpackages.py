from httpx import get
from subprocess import run, PIPE

GNOME_URL = "https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/manjaro/gnome/Packages-Desktop"
ROOT_URL = "https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/shared/Packages-Root"
MHWD_URL = "https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/shared/Packages-Mhwd"

MANUALLY_INSTALLED = {
    "flatpak",
    "nix",
    "xdg-desktop-portal-gnome",
    "manjaro-settings-manager",
    "xdg-desktop-portal-wlr",
    "pipewire-media-session",
    "manjaro-pipewire",
    "cups",
    "gnome-shell",
    "networkmanager-openvpn",
    "gcc",
}


GNOME_MANUALLY_REMOVED = {
    "bibata-cursor-theme",
    "evince",
    "file-roller",
    "firefox",
    "gedit",
    "gnome-calculator",
    "gnome-calendar",
    "gnome-disk-utility",
    "gnome-logs",
    "gnome-shell-extensions",
    "gnome-shell-maia",
    "gnome-system-monitor",
    "gnome-tour",
    "gnome-tweaks",
    "gnome-user-docs",
    "gnome-weather",
    "gthumb",
    "htop",
    "kvantum-manjaro",
    "lollypop",
    "manjaro-hello",
    "manjaro-ranger-settings",
    "plymouth-theme-manjaro",
    "sushi",
    "totem",
    "manjaro-browser-settings",
    "adobe-source-sans-pro-fonts",
    "manjaro-settings-manager-notifier",
    "qt6ct",
    "gnome-firmware",
    "manjaro-gnome-backgrounds",
    "qt5ct",
}

ROOT_MANUALLY_REMOVED = {
    "vi",
    "wget",
    "which",
    "nano-syntax-highlighting",
    "man-db",
    "man-pages",
    "manjaro-zsh-config",
}

ROOT_SPECIAL_REMOVED = {"amd-ucode", "KERNEL", "memtest86+-efi"}

# mhwd -f -a pci  nonfree 0300
GRAPHICS_DRIVER = {
    "xf86-video-ati",
    "xf86-video-amdgpu",
    "xf86-video-intel",
    "xf86-video-nouveau",
    "vulkan-intel",
    "vulkan-radeon",
    "libva-mesa-driver",
    "libva-vdpau-driver",
    "mesa-vdpau",
    "lib32-vulkan-intel",
    "lib32-vulkan-radeon",
    "lib32-libva-vdpau-driver",
    "lib32-mesa-vdpau",
}

# mhwd-kernel -li
KERNELS = {"linux61"}

LANGUAGE_PACKAGES = {"hyphen-en"}


def parse_packages(file: str) -> set[str]:
    packages: set[str] = set()
    for line in file.splitlines():
        if "#" in line:
            line = line[: line.index("#")]
        line = line.strip()
        if not line or line.startswith(">"):
            continue
        packages.add(line)
    return packages


def get_remote_packages(url: str) -> set[str]:
    response = get(url)
    return parse_packages(response.text)


def get_local_packages() -> set[str]:
    stdout = run(["pacman", "-Qeq"], stdout=PIPE, check=True, text=True).stdout
    packages = {line.strip() for line in stdout.splitlines()}
    assert packages > MANUALLY_INSTALLED
    return packages - MANUALLY_INSTALLED


def test_empty(s: set[str]) -> None:
    if s:
        print(s)
        exit(1)


def main():
    local_packages = get_local_packages()
    gnome_packages = get_remote_packages(GNOME_URL)
    test_empty(gnome_packages - local_packages - GNOME_MANUALLY_REMOVED)
    test_empty(GNOME_MANUALLY_REMOVED - gnome_packages)
    test_empty(local_packages & GNOME_MANUALLY_REMOVED)
    root_packages = get_remote_packages(ROOT_URL)
    test_empty(
        root_packages - local_packages - ROOT_MANUALLY_REMOVED - ROOT_SPECIAL_REMOVED
    )
    test_empty((ROOT_MANUALLY_REMOVED | ROOT_SPECIAL_REMOVED) - root_packages)
    test_empty(local_packages & ROOT_MANUALLY_REMOVED)
    mhwd_packages = get_remote_packages(MHWD_URL)
    removed = GNOME_MANUALLY_REMOVED | ROOT_MANUALLY_REMOVED
    all_packages = (
        gnome_packages
        | root_packages
        | GRAPHICS_DRIVER
        | KERNELS
        | mhwd_packages
        | LANGUAGE_PACKAGES
    )
    test_empty(local_packages - all_packages)
    with open("remove.txt", "wt") as f:
        f.write("\n".join(sorted(removed)))
    with open("install.txt", "wt") as f:
        f.write("\n".join(sorted(MANUALLY_INSTALLED)))


if __name__ == "__main__":
    main()
