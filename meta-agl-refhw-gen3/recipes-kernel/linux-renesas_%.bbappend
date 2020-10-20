FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0002-Introduce-dts-file-for-refhw-r-car-board.patch \
	file://0001-add-st_asm330lhh-driver.patch \
	file://0002-agl-reference-hardware-sample-bsp.patch \
	file://refhw-rcar.cfg \
"

KERNEL_CONFIG_FRAGMENTS_append = " ${WORKDIR}/refhw-rcar.cfg "

KERNEL_DEVICETREE_refhw = "renesas/r8a7795-refhw.dtb"
