#!/usr/bin/env python3
from argparse import ArgumentParser
from os import cpu_count
from os.path import splitext
from pathlib import Path
from subprocess import check_call, call
from sys import exit


def entry():
    parser = ArgumentParser()
    parser.add_argument("--port", "-p")
    parser.add_argument("--restrict-network", "-r", action="store_true", default=False)
    parser.add_argument("--display", "-d")
    parser.add_argument("image", type=Path)
    args = vars(parser.parse_args())
    main(
        port=args["port"],
        restrict_network=args["restrict_network"],
        image=args["image"],
        display=args["display"],
    )


def main(port: str | None, restrict_network: bool, display: str | None, image: Path):
    cores = cpu_count()
    if cores is None:
        cores = 1
    image_name, image_ext = splitext(image.name)
    backed_image = image.parent / f"{image_name}.data{image_ext}"
    if not backed_image.exists():
        check_call(
            [
                "qemu-img",
                "create",
                "-f",
                "qcow2",
                "-F",
                "qcow2",
                "-o",
                "cluster_size=2M",
                "-b",
                str(image),
                str(backed_image),
            ]
        )
    nic_args = ["user,model=virtio"]
    if port is not None:
        port1, port2 = port.split(":")
        nic_args.append(f"hostfwd=tcp::{port1}-:{port2}")
    if restrict_network:
        nic_args.append("restrict=y")
    args = [
        "qemu-system-x86_64",
        "-m",
        "4096",
        "-smp",
        str(cores),
        "-cpu",
        "host",
        "-enable-kvm",
        "-nic",
        ",".join(nic_args),
        "-display",
        display if display is not None else "none",
        "-monitor",
        "stdio",
        "-nodefaults",
        "-vga",
        "virtio",
        "-drive",
        f"file={str(backed_image)},if=virtio",
        "-no-reboot",
    ]
    try:
        exit(call(args))
    except KeyboardInterrupt:
        exit(1)


if __name__ == "__main__":
    entry()
