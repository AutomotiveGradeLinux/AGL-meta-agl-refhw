#FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

# There are hardware issues in using hyperflash. arm-trusted-firmware, optee and
# u-boot have to be stored into eMMC by using serial donwload.
EMMC_BOOT_OPTION = "RCAR_SA6_TYPE=1"

DDR_8G_OPTION= "RCAR_DRAM_LPDDR4_MEMCONF=1"

ATFW_OPT_append_refhw = " ${EMMC_BOOT_OPTION} "

# In arm-trusted-firmware-control.inc, a "extra_ipl_opt" task is appended to
# create firmware for 4x2g or 2x2g variation. it is supposed to use
# EXTRA_ATFW_OPT to customize the compiler opton.
#
#EXTRA_ATFW_OPT_append_refhw = " ${EMMC_BOOT_OPTION} ${DDR_8G_OPTION} "
#
# Unfortunately in do_extra_ipl_opt() it use d.setVar() instead of d.appendVar()
# to setup EXTRA_ATFW_OPT variable which makes it impossible to customize it properly
# by others... Override it.
# 
#
do_ipl_opt_compile_refhw () {
    oe_runmake distclean
    oe_runmake bl2 bl31 dummytool PLAT=${PLATFORM} ${EXTRA_ATFW_OPT} ${ATFW_OPT_LOSSY} ${EMMC_BOOT_OPTION} ${DDR_8G_OPTION}
}

