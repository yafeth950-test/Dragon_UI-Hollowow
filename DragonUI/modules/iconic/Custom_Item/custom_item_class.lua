local addon = select(2, ...)

-- Fallback class colors
local classColorsFallback = {
    ["Воин"] = "|cffc69b6d", ["Warrior"] = "|cffc69b6d", ["Guerrero"] = "|cffc69b6d",
    ["Паладин"] = "|cfff48cba", ["Paladin"] = "|cfff48cba", ["Paladín"] = "|cfff48cba",
    ["Охотник"] = "|cffaad372", ["Hunter"] = "|cffaad372", ["Cazador"] = "|cffaad372",
    ["Разбойник"] = "|cfffff468", ["Rogue"] = "|cfffff468", ["Pícaro"] = "|cfffff468",
    ["Жрец"] = "|cffffffff", ["Priest"] = "|cffffffff", ["Sacerdote"] = "|cffffffff",
    ["Рыцарь смерти"] = "|cffc41e3a", ["Death Knight"] = "|cffc41e3a", ["Caballero de la Muerte"] = "|cffc41e3a",
    ["Шаман"] = "|cff0070de", ["Shaman"] = "|cff0070de", ["Chamán"] = "|cff0070de",
    ["Маг"] = "|cff69ccf0", ["Mage"] = "|cff69ccf0", ["Mago"] = "|cff69ccf0",
    ["Чернокнижник"] = "|cff9482c9", ["Warlock"] = "|cff9482c9", ["Brujo"] = "|cff9482c9",
    ["Друид"] = "|cffff7d0a", ["Druid"] = "|cffff7d0a",
}

-- Localized class colors from RAID_CLASS_COLORS
local localizedClassColor = {}

local function buildLocalizedClassColors()
    if next(localizedClassColor) then
        return
    end
    local names = _G.LOCALIZED_CLASS_NAMES
    local colors = _G.RAID_CLASS_COLORS
    if type(names) == "table" and type(colors) == "table" then
        for token, locName in pairs(names) do
            local rgb = colors[token]
            if type(locName) == "string" and type(rgb) == "table" then
                local r = rgb.r or 0
                local g = rgb.g or 0
                local b = rgb.b or 0
                localizedClassColor[locName] = string.format(
                    "|cff%02x%02x%02x",
                    math.floor(r * 255 + 0.5),
                    math.floor(g * 255 + 0.5),
                    math.floor(b * 255 + 0.5)
                )
            end
        end
    end
    for name, hex in pairs(classColorsFallback) do
        if not localizedClassColor[name] then
            localizedClassColor[name] = hex
        end
    end
end

local function stripColorCodes(s)
    return (s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
end

local function classColorForName(name)
    buildLocalizedClassColors()
    name = stripColorCodes(name):match("^%s*(.-)%s*$") or name
    return localizedClassColor[name]
end

local function getClassesLinePrefix()
    local fmt = _G.ITEM_CLASSES_ALLOWED
    if type(fmt) ~= "string" then
        return nil
    end
    local pos = fmt:find("%%s", 1, true)
    if not pos or pos < 1 then
        return nil
    end
    return fmt:sub(1, pos - 1)
end

local classesPrefix = getClassesLinePrefix()

local function ModifyTooltip(self)
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then
        return
    end

    local tooltipLines = self:NumLines()
    for i = 1, tooltipLines do
        local fontString = _G[self:GetName() .. "TextLeft" .. i]
        local tooltipText = fontString and fontString:GetText()
        if tooltipText then
            local replaced = false
            local classStart, classEnd, classesStr, labelPrefix

            if classesPrefix and classesPrefix ~= "" then
                local plainPos = tooltipText:find(classesPrefix, 1, true)
                if plainPos then
                    classStart = plainPos
                    labelPrefix = classesPrefix
                    local tail = tooltipText:sub(plainPos + #classesPrefix)
                    classesStr = tail:match("^%s*(.-)%s*$") or tail
                    classEnd = #tooltipText
                end
            end
            if not classesStr then
                local ruStart, ruEnd, ruStr = string.find(tooltipText, "Классы:%s*(.+)")
                local enStart, enEnd, enStr = string.find(tooltipText, "Classes:%s*(.+)")
                local esStart, esEnd, esStr = string.find(tooltipText, "Clases:%s*(.+)")
                if ruStr then
                    classStart, classEnd, classesStr, labelPrefix = ruStart, ruEnd, ruStr, "Классы: "
                elseif enStr then
                    classStart, classEnd, classesStr, labelPrefix = enStart, enEnd, enStr, "Classes: "
                elseif esStr then
                    classStart, classEnd, classesStr, labelPrefix = esStart, esEnd, esStr, "Clases: "
                end
            end

            if classesStr then
                local classes = {}
                for part in classesStr:gmatch("[^,]+") do
                    local rawName = part:gsub("^%s*(.-)%s*$", "%1")
                    local lookupName = stripColorCodes(rawName):match("^%s*(.-)%s*$") or rawName
                    local col = classColorForName(lookupName)
                    if col then
                        table.insert(classes, { display = lookupName, color = col })
                    end
                end
                local coloredText = tooltipText:sub(1, classStart - 1) .. labelPrefix
                local isFirstClass = true
                for _, entry in ipairs(classes) do
                    if not isFirstClass then
                        coloredText = coloredText .. ", "
                    end
                    coloredText = coloredText .. entry.color .. entry.display .. "|r"
                    isFirstClass = false
                end
                coloredText = coloredText .. tooltipText:sub(classEnd + 1)
                fontString:SetText(coloredText)
                replaced = true
            end
            local hasClassesLine = classesPrefix and tooltipText:find(classesPrefix, 1, true)
            if not replaced and (hasClassesLine or string.find(tooltipText, "Классы:") or string.find(tooltipText, "Classes:") or string.find(tooltipText, "Clases:")) then
                fontString:SetText(tooltipText .. " ")
            end
        end
    end
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
        tt:HookScript("OnTooltipSetItem", ModifyTooltip)
    end
end
