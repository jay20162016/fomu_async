yosys fomu.ys

#nextpnr-ice40 --up5k --package uwg30 --json fomu.json --pcf ../hdl/fomu_pvt.pcf --asc fomu.asc \
#              --freq 16 --ignore-loops
./nextpnr-ice40-force fomu ../hdl/fomu_pvt 1 10

icepack fomu.asc fomu.dfu

dfu-suffix -v 1209 -p 70b1 -a fomu.dfu

dfu-util -w -D fomu.dfu


#screen /dev/cu.usb*

./catfomu || catfomu
