local addon = select(2, ...)

-- Item level line relocation to item title line
local function findPercentD(fmt)
    if type(fmt) ~= "string" then
        return nil
    end
    for i = 1, #fmt - 1 do
        if fmt:sub(i, i + 1) == "%d" then
            return i
        end
    end
    return nil
end

local function getItemLevelTextPrefix()
    local fmt = _G.ITEM_LEVEL
    local pos = findPercentD(fmt)
    if not pos then
        return nil
    end
    return fmt:sub(1, pos - 1)
end

local function stripColorCodes(s)
    if not s then
        return ""
    end
    s = s:gsub("|c%x%x%x%x%x%x%x%x", "")
    s = s:gsub("|r", "")
    return s
end

local cachedPrefix

local function getPrefixLive()
    local p = getItemLevelTextPrefix()
    if p and p ~= "" then
        cachedPrefix = p
        return p
    end
    return cachedPrefix
end

local function restAfterPrefixLooksLikeItemLevel(subText, prefix)
    if not subText or not prefix or prefix == "" then
        return false
    end
    local p = subText:find(prefix, 1, true)
    if not p then
        return false
    end
    local after = stripColorCodes(subText:sub(p + #prefix))
    return after:find("^%s*%d+") ~= nil
end

local function isItemLevelLineFallback(subText)
    if not subText then
        return false
    end
    local plain = stripColorCodes(subText)
    if plain:find("^%s*Item Level%s+%d+") then
        return true
    end
    if plain:find("^%s*Уровень предмета:%s*%d+") then
        return true
    end
    if plain:find("^%s*Nivel de objeto%s+%d+") then
        return true
    end
    return false
end

local function isItemLevelLine(subText)
    if not subText then
        return false
    end
    local prefix = getPrefixLive()
    if prefix and restAfterPrefixLooksLikeItemLevel(subText, prefix) then
        return true
    end
    return isItemLevelLineFallback(subText)
end

local function getTooltipLineText(tooltip, side, index)
    local fs = _G[tooltip:GetName() .. "Text" .. side .. index]
    return fs and fs:GetText() or nil
end

local function clearTooltipLine(tooltip, side, index)
    local fs = _G[tooltip:GetName() .. "Text" .. side .. index]
    if fs then
        fs:SetText("")
    end
end

local function ModifyItemLevelTooltip(tooltip)
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then
        return false
    end

    getPrefixLive()

    local n = tooltip:NumLines()
    local line = _G[tooltip:GetName() .. "TextLeft1"]
    if not line then
        return false
    end
    local text = line:GetText()
    if not text then
        return false
    end

    for j = 2, n do
        for _, side in ipairs({ "Left", "Right" }) do
            local subText = getTooltipLineText(tooltip, side, j)
            if isItemLevelLine(subText) then
                clearTooltipLine(tooltip, side, j)
                line:SetText(text .. " \n|cffffd100" .. subText .. "|r")
                tooltip:Show()
                return true
            end
        end
    end
    return false
end

local deferFrame = CreateFrame("Frame")
local deferredTooltip

local function runDeferredMerge()
    deferFrame:SetScript("OnUpdate", nil)
    local t = deferredTooltip
    deferredTooltip = nil
    if t then
        ModifyItemLevelTooltip(t)
    end
end

local function ModifyItemLevelTooltipQueued(tooltip)
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then
        return
    end
    if ModifyItemLevelTooltip(tooltip) then
        return
    end
    deferredTooltip = tooltip
    deferFrame:SetScript("OnUpdate", runDeferredMerge)
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ItemRefShoppingTooltip1,
    ItemRefShoppingTooltip2,
    ItemRefShoppingTooltip3,
    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,
}

for _, tt in ipairs(tooltips) do
    if tt and tt.HookScript then
        tt:HookScript("OnTooltipSetItem", ModifyItemLevelTooltipQueued)
    end
end
