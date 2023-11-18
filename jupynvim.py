#!/usr/bin/env python3

from subprocess import PIPE, Popen, check_call
from os import environ


def main():
    assert "NVIM_SERVER" in environ
    process = Popen(["jupyter", "nbclassic", "--no-browser"], stderr=PIPE, text=True)
    assert process.stderr is not None
    link: str | None = None
    for line in process.stderr:
        if "http://" not in line:
            continue
        link = line[line.index("http://") :].strip()
        break
    assert link is not None
    check_call(
        [
            "jupynium",
            "--nvim_listen_addr",
            environ["NVIM_SERVER"],
            "--notebook_URL",
            link,
        ]
    )


if __name__ == "__main__":
    main()
