#!/usr/bin/env python3
from __future__ import annotations
from subprocess import run, PIPE
from os.path import expanduser
from json import load
from typing import TypedDict, TypeGuard


class Repo(TypedDict):
    url: str
    packages: list[str]


def validate(json: object) -> TypeGuard[dict[str, Repo]]:
    if not isinstance(json, dict):
        return False
    key: object
    value: object
    for key, value in json.items():
        if (
            not isinstance(key, str)
            or not isinstance(value, dict)
            or not isinstance(value["url"], str)
        ):
            return False
        packages: object = value["packages"]
        if not isinstance(packages, list):
            return False
        package: object
        for package in packages:
            if not isinstance(package, str):
                return False
    return True


def main():
    with open(expanduser("~/.config/flatpak.json")) as f:
        json = load(f)
    assert validate(json)
    installed_packages = {
        *run(
            ["flatpak", "list", "--app", "--user", "--columns=application"],
            check=True,
            stdout=PIPE,
            text=True,
        ).stdout.splitlines()
    }
    for repo, value in json.items():
        url = value["url"]
        packages = set(value["packages"])
        run(
            ["flatpak", "remote-add", "--user", "--if-not-exists", repo, url],
            check=True,
        )
        missing_packages = packages - installed_packages
        if missing_packages:
            run(
                ["flatpak", "install", "--user", "-y", repo, *missing_packages],
                check=True,
            )
        installed_packages -= packages
    if installed_packages:
        run(
            [
                "flatpak",
                "remove",
                "--user",
                "-y",
                *(installed_packages),
            ],
            check=True,
        )


if __name__ == "__main__":
    main()
