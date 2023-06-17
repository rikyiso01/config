#!/usr/bin/env python3
from __future__ import annotations
from subprocess import check_call, check_output
from os.path import expanduser
from json import load
from typing import TypedDict, TypeGuard


class Repo(TypedDict):
    url: str
    packages: list[str]


class flatpak:
    @staticmethod
    def list():
        return check_output(
            ["flatpak", "list", "--app", "--user", "--columns=application"], text=True
        ).splitlines()

    @staticmethod
    def install(repo: str, packages: list[str] | set[str], /):
        check_call(["flatpak", "install", "--user", "-y", repo, *packages])

    @staticmethod
    def remove(packages: list[str] | set[str], /):
        check_call(["flatpak", "remove", "--user", "-y", *packages])

    @staticmethod
    def remote_add(name: str, url: str, /):
        check_call(["flatpak", "remote-add", "--user", "--if-not-exists", name, url])

    @staticmethod
    def remote_list(*, system: bool) -> list[str]:
        result = check_output(
            ["flatpak", "remote-list", "--system" if system else "--user"],
            text=True,
        ).splitlines()
        if len(result) == 1 and "" in result:
            result.remove("")
        return result

    @staticmethod
    def remote_delete(repo: str, /, *, system: bool):
        check_call(
            [
                "flatpak",
                "remote-delete",
                "--system" if system else "--user",
                "--force",
                repo,
            ]
        )


def validate(json: object) -> TypeGuard[dict[str, Repo]]:
    if not isinstance(json, dict):
        return False
    for key, value in json.items():
        if (
            not isinstance(key, str)
            or not isinstance(value, dict)
            or not isinstance(value["url"], str)
        ):
            return False
        packages = value["packages"]
        if not isinstance(packages, list):
            return False
        for package in packages:
            if not isinstance(package, str):
                return False
    return True


def main():
    with open(expanduser("~/.config/flatpak.json")) as f:
        json = load(f)
    assert validate(json)
    installed_packages = {*flatpak.list()}
    for repo, value in json.items():
        url = value["url"]
        packages = set(value["packages"])
        flatpak.remote_add(repo, url)
        missing_packages = packages - installed_packages
        if missing_packages:
            flatpak.install(repo, missing_packages)
        installed_packages -= packages
    for repo in flatpak.remote_list(system=True):
        flatpak.remote_delete(repo, system=True)
    for repo in flatpak.remote_list(system=False):
        if repo not in json:
            flatpak.remote_delete(repo, system=False)
    if installed_packages:
        flatpak.remove(installed_packages)


if __name__ == "__main__":
    main()
