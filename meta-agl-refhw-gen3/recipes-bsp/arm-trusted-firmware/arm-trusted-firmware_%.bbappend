FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_agl-refhw-h3 = " file://0001-rcar_gen3-plat-Delete-FDT-function-calls.patch"

# Apply the patch AGL applies for all rcar3 in meta-agl-bsp when
# building the standalone agl-refhw-h3 machine.
SRC_URI_append_agl-refhw-h3 = " file://0001-Boot-Normal-World-in-EL2.patch"

# It is believed the eMMC configuration below makes the result AGL
# reference hardware specific, mark it as such when building with
# MACHINE=agl-refhw-h3 to potentially flag this in an incorrectly
# configured build.
COMPATIBLE_MACHINE_agl-refhw-h3 = "agl-refhw-h3"

# There are hardware issues in using hyperflash. arm-trusted-firmware, optee and
# u-boot have to be stored into eMMC by using serial donwload.
EMMC_BOOT_OPTION = "RCAR_SA6_TYPE=1"

# RCAR_DRAM_MEMRANK must be set, since in case of RCAR_DRAM_LPDDR4_MEMCONF=1
# ddr_rank_judge is called. But for RCAR_DRAM_MEMRANK=0 it can determine values
# only for Salvator XS and Starter Kit Pre.
#
# RCAR_DRAM_MEMRANK=2 is set because for ATF from BSP v4.7.0:
#
# https://github.com/renesas-rcar/arm-trusted-firmware/tree/af9f429a48b438e314289f17947ad5d8036f398e
#
# _board_judge returns hardcoded 'brd = 8;  /*  8Gbit/2rank */' by default.
#
DDR_8G_OPTION = "RCAR_DRAM_LPDDR4_MEMCONF=1 RCAR_DRAM_MEMRANK=2"

ATFW_OPT_agl-refhw-h3 = "LSI=H3 RCAR_DRAM_SPLIT=1 ${EMMC_BOOT_OPTION} ${DDR_8G_OPTION}"

#
# Handle building as extra firmware with MACHINE=h3ulcb
#

# Build options for building as extra firmware when MACHINE=h3ulcb, based on H3[4x2g]
H3ULCB[agl-refhw-4x2g] = "LSI=H3 RCAR_DRAM_SPLIT=1 ${EMMC_BOOT_OPTION} ${DDR_8G_OPTION}"

#
# Need to prepend the compile tasks with a distclean that actually cleans
# out all the platform specific files like the new rcar_layout_tool output,
# otherwise they do not get rebuilt and board builds can get the wrong
# version of e.g. cert_headers_sa6.  This needs to be addressed with
# upstream.
#

do_compile_prepend() {
    oe_runmake distclean PLAT=${PLATFORM} MBEDTLS_COMMON_MK=1 ${ATFW_OPT}
}

do_ipl_opt_compile_prepend() {
    oe_runmake distclean PLAT=${PLATFORM} MBEDTLS_COMMON_MK=1 ${ATFW_OPT}
}

do_extra_ipl_opt_refhw_fixup() {
    # Rename agl-refhw-h3 firmware files to drop h3ulcb-
    for f in ${DEPLOYDIR}/*-h3ulcb-agl-refhw-4x2g*; do
        n=`basename $f | sed 's/h3ulcb-//'`
        mv -f $f ${DEPLOYDIR}/$n
    done
}

EXTRA_IPL_OPT_POSTFUNCS = ""
EXTRA_IPL_OPT_POSTFUNCS_h3ulcb = "do_extra_ipl_opt_refhw_fixup"
do_extra_ipl_opt[postfuncs] += "${EXTRA_IPL_OPT_POSTFUNCS}"
