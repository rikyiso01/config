import System.Process (callProcess)

main = do
  writeFile "/sys/bus/pci/devices/0000:02:00.0/power/control" "auto"
  writeFile "/proc/sys/kernel/nmi_watchdog" "0"
  writeFile "/proc/sys/vm/dirty_writeback_centisecs" "1500"
  callProcess "/usr/sbin/iw" ["dev", "wlp2s0", "set", "power_save", "off"]