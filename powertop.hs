main = do
  writeFile "/sys/bus/pci/devices/0000:02:00.0/power/control" "auto"
  writeFile "/proc/sys/kernel/nmi_watchdog" "0"
  writeFile "/proc/sys/vm/dirty_writeback_centisecs" "1500"