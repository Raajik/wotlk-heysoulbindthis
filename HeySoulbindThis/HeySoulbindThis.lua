local addonName = "HeySoulbindThis"

-- =====================================================================
-- 0. CONFIG / CONSTANTS
-- =====================================================================
local CHAT_PREFIX = "|cff33ff99[HeySoulbindThis]|r "
local MAX_ATTACHMENTS = 12
local BATCH_DELAY = 0.75
local PANEL_WIDTH = 560
local PANEL_HEIGHT = 560
local ROW_HEIGHT = 22

local FLAT_BG = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile = false, edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local CLASS_ORDER = {
    "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST",
    "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "DRUID",
}

local CLASS_DISPLAY = {
    WARRIOR = "Warrior",
    PALADIN = "Paladin",
    HUNTER = "Hunter",
    ROGUE = "Rogue",
    PRIEST = "Priest",
    DEATHKNIGHT = "Death Knight",
    SHAMAN = "Shaman",
    MAGE = "Mage",
    WARLOCK = "Warlock",
    DRUID = "Druid",
}

local CLASS_COLORS = {
    WARRIOR = "C79C6E",
    PALADIN = "F58CBA",
    HUNTER = "ABD473",
    ROGUE = "FFF569",
    PRIEST = "FFFFFF",
    DEATHKNIGHT = "C41F3B",
    SHAMAN = "0070DE",
    MAGE = "69CCF0",
    WARLOCK = "9482C9",
    DRUID = "FF7D0A",
}

local WEAPON_SUB = {
    AXE_1H = 1, AXE_2H = 2, BOW = 3, GUN = 4,
    MACE_1H = 5, MACE_2H = 6, POLEARM = 7,
    SWORD_1H = 8, SWORD_2H = 9, STAFF = 10,
    FIST = 13, MISC = 14, DAGGER = 15, THROWN = 16,
    CROSSBOW = 17, WAND = 18, FISHING = 19,
}

local ARMOR_SUB = {
    MISC = 1, CLOTH = 2, LEATHER = 3, MAIL = 4, PLATE = 5,
    SHIELD = 6, LIBRAM = 7, IDOL = 8, TOTEM = 9, SIGIL = 10,
}

-- Keyed by short category label (matched via subtype text, not auction index)
local CLASS_WEAPONS = {
    WARRIOR = {
        ["1H Axe"] = true, ["2H Axe"] = true, ["Bow"] = true, ["Gun"] = true,
        ["1H Mace"] = true, ["2H Mace"] = true, ["Polearm"] = true,
        ["1H Sword"] = true, ["2H Sword"] = true, ["Staff"] = true, ["Fist"] = true,
        ["Dagger"] = true, ["Thrown"] = true, ["Crossbow"] = true,
    },
    PALADIN = {
        ["1H Axe"] = true, ["2H Axe"] = true, ["1H Mace"] = true, ["2H Mace"] = true,
        ["Polearm"] = true, ["1H Sword"] = true, ["2H Sword"] = true,
    },
    HUNTER = {
        ["1H Axe"] = true, ["2H Axe"] = true, ["Bow"] = true, ["Gun"] = true,
        ["Polearm"] = true, ["1H Sword"] = true, ["2H Sword"] = true,
        ["Staff"] = true, ["Fist"] = true, ["Dagger"] = true, ["Thrown"] = true,
        ["Crossbow"] = true,
    },
    ROGUE = {
        ["1H Axe"] = true, ["Bow"] = true, ["Gun"] = true, ["1H Mace"] = true,
        ["1H Sword"] = true, ["Fist"] = true, ["Dagger"] = true, ["Thrown"] = true,
        ["Crossbow"] = true,
    },
    PRIEST = {
        ["1H Mace"] = true, ["Staff"] = true, ["Dagger"] = true, ["Wand"] = true,
    },
    DEATHKNIGHT = {
        ["1H Axe"] = true, ["2H Axe"] = true, ["1H Mace"] = true, ["2H Mace"] = true,
        ["Polearm"] = true, ["1H Sword"] = true, ["2H Sword"] = true,
    },
    SHAMAN = {
        ["1H Axe"] = true, ["2H Axe"] = true, ["1H Mace"] = true, ["2H Mace"] = true,
        ["Staff"] = true, ["Fist"] = true, ["Dagger"] = true,
    },
    MAGE = {
        ["1H Sword"] = true, ["Staff"] = true, ["Dagger"] = true, ["Wand"] = true,
    },
    WARLOCK = {
        ["1H Sword"] = true, ["Staff"] = true, ["Dagger"] = true, ["Wand"] = true,
    },
    DRUID = {
        ["1H Mace"] = true, ["2H Mace"] = true, ["Polearm"] = true, ["Staff"] = true,
        ["Fist"] = true, ["Dagger"] = true,
    },
}

local CLASS_SHIELDS = {
    WARRIOR = true, PALADIN = true, SHAMAN = true,
}

local CLASS_RELICS = {
    [ARMOR_SUB.LIBRAM] = { PALADIN = true },
    [ARMOR_SUB.IDOL] = { DRUID = true },
    [ARMOR_SUB.TOTEM] = { SHAMAN = true },
    [ARMOR_SUB.SIGIL] = { DEATHKNIGHT = true },
}

local WEAPON_CATEGORY = {
    [WEAPON_SUB.AXE_1H] = "1H Axe", [WEAPON_SUB.AXE_2H] = "2H Axe",
    [WEAPON_SUB.BOW] = "Bow", [WEAPON_SUB.GUN] = "Gun",
    [WEAPON_SUB.MACE_1H] = "1H Mace", [WEAPON_SUB.MACE_2H] = "2H Mace",
    [WEAPON_SUB.POLEARM] = "Polearm",
    [WEAPON_SUB.SWORD_1H] = "1H Sword", [WEAPON_SUB.SWORD_2H] = "2H Sword",
    [WEAPON_SUB.STAFF] = "Staff", [WEAPON_SUB.FIST] = "Fist",
    [WEAPON_SUB.MISC] = "Misc", [WEAPON_SUB.DAGGER] = "Dagger",
    [WEAPON_SUB.THROWN] = "Thrown", [WEAPON_SUB.CROSSBOW] = "Crossbow",
    [WEAPON_SUB.WAND] = "Wand", [WEAPON_SUB.FISHING] = "Fishing",
}

local ARMOR_CATEGORY = {
    [ARMOR_SUB.MISC] = "Misc",
    [ARMOR_SUB.CLOTH] = "Cloth",
    [ARMOR_SUB.LEATHER] = "Leather",
    [ARMOR_SUB.MAIL] = "Mail",
    [ARMOR_SUB.PLATE] = "Plate",
    [ARMOR_SUB.SHIELD] = "Shield",
    [ARMOR_SUB.LIBRAM] = "Libram",
    [ARMOR_SUB.IDOL] = "Idol",
    [ARMOR_SUB.TOTEM] = "Totem",
    [ARMOR_SUB.SIGIL] = "Sigil",
}

-- Cloaks / necks / rings / trinkets
local WILDCARD_SLOTS = {
    INVTYPE_CLOAK = true,
    INVTYPE_NECK = true,
    INVTYPE_FINGER = true,
    INVTYPE_TRINKET = true,
}

-- Held-in-off-hand frills — all classes can equip in WotLK
local OFFHAND_SLOTS = {
    INVTYPE_HOLDABLE = true,
}

local MAX_ROUTE_SLOTS = 5
local SLOT_LABELS = { "1st", "2nd", "3rd", "4th", "5th" }

-- Route buckets with dedicated recipient dropdowns
local ROUTE_KEYS = {
    "Cloth", "Leather", "Mail", "Plate",
    "Wildcard", "Offhand", "Shield", "Lockbox",
}

local DEFAULT_PRIORITY = {
    "Cloth", "Leather", "Mail", "Plate",
    "Wildcard", "Offhand", "Shield", "Lockbox",
}

local CATEGORY_ORDER = {
    "Wildcard", "Offhand", "Lockbox",
    "Cloth", "Leather", "Mail", "Plate", "Shield",
    "Libram", "Idol", "Totem", "Sigil",
    "1H Axe", "1H Mace", "1H Sword",
    "2H Axe", "2H Mace", "2H Sword",
    "Polearm", "Staff", "Fist", "Dagger",
    "Bow", "Crossbow", "Gun", "Thrown", "Wand",
    "Misc",
}

local CATEGORY_SORT = {}
for i, name in ipairs(CATEGORY_ORDER) do
    CATEGORY_SORT[name] = i
end

-- =====================================================================
-- 1. STATE
-- =====================================================================
local panel
local previewItems = {}
local previewExpanded = {} -- [recipName] = true when expanded (default collapsed)
local sending = false
local stopRequested = false
local openingMail = false
local sendQueue = {}
local sendRecipient
local sendBatchIndex = 0
local sendBatchTotal = 0
local scanTip
local OPEN_DELAY = 0.35
local MAX_INBOX_ATTACH = ATTACHMENTS_MAX_RECEIVE or 16

local weaponSubNames = {}
local armorSubNames = {}
local weaponClassName
local armorClassName

local RefreshPreview
local LayoutPreview
local RefreshCharacterList
local RefreshBlacklist
local RefreshRoutes
local UpdateSendButton
local BuildPanel
local ColorClassName
local CharKey
local GetRecipientList
local IsItemSoulbound
local ScanBags
local StartSending
local StopSending
local SendNextBatch
local StartOpenAll
local ProcessOpenAll
local ClassifyItem
local ResolveRecipient
local AutoFillRoutes
local NormalizeRouteList
local GetRouteCandidates
local MatchWeaponCategory
local GetMythicTier

-- =====================================================================
-- 2. HELPERS / STYLE
-- =====================================================================
local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(CHAT_PREFIX .. msg)
end

