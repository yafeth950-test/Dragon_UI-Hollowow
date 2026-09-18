local addon = select(2, ...)
local ICON_SIZE = 15

local function AddLootIcons(self, event, message, ...)
    if addon.IsModuleEnabled and not addon:IsModuleEnabled("iconic") then
        return false, message, ...
    end
    local function Icon(link)
        local texture = GetItemIcon(link)
        if texture then
            return format("\124T%s:%d\124t%s", texture, ICON_SIZE, link)
        end
        return link
    end
    message = message:gsub("(\124c%x+\124Hitem:.-\124h\124r)", Icon)
    return false, message, ...
end

local chatEvents = {
    "CHAT_MSG_LOOT", "CHAT_MSG_CHANNEL", "CHAT_MSG_PARTY", 
    "CHAT_MSG_RAID", "CHAT_MSG_SAY", "CHAT_MSG_YELL",
    "CHAT_MSG_GUILD", "CHAT_MSG_SYS", "CHAT_MSG_SYSTEM",
    "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID_LEADER", 
    "CHAT_MSG_RAID_WARNING"
}

for _, event in ipairs(chatEvents) do
    ChatFrame_AddMessageEventFilter(event, AddLootIcons)
end
