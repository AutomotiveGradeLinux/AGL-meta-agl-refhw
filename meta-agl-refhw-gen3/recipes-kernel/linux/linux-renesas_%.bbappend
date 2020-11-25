FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-create-r8a7795-usb-ovc-pinmux-groups.patch \
	file://0001-add-agl-refhw.patch \
	file://0003-rcar3-dw-hdmi-cec-mute.patch \
	file://refhw-rcar.cfg \
"

KERNEL_CONFIG_FRAGMENTS_append = " ${WORKDIR}/refhw-rcar.cfg"