local function EnsureDB()
    if type(HeySoulbindThisDB) ~= "table" then
        HeySoulbindThisDB = {}
    end
    if type(HeySoulbindThisDB.characters) ~= "table" then
        HeySoulbindThisDB.characters = {}
    end
    if type(HeySoulbindThisDB.blacklist) ~= "table" then
        HeySoulbindThisDB.blacklist = {}
    end
    if type(HeySoulbindThisDB.routes) ~= "table" then
        HeySoulbindThisDB.routes = {}
    end
    for routeKey, rk in pairs(HeySoulbindThisDB.routes) do
        if type(rk) == "string" then
            HeySoulbindThisDB.routes[routeKey] = (rk ~= "") and { rk } or {}
        elseif type(rk) ~= "table" then
            HeySoulbindThisDB.routes[routeKey] = {}
        end
    end
    if type(HeySoulbindThisDB.priority) ~= "table" then
        HeySoulbindThisDB.priority = {}
        for i, k in ipairs(DEFAULT_PRIORITY) do
            HeySoulbindThisDB.priority[i] = k
        end
    else
        -- Ensure all route keys exist in priority
        local have = {}
        for _, k in ipairs(HeySoulbindThisDB.priority) do
            have[k] = true
        end
        for _, k in ipairs(DEFAULT_PRIORITY) do
            if not have[k] then
                HeySoulbindThisDB.priority[#HeySoulbindThisDB.priority + 1] = k
            end
        end
    end
end

CharKey = function(name, realm)
    name = tostring(name or "")
    realm = tostring(realm or GetRealmName() or "")
    return realm .. "-" .. name
end

local function CurrentPlayerKey()
    return CharKey(UnitName("player"), GetRealmName())
end

ColorClassName = function(name, classFile)
    local hex = CLASS_COLORS[classFile] or "FFFFFF"
    return "|cff" .. hex .. (name or "?") .. "|r"
end

local function GetItemIDFromLink(link)
    if not link then return nil end
    local id = link:match("item:(%d+)")
    return id and tonumber(id) or nil
end

local function BuildSubclassCaches()
    weaponClassName = select(1, GetAuctionItemClasses())
    armorClassName = select(2, GetAuctionItemClasses())

    wipe(weaponSubNames)
    local wSubs = { GetAuctionItemSubClasses(1) }
    for i, name in ipairs(wSubs) do
        weaponSubNames[name] = i
    end

    wipe(armorSubNames)
    local aSubs = { GetAuctionItemSubClasses(2) }
    for i, name in ipairs(aSubs) do
        armorSubNames[name] = i
    end
end

local function GetScanTooltip()
    if scanTip then return scanTip end
    scanTip = CreateFrame("GameTooltip", "HeySoulbindThisScanTooltip", nil, "GameTooltipTemplate")
    scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
    return scanTip
end

local function CreateFlatButton(parent, width, height, text)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetWidth(width)
    btn:SetHeight(height)
    btn:SetBackdrop(FLAT_BG)
    btn:SetBackdropColor(0.16, 0.16, 0.16, 1)
    btn:SetBackdropBorderColor(0.55, 0.55, 0.55, 1)
    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("CENTER", 0, 0)
    fs:SetText(text or "")
    btn.text = fs
    btn:SetFontString(fs)
    btn:SetScript("OnEnter", function(self)
        if self:IsEnabled() then
            self:SetBackdropColor(0.24, 0.24, 0.24, 1)
            self:SetBackdropBorderColor(0.75, 0.75, 0.75, 1)
        end
    end)
    btn:SetScript("OnLeave", function(self)
        if self:IsEnabled() then
            self:SetBackdropColor(0.16, 0.16, 0.16, 1)
            self:SetBackdropBorderColor(0.55, 0.55, 0.55, 1)
        end
    end)
    btn:SetScript("OnMouseDown", function(self)
        if self:IsEnabled() then
            self:SetBackdropColor(0.1, 0.1, 0.1, 1)
        end
    end)
    btn:SetScript("OnMouseUp", function(self)
        if self:IsEnabled() then
            if self:IsMouseOver() then
                self:SetBackdropColor(0.24, 0.24, 0.24, 1)
            else
                self:SetBackdropColor(0.16, 0.16, 0.16, 1)
            end
        end
    end)
    local oldDisable = btn.Disable
    local oldEnable = btn.Enable
    btn.Disable = function(self)
        oldDisable(self)
        self:SetBackdropColor(0.08, 0.08, 0.08, 1)
        self:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        if self.text then self.text:SetTextColor(0.5, 0.5, 0.5) end
    end
    btn.Enable = function(self)
        oldEnable(self)
        self:SetBackdropColor(0.16, 0.16, 0.16, 1)
        self:SetBackdropBorderColor(0.55, 0.55, 0.55, 1)
        if self.text then self.text:SetTextColor(1, 1, 1) end
    end
    btn.SetText = function(self, t)
        if self.text then self.text:SetText(t) end
    end
    return btn
end

-- Shared open flat-dropdown menu (only one at a time)
local openFlatMenu

local function CloseFlatMenu()
    if openFlatMenu then
        openFlatMenu:Hide()
        openFlatMenu = nil
    end
end

-- Flat dropdown: button + popup list (no UIDropDownMenuTemplate)
local function CreateFlatDropdown(parent, width, height)
    local dd = CreateFlatButton(parent, width, height, "")
    dd.valueText = dd.text
    dd.valueText:ClearAllPoints()
    dd.valueText:SetPoint("LEFT", dd, "LEFT", 6, 0)
    dd.valueText:SetPoint("RIGHT", dd, "RIGHT", -18, 0)
    dd.valueText:SetJustifyH("LEFT")

    local arrow = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    arrow:SetPoint("RIGHT", dd, "RIGHT", -4, 0)
    arrow:SetText("v")
    dd.arrow = arrow

    -- Parent to UIParent so the list is never clipped by the panel/mailbox
    local menu = CreateFrame("Frame", nil, UIParent)
    menu:SetBackdrop(FLAT_BG)
    menu:SetBackdropColor(0.1, 0.1, 0.1, 1)
    menu:SetBackdropBorderColor(0.65, 0.65, 0.65, 1)
    menu:SetFrameStrata("TOOLTIP")
    menu:SetToplevel(true)
    menu:SetWidth(width)
    menu:Hide()
    menu.buttons = {}
    dd.menu = menu

    dd.SetLabel = function(self, text)
        self.valueText:SetText(text or "")
    end

    dd.SetBuildOptions = function(self, fn)
        self.buildOptions = fn
    end

    dd.SetOnSelect = function(self, fn)
        self.onSelect = fn
    end

    local function HideMenu()
        menu:Hide()
        if openFlatMenu == menu then
            openFlatMenu = nil
        end
    end

    dd:SetScript("OnClick", function(self)
        if menu:IsShown() then
            HideMenu()
            return
        end
        CloseFlatMenu()

        local opts = {}
        if type(self.buildOptions) == "function" then
            local ok, result = pcall(self.buildOptions)
            if ok and type(result) == "table" then
                opts = result
            else
                if not ok then
                    Print("|cffff0000Dropdown error:|r " .. tostring(result))
                end
            end
        end

        if #opts == 0 then
            opts[1] = { text = "|cff888888(none)|r", value = nil }
        end

        local y = 2
        for i, opt in ipairs(opts) do
            local optText = opt.text or "?"
            local optValue = opt.value
            local b = menu.buttons[i]
            if not b then
                b = CreateFrame("Button", nil, menu)
                b:SetHeight(20)
                local fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                fs:SetPoint("LEFT", b, "LEFT", 6, 0)
                fs:SetPoint("RIGHT", b, "RIGHT", -4, 0)
                fs:SetJustifyH("LEFT")
                fs:SetWordWrap(false)
                b.label = fs
                local hl = b:CreateTexture(nil, "BACKGROUND")
                hl:SetAllPoints(b)
                hl:SetTexture("Interface\\Buttons\\WHITE8X8")
                hl:SetVertexColor(0.3, 0.3, 0.35)
                hl:SetAlpha(0)
                b.hl = hl
                b:SetScript("OnEnter", function(btn)
                    btn.hl:SetAlpha(0.9)
                end)
                b:SetScript("OnLeave", function(btn)
                    btn.hl:SetAlpha(0)
                end)
                menu.buttons[i] = b
            end
            b:SetWidth(width - 4)
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", menu, "TOPLEFT", 2, -y)
            b.label:SetText(optText)
            b:SetScript("OnClick", function()
                if self.onSelect then
                    self.onSelect(optValue)
                end
                HideMenu()
            end)
            b:Show()
            y = y + 22
        end
        for i = #opts + 1, #menu.buttons do
            menu.buttons[i]:Hide()
        end

        menu:SetHeight(math.max(26, y + 2))
        menu:SetFrameLevel((self:GetFrameLevel() or 1) + 50)
        menu:ClearAllPoints()
        menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
        menu:Show()
        openFlatMenu = menu
    end)

    menu:SetScript("OnHide", function()
        if openFlatMenu == menu then
            openFlatMenu = nil
        end
    end)

    return dd
end

local ROUTE_AUTO_CLASSES = {
    Cloth = { MAGE = true, PRIEST = true, WARLOCK = true },
    Leather = { DRUID = true, ROGUE = true },
    Mail = { HUNTER = true, SHAMAN = true },
    Plate = { WARRIOR = true, PALADIN = true, DEATHKNIGHT = true },
    Shield = { WARRIOR = true, PALADIN = true, SHAMAN = true },
    Lockbox = { ROGUE = true },
}

AutoFillRoutes = function()
    EnsureDB()
    local list = GetRecipientList()
    if #list == 0 then return end

    local function firstMatching(classSet)
        for _, entry in ipairs(list) do
            if not classSet or classSet[entry.data.classFile] then
                return entry.key
            end
        end
        return nil
    end

    for routeKey, classSet in pairs(ROUTE_AUTO_CLASSES) do
        local candidates = NormalizeRouteList(routeKey)
        if #candidates == 0 then
            local key = firstMatching(classSet)
            if key then
                HeySoulbindThisDB.routes[routeKey] = { key }
            end
        end
    end

    for _, routeKey in ipairs({ "Wildcard", "Offhand" }) do
        local candidates = NormalizeRouteList(routeKey)
        if #candidates == 0 then
            HeySoulbindThisDB.routes[routeKey] = { list[1].key }
        end
    end
end

IsItemSoulbound = function(bag, slot)
    local tip = GetScanTooltip()
    tip:ClearLines()
    tip:SetBagItem(bag, slot)
    for i = 1, tip:NumLines() do
        local left = _G["HeySoulbindThisScanTooltipTextLeft" .. i]
        local text = left and left:GetText()
        if text == ITEM_SOULBOUND or text == ITEM_BIND_QUEST then
            return true
        end
    end
    return false
end

local function IsLockbox(bag, slot, itemName)
    local name = string.lower(tostring(itemName or ""))
    if name:find("lockbox", 1, true) or name:find("strongbox", 1, true) then
        return true
    end
    local tip = GetScanTooltip()
    tip:ClearLines()
    tip:SetBagItem(bag, slot)
    for i = 1, tip:NumLines() do
        local left = _G["HeySoulbindThisScanTooltipTextLeft" .. i]
        local text = left and left:GetText()
        if text then
            local lower = string.lower(text)
            if lower:find("lockpicking", 1, true) then
                return true
            end
            if text == LOCKED or lower == "locked" then
                return true
            end
        end
    end
    return false
end

-- =====================================================================
-- 3. CLASS / GEAR RULES
-- =====================================================================
local function CanUseArmorType(classFile, armorIndex, reqLevel)
    reqLevel = tonumber(reqLevel) or 0

    if armorIndex == ARMOR_SUB.CLOTH then
        return classFile == "MAGE" or classFile == "PRIEST" or classFile == "WARLOCK"
    end
    if armorIndex == ARMOR_SUB.LEATHER then
        if classFile == "DRUID" or classFile == "ROGUE" then return true end
        if classFile == "HUNTER" or classFile == "SHAMAN" then
            return reqLevel < 40
        end
        return false
    end
    if armorIndex == ARMOR_SUB.MAIL then
        if classFile == "HUNTER" or classFile == "SHAMAN" then return true end
        if classFile == "WARRIOR" or classFile == "PALADIN" or classFile == "DEATHKNIGHT" then
            return reqLevel < 40
        end
        return false
    end
    if armorIndex == ARMOR_SUB.PLATE then
        if classFile == "DEATHKNIGHT" then return true end
        if classFile == "WARRIOR" or classFile == "PALADIN" then
            return reqLevel >= 40
        end
        return false
    end
    if armorIndex == ARMOR_SUB.SHIELD then
        return CLASS_SHIELDS[classFile] == true
    end
    local relic = CLASS_RELICS[armorIndex]
    if relic then
        return relic[classFile] == true
    end
    return false
end

-- Match weapon subtype text robustly (auction subclass indices vary by client)
MatchWeaponCategory = function(itemSubType)
    if not itemSubType or itemSubType == "" then
        return nil
    end
    local s = string.lower(itemSubType)
    if s:find("fish", 1, true) then
        return nil
    end
    if s:find("fist", 1, true) then return "Fist" end
    if s:find("dagger", 1, true) then return "Dagger" end
    if s:find("thrown", 1, true) then return "Thrown" end
    if s:find("wand", 1, true) then return "Wand" end
    if s:find("crossbow", 1, true) then return "Crossbow" end
    if s:find("polearm", 1, true) then return "Polearm" end
    if s:find("staff", 1, true) or s:find("stave", 1, true) then return "Staff" end
    if s:find("bow", 1, true) and not s:find("cross", 1, true) then return "Bow" end
    if s:find("gun", 1, true) then return "Gun" end
    local oneHand = s:find("one%-hand") or s:find("one hand") or s:find("1h")
    local twoHand = s:find("two%-hand") or s:find("two hand") or s:find("2h")
    if s:find("axe", 1, true) then
        return twoHand and "2H Axe" or "1H Axe"
    end
    if s:find("mace", 1, true) then
        return twoHand and "2H Mace" or "1H Mace"
    end
    if s:find("sword", 1, true) then
        return twoHand and "2H Sword" or "1H Sword"
    end
    local idx = weaponSubNames[itemSubType]
    if idx and WEAPON_CATEGORY[idx] and WEAPON_CATEGORY[idx] ~= "Fishing" then
        return WEAPON_CATEGORY[idx]
    end
    return nil
end

GetMythicTier = function(bag, slot, itemName)
    local tip = GetScanTooltip()
    tip:ClearLines()
    tip:SetBagItem(bag, slot)
    for i = 1, tip:NumLines() do
        local left = _G["HeySoulbindThisScanTooltipTextLeft" .. i]
        local text = left and left:GetText()
        if text then
            local tier = text:match("[Mm]ythic%s*%+(%d+)")
                or text:match("[Mm]ythic%s*[Ll]evel%s*%+?(%d+)")
                or text:match("[Mm]ythic%s*%+?(%d+)")
                or text:match("[Uu]pgrade%s*[Ll]evel%s*:?%s*(%d+)")
            if tier then
                return tonumber(tier) or 0
            end
        end
    end
    if itemName then
        local lower = string.lower(itemName)
        if lower:find("mythic", 1, true) then
            local tier = itemName:match("%+(%d+)") or itemName:match("(%d+)")
            if tier then
                return tonumber(tier) or 0
            end
        end
    end
    return 0
end

NormalizeRouteList = function(routeKey)
    EnsureDB()
    local r = HeySoulbindThisDB.routes[routeKey]
    if type(r) == "string" and r ~= "" then
        HeySoulbindThisDB.routes[routeKey] = { r }
    elseif type(r) ~= "table" then
        HeySoulbindThisDB.routes[routeKey] = {}
    end
    -- Compact nils / empties
    local compact = {}
    for _, key in ipairs(HeySoulbindThisDB.routes[routeKey]) do
        if type(key) == "string" and key ~= "" and HeySoulbindThisDB.characters[key] then
            compact[#compact + 1] = key
        end
    end
    HeySoulbindThisDB.routes[routeKey] = compact
    return compact
end

GetRouteCandidates = function(routeKey)
    return NormalizeRouteList(routeKey)
end

local function RecipientAlreadyHas(assigned, recipKey, itemID, mythicTier)
    if not assigned[recipKey] then return false end
    if not assigned[recipKey][itemID] then return false end
    return assigned[recipKey][itemID][mythicTier] == true
end

local function MarkRecipientHas(assigned, recipKey, itemID, mythicTier)
    assigned[recipKey] = assigned[recipKey] or {}
    assigned[recipKey][itemID] = assigned[recipKey][itemID] or {}
    assigned[recipKey][itemID][mythicTier] = true
end

local function CanUseWeapon(classFile, weaponCategory)
    return CLASS_WEAPONS[classFile] and CLASS_WEAPONS[classFile][weaponCategory] or false
end

-- Returns category label, routeKey (Cloth/Weapon/etc), optional weaponIndex/relicIndex
ClassifyItem = function(bag, slot, itemName, itemType, itemSubType, reqLevel, equipLoc)
    if equipLoc == "INVTYPE_BODY" or equipLoc == "INVTYPE_TABARD"
        or equipLoc == "INVTYPE_BAG" or equipLoc == "INVTYPE_AMMO"
        or equipLoc == "INVTYPE_QUIVER" then
        return nil
    end

    if IsLockbox(bag, slot, itemName) then
        return "Lockbox", "Lockbox"
    end

    if equipLoc and WILDCARD_SLOTS[equipLoc] then
        return "Wildcard", "Wildcard"
    end

    -- Off-hand frills (tomes, orbs, lanterns)
    if equipLoc == "INVTYPE_HOLDABLE" then
        return "Offhand", "Offhand"
    end

    -- Weapons (including fist / weapon-offhand)
    local weaponCat = MatchWeaponCategory(itemSubType)
    if itemType == weaponClassName or (equipLoc == "INVTYPE_WEAPON"
        or equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND"
        or equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_RANGED"
        or equipLoc == "INVTYPE_THROWN" or equipLoc == "INVTYPE_RANGEDRIGHT") then
        if weaponCat then
            return weaponCat, "Weapon", weaponCat
        end
    end

    -- Weapon-offhand with no recognized weapon subtype = offhand frill
    if equipLoc == "INVTYPE_WEAPONOFFHAND" then
        return "Offhand", "Offhand"
    end

    if itemType == armorClassName or (itemType and armorClassName and itemType == armorClassName) then
        local idx = armorSubNames[itemSubType]
        if not idx then
            -- Fallback: subtype text
            local s = string.lower(tostring(itemSubType or ""))
            if s:find("shield", 1, true) then
                return "Shield", "Shield"
            end
            if s == "miscellaneous" or s == "misc" then
                if equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
                    return "Offhand", "Offhand"
                end
            end
            return nil
        end

        if idx == ARMOR_SUB.SHIELD then
            return "Shield", "Shield"
        end
        if CLASS_RELICS[idx] then
            return ARMOR_CATEGORY[idx], "Relic", nil, idx
        end
        if idx == ARMOR_SUB.CLOTH or idx == ARMOR_SUB.LEATHER
            or idx == ARMOR_SUB.MAIL or idx == ARMOR_SUB.PLATE then
            return ARMOR_CATEGORY[idx], ARMOR_CATEGORY[idx]
        end
        -- Misc armor holdables
        if idx == ARMOR_SUB.MISC and (equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND") then
            return "Offhand", "Offhand"
        end
    end

    -- Last-chance offhand / fist by subtype alone
    if weaponCat == "Fist" then
        return "Fist", "Weapon", "Fist"
    end
    if equipLoc == "INVTYPE_HOLDABLE" then
        return "Offhand", "Offhand"
    end

    return nil
end

local function GetAssigneesInPriorityOrder()
    EnsureDB()
    local seen = {}
    local list = {}
    for _, routeKey in ipairs(HeySoulbindThisDB.priority) do
        for _, charKey in ipairs(GetRouteCandidates(routeKey)) do
            if not seen[charKey] then
                local data = HeySoulbindThisDB.characters[charKey]
                if data and data.name and charKey ~= CurrentPlayerKey() then
                    seen[charKey] = true
                    list[#list + 1] = { key = charKey, data = data, routeKey = routeKey }
                end
            end
        end
    end
    return list
end

-- Lower number = higher mailing priority
local function GetRecipientSortRank(recipKey, recipName)
    local assignees = GetAssigneesInPriorityOrder()
    for i, entry in ipairs(assignees) do
        if entry.key == recipKey or entry.data.name == recipName then
            return i
        end
    end
    return 999
end

local function TryCandidate(charKey, checkFn, assigned, itemID, mythicTier)
    if not charKey or charKey == CurrentPlayerKey() then
        return nil
    end
    local data = HeySoulbindThisDB.characters[charKey]
    if not data then
        return nil
    end
    if checkFn and not checkFn(data) then
        return nil
    end
    if itemID and RecipientAlreadyHas(assigned, charKey, itemID, mythicTier) then
        return nil
    end
    return charKey, data
end

-- assigned tracks itemID@mythicTier already claimed by a recipient this scan
ResolveRecipient = function(routeKey, weaponCategory, relicIndex, reqLevel, category, itemID, mythicTier, assigned)
    EnsureDB()
    assigned = assigned or {}
    mythicTier = mythicTier or 0
    local me = CurrentPlayerKey()

    local function accept(charKey, data)
        if charKey and data then
            MarkRecipientHas(assigned, charKey, itemID, mythicTier)
            return charKey, data
        end
        return nil
    end

    if routeKey == "Weapon" then
        for _, entry in ipairs(GetAssigneesInPriorityOrder()) do
            local key, data = TryCandidate(entry.key, function(d)
                return CanUseWeapon(d.classFile, weaponCategory)
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    if routeKey == "Relic" then
        local allowed = CLASS_RELICS[relicIndex]
        if not allowed then return nil end
        for _, entry in ipairs(GetAssigneesInPriorityOrder()) do
            local key, data = TryCandidate(entry.key, function(d)
                return allowed[d.classFile]
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    local function isTransitionalMailWearer(cf)
        return cf == "WARRIOR" or cf == "PALADIN" or cf == "DEATHKNIGHT"
    end

    -- Pre-40 mail: prefer plate-route backups (warr/pala/dk), then mail wearers
    if routeKey == "Mail" and (tonumber(reqLevel) or 0) < 40 then
        for _, charKey in ipairs(GetRouteCandidates("Plate")) do
            local key, data = TryCandidate(charKey, function(d)
                return isTransitionalMailWearer(d.classFile)
                    and CanUseArmorType(d.classFile, ARMOR_SUB.MAIL, reqLevel)
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        for _, entry in ipairs(GetAssigneesInPriorityOrder()) do
            local key, data = TryCandidate(entry.key, function(d)
                return isTransitionalMailWearer(d.classFile)
                    and CanUseArmorType(d.classFile, ARMOR_SUB.MAIL, reqLevel)
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        for _, charKey in ipairs(GetRouteCandidates("Mail")) do
            local key, data = TryCandidate(charKey, function(d)
                return CanUseArmorType(d.classFile, ARMOR_SUB.MAIL, reqLevel)
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    if routeKey == "Lockbox" then
        for _, charKey in ipairs(GetRouteCandidates("Lockbox")) do
            local key, data = TryCandidate(charKey, function(d)
                return d.classFile == "ROGUE"
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    if routeKey == "Shield" then
        for _, charKey in ipairs(GetRouteCandidates("Shield")) do
            local key, data = TryCandidate(charKey, function(d)
                return CLASS_SHIELDS[d.classFile]
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    if routeKey == "Cloth" or routeKey == "Leather" or routeKey == "Mail" or routeKey == "Plate" then
        local armorIdx = ARMOR_SUB[string.upper(routeKey)]
        for _, charKey in ipairs(GetRouteCandidates(routeKey)) do
            local key, data = TryCandidate(charKey, function(d)
                return CanUseArmorType(d.classFile, armorIdx, reqLevel)
            end, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    -- Wildcard / Offhand — any class, walk backups
    if routeKey == "Wildcard" or routeKey == "Offhand" then
        for _, charKey in ipairs(GetRouteCandidates(routeKey)) do
            local key, data = TryCandidate(charKey, nil, assigned, itemID, mythicTier)
            if key then return accept(key, data) end
        end
        return nil
    end

    for _, charKey in ipairs(GetRouteCandidates(routeKey)) do
        local key, data = TryCandidate(charKey, nil, assigned, itemID, mythicTier)
        if key then return accept(key, data) end
    end
    return nil
end

-- =====================================================================
-- 4. BAG SCANNER
-- =====================================================================
ScanBags = function()
    local results = {}
    EnsureDB()
    local assigned = {}

    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag) or 0
        for slot = 1, numSlots do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local itemID = GetItemIDFromLink(link)
                local itemName, _, quality, _, reqLevel, itemType, itemSubType, _, equipLoc = GetItemInfo(link)

                local skip = false
                if not itemID or not itemName then
                    skip = true
                elseif quality == 5 then
                    if not HeySoulbindThisDB.blacklist[itemID] then
                        HeySoulbindThisDB.blacklist[itemID] = true
                        Print("Auto-blacklisted legendary " .. link)
                    end
                    skip = true
                elseif HeySoulbindThisDB.blacklist[itemID] then
                    skip = true
                elseif IsItemSoulbound(bag, slot) then
                    skip = true
                end

                if not skip then
                    local category, routeKey, weaponCategory, relicIndex =
                        ClassifyItem(bag, slot, itemName, itemType, itemSubType, reqLevel, equipLoc)
                    if category and routeKey then
                        local mythicTier = GetMythicTier(bag, slot, itemName)
                        local recipKey, recipData = ResolveRecipient(
                            routeKey, weaponCategory, relicIndex, reqLevel, category,
                            itemID, mythicTier, assigned)
                        if recipKey and recipData then
                            results[#results + 1] = {
                                bag = bag,
                                slot = slot,
                                link = link,
                                itemID = itemID,
                                category = category,
                                routeKey = routeKey,
                                mythicTier = mythicTier,
                                recipKey = recipKey,
                                recipName = recipData.name,
                                recipClass = recipData.classFile,
                                checked = true,
                            }
                        end
                    end
                end
            end
        end
    end

    table.sort(results, function(a, b)
        local ra = GetRecipientSortRank(a.recipKey, a.recipName)
        local rb = GetRecipientSortRank(b.recipKey, b.recipName)
        if ra ~= rb then
            return ra < rb
        end
        if a.recipName ~= b.recipName then
            return (a.recipName or "") < (b.recipName or "")
        end
        local oa = CATEGORY_SORT[a.category] or 999
        local ob = CATEGORY_SORT[b.category] or 999
        if oa ~= ob then return oa < ob end
        if (a.mythicTier or 0) ~= (b.mythicTier or 0) then
            return (a.mythicTier or 0) > (b.mythicTier or 0)
        end
        return (a.link or "") < (b.link or "")
    end)

    return results
end

================================================================
-- 5. CHARACTER RECORDING
-- =====================================================================
local function RecordCurrentCharacter()
    EnsureDB()
    local name = UnitName("player")
    local realm = GetRealmName()
    if not name or not realm then return end

    local key = CharKey(name, realm)
    local localized, classFile = UnitClass("player")
    local existing = HeySoulbindThisDB.characters[key]

    if existing then
        if not existing.isManual then
            existing.name = name
            existing.realm = realm
            if not existing.classOverride then
                existing.class = localized
                existing.classFile = classFile
            end
        end
    else
        HeySoulbindThisDB.characters[key] = {
            name = name,
            realm = realm,
            class = localized,
            classFile = classFile,
            isManual = false,
            classOverride = false,
        }
    end
end

GetRecipientList = function()
    EnsureDB()
    local myName = UnitName("player")
    local myRealm = GetRealmName()
    local me = CharKey(myName, myRealm)
    local list = {}
    for key, data in pairs(HeySoulbindThisDB.characters) do
        if data and data.name then
            local sameName = (data.name == myName)
            local sameRealm = (not data.realm) or (data.realm == myRealm)
            local isSelf = (key == me) or (sameName and sameRealm)
            if not isSelf then
                list[#list + 1] = { key = key, data = data }
            end
        end
    end
    table.sort(list, function(a, b)
        return (a.data.name or "") < (b.data.name or "")
    end)
    return list
end

-- =====================================================================
-- 6. MAIL BATCH SENDING (multi-recipient queue)
-- =====================================================================
local function MailboxOpen()
    return MailFrame and MailFrame:IsShown()
end

local function ClearMailAttachments()
    ClearSendMail()
end

local function AttachItem(bag, slot, attachIndex)
    ClearCursor()
    PickupContainerItem(bag, slot)
    if CursorHasItem() then
        ClickSendMailItemButton(attachIndex)
        ClearCursor()
        return true
    end
    ClearCursor()
    return false
end

StopSending = function()
    stopRequested = true
    sending = false
    openingMail = false
    sendQueue = {}
    if panel and panel.stopBtn then
        panel.stopBtn:Disable()
    end
    UpdateSendButton()
    Print("Stopped.")
end

SendNextBatch = function()
    if stopRequested then
        sending = false
        UpdateSendButton()
        return
    end

    if not MailboxOpen() then
        sending = false
        Print("|cffff0000Mailbox closed — send cancelled.|r")
        UpdateSendButton()
        return
    end

    if #sendQueue == 0 then
        sending = false
        ClearMailAttachments()
        Print("|cff00ff00Done.|r All batches sent.")
        if panel and panel.stopBtn then
            panel.stopBtn:Disable()
        end
        UpdateSendButton()
        RefreshPreview()
        return
    end

    -- Peek recipient for this batch — keep same recipient until 12 or recipient changes
    local recipient = sendQueue[1].recipient
    local batch = {}
    while #batch < MAX_ATTACHMENTS and #sendQueue > 0 do
        if sendQueue[1].recipient ~= recipient then
            break
        end
        batch[#batch + 1] = table.remove(sendQueue, 1)
    end

    sendBatchIndex = sendBatchIndex + 1
    Print(string.format("Batch %d/%d -> %s (%d item(s))...",
        sendBatchIndex, sendBatchTotal, recipient, #batch))

    ClearMailAttachments()

    if MailFrameTab_OnClick and MailFrameTab2 then
        MailFrameTab_OnClick(MailFrameTab2, 2)
    end

    local attached = 0
    for i, entry in ipairs(batch) do
        local link = GetContainerItemLink(entry.bag, entry.slot)
        if link and GetItemIDFromLink(link) == entry.itemID then
            if AttachItem(entry.bag, entry.slot, i) then
                attached = attached + 1
            end
        end
    end

    local function ContinueAfterDelay()
        local f = CreateFrame("Frame")
        local t = 0
        f:SetScript("OnUpdate", function(self, e)
            t = t + e
            if t >= BATCH_DELAY then
                self:SetScript("OnUpdate", nil)
                SendNextBatch()
            end
        end)
    end

    if attached == 0 then
        Print("|cffff9900Batch had no attachable items — skipping.|r")
        ContinueAfterDelay()
        return
    end

    local postage = GetSendMailPrice and GetSendMailPrice() or 30
    if GetMoney() < postage then
        sending = false
        ClearMailAttachments()
        Print("|cffff0000Not enough money for postage. Send cancelled.|r")
        if panel and panel.stopBtn then
            panel.stopBtn:Disable()
        end
        UpdateSendButton()
        return
    end

    local subject = string.format("HeySoulbindThis %d/%d", sendBatchIndex, sendBatchTotal)
    if SendMailNameEditBox then SendMailNameEditBox:SetText(recipient) end
    if SendMailSubjectEditBox then SendMailSubjectEditBox:SetText(subject) end
    if SendMailBodyEditBox then SendMailBodyEditBox:SetText("") end
    SendMail(recipient, subject, "")

    local f = CreateFrame("Frame")
    local elapsed = 0
    local waiting = true
    f:RegisterEvent("MAIL_SEND_SUCCESS")
    f:RegisterEvent("MAIL_FAILED")
    f:SetScript("OnEvent", function(self, event)
        if event == "MAIL_SEND_SUCCESS" then
            waiting = false
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            self:SetScript("OnUpdate", nil)
            ContinueAfterDelay()
        elseif event == "MAIL_FAILED" then
            waiting = false
            sending = false
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            self:SetScript("OnUpdate", nil)
            Print("|cffff0000Mail failed. Remaining batches cancelled.|r")
            if panel and panel.stopBtn then
                panel.stopBtn:Disable()
            end
            UpdateSendButton()
        end
    end)
    f:SetScript("OnUpdate", function(self, e)
        elapsed = elapsed + e
        if waiting and elapsed >= 8 then
            waiting = false
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            self:SetScript("OnUpdate", nil)
            Print("|cffff9900No mail success event — continuing anyway.|r")
            SendNextBatch()
        end
    end)
end

StartSending = function()
    if sending then return end
    if not MailboxOpen() then
        Print("|cffff0000Open a mailbox first.|r")
        return
    end

    -- Build queue grouped by recipient (priority order of first appearance)
    local byRecip = {}
    local recipOrder = {}
    for _, entry in ipairs(previewItems) do
        if entry.checked and entry.recipName then
            if not byRecip[entry.recipName] then
                byRecip[entry.recipName] = {}
                recipOrder[#recipOrder + 1] = entry.recipName
            end
            byRecip[entry.recipName][#byRecip[entry.recipName] + 1] = {
                bag = entry.bag,
                slot = entry.slot,
                itemID = entry.itemID,
                recipient = entry.recipName,
            }
        end
    end

    local queue = {}
    for _, name in ipairs(recipOrder) do
        for _, item in ipairs(byRecip[name]) do
            queue[#queue + 1] = item
        end
    end

    if #queue == 0 then
        Print("|cffff9900No items selected (check Routes tab recipients).|r")
        return
    end

    sendQueue = queue
    stopRequested = false
    sending = true
    sendBatchTotal = 0
    -- Count batches
    local i = 1
    while i <= #queue do
        sendBatchTotal = sendBatchTotal + 1
        local r = queue[i].recipient
        local n = 0
        while i <= #queue and queue[i].recipient == r and n < MAX_ATTACHMENTS do
            n = n + 1
            i = i + 1
        end
    end
    sendBatchIndex = 0

    if panel and panel.stopBtn then
        panel.stopBtn:Enable()
    end
    UpdateSendButton()
    Print(string.format("Sending %d item(s) to %d recipient(s) in %d batch(es)...",
        #queue, #recipOrder, sendBatchTotal))
    SendNextBatch()
end

local function CountInboxAttachments(mailIndex)
    local n = 0
    for i = 1, MAX_INBOX_ATTACH do
        local name = GetInboxItem(mailIndex, i)
        if name then
            n = n + 1
        end
    end
    return n
end

local function ScheduleOpenAll()
    local f = CreateFrame("Frame")
    local t = 0
    f:SetScript("OnUpdate", function(self, e)
        t = t + e
        if t >= OPEN_DELAY then
            self:SetScript("OnUpdate", nil)
            ProcessOpenAll()
        end
    end)
end

-- Pick lootable mail with the fewest attachments first (faster inbox refresh)
local function FindBestOpenMail()
    local num = GetInboxNumItems() or 0
    local bestIdx, bestScore = nil, 9999
    for i = 1, num do
        local _, _, _, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(i)
        money = money or 0
        CODAmount = CODAmount or 0
        if CODAmount <= 0 then
            local attachments = CountInboxAttachments(i)
            if attachments > 0 or money > 0 then
                -- Prefer fewer attachments; money-only (0) sorts first
                local score = attachments
                if score < bestScore then
                    bestScore = score
                    bestIdx = i
                end
            else
                -- Empty mail (already looted) — delete these next-priority via score -1
                if bestScore > -1 then
                    -- Prefer deleting empties before heavy mails only if nothing lootable
                    -- handled below if bestIdx stays nil for lootable
                end
            end
        end
    end
    if bestIdx then
        return bestIdx, "loot"
    end
    -- No lootable mail — delete empty non-COD messages
    for i = 1, num do
        local _, _, _, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(i)
        money = money or 0
        CODAmount = CODAmount or 0
        if CODAmount <= 0 and money <= 0 and CountInboxAttachments(i) == 0 then
            return i, "delete"
        end
    end
    return nil
end

ProcessOpenAll = function()
    if not openingMail or stopRequested then
        openingMail = false
        UpdateSendButton()
        return
    end
    if not MailboxOpen() then
        openingMail = false
        Print("|cffff0000Mailbox closed — open-all cancelled.|r")
        UpdateSendButton()
        return
    end

    local num = GetInboxNumItems() or 0
    if num == 0 then
        openingMail = false
        Print("|cff00ff00Inbox empty.|r")
        if panel and panel.stopBtn then
            panel.stopBtn:Disable()
        end
        UpdateSendButton()
        return
    end

    local idx, mode = FindBestOpenMail()
    if not idx then
        openingMail = false
        Print("|cff00ff00Open-all finished.|r (COD mail left untouched if any)")
        if panel and panel.stopBtn then
            panel.stopBtn:Disable()
        end
        UpdateSendButton()
        return
    end

    if mode == "delete" then
        DeleteInboxItem(idx)
        ScheduleOpenAll()
        return
    end

    local _, _, _, _, money = GetInboxHeaderInfo(idx)
    money = money or 0
    if money > 0 then
        TakeInboxMoney(idx)
        ScheduleOpenAll()
        return
    end

    for attach = 1, MAX_INBOX_ATTACH do
        local name = GetInboxItem(idx, attach)
        if name then
            TakeInboxItem(idx, attach)
            ScheduleOpenAll()
            return
        end
    end

    -- Nothing left on this mail
    DeleteInboxItem(idx)
    ScheduleOpenAll()
end

StartOpenAll = function()
    if sending or openingMail then return end
    if not MailboxOpen() then
        Print("|cffff0000Open a mailbox first.|r")
        return
    end
    -- Ensure inbox tab
    if MailFrameTab_OnClick and MailFrameTab1 then
        MailFrameTab_OnClick(MailFrameTab1, 1)
    end
    stopRequested = false
    openingMail = true
    if panel and panel.stopBtn then
        panel.stopBtn:Enable()
    end
    UpdateSendButton()
    Print("Opening mail (fewest attachments first)...")
    ProcessOpenAll()
end

-- =====================================================================
-- 7. UI
-- =====================================================================
UpdateSendButton = function()
    if not panel or not panel.sendBtn then return end
    local n = 0
    local recipients = {}
    for _, entry in ipairs(previewItems) do
        if entry.checked then
            n = n + 1
            recipients[entry.recipName] = true
        end
    end
    local rc = 0
    for _ in pairs(recipients) do rc = rc + 1 end
    panel.sendBtn:SetText(string.format("Send All (%d to %d)", n, rc))
    if sending or openingMail or n == 0 then
        panel.sendBtn:Disable()
    else
        panel.sendBtn:Enable()
    end
    if panel.openAllBtn then
        if sending or openingMail then
            panel.openAllBtn:Disable()
        else
            panel.openAllBtn:Enable()
        end
    end
end

local function CreateScrollList(parent, name, width, height)
    local scroll = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
    scroll:SetWidth(width)
    scroll:SetHeight(height)
    local content = CreateFrame("Frame", name .. "Content", scroll)
    content:SetWidth(width - 20)
    content:SetHeight(1)
    scroll:SetScrollChild(content)
    scroll.content = content
    scroll.rows = {}
    return scroll
end

local function ClearRows(scroll)
    CloseFlatMenu()
    for _, row in ipairs(scroll.rows) do
        row:Hide()
        row:SetParent(nil)
    end
    wipe(scroll.rows)
end

local function CharLabel(charKey)
    local data = charKey and HeySoulbindThisDB.characters[charKey]
    if data then
        return ColorClassName(data.name, data.classFile)
    end
    return "|cff888888(none)|r"
end

local function InitSlotDropdown(dd, routeKey, slotIndex)
    local list = NormalizeRouteList(routeKey)
    dd:SetLabel(CharLabel(list[slotIndex]))
    dd:SetBuildOptions(function()
        local opts = {
            { text = "|cff888888(none)|r", value = false },
        }
        for _, entry in ipairs(GetRecipientList()) do
            opts[#opts + 1] = {
                text = ColorClassName(entry.data.name, entry.data.classFile),
                value = entry.key,
            }
        end
        return opts
    end)
    dd:SetOnSelect(function(value)
        local list = NormalizeRouteList(routeKey)
        if value == false or value == nil then
            table.remove(list, slotIndex)
        else
            list[slotIndex] = value
        end
        HeySoulbindThisDB.routes[routeKey] = list
        NormalizeRouteList(routeKey)
        RefreshRoutes()
        RefreshPreview()
    end)
end

RefreshRoutes = function()
    if not panel or not panel.routeScroll then return end
    EnsureDB()
    AutoFillRoutes()
    ClearRows(panel.routeScroll)

    local content = panel.routeScroll.content
    local y = 0

    for _, routeKey in ipairs(ROUTE_KEYS) do
        local list = NormalizeRouteList(routeKey)

        local header = CreateFrame("Frame", nil, content)
        header:SetHeight(ROW_HEIGHT)
        header:SetWidth(content:GetWidth())
        header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

        local bg = header:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(header)
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        bg:SetVertexColor(0.18, 0.18, 0.22)
        bg:SetAlpha(0.8)

        local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("LEFT", header, "LEFT", 6, 0)
        title:SetText(routeKey)

        local addBtn = CreateFlatButton(header, 22, 18, "+")
        addBtn:SetPoint("RIGHT", header, "RIGHT", -4, 0)
        addBtn:SetScript("OnClick", function()
            local list = NormalizeRouteList(routeKey)
            if #list >= MAX_ROUTE_SLOTS then
                Print("|cffff9900Max " .. MAX_ROUTE_SLOTS .. " recipients for " .. routeKey .. ".|r")
                return
            end
            local recipList = GetRecipientList()
            local pick = recipList[1] and recipList[1].key or nil
            if not pick then
                Print("|cffff0000No characters available.|r")
                return
            end
            list[#list + 1] = pick
            HeySoulbindThisDB.routes[routeKey] = list
            RefreshRoutes()
            RefreshPreview()
        end)

        panel.routeScroll.rows[#panel.routeScroll.rows + 1] = header
        y = y + ROW_HEIGHT

        if #list == 0 then
            local empty = CreateFrame("Frame", nil, content)
            empty:SetHeight(ROW_HEIGHT)
            empty:SetWidth(content:GetWidth())
            empty:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
            local fs = empty:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            fs:SetPoint("LEFT", empty, "LEFT", 20, 0)
            fs:SetText("(none - click + to add)")
            panel.routeScroll.rows[#panel.routeScroll.rows + 1] = empty
            y = y + ROW_HEIGHT
        end

        for slotIndex, charKey in ipairs(list) do
            local row = CreateFrame("Frame", nil, content)
            row:SetHeight(26)
            row:SetWidth(content:GetWidth())
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

            local slotFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            slotFS:SetPoint("LEFT", row, "LEFT", 12, 0)
            slotFS:SetWidth(36)
            slotFS:SetText(SLOT_LABELS[slotIndex] or tostring(slotIndex))

            local dd = CreateFlatDropdown(row, 160, 22)
            dd:SetPoint("LEFT", slotFS, "RIGHT", 4, 0)
            InitSlotDropdown(dd, routeKey, slotIndex)

            local rm = CreateFlatButton(row, 22, 18, "-")
            rm:SetPoint("LEFT", dd, "RIGHT", 6, 0)
            rm:SetScript("OnClick", function()
                local list = NormalizeRouteList(routeKey)
                table.remove(list, slotIndex)
                HeySoulbindThisDB.routes[routeKey] = list
                RefreshRoutes()
                RefreshPreview()
            end)

            panel.routeScroll.rows[#panel.routeScroll.rows + 1] = row
            y = y + 28
        end

        y = y + 4
    end

    content:SetHeight(math.max(1, y))

    if panel.priorityScroll then
        ClearRows(panel.priorityScroll)
        local pcontent = panel.priorityScroll.content
        local py = 0
        for i, routeKey in ipairs(HeySoulbindThisDB.priority) do
            local row = CreateFrame("Frame", nil, pcontent)
            row:SetHeight(ROW_HEIGHT + 2)
            row:SetWidth(pcontent:GetWidth())
            row:SetPoint("TOPLEFT", pcontent, "TOPLEFT", 0, -py)

            local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            fs:SetPoint("LEFT", row, "LEFT", 4, 0)
            fs:SetText(string.format("%d. %s", i, routeKey))

            local up = CreateFlatButton(row, 28, 18, "^")
            up:SetPoint("RIGHT", row, "RIGHT", -36, 0)
            up:SetScript("OnClick", function()
                if i > 1 then
                    HeySoulbindThisDB.priority[i], HeySoulbindThisDB.priority[i - 1] =
                        HeySoulbindThisDB.priority[i - 1], HeySoulbindThisDB.priority[i]
                    RefreshRoutes()
                    RefreshPreview()
                end
            end)

            local down = CreateFlatButton(row, 28, 18, "v")
            down:SetPoint("RIGHT", row, "RIGHT", -4, 0)
            down:SetScript("OnClick", function()
                if i < #HeySoulbindThisDB.priority then
                    HeySoulbindThisDB.priority[i], HeySoulbindThisDB.priority[i + 1] =
                        HeySoulbindThisDB.priority[i + 1], HeySoulbindThisDB.priority[i]
                    RefreshRoutes()
                    RefreshPreview()
                end
            end)

            panel.priorityScroll.rows[#panel.priorityScroll.rows + 1] = row
            py = py + ROW_HEIGHT + 2
        end
        pcontent:SetHeight(math.max(1, py))
    end
end

RefreshPreview = function()
    if not panel or not panel.previewScroll then return end
    previewItems = ScanBags()
    LayoutPreview()
end

LayoutPreview = function()
    if not panel or not panel.previewScroll then return end
    ClearRows(panel.previewScroll)

    local content = panel.previewScroll.content
    local y = 0
    local lastRecip = nil
    local lastCategory = nil
    local recipCounts = {}
    local recipRanks = {}

    for _, entry in ipairs(previewItems) do
        recipCounts[entry.recipName] = (recipCounts[entry.recipName] or 0) + 1
        if not recipRanks[entry.recipName] then
            recipRanks[entry.recipName] = GetRecipientSortRank(entry.recipKey, entry.recipName)
        end
    end

    for _, entry in ipairs(previewItems) do
        local expanded = previewExpanded[entry.recipName] == true

        if entry.recipName ~= lastRecip then
            lastRecip = entry.recipName
            lastCategory = nil

            local recipName = entry.recipName
            local rank = recipRanks[recipName] or 999
            local count = recipCounts[recipName] or 0

            local header = CreateFrame("Button", nil, content)
            header:SetHeight(ROW_HEIGHT + 2)
            header:SetWidth(content:GetWidth())
            header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
            header:RegisterForClicks("LeftButtonUp")

            local bg = header:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(header)
            bg:SetTexture("Interface\\Buttons\\WHITE8X8")
            bg:SetVertexColor(0.15, 0.25, 0.15)
            bg:SetAlpha(0.85)

            local twist = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            twist:SetPoint("LEFT", header, "LEFT", 4, 0)
            twist:SetWidth(14)
            twist:SetText(expanded and "-" or "+")

            local hdrFS = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            hdrFS:SetPoint("LEFT", twist, "RIGHT", 4, 0)
            local rankText = (rank < 999) and string.format("%d. ", rank) or ""
            hdrFS:SetText(string.format("%s%s  (%d)",
                rankText,
                ColorClassName(recipName, entry.recipClass),
                count))

            header:SetScript("OnClick", function()
                previewExpanded[recipName] = not previewExpanded[recipName]
                LayoutPreview()
            end)
            header:SetScript("OnEnter", function()
                bg:SetVertexColor(0.22, 0.35, 0.22)
            end)
            header:SetScript("OnLeave", function()
                bg:SetVertexColor(0.15, 0.25, 0.15)
            end)

            panel.previewScroll.rows[#panel.previewScroll.rows + 1] = header
            y = y + ROW_HEIGHT + 2
        end

        if not expanded then
            -- Collapsed: skip item/category rows for this recipient
        else
            if entry.category ~= lastCategory then
                lastCategory = entry.category
                local header = CreateFrame("Frame", nil, content)
                header:SetHeight(ROW_HEIGHT)
                header:SetWidth(content:GetWidth())
                header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

                local bg = header:CreateTexture(nil, "BACKGROUND")
                bg:SetAllPoints(header)
                bg:SetTexture("Interface\\Buttons\\WHITE8X8")
                bg:SetVertexColor(0.2, 0.2, 0.28)
                bg:SetAlpha(0.7)

                local hdrFS = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                hdrFS:SetPoint("LEFT", header, "LEFT", 14, 0)
                local catLabel = entry.category or "Other"
                if entry.mythicTier and entry.mythicTier > 0 then
                    catLabel = string.format("%s  +%d", catLabel, entry.mythicTier)
                end
                hdrFS:SetText(catLabel)

                local sectionCat = entry.category
                local sectionRecip = entry.recipName
                local hdrCB = CreateFrame("CheckButton", nil, header, "UICheckButtonTemplate")
                hdrCB:SetWidth(24)
                hdrCB:SetHeight(24)
                hdrCB:SetPoint("RIGHT", header, "RIGHT", -4, 0)
                local allChecked = true
                for _, e in ipairs(previewItems) do
                    if e.category == sectionCat and e.recipName == sectionRecip and not e.checked then
                        allChecked = false
                        break
                    end
                end
                hdrCB:SetChecked(allChecked)
                hdrCB:SetScript("OnClick", function(self)
                    local checked = self:GetChecked() and true or false
                    for _, e in ipairs(previewItems) do
                        if e.category == sectionCat and e.recipName == sectionRecip then
                            e.checked = checked
                        end
                    end
                    for _, row in ipairs(panel.previewScroll.rows) do
                        if row.entry and row.entry.category == sectionCat
                            and row.entry.recipName == sectionRecip and row.itemCB then
                            row.itemCB:SetChecked(checked)
                        end
                    end
                    UpdateSendButton()
                end)

                panel.previewScroll.rows[#panel.previewScroll.rows + 1] = header
                y = y + ROW_HEIGHT
            end

            local row = CreateFrame("Frame", nil, content)
            row:SetHeight(ROW_HEIGHT)
            row:SetWidth(content:GetWidth())
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
            row.entry = entry

            local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
            cb:SetWidth(24)
            cb:SetHeight(24)
            cb:SetPoint("LEFT", row, "LEFT", 8, 0)
            cb:SetChecked(entry.checked)
            cb:SetScript("OnClick", function(self)
                entry.checked = self:GetChecked() and true or false
                UpdateSendButton()
            end)
            row.itemCB = cb

            local linkBtn = CreateFrame("Button", nil, row)
            linkBtn:SetHeight(ROW_HEIGHT)
            linkBtn:SetWidth(320)
            linkBtn:SetPoint("LEFT", cb, "RIGHT", 2, 0)
            local linkFS = linkBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            linkFS:SetPoint("LEFT", linkBtn, "LEFT", 0, 0)
            linkFS:SetJustifyH("LEFT")
            linkFS:SetWidth(320)
            linkFS:SetWordWrap(false)
            linkFS:SetText(entry.link)
            linkBtn:SetFontString(linkFS)
            linkBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(entry.link)
                GameTooltip:Show()
            end)
            linkBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            linkBtn:SetScript("OnClick", function()
                if IsShiftKeyDown() and ChatFrameEditBox and ChatFrameEditBox:IsVisible() then
                    ChatFrameEditBox:Insert(entry.link)
                elseif IsShiftKeyDown() and ChatEdit_GetActiveWindow then
                    local edit = ChatEdit_GetActiveWindow()
                    if edit then edit:Insert(entry.link) end
                end
            end)

            local blBtn = CreateFlatButton(row, 70, 18, "Blacklist")
            blBtn:SetPoint("RIGHT", row, "RIGHT", -4, 0)
            blBtn:SetScript("OnClick", function()
                EnsureDB()
                HeySoulbindThisDB.blacklist[entry.itemID] = true
                Print("Blacklisted " .. entry.link)
                RefreshPreview()
                RefreshBlacklist()
            end)

            panel.previewScroll.rows[#panel.previewScroll.rows + 1] = row
            y = y + ROW_HEIGHT
        end
    end

    content:SetHeight(math.max(1, y))
    UpdateSendButton()

    if panel.previewStatus then
        panel.previewStatus:SetText(string.format("%d item(s) ready to send", #previewItems))
    end
end

RefreshCharacterList = function()
    if not panel or not panel.charScroll then return end
    ClearRows(panel.charScroll)
    EnsureDB()

    local content = panel.charScroll.content
    local y = 0
    local me = CurrentPlayerKey()
    local rowH = 28

    local keys = {}
    for key in pairs(HeySoulbindThisDB.characters) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local data = HeySoulbindThisDB.characters[key]
        if data then
            local row = CreateFrame("Frame", nil, content)
            row:SetHeight(rowH)
            row:SetWidth(content:GetWidth())
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

            local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            label:SetPoint("LEFT", row, "LEFT", 4, 0)
            label:SetWidth(160)
            label:SetJustifyH("LEFT")
            local suffix = (key == me) and " (you)" or (data.isManual and " (manual)" or "")
            label:SetText(ColorClassName(data.name, data.classFile) .. suffix)

            local classDD = CreateFlatDropdown(row, 130, 22)
            classDD:SetPoint("LEFT", label, "RIGHT", 8, 0)
            classDD:SetLabel(CLASS_DISPLAY[data.classFile] or data.classFile or "?")
            classDD:SetBuildOptions(function()
                local opts = {}
                for _, cf in ipairs(CLASS_ORDER) do
                    opts[#opts + 1] = {
                        text = CLASS_DISPLAY[cf],
                        value = cf,
                    }
                end
                return opts
            end)
            classDD:SetOnSelect(function(value)
                data.classFile = value
                data.class = CLASS_DISPLAY[value]
                data.classOverride = true
                classDD:SetLabel(CLASS_DISPLAY[value])
                label:SetText(ColorClassName(data.name, data.classFile) .. suffix)
                AutoFillRoutes()
                RefreshRoutes()
                RefreshPreview()
            end)

            local rm = CreateFlatButton(row, 60, 20, "Remove")
            rm:SetPoint("RIGHT", row, "RIGHT", -4, 0)
            rm:SetScript("OnClick", function()
                HeySoulbindThisDB.characters[key] = nil
                for routeKey, rk in pairs(HeySoulbindThisDB.routes) do
                    if type(rk) == "string" and rk == key then
                        HeySoulbindThisDB.routes[routeKey] = {}
                    elseif type(rk) == "table" then
                        local keep = {}
                        for _, ck in ipairs(rk) do
                            if ck ~= key then keep[#keep + 1] = ck end
                        end
                        HeySoulbindThisDB.routes[routeKey] = keep
                    end
                end
                AutoFillRoutes()
                RefreshCharacterList()
                RefreshRoutes()
                RefreshPreview()
            end)

            panel.charScroll.rows[#panel.charScroll.rows + 1] = row
            y = y + rowH + 2
        end
    end
    content:SetHeight(math.max(1, y))
end

RefreshBlacklist = function()
    if not panel or not panel.blScroll then return end
    ClearRows(panel.blScroll)
    EnsureDB()

    local content = panel.blScroll.content
    local y = 0
    local ids = {}
    for id in pairs(HeySoulbindThisDB.blacklist) do
        ids[#ids + 1] = id
    end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local _, link = GetItemInfo(id)
        local row = CreateFrame("Frame", nil, content)
        row:SetHeight(ROW_HEIGHT)
        row:SetWidth(content:GetWidth())
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

        local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("LEFT", row, "LEFT", 4, 0)
        fs:SetWidth(360)
        fs:SetJustifyH("LEFT")
        fs:SetText(link or ("item:" .. tostring(id)))

        local rm = CreateFlatButton(row, 60, 18, "Remove")
        rm:SetPoint("RIGHT", row, "RIGHT", -4, 0)
        rm:SetScript("OnClick", function()
            HeySoulbindThisDB.blacklist[id] = nil
            RefreshBlacklist()
            RefreshPreview()
        end)

        panel.blScroll.rows[#panel.blScroll.rows + 1] = row
        y = y + ROW_HEIGHT
    end
    content:SetHeight(math.max(1, y))
end

local function ShowTab(tabIndex)
    if not panel then return end
    CloseFlatMenu()
    panel.tabMail:Hide()
    panel.tabRoutes:Hide()
    panel.tabChars:Hide()
    panel.tabBlacklist:Hide()
    if tabIndex == 1 then
        panel.tabMail:Show()
        AutoFillRoutes()
        RefreshPreview()
    elseif tabIndex == 2 then
        panel.tabRoutes:Show()
        RefreshRoutes()
    elseif tabIndex == 3 then
        panel.tabChars:Show()
        RefreshCharacterList()
    else
        panel.tabBlacklist:Show()
        RefreshBlacklist()
    end
end

BuildPanel = function()
    if panel then return panel end

    panel = CreateFrame("Frame", "HeySoulbindThisFrame", UIParent)
    panel:SetWidth(PANEL_WIDTH)
    panel:SetHeight(PANEL_HEIGHT)
    panel:SetPoint("CENTER", UIParent, "CENTER", 200, 40)
    panel:SetBackdrop(FLAT_BG)
    panel:SetBackdropColor(0.08, 0.08, 0.08, 0.96)
    panel:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:SetFrameStrata("HIGH")
    panel:Hide()
    tinsert(UISpecialFrames, "HeySoulbindThisFrame")

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", panel, "TOP", 0, -10)
    title:SetText("HeySoulbindThis")

    local close = CreateFlatButton(panel, 22, 22, "X")
    close:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -6, -6)
    close:SetScript("OnClick", function() panel:Hide() end)

    local function MakeTab(text, x)
        local t = CreateFlatButton(panel, 90, 22, text)
        t:SetPoint("TOPLEFT", panel, "TOPLEFT", x, -36)
        return t
    end
    local tab1 = MakeTab("Send", 12)
    tab1:SetScript("OnClick", function() ShowTab(1) end)
    local tab2 = MakeTab("Routes", 106)
    tab2:SetWidth(80)
    tab2:SetScript("OnClick", function() ShowTab(2) end)
    local tab3 = MakeTab("Characters", 190)
    tab3:SetWidth(100)
    tab3:SetScript("OnClick", function() ShowTab(3) end)
    local tab4 = MakeTab("Blacklist", 294)
    tab4:SetWidth(90)
    tab4:SetScript("OnClick", function() ShowTab(4) end)

    -- ===== Send tab =====
    local tabMail = CreateFrame("Frame", nil, panel)
    tabMail:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -64)
    tabMail:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
    panel.tabMail = tabMail

    panel.previewStatus = tabMail:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    panel.previewStatus:SetPoint("TOPLEFT", tabMail, "TOPLEFT", 4, -4)
    panel.previewStatus:SetText("Configure Routes, then refresh")

    local refreshBtn = CreateFlatButton(tabMail, 70, 20, "Refresh")
    refreshBtn:SetPoint("TOPRIGHT", tabMail, "TOPRIGHT", -4, -2)
    refreshBtn:SetScript("OnClick", function()
        RefreshPreview()
    end)

    local headerLink = tabMail:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    headerLink:SetPoint("TOPLEFT", tabMail, "TOPLEFT", 32, -28)
    headerLink:SetText("Items grouped by recipient / type")

    panel.previewScroll = CreateScrollList(tabMail, "HeySoulbindThisPreviewScroll", 510, 360)
    panel.previewScroll:SetPoint("TOPLEFT", tabMail, "TOPLEFT", 4, -44)

    panel.sendBtn = CreateFlatButton(tabMail, 150, 24, "Send All (0 to 0)")
    panel.sendBtn:SetPoint("BOTTOMLEFT", tabMail, "BOTTOMLEFT", 4, 4)
    panel.sendBtn:SetScript("OnClick", StartSending)
    panel.sendBtn:Disable()

    panel.openAllBtn = CreateFlatButton(tabMail, 90, 24, "Open All")
    panel.openAllBtn:SetPoint("LEFT", panel.sendBtn, "RIGHT", 6, 0)
    panel.openAllBtn:SetScript("OnClick", StartOpenAll)

    panel.stopBtn = CreateFlatButton(tabMail, 60, 24, "Stop")
    panel.stopBtn:SetPoint("LEFT", panel.openAllBtn, "RIGHT", 6, 0)
    panel.stopBtn:Disable()
    panel.stopBtn:SetScript("OnClick", StopSending)

    local mailHint = tabMail:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    mailHint:SetPoint("BOTTOMRIGHT", tabMail, "BOTTOMRIGHT", -4, 8)
    mailHint:SetText("Mailbox must be open")

    -- ===== Routes tab =====
    local tabRoutes = CreateFrame("Frame", nil, panel)
    tabRoutes:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -64)
    tabRoutes:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
    tabRoutes:Hide()
    panel.tabRoutes = tabRoutes

    local routeHelp = tabRoutes:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    routeHelp:SetPoint("TOPLEFT", tabRoutes, "TOPLEFT", 4, -2)
    routeHelp:SetWidth(520)
    routeHelp:SetJustifyH("LEFT")
    routeHelp:SetText("Primary + backups per category (+/-). Duplicates of the same item at the same mythic tier go to the next backup.")

    panel.routeScroll = CreateScrollList(tabRoutes, "HeySoulbindThisRouteScroll", 280, 420)
    panel.routeScroll:SetPoint("TOPLEFT", tabRoutes, "TOPLEFT", 4, -36)

    local priLabel = tabRoutes:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    priLabel:SetPoint("TOPLEFT", tabRoutes, "TOPLEFT", 300, -36)
    priLabel:SetText("Mailing priority")

    local priHelp = tabRoutes:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    priHelp:SetPoint("TOPLEFT", priLabel, "BOTTOMLEFT", 0, -2)
    priHelp:SetWidth(220)
    priHelp:SetJustifyH("LEFT")
    priHelp:SetText("Weapons / relics pick the first matching assignee in this order (includes backups).")

    panel.priorityScroll = CreateScrollList(tabRoutes, "HeySoulbindThisPriScroll", 230, 360)
    panel.priorityScroll:SetPoint("TOPLEFT", tabRoutes, "TOPLEFT", 300, -70)

    -- ===== Characters tab =====
    local tabChars = CreateFrame("Frame", nil, panel)
    tabChars:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -64)
    tabChars:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
    tabChars:Hide()
    panel.tabChars = tabChars

    local charHelp = tabChars:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    charHelp:SetPoint("TOPLEFT", tabChars, "TOPLEFT", 4, -4)
    charHelp:SetWidth(500)
    charHelp:SetJustifyH("LEFT")
    charHelp:SetText("Characters are recorded on login. Add friends below for gift mailing.")

    panel.charScroll = CreateScrollList(tabChars, "HeySoulbindThisCharScroll", 510, 340)
    panel.charScroll:SetPoint("TOPLEFT", tabChars, "TOPLEFT", 4, -28)

    local addLabel = tabChars:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    addLabel:SetPoint("BOTTOMLEFT", tabChars, "BOTTOMLEFT", 4, 36)
    addLabel:SetText("Add:")

    local nameEdit = CreateFrame("EditBox", "HeySoulbindThisAddName", tabChars, "InputBoxTemplate")
    nameEdit:SetWidth(120)
    nameEdit:SetHeight(20)
    nameEdit:SetPoint("LEFT", addLabel, "RIGHT", 8, 0)
    nameEdit:SetAutoFocus(false)
    nameEdit:SetMaxLetters(40)

    local addClassFile = "WARRIOR"
    local addClassDD = CreateFlatDropdown(tabChars, 120, 22)
    addClassDD:SetPoint("LEFT", nameEdit, "RIGHT", 8, 0)
    addClassDD:SetLabel(CLASS_DISPLAY[addClassFile])
    addClassDD:SetBuildOptions(function()
        local opts = {}
        for _, cf in ipairs(CLASS_ORDER) do
            opts[#opts + 1] = { text = CLASS_DISPLAY[cf], value = cf }
        end
        return opts
    end)
    addClassDD:SetOnSelect(function(value)
        addClassFile = value
        addClassDD:SetLabel(CLASS_DISPLAY[value])
    end)

    local addBtn = CreateFlatButton(tabChars, 60, 22, "Add")
    addBtn:SetPoint("LEFT", addClassDD, "RIGHT", 8, 0)
    addBtn:SetScript("OnClick", function()
        local name = strtrim(nameEdit:GetText() or "")
        if name == "" then
            Print("|cffff0000Enter a character name.|r")
            return
        end
        EnsureDB()
        local realm = GetRealmName()
        local key = CharKey(name, realm)
        HeySoulbindThisDB.characters[key] = {
            name = name,
            realm = realm,
            class = CLASS_DISPLAY[addClassFile],
            classFile = addClassFile,
            isManual = true,
            classOverride = true,
        }
        nameEdit:SetText("")
        Print("Added " .. ColorClassName(name, addClassFile))
        AutoFillRoutes()
        RefreshCharacterList()
        RefreshRoutes()
        RefreshPreview()
    end)

    -- ===== Blacklist tab =====
    local tabBL = CreateFrame("Frame", nil, panel)
    tabBL:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -64)
    tabBL:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
    tabBL:Hide()
    panel.tabBlacklist = tabBL

    local blHelp = tabBL:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    blHelp:SetPoint("TOPLEFT", tabBL, "TOPLEFT", 4, -4)
    blHelp:SetText("Blacklisted items are never offered for mailing.")

    panel.blScroll = CreateScrollList(tabBL, "HeySoulbindThisBLScroll", 510, 420)
    panel.blScroll:SetPoint("TOPLEFT", tabBL, "TOPLEFT", 4, -28)

    return panel
end

local function AnchorToMailbox()
    if not panel then return end
    panel:ClearAllPoints()
    if MailFrame and MailFrame:IsShown() then
        panel:SetParent(MailFrame)
        panel:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", -8, -12)
        panel:SetFrameStrata(MailFrame:GetFrameStrata())
        panel:SetFrameLevel((MailFrame:GetFrameLevel() or 0) + 10)
    else
        panel:SetParent(UIParent)
        panel:SetPoint("CENTER", UIParent, "CENTER", 200, 40)
        panel:SetFrameStrata("HIGH")
    end
end

local function TogglePanel()
    BuildPanel()
    if panel:IsShown() then
        panel:Hide()
    else
        EnsureDB()
        BuildSubclassCaches()
        ShowTab(1)
        AnchorToMailbox()
        panel:Show()
    end
end

local function ShowPanel()
    BuildPanel()
    EnsureDB()
    BuildSubclassCaches()
    ShowTab(1)
    AnchorToMailbox()
    panel:Show()
end

-- =====================================================================
-- 8. EVENTS / SLASH
-- =====================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("MAIL_SHOW")
eventFrame:RegisterEvent("MAIL_CLOSED")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        EnsureDB()
    elseif event == "PLAYER_LOGIN" then
        EnsureDB()
        BuildSubclassCaches()
        RecordCurrentCharacter()
        AutoFillRoutes()
    elseif event == "MAIL_SHOW" then
        ShowPanel()
    elseif event == "MAIL_CLOSED" then
        if sending or openingMail then
            StopSending()
        end
        CloseFlatMenu()
        if panel then
            panel:Hide()
            panel:SetParent(UIParent)
        end
    end
end)

SLASH_HeySoulbindThis1 = "/hst"
SLASH_HeySoulbindThis2 = "/heysoulbind"
SlashCmdList["HeySoulbindThis"] = function(msg)
    msg = strtrim(string.lower(msg or ""))
    if msg == "scan" or msg == "refresh" then
        if panel and panel:IsShown() then
            RefreshPreview()
        else
            TogglePanel()
        end
    elseif msg == "stop" then
        if sending then StopSending() end
    else
        TogglePanel()
    end
end

Print("Loaded. /hst — set Routes, open mailbox, Send All.")
