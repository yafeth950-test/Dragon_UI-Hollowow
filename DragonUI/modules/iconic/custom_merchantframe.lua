local addon = select(2, ...)
local select, hooksecurefunc = select, hooksecurefunc
local CreateFrame, GetMerchantNumItems, GetMerchantItemInfo = CreateFrame, GetMerchantNumItems, GetMerchantItemInfo
local ceil = math.ceil

-- Function to scroll merchant frame pages
local function ScrollMerchantFrame(delta)
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then return end
    if not MerchantFrame or not MerchantFrame:IsShown() then return end

    if delta > 0 then
        -- Scroll up / previous page
        if MerchantFrame.page > 1 then
            MerchantPrevPageButton:Click()
        end
    elseif delta < 0 then
        -- Scroll down / next page
        local maxPages = ceil(GetMerchantNumItems() / MERCHANT_ITEMS_PER_PAGE)
        if MerchantFrame.page < maxPages then
            MerchantNextPageButton:Click()
        end
    end
end

if MerchantFrame then
    MerchantFrame:EnableMouseWheel(true)
    if MerchantFrame:GetScript("OnMouseWheel") then
        MerchantFrame:HookScript("OnMouseWheel", function(self, delta)
            ScrollMerchantFrame(delta)
        end)
    else
        MerchantFrame:SetScript("OnMouseWheel", function(self, delta)
            ScrollMerchantFrame(delta)
        end)
    end

    MerchantFrame:HookScript("OnShow", function(self)
        if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then return end
        self:EnableMouseWheel(true)
    end)
end

-- Dedicated scan tooltip so we don't pollute GameTooltip
local scanTooltip = CreateFrame("GameTooltip", "IconicMerchantScanTooltip", UIParent, "GameTooltipTemplate")
scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local cache = {}

local function checkItem(link)
    if not link then return end
    local id = link:match("item:(%d+)")
    if not id then return end
    if cache[id] ~= nil then return cache[id] end

    scanTooltip:ClearLines()
    scanTooltip:SetHyperlink(link)
    local alreadyKnown = false
    local numLines = scanTooltip:NumLines()
    for i = 2, numLines do
        local fontString = _G["IconicMerchantScanTooltipTextLeft" .. i]
        local text = fontString and fontString:GetText()
        if text == ITEM_SPELL_KNOWN then
            alreadyKnown = true
            break
        end
    end
    cache[id] = alreadyKnown
    return alreadyKnown
end

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then return end
    local numMerchantItems = GetMerchantNumItems()

    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
        if index <= numMerchantItems then
            local isUsable = select(1, GetMerchantItemInfo(index))
            local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
            local merchantButton = _G["MerchantItem" .. i]

            if isUsable and checkItem(GetMerchantItemLink(index)) then
                if merchantButton then
                    SetItemButtonNameFrameVertexColor(merchantButton, 0.3, 0.3, 0.3)
                    SetItemButtonSlotVertexColor(merchantButton, 0.3, 0.3, 0.3)
                end
                if itemButton then
                    SetItemButtonTextureVertexColor(itemButton, 0.3, 0.3, 0.3)
                    SetItemButtonNormalTextureVertexColor(itemButton, 0.3, 0.3, 0.3)
                end
            end
        end
    end
end)
