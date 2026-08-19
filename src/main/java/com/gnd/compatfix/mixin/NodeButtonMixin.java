package com.gnd.compatfix.mixin;

import com.yesman.epicskills.client.gui.screen.CategorySlotTexture;
import com.yesman.epicskills.client.gui.screen.SkillTreeScreen;
import com.yesman.epicskills.neoforge.attachment.SkillTreeProgression;
import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = SkillTreeScreen.TreePage.NodeButton.class, remap = false)
public class NodeButtonMixin {
    @Shadow @Final @Mutable
    private CategorySlotTexture categoryTexture;

    @Inject(method = "<init>", at = @At("RETURN"))
    private void gnd_compat_fix$fallbackCategoryTexture(SkillTreeScreen.TreePage treePage, SkillTreeProgression.TopDownTreeNode treeNode, CallbackInfo ci) {
        if (this.categoryTexture == null) {
            this.categoryTexture = SkillTreeScreen.TreePage.NodeButton.CategorySlotTextures.PASSIVE;
        }
    }
}
