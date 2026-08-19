package com.gnd.compatfix;

import net.neoforged.fml.common.Mod;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod(GndCompatFix.MODID)
public class GndCompatFix {
    public static final String MODID = "gnd_compat_fix";
    public static final Logger LOGGER = LogManager.getLogger(MODID);

    public GndCompatFix() {
        LOGGER.info("G&D Live Compat Fix initialized successfully!");
    }
}
