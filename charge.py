#!/usr/bin/env python3

from time import sleep
from functools import cache
from os.path import join
from subprocess import run

BAT_DIR = "/sys/class/power_supply/BAT1"

CONSERVATIVE = "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"


def set_conservative(enable: bool) -> None:
    with open(CONSERVATIVE, "wt") as f:
        f.write(str(int(enable)))


def read_int(name: str) -> int:
    with open(join(BAT_DIR, name)) as f:
        return int(f.read())


def energy_now() -> float:
    return read_int("energy_now") / 1000 / 1000


@cache
def energy_full() -> float:
    return read_int("energy_full") / 1000 / 1000


def power_now() -> float:
    return read_int("power_now") / 1000 / 1000


def percentage() -> float:
    return energy_now() / energy_full()


def main():
    set_conservative(False)
    while (perc := percentage()) < 0.80:
        print("Percentage is", perc)
        sleep(60)
    set_conservative(True)
    run(["poweroff"], check=True)


if __name__ == "__main__":
    main()
