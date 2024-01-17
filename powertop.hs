import System.Process (callProcess)

main = do
  writeFile "/proc/sys/kernel/nmi_watchdog" "0"
  writeFile "/proc/sys/vm/dirty_writeback_centisecs" "1500"
  --callProcess "/usr/sbin/iw" ["dev", "wlp2s0", "set", "power_save", "off"]
  writeFile "/sys/class/scsi_host/host0/link_power_management_policy" "med_power_with_dipm"
  writeFile "/sys/bus/usb/devices/1-4/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:04.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:1f.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:14.3/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:08.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:17.0/ata1/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:17.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:1f.5/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:00.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:02:00.1/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:14.2/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:00:0a.0/power/control" "auto"
  writeFile "/sys/bus/pci/devices/0000:01:00.0/power/control" "auto"
