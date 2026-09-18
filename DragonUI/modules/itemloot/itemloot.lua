-- ============================================================================
-- DragonUI - Item Loot Module (pretty_lootalert)
-- Animated loot toast notifications with custom textures and sounds.
-- ============================================================================

local addonName, addon = ...;
local L = addon.L;

addon.ItemLoot = addon.ItemLoot or {};
local private = addon.ItemLoot;

local ItemLootModule = {
    initialized = false,
    applied = false,
};
addon.ItemLootModule = ItemLootModule;

if addon.RegisterModule then
    addon:RegisterModule(
        "itemloot",
        ItemLootModule,
        L["Loot Toast"],
        L["Pretty loot toast alert notifications with custom textures."],
        { loadOnce = true }
    );
end

function ItemLootModule:ApplySystem()
    self.applied = true;
    if LootAlertFrame then
        LootAlertFrame:RegisterEvent("CHAT_MSG_LOOT");
        LootAlertFrame:RegisterEvent("CHAT_MSG_SYSTEM");
        LootAlertFrame:RegisterEvent("CHAT_MSG_MONEY");
        LootAlertFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
        LootAlertFrame:Show();
    end
end

function ItemLootModule:RestoreSystem()
    self.applied = false;
    if LootAlertFrame then
        LootAlertFrame:UnregisterAllEvents();
        LootAlertFrame:Hide();
    end
    if private.HideAllToasts then
        private.HideAllToasts();
    end
end

function addon.ApplyItemLootSystem()
    ItemLootModule:ApplySystem();
end

function addon.RestoreItemLootSystem()
    ItemLootModule:RestoreSystem();
end

function private.HideAllToasts()
    for i = 1, 8 do
        local btn = _G["LootAlertButton" .. i];
        if btn then
            btn:Hide();
            if btn.animIn then btn.animIn:Stop(); end
            if btn.waitAndAnimOut then btn.waitAndAnimOut:Stop(); end
            if btn.data then table.wipe(btn.data); end
        end
    end
    local alertQueue = private.alertQueue;
    if alertQueue then
        table.wipe(alertQueue);
    end
end

-- ============================================================================
-- EDITOR MODE PREVIEW INTEGRATION
-- Shows a preview toast attached to DragonUI_LootRollAnchor ("Botín" card)
-- so the player can see where loot toasts will appear while dragging.
-- ============================================================================

function private.ShowEditorPreview()
    local btn = LootAlertButton1;
    if not btn then return; end

    local anchor = _G["DragonUI_LootRollAnchor"] or (addon.LootRollModule and addon.LootRollModule.anchorFrame);
    if not anchor then return; end

    btn:EnableMouse(false);

    btn.data = {
        name = "|cffa335eeDragonUI Loot Alert|r",
        link = "item:19019",
        quality = 4,
        texture = "Interface\\Icons\\INV_Sword_04",
        count = 1,
        label = _G.YOU_RECEIVED_LABEL or "You received",
        toast = "defaulttoast",
    };

    btn:ClearAllPoints();
    btn:SetPoint("CENTER", anchor, "CENTER", 0, 0);
    btn:SetScale(private.config and private.config.scale or 1);

    if not btn._origStrata then
        btn._origStrata = btn:GetFrameStrata();
    end
    btn:SetFrameStrata(anchor:GetFrameStrata() or "MEDIUM");
    btn:SetFrameLevel(math.max(1, (anchor:GetFrameLevel() or 10) - 1));

    btn:Show();
    btn.animIn:Stop();
    btn.waitAndAnimOut:Stop();
    btn:SetAlpha(1);

    if btn.Background then btn.Background:Show(); end
    if btn.HeroicBackground then btn.HeroicBackground:Hide(); end
    if btn.PvPBackground then btn.PvPBackground:Hide(); end
    if btn.MoneyBackground then btn.MoneyBackground:Hide(); end
    if btn.MountToastBackground then btn.MountToastBackground:Hide(); end
    if btn.PetToastBackground then btn.PetToastBackground:Hide(); end
    if btn.LegendaryBackground then btn.LegendaryBackground:Hide(); end
    if btn.LessBackground then btn.LessBackground:Hide(); end

    if btn.Icon then
        btn.Icon:SetTexture("Interface\\Icons\\INV_Sword_04");
        btn.Icon:Show();
    end
    if btn.IconBorder then btn.IconBorder:Show(); end
    if btn.ItemName then
        btn.ItemName:SetText("|cffa335eeDragonUI Loot Alert|r");
        btn.ItemName:Show();
    end
    if btn.Label then
        btn.Label:SetText(_G.YOU_RECEIVED_LABEL or "You received");
        btn.Label:Show();
    end
end

function private.HideEditorPreview()
    local btn = LootAlertButton1;
    if not btn then return; end
    if btn._origStrata then
        btn:SetFrameStrata(btn._origStrata);
    end
    btn:EnableMouse(true);
    btn:Hide();
    if btn.data then table.wipe(btn.data); end
end

-- Export helpers for lootroll / editor_mode
addon.ItemLoot.ShowEditorPreview = private.ShowEditorPreview;
addon.ItemLoot.HideEditorPreview = private.HideEditorPreview;
addon.ItemLoot.HideAllToasts = private.HideAllToasts;
