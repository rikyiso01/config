from __future__ import annotations
from pwn import *  # type: ignore
from argparse import ArgumentParser

EXE = ""
REMOTE = ("", 0)
exe = context.binary = ELF(EXE)


def start(argv: list[str] = []):
    parser = ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--remote", action="store_true")
    group.add_argument("--gdb", action="store_true")
    args = parser.parse_args()
    if args.remote:
        return connect(*REMOTE)
    if args.gdb:
        return gdb.debug([exe.path] + argv, gdbscript=gdbscript)
    return process([exe.path] + argv)


gdbscript = f"""
tbreak main
continue
"""

# ===========================================================
#                    EXPLOIT GOES HERE
# ===========================================================

io = start()

io.interactive()
