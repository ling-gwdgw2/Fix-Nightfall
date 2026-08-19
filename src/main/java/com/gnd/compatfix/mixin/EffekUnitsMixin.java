package com.gnd.compatfix.mixin;

import com.hm.efn.EFNClientConfig;
import com.hm.efn.util.EffekUnits;
import net.neoforged.fml.ModList;
import net.neoforged.fml.loading.FMLEnvironment;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Overwrite;

@Mixin(value = EffekUnits.class, remap = false)
public class EffekUnitsMixin {
    /**
     * @author vivo9
     * @reason Safely bypass client config access on dedicated servers to prevent crashes
     */
    @Overwrite
    public static boolean VFXENABLE() {
        try {
            if (FMLEnvironment.dist != null && !FMLEnvironment.dist.isClient()) {
                return false;
            }
            if (EFNClientConfig.VFX_PLUS != null && EFNClientConfig.VFX_PLUS.get()) {
                return ModList.get() != null && ModList.get().isLoaded("aaa_particles");
            }
        } catch (Throwable ignored) {
            return false;
        }
        return false;
    }
}
