-- Copyright (c) 2026 NeticSoul. Licensed under the MIT License; see LICENSE.

local addon = select(2, ...)
local L = addon.L

local function T(key, fallback)
    return (L and L[key]) or fallback or key
end

local IconicModule = {
    initialized = false,
    applied = false,
}

addon.IconicModule = IconicModule

if addon.RegisterModule then
    addon:RegisterModule("iconic", IconicModule,
        T("Iconic"),
        T("Item icons in chat, merchant improvements, and enhanced item tooltips."),
        {
            lifecyclePrefix = "Iconic",
            loadOnce = true,
        }
    )
end

function addon:IsIconicEnabled()
    return self:IsModuleEnabled("iconic")
end

local function ApplyIconicSystem()
    IconicModule.initialized = true
    IconicModule.applied = true
end

local function RestoreIconicSystem()
    IconicModule.applied = false
end

local function RefreshIconicSystem()
    if addon:IsIconicEnabled() then
        ApplyIconicSystem()
    else
        RestoreIconicSystem()
    end
end

addon.ApplyIconicSystem = ApplyIconicSystem
addon.RestoreIconicSystem = RestoreIconicSystem
addon.RefreshIconicSystem = RefreshIconicSystem

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        if addon:IsIconicEnabled() then
            ApplyIconicSystem()
        end
    end
end)
