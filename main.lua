--[[
    UI Library (main.lua)
    Used by wvoxu's scripts. Same API as FeatherLite, restyled: ink / parchment themes,
    serif headings, numbered sections, grain textures, slim controls.
    Themes: Midnight (default), Ember, Forest, Slate, Noir, Parchment, Sepia, Rose, Manuscript, Inkwell, Herbarium

    Credits:
      - S2kh     : FeatherLite, which this is a modified copy of  (https://github.com/S2kh/FeatherLite)
      - Eazvy    : Apple UI library, which FeatherLite is based on
      - restyle, themes and textures by wvoxu

    Usage:
      local UI = loadstring(game:HttpGet("<raw url to main.lua>"))()
      local Window = UI:Window({ Title = "...", Subtitle = "...", Logo = "W" })
]]

local FeatherLite = { Version = "2.0.0", Flags = {} }

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- body: Josefin Sans, headings: Merriweather (falls back to Builder Sans if a font isn't there)
local function familyOf(enumFont, fallback)
    local ok, family = pcall(function() return Font.fromEnum(enumFont).Family end)
    return ok and family or fallback
end
local FAMILY = familyOf(Enum.Font.JosefinSans, "rbxasset://fonts/families/BuilderSans.json")
local SERIF = familyOf(Enum.Font.Merriweather, FAMILY)
local FONTS = {
    -- one step lighter than the names say: Roblox draws text heavier than the hub's web font
    Regular = Font.new(FAMILY, Enum.FontWeight.Light),
    Medium = Font.new(FAMILY, Enum.FontWeight.Light),
    Semi = Font.new(FAMILY, Enum.FontWeight.Regular),
    Bold = Font.new(FAMILY, Enum.FontWeight.Regular),
    Serif = Font.new(SERIF, Enum.FontWeight.Light),
    SerifBold = Font.new(SERIF, Enum.FontWeight.Regular),
    SerifItalic = Font.new(SERIF, Enum.FontWeight.Light, Enum.FontStyle.Italic),
}
do
    -- cursive-looking font for the logo letter (Fondamento), falls back to the serif italic
    local ok, family = pcall(function() return Font.fromEnum(Enum.Font.Fondamento).Family end)
    FONTS.Script = ok and Font.new(family, Enum.FontWeight.Regular) or FONTS.SerifItalic
end

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end

FeatherLite.Themes = {
    Ember = {
        Window = rgb(27, 24, 21), Sidebar = rgb(31, 27, 23), Card = rgb(33, 29, 25), Field = rgb(45, 40, 35),
        Separator = rgb(52, 46, 40), Stroke = rgb(64, 57, 49), Text = rgb(236, 230, 218), SubText = rgb(150, 141, 128),
        Faint = rgb(112, 104, 93), Accent = rgb(240, 90, 48), OnAccent = rgb(255, 255, 255), Track = rgb(70, 64, 56),
        Knob = rgb(238, 232, 220), Hover = rgb(255, 255, 255), Danger = rgb(232, 82, 70),
    },
    Parchment = {
        Window = rgb(245, 240, 228), Sidebar = rgb(237, 231, 216), Card = rgb(248, 244, 234), Field = rgb(233, 227, 212),
        Separator = rgb(222, 214, 197), Stroke = rgb(205, 196, 178), Text = rgb(38, 32, 26), SubText = rgb(112, 102, 88),
        Faint = rgb(160, 150, 134), Accent = rgb(196, 64, 28), OnAccent = rgb(255, 255, 255), Track = rgb(206, 198, 180),
        Knob = rgb(252, 250, 244), Hover = rgb(0, 0, 0), Danger = rgb(190, 50, 40),
    },
    Manuscript = {
        Window = rgb(245, 240, 228), Sidebar = rgb(30, 26, 22), Card = rgb(249, 245, 235), Field = rgb(233, 227, 212),
        Separator = rgb(222, 214, 197), Stroke = rgb(205, 196, 178), Text = rgb(38, 32, 26), SubText = rgb(112, 102, 88),
        Faint = rgb(160, 150, 134), Accent = rgb(214, 72, 34), OnAccent = rgb(255, 255, 255), Track = rgb(206, 198, 180),
        Knob = rgb(252, 250, 244), Hover = rgb(0, 0, 0), Danger = rgb(190, 50, 40),
        SideText = rgb(236, 230, 218), SideSub = rgb(150, 141, 128), SideField = rgb(46, 41, 36), SideFaint = rgb(112, 104, 93),
        SideSep = rgb(54, 48, 42), SideHover = rgb(255, 255, 255), SideActive = rgb(240, 96, 54),
        Grain = 0.72, GrainColor = rgb(110, 80, 40), GrainKind = "paper",
        SideGrain = 0.95, SideGrainColor = rgb(255, 255, 255), SideGrainKind = "noise",
    },
    Midnight = {
        Window = rgb(15, 20, 34), Sidebar = rgb(18, 24, 41), Card = rgb(20, 27, 46), Field = rgb(31, 40, 64),
        Separator = rgb(34, 44, 70), Stroke = rgb(46, 58, 90), Text = rgb(232, 228, 214), SubText = rgb(140, 150, 176),
        Faint = rgb(96, 106, 134), Accent = rgb(226, 184, 96), OnAccent = rgb(20, 16, 6), Track = rgb(52, 64, 96),
        Knob = rgb(240, 234, 218), Hover = rgb(255, 255, 255), Danger = rgb(232, 100, 90),
        Grain = 0.95, GrainColor = rgb(255, 255, 255),
    },
    Forest = {
        Window = rgb(18, 26, 21), Sidebar = rgb(21, 31, 25), Card = rgb(23, 34, 27), Field = rgb(33, 48, 38),
        Separator = rgb(38, 54, 43), Stroke = rgb(50, 70, 56), Text = rgb(230, 232, 214), SubText = rgb(140, 156, 132),
        Faint = rgb(98, 114, 92), Accent = rgb(226, 160, 60), OnAccent = rgb(24, 14, 0), Track = rgb(52, 72, 58),
        Knob = rgb(236, 238, 222), Hover = rgb(255, 255, 255), Danger = rgb(226, 90, 80),
        Grain = 0.95, GrainColor = rgb(255, 255, 255),
    },
    Noir = {
        Window = rgb(10, 10, 10), Sidebar = rgb(13, 13, 13), Card = rgb(16, 16, 16), Field = rgb(27, 27, 27),
        Separator = rgb(34, 34, 34), Stroke = rgb(48, 48, 48), Text = rgb(240, 240, 240), SubText = rgb(140, 140, 140),
        Faint = rgb(98, 98, 98), Accent = rgb(214, 40, 40), OnAccent = rgb(255, 255, 255), Track = rgb(58, 58, 58),
        Knob = rgb(240, 240, 240), Hover = rgb(255, 255, 255), Danger = rgb(240, 70, 70),
        Grain = 0.97, GrainColor = rgb(255, 255, 255),
    },
    Sepia = {
        Window = rgb(232, 218, 190), Sidebar = rgb(222, 206, 176), Card = rgb(238, 226, 200), Field = rgb(220, 204, 172),
        Separator = rgb(206, 188, 152), Stroke = rgb(188, 168, 130), Text = rgb(58, 40, 24), SubText = rgb(120, 98, 70),
        Faint = rgb(160, 138, 106), Accent = rgb(168, 62, 28), OnAccent = rgb(255, 255, 255), Track = rgb(196, 176, 138),
        Knob = rgb(250, 244, 228), Hover = rgb(0, 0, 0), Danger = rgb(170, 44, 34),
        Grain = 0.7, GrainColor = rgb(110, 70, 30), GrainKind = "paper",
    },
    Rose = {
        Window = rgb(246, 232, 230), Sidebar = rgb(238, 218, 216), Card = rgb(250, 239, 237), Field = rgb(236, 216, 214),
        Separator = rgb(226, 202, 200), Stroke = rgb(210, 182, 180), Text = rgb(58, 28, 34), SubText = rgb(128, 92, 98),
        Faint = rgb(170, 138, 142), Accent = rgb(140, 28, 58), OnAccent = rgb(255, 255, 255), Track = rgb(214, 190, 190),
        Knob = rgb(255, 250, 250), Hover = rgb(0, 0, 0), Danger = rgb(176, 30, 50),
        Grain = 0.74, GrainColor = rgb(120, 60, 70), GrainKind = "paper",
    },
    Slate = {
        Window = rgb(28, 32, 36), Sidebar = rgb(32, 37, 42), Card = rgb(35, 41, 46), Field = rgb(46, 54, 60),
        Separator = rgb(52, 60, 66), Stroke = rgb(66, 76, 84), Text = rgb(226, 232, 236), SubText = rgb(140, 152, 160),
        Faint = rgb(100, 112, 120), Accent = rgb(45, 190, 176), OnAccent = rgb(0, 24, 22), Track = rgb(64, 74, 82),
        Knob = rgb(232, 238, 242), Hover = rgb(255, 255, 255), Danger = rgb(232, 90, 90),
        Grain = 0.96, GrainColor = rgb(255, 255, 255),
    },
    Inkwell = {
        Window = rgb(245, 240, 228), Sidebar = rgb(18, 26, 46), Card = rgb(249, 245, 235), Field = rgb(233, 227, 212),
        Separator = rgb(222, 214, 197), Stroke = rgb(205, 196, 178), Text = rgb(38, 32, 26), SubText = rgb(112, 102, 88),
        Faint = rgb(160, 150, 134), Accent = rgb(176, 120, 28), OnAccent = rgb(255, 255, 255), Track = rgb(206, 198, 180),
        Knob = rgb(252, 250, 244), Hover = rgb(0, 0, 0), Danger = rgb(190, 50, 40),
        SideText = rgb(232, 228, 214), SideSub = rgb(140, 150, 176), SideField = rgb(30, 40, 66), SideFaint = rgb(96, 106, 134),
        SideSep = rgb(34, 46, 74), SideHover = rgb(255, 255, 255), SideActive = rgb(226, 184, 96),
        Grain = 0.72, GrainColor = rgb(110, 80, 40), GrainKind = "paper",
        SideGrain = 0.95, SideGrainColor = rgb(255, 255, 255), SideGrainKind = "noise",
    },
    Herbarium = {
        Window = rgb(238, 242, 230), Sidebar = rgb(22, 34, 26), Card = rgb(243, 246, 236), Field = rgb(224, 230, 214),
        Separator = rgb(208, 216, 196), Stroke = rgb(188, 198, 174), Text = rgb(30, 38, 28), SubText = rgb(96, 110, 90),
        Faint = rgb(146, 160, 138), Accent = rgb(150, 94, 20), OnAccent = rgb(255, 255, 255), Track = rgb(200, 210, 188),
        Knob = rgb(250, 252, 246), Hover = rgb(0, 0, 0), Danger = rgb(180, 46, 40),
        SideText = rgb(230, 232, 214), SideSub = rgb(140, 156, 132), SideField = rgb(34, 50, 40), SideFaint = rgb(98, 114, 92),
        SideSep = rgb(40, 56, 46), SideHover = rgb(255, 255, 255), SideActive = rgb(226, 160, 60),
        Grain = 0.72, GrainColor = rgb(60, 80, 50), GrainKind = "paper",
        SideGrain = 0.95, SideGrainColor = rgb(255, 255, 255), SideGrainKind = "noise",
    },
}
FeatherLite.Themes.Ember.Grain = 0.95
FeatherLite.Themes.Ember.GrainColor = rgb(255, 255, 255)
FeatherLite.Themes.Parchment.Grain = 0.72
FeatherLite.Themes.Parchment.GrainColor = rgb(110, 80, 40)
FeatherLite.Themes.Parchment.GrainKind = "paper"
-- sidebar colours default to the normal ones (Journal and Samurai set their own)
for _, t in pairs(FeatherLite.Themes) do
    t.SideText = t.SideText or t.Text
    t.SideSub = t.SideSub or t.SubText
    t.SideField = t.SideField or t.Field
    t.SideFaint = t.SideFaint or t.Faint
    t.SideSep = t.SideSep or t.Separator
    t.SideHover = t.SideHover or t.Hover
    t.SideActive = t.SideActive or t.Accent
    t.SideGrain = t.SideGrain or t.Grain
    t.SideGrainColor = t.SideGrainColor or t.GrainColor
    t.SideGrainKind = t.SideGrainKind or t.GrainKind
end
FeatherLite.ThemeOrder = {
    "Midnight", "Ember", "Forest", "Slate", "Noir",            -- dark
    "Parchment", "Sepia", "Rose",                                  -- light
    "Manuscript", "Inkwell", "Herbarium",                               -- dark sidebar, light page
}

local BADGES = {
    rgb(10, 132, 255), rgb(94, 92, 230), rgb(191, 90, 242), rgb(255, 55, 95),
    rgb(255, 159, 10), rgb(48, 209, 88), rgb(100, 210, 255), rgb(255, 69, 58),
}
local SHADOW = "rbxassetid://6015897843"
local PLUME_VANE, PLUME_SHAFT = "rbxassetid://109028262244405", "rbxassetid://124588188115353"

FeatherLite.Icons = {
    Combat = 119168694531898, Player = 127505433136549, Visuals = 84745516177083, World = 93371680357706,
    Teleport = 85674376575351, Misc = 110695217426888, Settings = 87862881290117, Config = 105363416845572,
    Search = 79488727439532,
}
local function iconFor(v)
    if type(v) == "number" then return "rbxassetid://" .. v end
    if type(v) ~= "string" or v == "" then return nil end
    for name, id in pairs(FeatherLite.Icons) do
        if string.lower(name) == string.lower(v) then return "rbxassetid://" .. id end
    end
    if string.find(v, "^rbxasset") or string.find(v, "^http") then return v end
    return nil
end
local STRIPES = { rgb(255, 150, 76), rgb(248, 112, 56), rgb(240, 90, 48), rgb(228, 74, 38), rgb(240, 90, 48), rgb(255, 128, 66) }

local function make(class, props, kids)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then inst[k] = v end
        end
    end
    if kids then
        for _, k in ipairs(kids) do k.Parent = inst end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function tw(inst, t, props, style, dir, delay)
    local tween = TweenService:Create(inst, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out, 0, false, delay or 0), props)
    tween:Play()
    return tween
end

local function corner(r) return make("UICorner", { CornerRadius = r == "full" and UDim.new(1, 0) or UDim.new(0, r) }) end
local function pad(t, r, b, l)
    return make("UIPadding", { PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l) })
end
local function list(dir, padding, props)
    local p = props or {}
    p.FillDirection = dir == "x" and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    p.Padding = UDim.new(0, padding or 0)
    p.SortOrder = Enum.SortOrder.LayoutOrder
    return make("UIListLayout", p)
end

-- the old apple rainbow. hard color stops on a gradient, kinda hacky
local function stripes()
    local keys = {}
    for i, c in ipairs(STRIPES) do
        table.insert(keys, ColorSequenceKeypoint.new((i - 1) / 6, c))
        table.insert(keys, ColorSequenceKeypoint.new(i == #STRIPES and 1 or (i / 6 - 0.001), c))
    end
    return make("UIGradient", { Color = ColorSequence.new(keys), Rotation = 90 })
end

local function safe(fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args, 1, args.n))
        if not ok then warn("[FeatherLite] " .. tostring(err)) end
    end)
end

local SHORT_KEYS = {
    LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
    LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Backquote = "`", Insert = "Ins",
    PageUp = "PgUp", PageDown = "PgDn", Delete = "Del",
}
local function keyName(k)
    if typeof(k) ~= "EnumItem" then return "None" end
    return SHORT_KEYS[k.Name] or k.Name
end
local function toKey(v)
    if typeof(v) == "EnumItem" then return v end
    if type(v) == "string" then
        local ok, k = pcall(function() return Enum.KeyCode[v] end)
        if ok then return k end
    end
    return nil
end

local function encode(v)
    local t = typeof(v)
    if t == "Color3" then return { __c = v:ToHex() } end
    if t == "EnumItem" then return { __k = v.Name } end
    if t == "table" then
        local o = {}
        for k, x in pairs(v) do o[k] = encode(x) end
        return o
    end
    return v
end
local function decode(v)
    if type(v) ~= "table" then return v end
    if v.__c then
        local ok, c = pcall(Color3.fromHex, v.__c)
        return ok and c or nil
    end
    if v.__k then return toKey(v.__k) end
    local o = {}
    for k, x in pairs(v) do o[k] = decode(x) end
    return o
end

local FS = {}
local hasFS = type(writefile) == "function" and type(readfile) == "function"
function FS.ensure(path)
    if not hasFS or type(makefolder) ~= "function" then return end
    local cur = ""
    for part in string.gmatch(path, "[^/]+") do
        cur = cur == "" and part or (cur .. "/" .. part)
        local ok, exists = pcall(function() return isfolder and isfolder(cur) end)
        if not (ok and exists) then pcall(makefolder, cur) end
    end
end
function FS.read(path)
    if not hasFS then return nil end
    local ok, res = pcall(readfile, path)
    if ok and type(res) == "string" then return res end
    return nil
end
function FS.write(path, data)
    if hasFS then pcall(writefile, path, data) end
end
function FS.delete(path)
    if type(delfile) == "function" then pcall(delfile, path) end
end
function FS.json(path)
    local raw = FS.read(path)
    if not raw then return nil end
    local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok and res or nil
end
function FS.configs(dir)
    local names = {}
    if type(listfiles) ~= "function" then return names end
    local ok, files = pcall(listfiles, dir)
    if not ok or type(files) ~= "table" then return names end
    for _, f in ipairs(files) do
        local n = string.match(f, "([^/\\]+)%.json$")
        if n then table.insert(names, n) end
    end
    table.sort(names)
    return names
end

-- Grain texture: a small noise PNG shipped inside this file. Needs writefile + getcustomasset
-- (most executors have both); without them the texture is simply left out.
local PAPER_B64 = "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"
local GRAIN_B64 = "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"
local function b64decode(data)
    if crypt and crypt.base64decode then
        local ok, out = pcall(crypt.base64decode, data)
        if ok and type(out) == "string" then return out end
    end
    if base64_decode then
        local ok, out = pcall(base64_decode, data)
        if ok and type(out) == "string" then return out end
    end
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local map = {}
    for i = 1, #alphabet do map[string.byte(alphabet, i)] = i - 1 end
    local out, n, acc = {}, 0, 0
    for i = 1, #data do
        local v = map[string.byte(data, i)]
        if v then
            acc = acc * 64 + v
            n = n + 1
            if n == 4 then
                table.insert(out, string.char(math.floor(acc / 65536) % 256, math.floor(acc / 256) % 256, acc % 256))
                n, acc = 0, 0
            end
        end
    end
    if n == 3 then
        acc = acc * 64
        table.insert(out, string.char(math.floor(acc / 65536) % 256, math.floor(acc / 256) % 256))
    elseif n == 2 then
        acc = acc * 4096
        table.insert(out, string.char(math.floor(acc / 65536) % 256))
    end
    return table.concat(out)
end

local grainAssets = {}
local function grainAsset(kind)
    kind = kind == "paper" and "paper" or "noise"
    if grainAssets[kind] ~= nil then return grainAssets[kind] or nil end
    grainAssets[kind] = false
    if not (writefile and getcustomasset) then return nil end
    pcall(function()
        if makefolder and not (isfolder and isfolder("FeatherInk")) then makefolder("FeatherInk") end
        local path = "FeatherInk/" .. kind .. "_v2.png"
        if not (isfile and isfile(path)) then
            writefile(path, b64decode(kind == "paper" and PAPER_B64 or GRAIN_B64))
        end
        grainAssets[kind] = getcustomasset(path)
    end)
    return grainAssets[kind] or nil
end

local env = (getgenv and getgenv()) or _G
env.FeatherLiteWindows = env.FeatherLiteWindows or {}
local registry = env.FeatherLiteWindows

local function parentGui(gui)
    if gethui then
        local ok, holder = pcall(gethui)
        if ok and typeof(holder) == "Instance" then
            gui.Parent = holder
            return
        end
    end
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

function FeatherLite:Window(opts)
    opts = opts or {}
    if opts.KeepPrevious ~= true then
        for i = #registry, 1, -1 do
            pcall(function() registry[i]:Unload(true) end)
        end
    end

    local title = tostring(opts.Title or "FeatherLite")
    local subtitle = opts.Subtitle and tostring(opts.Subtitle) or nil
    local folder = tostring(opts.Folder or ("FeatherLite/" .. (title:gsub("[^%w%-_ ]", ""))))
    local configDir = folder .. "/configs"
    FS.ensure(configDir)
    local prefs = FS.json(folder .. "/settings.json") or {}

    local Window = { Flags = {}, Title = title }
    FeatherLite.Flags = Window.Flags

    local conns, unloadFns, themed, hooks = {}, {}, {}, {}
    local toggles, binds, searchItems, tabs = {}, {}, {}, {}
    local alive, visible, animating = true, false, false
    local themeName = prefs.Theme or opts.Theme or "Midnight"
    if not FeatherLite.Themes[themeName] then themeName = "Midnight" end
    local theme = FeatherLite.Themes[themeName]
    local alpha = tonumber(prefs.Transparency) or 0
    local userScale = tonumber(prefs.Scale) or 1
    local menuKey = toKey(prefs.MenuKey) or opts.Key or Enum.KeyCode.RightShift
    local notifyOn = prefs.Notifications ~= false
    -- configs: autosave keeps the active config up to date, autoload loads it when the script starts
    local autoSave = prefs.AutoSave ~= false
    local autoLoad = prefs.AutoLoad ~= false
    local activeConfig = (type(prefs.Config) == "string" and prefs.Config ~= "") and prefs.Config or "Default"
    local autoSaveHalt = false
    local lastBuild = os.clock()
    local listening

    local function on(signal, fn)
        local c = signal:Connect(fn)
        table.insert(conns, c)
        return c
    end

    -- anything that changes with the theme goes through T, otherwise SetTheme misses it
    local function T(inst, map)
        table.insert(themed, { inst, map })
        for prop, role in pairs(map) do inst[prop] = theme[role] end
        return inst
    end
    local function hook(fn)
        table.insert(hooks, fn)
        fn(false)
    end

    local function mark(parent, px, props)
        local z = props and props.ZIndex or 4
        local holder = make("Frame", { Size = UDim2.fromOffset(px, px), BackgroundTransparency = 1, ZIndex = z })
        for k, v in pairs(props or {}) do holder[k] = v end
        local vane = make("ImageLabel", {
            Parent = holder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = PLUME_VANE,
            ImageColor3 = rgb(255, 255, 255), ScaleType = Enum.ScaleType.Fit, ZIndex = z,
        }, { stripes() })
        local shaft = T(make("ImageLabel", {
            Parent = holder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = PLUME_SHAFT,
            ScaleType = Enum.ScaleType.Fit, ZIndex = z + 1,
        }), { ImageColor3 = "SideText" })
        holder.Parent = parent
        return holder, vane, shaft
    end

    local function savePrefs()
        FS.write(folder .. "/settings.json", HttpService:JSONEncode({
            Theme = themeName, Transparency = alpha, Scale = userScale,
            MenuKey = menuKey.Name, Notifications = notifyOn, Float = prefs.Float,
            AutoSave = autoSave, AutoLoad = autoLoad, Config = activeConfig,
        }))
    end

    local gui = make("ScreenGui", {
        Name = "FeatherLite_" .. string.sub(HttpService:GenerateGUID(false), 1, 8),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    parentGui(gui)

    local size = opts.Size or Vector2.new(1034, 624)
    local MIN_W, MIN_H, SIDEBAR_W = 640, 420, 220
    local MOBILE = opts.Mobile
    if MOBILE == nil then MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled end
    Window.Mobile = MOBILE
    if MOBILE then
        SIDEBAR_W = 66
        MIN_W, MIN_H = 360, 240
    else
        -- small windows: opts.MinSize lowers the minimum window size, opts.SidebarWidth narrows the sidebar
        if typeof(opts.MinSize) == "Vector2" then MIN_W, MIN_H = opts.MinSize.X, opts.MinSize.Y end
        if tonumber(opts.SidebarWidth) then SIDEBAR_W = math.floor(tonumber(opts.SidebarWidth)) end
        -- Compact = true: no sidebar at all (for tiny one-page scripts). A gear button in the header
        -- opens Settings instead, and the window can't be resized.
        if opts.Compact == true then SIDEBAR_W = 0 end
    end
    local COMPACT = opts.Compact == true and not MOBILE
    local SHOW_SEARCH = opts.Search ~= false -- Search = false hides the search box (handy for one-page scripts)
    local userSized = false
    local ROW_H = MOBILE and 46 or 36

    local root = make("Frame", {
        Name = "Window", Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(size.X, size.Y),
        BackgroundTransparency = 1, Visible = false,
    })
    local fitScale = make("UIScale", { Parent = root })
    local body = make("Frame", {
        Parent = root, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    })
    local popScale = make("UIScale", { Parent = body })
    Window.Frame = body -- the visible window frame (scripts can use it to check if the cursor is over the window)
    local shadow = make("ImageLabel", {
        Parent = body, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 40, 1, 40), BackgroundTransparency = 1, Image = SHADOW,
        ImageColor3 = rgb(0, 0, 0), ImageTransparency = 0.7, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0,
    })
    local main = make("Frame", {
        Name = "Main", Parent = body, Size = UDim2.fromScale(1, 1), ClipsDescendants = true, ZIndex = 1,
    }, { corner(12) })
    T(main, { BackgroundColor3 = "Window" })
    T(make("UIStroke", { Parent = main, Transparency = 0.35, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })

    -- grain over everything, very faint (only themes that set Grain show it). The sidebar and the page
    -- get their own layer so a dark sidebar next to a light page can each have a grain that shows up.
    local function grainLayer(position, size)
        return make("ImageLabel", {
            Name = "Grain", Parent = main, Position = position, Size = size, BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(96, 96), ZIndex = 60, Visible = false,
        })
    end
    local grainSide = grainLayer(UDim2.fromOffset(0, 0), UDim2.new(0, SIDEBAR_W, 1, 0))
    local grainPage = grainLayer(UDim2.fromOffset(SIDEBAR_W, 0), UDim2.new(1, -SIDEBAR_W, 1, 0))
    local function paintGrain(layer, strength, color, kind)
        local img = strength and grainAsset(kind)
        if img then
            layer.Image = img
            layer.TileSize = kind == "paper" and UDim2.fromOffset(160, 160) or UDim2.fromOffset(96, 96)
            layer.ImageColor3 = color or rgb(255, 255, 255)
            layer.ImageTransparency = strength
            layer.Visible = true
        else
            layer.Visible = false
        end
    end
    hook(function()
        paintGrain(grainSide, theme.SideGrain, theme.SideGrainColor, theme.SideGrainKind)
        paintGrain(grainPage, theme.Grain, theme.GrainColor, theme.GrainKind)
    end)

    local function screenFit()
        local area = gui.AbsoluteSize
        if area.X < 2 or area.Y < 2 then return userScale end
        local s = math.min(userScale, (area.X - 24) / root.Size.X.Offset, (area.Y - 24) / root.Size.Y.Offset)
        return math.clamp(s, 0.35, 2)
    end
    local toastScale
    -- mobile sizing was annoying to get right, careful changing this
    local function fit()
        if MOBILE then
            local area = gui.AbsoluteSize
            local s = math.max(userScale, 0.35)
            if area.X > 2 and area.Y > 2 then
                local maxW, maxH = (area.X - 16) / s, (area.Y - 16) / s
                local w, h
                if userSized then
                    w, h = math.min(root.Size.X.Offset, maxW), math.min(root.Size.Y.Offset, maxH)
                else
                    w, h = maxW * 0.85, maxH * 0.85
                end
                w, h = math.floor(math.max(MIN_W, w)), math.floor(math.max(MIN_H, h))
                if root.Size.X.Offset ~= w or root.Size.Y.Offset ~= h then root.Size = UDim2.fromOffset(w, h) end
            end
            fitScale.Scale = s
        else
            fitScale.Scale = screenFit()
        end
        if toastScale then
            local area = gui.AbsoluteSize
            toastScale.Scale = math.clamp(math.min(1, (area.X - 32) / 320), 0.5, 1)
        end
    end
    on(gui:GetPropertyChangedSignal("AbsoluteSize"), fit)

    local sidebar = make("Frame", {
        Name = "Sidebar", Parent = main, Size = UDim2.new(0, SIDEBAR_W, 1, 0), BorderSizePixel = 0, ZIndex = 2,
    }, { corner(12) })
    T(sidebar, { BackgroundColor3 = "Sidebar" })
    if COMPACT then sidebar.Visible = false end
    local sidebarFill = make("Frame", {
        Parent = sidebar, Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0,
    })
    T(sidebarFill, { BackgroundColor3 = "Sidebar" })
    T(make("Frame", { Parent = sidebar, Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0, ZIndex = 3 }), { BackgroundColor3 = "SideSep" })

    local function applyAlpha()
        main.BackgroundTransparency = alpha
        sidebar.BackgroundTransparency = alpha
        sidebarFill.BackgroundTransparency = alpha
    end
    applyAlpha()

    local lights = make("Frame", {
        Parent = sidebar, Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(60, 14),
        BackgroundTransparency = 1, ZIndex = 4, Visible = false,
    }, { list("x", 8, { VerticalAlignment = Enum.VerticalAlignment.Center }) })
    local glyphs = {}
    local function light(color, glyph, glyphColor, order)
        local b = make("TextButton", {
            Parent = lights, Size = UDim2.fromOffset(13, 13), BackgroundColor3 = color, Text = "",
            AutoButtonColor = false, LayoutOrder = order, ZIndex = 4,
        }, { corner("full") })
        table.insert(glyphs, make("TextLabel", {
            Parent = b, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = glyph,
            FontFace = FONTS.Bold, TextSize = 11, TextColor3 = glyphColor, TextTransparency = 1, ZIndex = 5,
        }))
        return b
    end
    light(rgb(254, 188, 46), "", rgb(120, 70, 0), 1)
    light(rgb(40, 200, 64), "", rgb(0, 90, 15), 2)

    local brandMark = mark(sidebar, MOBILE and 30 or 24, {
        Position = MOBILE and UDim2.fromOffset(18, 14) or UDim2.fromOffset(16, subtitle and 20 or 18), ZIndex = 4,
    })
    if opts.Logo and tostring(opts.Logo) ~= "" then
        for _, child in ipairs(brandMark:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = false end
        end
        T(make("TextLabel", {
            Parent = brandMark, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Text = tostring(opts.Logo),
            FontFace = FONTS.Script, TextSize = MOBILE and 36 or 32, ZIndex = 6,
        }), { TextColor3 = "SideActive" })
    end
    local brandScale = make("UIScale", { Parent = brandMark })
    on(brandMark.MouseEnter, function()
        tw(brandScale, 0.3, { Scale = 1.15 }, Enum.EasingStyle.Back)
        tw(brandMark, 0.5, { Rotation = -12 }, Enum.EasingStyle.Back)
    end)
    on(brandMark.MouseLeave, function()
        tw(brandScale, 0.3, { Scale = 1 })
        tw(brandMark, 0.4, { Rotation = 0 })
    end)
    local brandTitle = T(make("TextLabel", {
        Parent = sidebar, Position = UDim2.fromOffset(48, 18), Size = UDim2.new(1, -62, 0, 20),
        BackgroundTransparency = 1, Text = title, FontFace = FONTS.SerifBold, TextSize = 15, Visible = not MOBILE,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
    }), { TextColor3 = "SideText" })
    local searchY = 52
    local brandSub
    if subtitle then
        brandSub = T(make("TextLabel", {
            Parent = sidebar, Position = UDim2.fromOffset(48, 38), Size = UDim2.new(1, -62, 0, 14),
            BackgroundTransparency = 1, Text = "\226\128\148  " .. string.upper(subtitle), FontFace = FONTS.Medium, TextSize = 11, Visible = not MOBILE,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
        }), { TextColor3 = "Accent" })
        searchY = 66
    end

    local searchField = make("Frame", {
        Parent = sidebar, Position = UDim2.fromOffset(12, searchY), Size = UDim2.new(1, -24, 0, 34), ZIndex = 4,
        Visible = not MOBILE and SHOW_SEARCH,
    }, { corner(8) })
    T(searchField, { BackgroundColor3 = "SideField" })
    local searchStroke = T(make("UIStroke", { Parent = searchField, Transparency = 1, Thickness = 1.5 }), { Color = "Accent" })
    T(make("ImageLabel", {
        Parent = searchField, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1, Image = iconFor("Search"), ScaleType = Enum.ScaleType.Fit, ZIndex = 5,
    }), { ImageColor3 = "SideSub" })
    local searchBox = make("TextBox", {
        Parent = searchField, Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -34, 1, 0),
        BackgroundTransparency = 1, Text = "", PlaceholderText = "Search", ClearTextOnFocus = false,
        FontFace = FONTS.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    })
    T(searchBox, { TextColor3 = "SideText", PlaceholderColor3 = "SideFaint" })
    on(searchBox.Focused, function() tw(searchStroke, 0.2, { Transparency = 0.2 }) end)
    on(searchBox.FocusLost, function() tw(searchStroke, 0.25, { Transparency = 1 }) end)

    local tabScroll = make("ScrollingFrame", {
        Parent = sidebar, Position = UDim2.fromOffset(0, MOBILE and 58 or (SHOW_SEARCH and searchY + 46 or searchY)),
        Size = UDim2.new(1, 0, 1, -(MOBILE and 58 or (SHOW_SEARCH and searchY + 46 or searchY)) - (MOBILE and 66 or 58)),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 4,
    })
    local highlight = make("Frame", {
        Parent = tabScroll, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 0, ROW_H),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 4,
    }, { corner(7) })
    T(highlight, { BackgroundColor3 = "SideActive" })
    T(make("Frame", {
        Parent = highlight, Position = UDim2.fromOffset(-10, 6), Size = UDim2.new(0, 3, 1, -12),
        BorderSizePixel = 0, ZIndex = 5,
    }, { corner("full") }), { BackgroundColor3 = "SideActive" })
    local tabHolder = make("Frame", {
        Parent = tabScroll, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, ZIndex = 5,
    }, { list("y", 2), pad(0, 10, 8, 10) })
    local sideItems = {}

    T(make("Frame", {
        Parent = sidebar, Position = UDim2.new(0, 12, 1, MOBILE and -62 or -56), Size = UDim2.new(1, -24, 0, 1), BorderSizePixel = 0, ZIndex = 4,
    }), { BackgroundColor3 = "SideSep" })
    local settingsRow = make("TextButton", {
        Parent = sidebar, Position = UDim2.new(0, 10, 1, MOBILE and -54 or -48), Size = UDim2.new(1, -20, 0, MOBILE and 46 or 40),
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1, ZIndex = 4,
    }, { corner(7) })
    T(settingsRow, { BackgroundColor3 = "SideActive" })
    local settingsBar = T(make("Frame", {
        Parent = settingsRow, Position = UDim2.fromOffset(-10, 6), Size = UDim2.new(0, 3, 1, -12),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 6,
    }, { corner("full") }), { BackgroundColor3 = "SideActive" })

    local content = make("Frame", {
        Parent = main, Position = UDim2.fromOffset(SIDEBAR_W, 0), Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2,
    })
    local header = make("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, ZIndex = 3 })
    local pageTitle = make("TextLabel", {
        Parent = header, Position = UDim2.fromOffset(26, 4), Size = UDim2.new(1, -52, 1, -4), BackgroundTransparency = 1,
        Text = "", FontFace = FONTS.SerifBold, TextSize = 24, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    })
    T(pageTitle, { TextColor3 = "Text" })
    local CLOSE = MOBILE and 38 or 32
    pageTitle.Size = UDim2.new(1, -(60 + CLOSE), 1, -4)
    local closeBtn = make("TextButton", {
        Parent = header, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0.5, 2),
        Size = UDim2.fromOffset(CLOSE, CLOSE), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 6,
    }, { corner("full") })
    T(make("Frame", {
        Parent = closeBtn, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(10, 2), BorderSizePixel = 0, ZIndex = 7,
    }), { BackgroundColor3 = "SubText" })
    local closeScale = make("UIScale", { Parent = closeBtn })
    local headerLine = make("Frame", {
        Parent = header, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 3,
    })
    T(headerLine, { BackgroundColor3 = "Separator" })
    local pages = make("Frame", {
        Parent = content, Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, 0, 1, -58),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2,
    })

    local grip = make("TextButton", {
        Parent = content, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3),
        Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Text = "", ZIndex = 6,
    })
    if COMPACT then grip.Visible = false end
    for i, len in ipairs({ 11, 6 }) do
        T(make("Frame", {
            Parent = grip, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(18 - (i == 1 and 7 or 4), 18 - (i == 1 and 7 or 4)),
            Size = UDim2.fromOffset(len, 1.5), Rotation = -45, BorderSizePixel = 0, ZIndex = 6,
        }), { BackgroundColor3 = "Faint" })
    end

    if MOBILE then
        grip.Size = UDim2.fromOffset(34, 34)
        for _, line in ipairs(grip:GetChildren()) do
            line.Position = UDim2.fromOffset(line.Position.X.Offset + 14, line.Position.Y.Offset + 14)
            line.Size = UDim2.fromOffset(line.Size.X.Offset + 4, 2)
        end
    end

    local function dragZone(zone)
        on(zone.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            local start, startPos = input.Position, root.Position
            local move
            move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then
                    local d = i.Position - start
                    root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
            table.insert(conns, move)
            local done
            done = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    move:Disconnect()
                    done:Disconnect()
                end
            end)
        end)
    end
    dragZone(header)
    dragZone(make("Frame", { Parent = sidebar, Size = UDim2.new(1, 0, 0, MOBILE and 56 or 42), BackgroundTransparency = 1, ZIndex = 3 }))

    local function clampSize(w, h)
        local area = gui.AbsoluteSize
        local maxW = math.max(MIN_W, (area.X - 20) / math.max(userScale, 0.35))
        local maxH = math.max(MIN_H, (area.Y - 20) / math.max(userScale, 0.35))
        return math.clamp(w, MIN_W, maxW), math.clamp(h, MIN_H, maxH)
    end
    on(grip.InputBegan, function(input)
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        local start, startSize, startPos = input.Position, root.Size, root.Position
        local move
        move = UIS.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then
                local d = (i.Position - start) / fitScale.Scale
                local w, h = clampSize(startSize.X.Offset + d.X, startSize.Y.Offset + d.Y)
                userSized = true
                root.Size = UDim2.fromOffset(w, h)
                -- window is anchored in the middle so we nudge it by half the size change. lazy but it works
                local dw, dh = (w - startSize.X.Offset) * fitScale.Scale, (h - startSize.Y.Offset) * fitScale.Scale
                root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + dw / 2, startPos.Y.Scale, startPos.Y.Offset + dh / 2)
            end
        end)
        table.insert(conns, move)
        local done
        done = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                move:Disconnect()
                done:Disconnect()
            end
        end)
    end)

    local toastHolder = make("Frame", {
        Parent = gui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, 320, 1, -32), BackgroundTransparency = 1, ZIndex = 50,
    }, { list("y", 8, { HorizontalAlignment = Enum.HorizontalAlignment.Right }) })
    toastScale = make("UIScale", { Parent = toastHolder })
    fit()
    local toastOrder = 0

    function Window:Notify(o)
        if not alive or not notifyOn then return end
        if type(o) ~= "table" then o = { Title = tostring(o) } end
        local duration = tonumber(o.Duration) or 5
        toastOrder -= 1
        local wrap = make("Frame", {
            Parent = toastHolder, Size = UDim2.new(0, 300, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = toastOrder, ZIndex = 50,
        })
        local card = make("TextButton", {
            Parent = wrap, Position = UDim2.fromOffset(340, 0), Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y, Text = "", AutoButtonColor = false, ZIndex = 51,
        }, { corner(12), pad(12, 14, 14, 18) })
        T(card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = card, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
        local bar = make("Frame", {
            Parent = card, Position = UDim2.new(0, -10, 0, 2), Size = UDim2.new(0, 3, 1, -4), BorderSizePixel = 0, ZIndex = 52,
        }, { corner("full") })
        T(bar, { BackgroundColor3 = "Accent" })
        local inner = make("Frame", {
            Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 52,
        }, { list("y", 3) })
        T(make("TextLabel", {
            Parent = inner, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = tostring(o.Title or "Notice"),
            FontFace = FONTS.Semi, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = 1, ZIndex = 52,
        }), { TextColor3 = "Text" })
        if o.Text or o.Content then
            T(make("TextLabel", {
                Parent = inner, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Text or o.Content), FontFace = FONTS.Regular, TextSize = 13, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 52,
            }), { TextColor3 = "SubText" })
        end
        local progress = make("Frame", {
            Parent = card, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, -4, 1, 10),
            Size = UDim2.new(1, 4, 0, 2), BorderSizePixel = 0, BackgroundTransparency = 0.5, ZIndex = 52,
        }, { corner("full") })
        T(progress, { BackgroundColor3 = "Accent" })
        tw(card, 0.45, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
        tw(progress, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
        local gone = false
        local function dismiss()
            if gone then return end
            gone = true
            tw(card, 0.3, { Position = UDim2.fromOffset(340, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.28, function()
                local h = wrap.AbsoluteSize.Y / math.max(toastScale.Scale, 0.01)
                wrap.AutomaticSize = Enum.AutomaticSize.None
                wrap.Size = UDim2.new(0, 300, 0, h)
                tw(wrap, 0.25, { Size = UDim2.new(0, 300, 0, 0) })
                task.delay(0.26, function() wrap:Destroy() end)
            end)
        end
        card.MouseButton1Click:Connect(dismiss)
        task.delay(duration, dismiss)
    end

    function Window:Dialog(o)
        if not alive then return end
        o = o or {}
        local overlay = make("TextButton", {
            Parent = main, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false,
            BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 1, ZIndex = 40,
        }, { corner(12) })
        tw(overlay, 0.25, { BackgroundTransparency = 0.45 })
        local card = make("Frame", {
            Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 340, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 41,
        }, { corner(14), pad(20, 20, 18, 20), list("y", 8) })
        T(card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = card, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
        local s = make("UIScale", { Parent = card, Scale = 0.85 })
        tw(s, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
        T(make("TextLabel", {
            Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = tostring(o.Title or "Are you sure?"), FontFace = FONTS.Bold, TextSize = 17, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, ZIndex = 42,
        }), { TextColor3 = "Text" })
        if o.Text then
            T(make("TextLabel", {
                Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Text), FontFace = FONTS.Regular, TextSize = 14, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 42,
            }), { TextColor3 = "SubText" })
        end
        local row = make("Frame", {
            Parent = card, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, LayoutOrder = 3, ZIndex = 42,
        }, { list("x", 8, { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom }) })
        local closed = false
        local function close(cb)
            if closed then return end
            closed = true
            tw(s, 0.18, { Scale = 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw(overlay, 0.2, { BackgroundTransparency = 1 })
            task.delay(0.16, function() card.Visible = false end)
            task.delay(0.22, function() overlay:Destroy() end)
            safe(cb)
        end
        local buttons = o.Buttons or { { Text = "OK", Primary = true } }
        for i, b in ipairs(buttons) do
            local primary = b.Primary or b.Danger
            local btn = make("TextButton", {
                Parent = row, Size = UDim2.new(0, 0, 0, 38), AutomaticSize = Enum.AutomaticSize.X, Text = tostring(b.Text or "OK"),
                FontFace = FONTS.Semi, TextSize = 15, AutoButtonColor = false, LayoutOrder = i, ZIndex = 43,
            }, { corner(9), pad(0, 20, 0, 20) })
            T(btn, { BackgroundColor3 = b.Danger and "Danger" or (primary and "Accent" or "Field"), TextColor3 = primary and "OnAccent" or "Text" })
            local bs = make("UIScale", { Parent = btn })
            btn.MouseButton1Down:Connect(function() tw(bs, 0.1, { Scale = 0.95 }) end)
            btn.MouseButton1Up:Connect(function() tw(bs, 0.15, { Scale = 1 }) end)
            btn.MouseLeave:Connect(function() tw(bs, 0.15, { Scale = 1 }) end)
            btn.MouseButton1Click:Connect(function() close(b.Callback) end)
        end
    end

    local FLOAT = MOBILE and 62 or 54
    local savedFloat = type(prefs.Float) == "table" and prefs.Float
    -- the little floating button on mobile. you can drag it around
    local pill = make("TextButton", {
        Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = savedFloat and UDim2.fromOffset(tonumber(savedFloat[1]) or 0, tonumber(savedFloat[2]) or 0) or UDim2.new(0.5, 0, 0, 60),
        Size = UDim2.fromOffset(FLOAT, FLOAT), Text = "", AutoButtonColor = false, Visible = false, ZIndex = 60,
    }, { corner("full") })
    T(pill, { BackgroundColor3 = "Card" })
    T(make("UIStroke", { Parent = pill, Transparency = 0.25, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
    make("ImageLabel", {
        Parent = pill, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 24, 1, 24), BackgroundTransparency = 1, Image = SHADOW, ImageColor3 = rgb(0, 0, 0),
        ImageTransparency = 0.75, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 59,
    })
    mark(pill, math.floor(FLOAT * 0.56), { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 61 })
    local pillScale = make("UIScale", { Parent = pill, Scale = 0 })

    local function clampFloat()
        local area = gui.AbsoluteSize
        if area.X < 2 then return end
        local c = pill.AbsolutePosition + pill.AbsoluteSize / 2
        if pill.AbsoluteSize.X < 1 then return end
        local half = FLOAT / 2 + 6
        local x = math.clamp(c.X, half, area.X - half)
        local y = math.clamp(c.Y, half, area.Y - half)
        pill.Position = UDim2.fromOffset(x, y)
    end
    on(pill.MouseEnter, function() if pillScale.Scale > 0.5 then tw(pillScale, 0.25, { Scale = 1.08 }, Enum.EasingStyle.Back) end end)
    on(pill.MouseLeave, function() if pillScale.Scale > 0.5 then tw(pillScale, 0.25, { Scale = 1 }) end end)
    on(pill.InputBegan, function(input)
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        local start, startPos, moved = input.Position, pill.Position, false
        tw(pillScale, 0.12, { Scale = 0.9 })
        local move
        move = UIS.InputChanged:Connect(function(i)
            if i == input or i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - start
                if moved or d.Magnitude > 8 then
                    moved = true
                    pill.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end
        end)
        table.insert(conns, move)
        local done
        done = input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then return end
            move:Disconnect()
            done:Disconnect()
            tw(pillScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            if moved then
                clampFloat()
                local c = pill.AbsolutePosition + pill.AbsoluteSize / 2
                prefs.Float = { math.floor(c.X), math.floor(c.Y) }
                savePrefs()
            else
                Window:Toggle(true)
            end
        end)
    end)

    local function showPill(state)
        if state then
            pill.Visible = true
            task.defer(clampFloat)
            pillScale.Scale = 0
            tw(pillScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
        else
            tw(pillScale, 0.2, { Scale = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.2, function() if visible then pill.Visible = false end end)
        end
    end

    function Window:Toggle(state, fromButton)
        if not alive or animating then return end
        if state == nil then state = not visible end
        if state == visible then return end
        visible = state
        animating = true
        if state then
            showPill(false)
            root.Visible = true
            popScale.Scale = 0.88
            shadow.ImageTransparency = 1
            tw(popScale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(shadow, 0.4, { ImageTransparency = 0.7 })
            task.delay(0.3, function() animating = false end)
        else
            searchBox:ReleaseFocus()
            tw(popScale, 0.2, { Scale = 0.88 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw(shadow, 0.18, { ImageTransparency = 1 })
            task.delay(0.2, function()
                if not visible then root.Visible = false end
                animating = false
            end)
            if MOBILE then showPill(true) end
        end
    end
    function Window:IsVisible() return visible end

    -- first person and shift lock games keep the mouse stuck in the middle, so free it while the menu is open
    local mouseSaved
    -- ask roblox's camera if it wants the mouse locked right now (first person or shift lock)
    local function loaded(m)
        if not getloadedmodules then return false end
        for _, x in ipairs(getloadedmodules()) do if x == m then return true end end
        return false
    end
    local function cameras()
        -- classic layout: PlayerScripts.PlayerModule
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if pm then
            local m = require(pm)
            if type(m) == "table" and m.GetCameras then return m:GetCameras() end
        end
        -- newer layout: StarterPlayer.PlayerModule.CameraModule, only if the game already loaded it
        local sp = game:GetService("StarterPlayer"):FindFirstChild("PlayerModule")
        local cm = sp and sp:FindFirstChild("CameraModule")
        if cm and loaded(cm) then
            local m = require(cm)
            if type(m) == "table" then return m end
        end
    end
    local function cameraWantsLock()
        local ok, res = pcall(function()
            local cams = cameras()
            local ctrl = cams and cams.activeCameraController
            if not ctrl then return nil end
            local lock = cams.activeMouseLockController
            return ctrl.inFirstPerson == true or (lock ~= nil and lock:GetIsMouseLocked() == true)
        end)
        if ok then return res end
        return nil
    end
    -- the camera can change while the menu is open, so don't put back a stale lock or a hidden cursor
    local function restoreMouse()
        if not mouseSaved then return end
        local behavior, icon = mouseSaved[1], mouseSaved[2]
        mouseSaved = nil
        local want = cameraWantsLock()
        if want == true then
            behavior = Enum.MouseBehavior.LockCenter
        elseif want == false and behavior == Enum.MouseBehavior.LockCenter then
            behavior = Enum.MouseBehavior.Default
        end
        UIS.MouseBehavior, UIS.MouseIconEnabled = behavior, icon
    end
    -- Modal frees the mouse while the menu is open (it's switched off while right mouse is held, see below)
    local modalBtn = make("TextButton", { Parent = root, Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Text = "", Modal = false, Selectable = false })
    on(RunService.RenderStepped, function()
        if visible then
            local b = UIS.MouseBehavior
            if not mouseSaved then
                mouseSaved = { b == Enum.MouseBehavior.LockCenter and b or Enum.MouseBehavior.Default, UIS.MouseIconEnabled }
            end
            -- something locked the mouse to the centre since last frame: that's what it wants after we close
            if b == Enum.MouseBehavior.LockCenter then
                mouseSaved[1] = b
                UIS.MouseBehavior = Enum.MouseBehavior.Default
            end
            -- only bring the cursor back when the camera had the mouse locked. Games that hide the real
            -- cursor on purpose draw their own, and forcing the real one on gives you two
            if not UIS.MouseIconEnabled and mouseSaved[1] == Enum.MouseBehavior.LockCenter then
                mouseSaved[2] = false
                UIS.MouseIconEnabled = true
            end
            -- Modal is what keeps the normal cursor clean while the menu is open, but it blocks camera
            -- turning, so it only drops while right mouse is held
            modalBtn.Modal = not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif mouseSaved then
            modalBtn.Modal = false
            restoreMouse()
        end
    end)

    on(closeBtn.MouseEnter, function() tw(closeScale, 0.25, { Scale = 1.1 }, Enum.EasingStyle.Back) end)
    on(closeBtn.MouseLeave, function() tw(closeScale, 0.2, { Scale = 1 }) end)
    on(closeBtn.MouseButton1Down, function() tw(closeScale, 0.1, { Scale = 0.88 }) end)
    on(closeBtn.MouseButton1Click, function()
        closeScale.Scale = 1
        Window:Toggle(false)
    end)

    on(root:GetPropertyChangedSignal("Size"), fit)

    on(UIS.InputBegan, function(input)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local k = input.KeyCode
                if k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then k = nil end
                listening(k)
            end
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Keyboard or UIS:GetFocusedTextBox() then return end
        if input.KeyCode == menuKey then
            Window:Toggle()
            return
        end
        for _, b in ipairs(binds) do
            if b.key == input.KeyCode then b.press(true) end
        end
    end)
    on(UIS.InputEnded, function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, b in ipairs(binds) do
            if b.key == input.KeyCode then b.press(false) end
        end
    end)

    -- click it, press a key. esc or backspace clears
    local function keycap(parent, key, changed, props)
        local cap = make("TextButton", {
            Parent = parent, AnchorPoint = Vector2.new(1, 0.5), Position = props and props.Position or UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X, Text = keyName(key),
            FontFace = FONTS.Medium, TextSize = 13, AutoButtonColor = false, ZIndex = 4,
        }, { corner(6), pad(0, 9, 0, 9), make("UISizeConstraint", { MinSize = Vector2.new(42, 26) }) })
        T(cap, { BackgroundColor3 = "Field", TextColor3 = "SubText" })
        local stroke = T(make("UIStroke", { Parent = cap, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local state = { key = key }
        local pulse
        function state.set(k)
            state.key = k
            cap.Text = keyName(k)
        end
        on(cap.MouseButton1Click, function()
            if listening then return end
            cap.Text = "..."
            tw(stroke, 0.2, { Color = theme.Accent, Transparency = 0 })
            pulse = TweenService:Create(cap, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { TextTransparency = 0.7 })
            pulse:Play()
            listening = function(k)
                listening = nil
                if pulse then pulse:Cancel() end
                cap.TextTransparency = 0
                tw(stroke, 0.25, { Color = theme.Separator, Transparency = 0.4 })
                local final = changed(k)
                if final ~= nil then k = final end
                state.set(k)
            end
        end)
        return cap, state
    end

    local current
    local settingsTab
    local function sideY(target)
        local y = 0
        for _, it in ipairs(sideItems) do
            if it.inst == target then return y end
            if it.inst.Visible then y += it.height + 2 end
        end
        return y
    end

    local function refreshTabColors(animate)
        for _, t in ipairs(tabs) do
            local col = (t == current) and theme.SideActive or theme.SideText
            if animate then tw(t.label, 0.25, { TextColor3 = col }) else t.label.TextColor3 = col end
            if t.icon then
                local ic = (t == current) and theme.SideActive or theme.SideSub
                if animate then tw(t.icon, 0.25, { ImageColor3 = ic }) else t.icon.ImageColor3 = ic end
            end
        end
        if settingsTab then
            local sel = current == settingsTab
            local col = sel and theme.SideActive or theme.SideText
            local ic = sel and theme.SideActive or theme.SideSub
            if animate then
                tw(settingsTab.label, 0.25, { TextColor3 = col })
                tw(settingsRow, 0.25, { BackgroundTransparency = sel and 0.88 or 1 })
                tw(settingsBar, 0.25, { BackgroundTransparency = sel and 0 or 1 })
                if settingsTab.icon then tw(settingsTab.icon, 0.25, { ImageColor3 = ic }) end
            else
                settingsTab.label.TextColor3 = col
                settingsRow.BackgroundTransparency = sel and 0.88 or 1
                settingsBar.BackgroundTransparency = sel and 0 or 1
                if settingsTab.icon then settingsTab.icon.ImageColor3 = ic end
            end
        end
    end

    local function moveHighlight(animate)
        if not current or current == settingsTab or not current.button.Visible then
            tw(highlight, 0.2, { BackgroundTransparency = 1 })
            return
        end
        local goal = UDim2.fromOffset(10, sideY(current.button))
        if animate and highlight.BackgroundTransparency < 0.99 then
            tw(highlight, 0.35, { Position = goal })
        else
            highlight.Position = goal
        end
        tw(highlight, 0.2, { BackgroundTransparency = 0.88 })
    end

    local function selectTab(tab)
        if current == tab then return end
        local old = current
        current = tab
        if old then old.page.Visible = false end
        tab.page.Visible = true
        tab.page.Position = UDim2.fromOffset(22, 0)
        tw(tab.page, 0.38, { Position = UDim2.fromOffset(0, 0) })
        for i, g in ipairs(tab.groups) do
            g.lift.PaddingTop = UDim.new(0, 14)
            tw(g.lift, 0.4, { PaddingTop = UDim.new(0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, math.min(i - 1, 6) * 0.04)
        end
        pageTitle.Text = tab.name
        pageTitle.TextTransparency = 1
        pageTitle.Position = UDim2.fromOffset(36, 4)
        tw(pageTitle, 0.3, { TextTransparency = 0, Position = UDim2.fromOffset(26, 4) })
        headerLine.BackgroundTransparency = tab.page.CanvasPosition.Y > 2 and 0 or 1
        moveHighlight(true)
        refreshTabColors(true)
    end

    local function applySearch()
        local q = string.lower(searchBox.Text)
        local function hit(s) return q == "" or string.find(string.lower(s), q, 1, true) ~= nil end
        for _, t in ipairs(tabs) do
            local tabHit = hit(t.name)
            local any = tabHit
            for _, g in ipairs(t.groups) do
                local groupHit = tabHit or hit(g.name)
                local groupAny = false
                for _, item in ipairs(g.items) do
                    local show = groupHit or hit(item.name)
                    item.row.Visible = show
                    groupAny = groupAny or show
                end
                g.frame.Visible = groupAny or (q == "")
                any = any or groupAny
            end
            t.button.Visible = any
            t.matches = any
        end
        for _, it in ipairs(sideItems) do
            if it.header then
                local show = false
                for _, t in ipairs(it.header) do show = show or t.button.Visible end
                it.inst.Visible = show
            end
        end
        if current and current ~= settingsTab and not current.matches then
            for _, t in ipairs(tabs) do
                if t.matches then selectTab(t) break end
            end
        end
        task.defer(moveHighlight, true)
    end
    on(searchBox:GetPropertyChangedSignal("Text"), applySearch)

    local groupMeta = {}
    groupMeta.__index = groupMeta

    local function makePage()
        local page = make("ScrollingFrame", {
            Parent = pages, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 3, Visible = false, ZIndex = 2,
        }, { list("y", 18), pad(4, 24, 26, 24) })
        T(page, { ScrollBarImageColor3 = "Faint" })
        on(page:GetPropertyChangedSignal("CanvasPosition"), function()
            if current and current.page == page then
                local want = page.CanvasPosition.Y > 2 and 0 or 1
                if headerLine.BackgroundTransparency ~= want then tw(headerLine, 0.2, { BackgroundTransparency = want }) end
            end
        end)
        return page
    end

    local function roman(n)
        local out = ""
        for _, p in ipairs({ { 10, "X" }, { 9, "IX" }, { 5, "V" }, { 4, "IV" }, { 1, "I" } }) do
            while n >= p[1] do
                out = out .. p[2]
                n = n - p[1]
            end
        end
        return out
    end

    local tabMeta = {}
    tabMeta.__index = function(self, key)
        if tabMeta[key] then return tabMeta[key] end
        if groupMeta[key] and key ~= "__index" then
            -- lets you do Tab:Toggle{} without making a group first
            return function(t, ...)
                if not t._auto then t._auto = t:Group(nil) end
                return groupMeta[key](t._auto, ...)
            end
        end
        return nil
    end

    function tabMeta:Group(name)
        local o = type(name) == "table" and name or { Name = name }
        local g = setmetatable({ tab = self, name = o.Name and tostring(o.Name) or "", items = {}, count = 0 }, groupMeta)
        self.order += 1
        g.frame = make("Frame", {
            Parent = self.page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = self.order, ZIndex = 2,
        }, { list("y", 7) })
        g.lift = make("UIPadding", { Parent = g.frame })
        if g.name ~= "" then
            self.titled = (self.titled or 0) + 1
            local heading = make("Frame", {
                Parent = g.frame, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 2,
            })
            local numeral = T(make("TextLabel", {
                Parent = heading, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
                Text = roman(self.titled) .. ".", FontFace = FONTS.SerifItalic, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
            }, { pad(0, 0, 0, 2) }), { TextColor3 = "Accent" })
            local nameLabel = T(make("TextLabel", {
                Parent = heading, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = g.name, FontFace = FONTS.Serif, TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
            }), { TextColor3 = "Text" })
            local rule = T(make("Frame", {
                Parent = heading, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 80, 0.5, 2),
                Size = UDim2.new(1, -80, 0, 1), BorderSizePixel = 0, ZIndex = 2,
            }), { BackgroundColor3 = "Stroke" })
            -- numeral, then the name, then a line running to the right edge
            local function lay()
                nameLabel.Position = UDim2.fromOffset(numeral.AbsoluteSize.X + 8, 0)
                local x = numeral.AbsoluteSize.X + 8 + nameLabel.AbsoluteSize.X + 10
                rule.Position = UDim2.new(0, x, 0.5, 2)
                rule.Size = UDim2.new(1, -x, 0, 1)
            end
            on(numeral:GetPropertyChangedSignal("AbsoluteSize"), lay)
            on(nameLabel:GetPropertyChangedSignal("AbsoluteSize"), lay)
            task.defer(lay)
        end
        g.card = make("Frame", {
            Parent = g.frame, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, ZIndex = 2,
        }, { corner(7), list("y", 0) })
        T(g.card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = g.card, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        if o.Description then
            T(make("TextLabel", {
                Parent = g.frame, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Description), FontFace = FONTS.Regular, TextSize = 12, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 3, ZIndex = 2,
            }, { pad(0, 4, 0, 4) }), { TextColor3 = "Faint" })
        end
        table.insert(self.groups, g)
        lastBuild = os.clock()
        return g
    end

    function Window:Tab(o)
        if type(o) ~= "table" then o = { Name = o } end
        local tab = setmetatable({ name = tostring(o.Name or "Tab"), groups = {}, order = 0 }, tabMeta)
        tab.page = makePage()
        local idx = #tabs + 1

        if not MOBILE and o.Group and o.Group ~= "" and (not tabs[#tabs] or tabs[#tabs].groupName ~= o.Group) then
            local h = make("TextLabel", {
                Parent = tabHolder, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = tostring(o.Group),
                FontFace = FONTS.Semi, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = #sideItems + 1, ZIndex = 5,
            }, { pad(0, 0, 4, 8) })
            T(h, { TextColor3 = "SideFaint" })
            table.insert(sideItems, { inst = h, height = 26, header = {} })
        end
        tab.groupName = o.Group
        local headerItem
        for i = #sideItems, 1, -1 do
            if sideItems[i].header then headerItem = sideItems[i] break end
        end
        if headerItem and o.Group then table.insert(headerItem.header, tab) end

        local btn = make("TextButton", {
            Parent = tabHolder, Size = UDim2.new(1, 0, 0, ROW_H), Text = "", AutoButtonColor = false,
            BackgroundTransparency = 1, LayoutOrder = #sideItems + 1, ZIndex = 5,
        }, { corner(7) })
        T(btn, { BackgroundColor3 = "SideHover" })
        local badge = make("Frame", {
            Parent = btn, AnchorPoint = MOBILE and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5),
            Position = MOBILE and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 7, 0.5, 0),
            Size = MOBILE and UDim2.fromOffset(32, 32) or UDim2.fromOffset(24, 24),
            BackgroundTransparency = 1, BackgroundColor3 = o.Color or BADGES[(idx - 1) % #BADGES + 1], ZIndex = 6,
        }, { corner(6) })
        local badgeScale = make("UIScale", { Parent = badge })
        local icon = iconFor(o.Icon) or iconFor(tab.name)
        if icon then
            tab.icon = make("ImageLabel", {
                Parent = badge, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = MOBILE and UDim2.fromOffset(20, 20) or UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1, Image = icon, ImageColor3 = theme.SideSub, ScaleType = Enum.ScaleType.Fit, ZIndex = 7,
            })
        else
            make("TextLabel", {
                Parent = badge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = string.upper(string.sub(tab.name, 1, 1)), FontFace = FONTS.Bold, TextSize = MOBILE and 16 or 13,
                TextColor3 = theme.SideSub, ZIndex = 7,
            })
        end
        tab.label = make("TextLabel", {
            Parent = btn, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -46, 1, 0), BackgroundTransparency = 1,
            Visible = not MOBILE, Text = tab.name, FontFace = FONTS.Medium, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = theme.SideText, ZIndex = 6,
        })
        tab.button = btn
        table.insert(sideItems, { inst = btn, height = ROW_H, tab = tab })
        table.insert(tabs, tab)

        on(btn.MouseEnter, function()
            if current ~= tab then tw(btn, 0.15, { BackgroundTransparency = 0.94 }) end
            tw(badgeScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Back)
        end)
        on(btn.MouseLeave, function()
            tw(btn, 0.2, { BackgroundTransparency = 1 })
            tw(badgeScale, 0.2, { Scale = 1 })
        end)
        on(btn.MouseButton1Click, function()
            tw(btn, 0.2, { BackgroundTransparency = 1 })
            badgeScale.Scale = 0.85
            tw(badgeScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            selectTab(tab)
        end)
        if not current or current == settingsTab and #tabs == 1 then selectTab(tab) end
        lastBuild = os.clock()
        return tab
    end

    local function register(o, obj, r)
        if r then
            function obj:SetLocked(v)
                obj.Locked = v == true
                r.lock(obj.Locked)
            end
        end
        if o.Flag then
            Window.Flags[o.Flag] = obj
        end
        lastBuild = os.clock()
    end

    local function newRow(g, o, controlWidth)
        g.count += 1
        local row = make("Frame", {
            Parent = g.card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = g.count, ZIndex = 2,
        })
        if g.count > 1 then
            T(make("Frame", {
                Parent = row, Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -16, 0, 1), BorderSizePixel = 0, ZIndex = 4,
            }), { BackgroundColor3 = "Separator" })
        end
        local hover = make("Frame", {
            Parent = row, Position = UDim2.fromOffset(4, 3), Size = UDim2.new(1, -8, 1, -6),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
        }, { corner(7) })
        T(hover, { BackgroundColor3 = "Hover" })
        local stack = make("Frame", {
            Parent = row, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, ZIndex = 3,
        }, { list("y", 0) })
        -- whole line is a button so tapping the name works too
        local line = make("TextButton", {
            Parent = stack, Size = UDim2.new(1, 0, 0, MOBILE and 54 or 46), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1, ZIndex = 3,
        }, { list("x", 12, { VerticalAlignment = Enum.VerticalAlignment.Center }), pad(8, 16, 8, 16) })
        local textBlock = make("Frame", {
            Parent = line, Size = UDim2.new(1, -(controlWidth + 12), 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 3,
        }, { list("y", 2) })
        local name = make("TextLabel", {
            Parent = textBlock, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = tostring(o.Name or o.Title or ""), FontFace = FONTS.Medium, TextSize = 15, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, ZIndex = 3,
        })
        T(name, { TextColor3 = "Text" })
        local desc
        if o.Description then
            desc = make("TextLabel", {
                Parent = textBlock, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Description), FontFace = FONTS.SerifItalic, TextSize = 11, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 3,
            })
            T(desc, { TextColor3 = "SubText" })
        end
        local ctrl = make("Frame", {
            Parent = line, Size = UDim2.fromOffset(controlWidth, 28), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 3,
        })
        local fold = make("Frame", {
            Parent = stack, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, ClipsDescendants = true,
            Visible = false, LayoutOrder = 2, ZIndex = 3,
        })
        on(row.MouseEnter, function() tw(hover, 0.15, { BackgroundTransparency = theme == FeatherLite.Themes.Parchment and 0.97 or 0.965 }) end)
        on(row.MouseLeave, function() tw(hover, 0.25, { BackgroundTransparency = 1 }) end)
        table.insert(g.items, { name = name.Text, row = row })
        local function tap(fn) on(line.MouseButton1Click, fn) end
        -- greyed out + not clickable while locked
        local veil = make("TextButton", {
            Parent = row, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false,
            BackgroundTransparency = 1, Visible = false, ZIndex = 9,
        })
        T(veil, { BackgroundColor3 = "Card" })
        local function lock(v)
            if v then
                veil.Visible = true
                tw(veil, 0.2, { BackgroundTransparency = 0.45 })
            else
                tw(veil, 0.2, { BackgroundTransparency = 1 })
                task.delay(0.21, function() if veil.BackgroundTransparency > 0.99 then veil.Visible = false end end)
            end
        end
        return { row = row, line = line, name = name, desc = desc, ctrl = ctrl, fold = fold, hover = hover, tap = tap, lock = lock }
    end

    local function openFold(r, height, state)
        if state then
            r.fold.Visible = true
            tw(r.fold, 0.32, { Size = UDim2.new(1, 0, 0, height) })
        else
            tw(r.fold, 0.25, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            task.delay(0.25, function()
                if r.fold.Size.Y.Offset < 1 then r.fold.Visible = false end
            end)
        end
    end

    local function chevron(parent, pos)
        local holder = make("Frame", {
            Parent = parent, AnchorPoint = Vector2.new(1, 0.5), Position = pos, Size = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1, ZIndex = 5,
        })
        local a = make("Frame", { Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(3, 5), Size = UDim2.fromOffset(6, 1.6), Rotation = 45, BorderSizePixel = 0, ZIndex = 5 })
        local b = make("Frame", { Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(6, 1.6), Rotation = -45, BorderSizePixel = 0, ZIndex = 5 })
        T(a, { BackgroundColor3 = "SubText" })
        T(b, { BackgroundColor3 = "SubText" })
        return function(open)
            tw(a, 0.3, { Rotation = open and -45 or 45 })
            tw(b, 0.3, { Rotation = open and 45 or -45 })
        end
    end

    function groupMeta:Toggle(o)
        o = o or {}
        local hasBind = o.Keybind ~= nil and not MOBILE
        local r = newRow(self, o, hasBind and 122 or 54)
        local value = o.Default == true
        local track = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(38, 20), Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 4,
        }, { corner("full") })
        local knob = make("Frame", {
            Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.fromOffset(14, 14), BorderSizePixel = 0, ZIndex = 5,
        }, { corner("full") })
        T(knob, { BackgroundColor3 = "Knob" })
        make("UIStroke", { Parent = knob, Color = rgb(0, 0, 0), Transparency = 0.88, Thickness = 1 })

        local function render(animate)
            local x = value and 28 or 10
            local col = value and theme.Accent or theme.Track
            if animate then
                tw(track, 0.25, { BackgroundColor3 = col }, Enum.EasingStyle.Quad)
                tw(knob, 0.12, { Size = UDim2.fromOffset(19, 14) }, Enum.EasingStyle.Quad)
                tw(knob, 0.36, { Position = UDim2.new(0, x, 0.5, 0) }, Enum.EasingStyle.Back)
                task.delay(0.12, function() tw(knob, 0.2, { Size = UDim2.fromOffset(14, 14) }, Enum.EasingStyle.Quad) end)
            else
                track.BackgroundColor3 = col
                knob.Position = UDim2.new(0, x, 0.5, 0)
            end
        end
        hook(function() render(false) end)

        local obj = { Type = "Toggle" }
        function obj:Set(v, silent)
            v = v == true
            if v == value then return end
            value = v
            render(true)
            if not silent then safe(o.Callback, value) end
        end
        function obj:Get() return value end
        function obj:Toggle() obj:Set(not value) end
        on(track.MouseButton1Click, function() obj:Toggle() end)
        r.tap(function() obj:Toggle() end)

        if hasBind then
            local entry = { key = toKey(o.Keybind) }
            local _, cap = keycap(r.ctrl, entry.key, function(k) entry.key = k end, { Position = UDim2.new(1, -62, 0.5, 0) })
            function entry.press(down)
                if not down or obj.Locked then return end
                obj:Toggle()
            end
            table.insert(binds, entry)
            function obj:SetBind(k) entry.key = toKey(k); cap.set(entry.key) end
            function obj:GetBind() return entry.key end
        end
        if value then safe(o.Callback, true) end
        table.insert(toggles, obj)
        register(o, obj, r)
        return obj
    end

    function groupMeta:Slider(o)
        o = o or {}
        local min, max = tonumber(o.Min) or 0, tonumber(o.Max) or 100
        if max <= min then max = min + 1 end
        local step = tonumber(o.Step or o.Increment) or 1
        local decimals = o.Decimals or (step < 1 and #(tostring(step):match("%.(%d+)") or "") or 0)
        local suffix = o.Suffix and tostring(o.Suffix) or ""
        local r = newRow(self, o, 266)
        local value = math.clamp(tonumber(o.Default) or min, min, max)

        local box = make("TextBox", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(56, 26), Text = "", FontFace = FONTS.Medium, TextSize = 13,
            ClearTextOnFocus = false, ZIndex = 4,
        }, { corner(6) })
        T(box, { BackgroundColor3 = "Field", TextColor3 = "Text" })
        local bar = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -80, 0.5, 0),
            Size = UDim2.fromOffset(178, 3), BorderSizePixel = 0, ZIndex = 4,
        }, { corner("full") })
        T(bar, { BackgroundColor3 = "Track" })
        local fill = make("Frame", { Parent = bar, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 5 }, { corner("full") })
        T(fill, { BackgroundColor3 = "Accent" })
        local knob = make("Frame", {
            Parent = bar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromOffset(12, 12), BorderSizePixel = 0, ZIndex = 6,
        }, { corner("full") })
        T(knob, { BackgroundColor3 = "Knob" })
        make("UIStroke", { Parent = knob, Color = rgb(0, 0, 0), Transparency = 0.82 })
        local hit = make("TextButton", {
            Parent = bar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 24, 0, 44), BackgroundTransparency = 1, Text = "", ZIndex = 7,
        })

        local function fmt(v) return string.format("%." .. decimals .. "f", v) end
        local function render(animate)
            local a = (value - min) / (max - min)
            box.Text = fmt(value) .. suffix
            if animate then
                tw(fill, 0.12, { Size = UDim2.fromScale(a, 1) }, Enum.EasingStyle.Quad)
                tw(knob, 0.12, { Position = UDim2.fromScale(a, 0.5) }, Enum.EasingStyle.Quad)
            else
                fill.Size = UDim2.fromScale(a, 1)
                knob.Position = UDim2.fromScale(a, 0.5)
            end
        end

        local obj = { Type = "Slider" }
        function obj:Set(v, silent)
            v = tonumber(v)
            if not v then render(false) return end
            v = math.clamp(min + math.floor((v - min) / step + 0.5) * step, min, max)
            v = tonumber(fmt(v))
            if v == value then render(true) return end
            value = v
            render(true)
            if not silent then safe(o.Callback, value) end
        end
        function obj:Get() return value end

        local dragging = false
        local function fromX(x)
            local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            obj:Set(min + a * (max - min))
        end
        on(hit.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            dragging = true
            tw(knob, 0.2, { Size = UDim2.fromOffset(16, 16) }, Enum.EasingStyle.Back)
            fromX(input.Position.X)
            local move
            move = UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i == input) then fromX(i.Position.X) end
            end)
            table.insert(conns, move)
            local done
            done = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    move:Disconnect()
                    done:Disconnect()
                    tw(knob, 0.2, { Size = UDim2.fromOffset(12, 12) })
                end
            end)
        end)
        on(hit.MouseEnter, function() if not dragging then tw(knob, 0.15, { Size = UDim2.fromOffset(14, 14) }) end end)
        on(hit.MouseLeave, function() if not dragging then tw(knob, 0.15, { Size = UDim2.fromOffset(12, 12) }) end end)
        on(box.Focused, function() box.Text = fmt(value) end)
        on(box.FocusLost, function()
            local n = tonumber((box.Text:gsub("[^%d%.%-]", "")))
            if n then obj:Set(n) else render(false) end
        end)
        render(false)
        if o.Default ~= nil then safe(o.Callback, value) end
        register(o, obj, r)
        return obj
    end

    function groupMeta:Dropdown(o)
        o = o or {}
        local multi = o.Multi == true
        local options = {}
        for _, v in ipairs(o.Options or o.Values or {}) do table.insert(options, tostring(v)) end
        local r = newRow(self, o, 210)
        local selected = {}
        local single
        if multi then
            for _, v in ipairs(type(o.Default) == "table" and o.Default or {}) do selected[tostring(v)] = true end
        elseif o.Default ~= nil then
            single = tostring(o.Default)
        end

        local field = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(210, 30), Text = "", AutoButtonColor = false, ZIndex = 4,
        }, { corner(7) })
        T(field, { BackgroundColor3 = "Field" })
        local fieldStroke = T(make("UIStroke", { Parent = field, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local shown = make("TextLabel", {
            Parent = field, Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -34, 1, 0), BackgroundTransparency = 1,
            Text = "", FontFace = FONTS.Regular, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
        })
        T(shown, { TextColor3 = "Text" })
        local flip = chevron(field, UDim2.new(1, -10, 0.5, 0))

        local listFrame = make("ScrollingFrame", {
            Parent = r.fold, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, -10),
            BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 2, ZIndex = 4,
        }, { list("y", 2) })
        T(listFrame, { ScrollBarImageColor3 = "Faint" })

        local obj = { Type = "Dropdown" }
        local open = false
        local optionButtons = {}
        local function isOn(v) if multi then return selected[v] == true end return single == v end
        local function display()
            if multi then
                local picked = {}
                for _, v in ipairs(options) do if selected[v] then table.insert(picked, v) end end
                shown.Text = #picked == 0 and "None" or (#picked <= 2 and table.concat(picked, ", ") or (#picked .. " selected"))
            else
                shown.Text = single or "Select"
            end
        end
        local function paint(animate)
            for v, b in pairs(optionButtons) do
                local sel = isOn(v)
                local goalText = sel and theme.Accent or theme.Text
                if animate then
                    tw(b.label, 0.2, { TextColor3 = goalText })
                    tw(b.dot, 0.3, { Size = sel and UDim2.fromOffset(7, 7) or UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
                else
                    b.label.TextColor3 = goalText
                    b.dot.Size = sel and UDim2.fromOffset(7, 7) or UDim2.fromOffset(0, 0)
                end
            end
            display()
        end
        local function foldHeight() return math.min(#options, 6) * 40 + 10 end

        local function fire()
            if multi then safe(o.Callback, obj:Get()) else safe(o.Callback, single) end
        end
        local function build()
            for _, b in pairs(optionButtons) do b.button:Destroy() end
            optionButtons = {}
            for i, v in ipairs(options) do
                local b = make("TextButton", {
                    Parent = listFrame, Size = UDim2.new(1, -4, 0, 38), Text = "", AutoButtonColor = false,
                    BackgroundTransparency = 1, LayoutOrder = i, ZIndex = 5,
                }, { corner(6) })
                T(b, { BackgroundColor3 = "Hover" })
                local label = make("TextLabel", {
                    Parent = b, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1,
                    Text = v, FontFace = FONTS.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = theme.Text, ZIndex = 6,
                })
                local dot = make("Frame", {
                    Parent = b, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -16, 0.5, 0),
                    Size = UDim2.fromOffset(0, 0), BorderSizePixel = 0, ZIndex = 6,
                }, { corner("full") })
                T(dot, { BackgroundColor3 = "Accent" })
                b.MouseEnter:Connect(function() tw(b, 0.12, { BackgroundTransparency = 0.94 }) end)
                b.MouseLeave:Connect(function() tw(b, 0.2, { BackgroundTransparency = 1 }) end)
                b.MouseButton1Click:Connect(function()
                    if multi then
                        selected[v] = not selected[v] or nil
                        paint(true)
                        fire()
                    else
                        if single ~= v then
                            single = v
                            paint(true)
                            fire()
                        end
                        obj:Close()
                    end
                end)
                optionButtons[v] = { button = b, label = label, dot = dot }
            end
            paint(false)
            if open then openFold(r, foldHeight(), true) end
        end

        function obj:Open()
            open = true
            flip(true)
            tw(fieldStroke, 0.2, { Color = theme.Accent, Transparency = 0 })
            openFold(r, foldHeight(), true)
        end
        function obj:Close()
            open = false
            flip(false)
            tw(fieldStroke, 0.2, { Color = theme.Separator, Transparency = 0.4 })
            openFold(r, 0, false)
        end
        function obj:Set(v, silent)
            if multi then
                selected = {}
                if type(v) == "table" then
                    for k, x in pairs(v) do
                        if type(k) == "number" then selected[tostring(x)] = true elseif x then selected[tostring(k)] = true end
                    end
                end
            else
                single = v ~= nil and tostring(v) or nil
            end
            paint(true)
            if not silent then fire() end
        end
        function obj:Get()
            if multi then
                local out = {}
                for _, v in ipairs(options) do if selected[v] then table.insert(out, v) end end
                return out
            end
            return single
        end
        function obj:SetOptions(newOptions, keep)
            options = {}
            for _, v in ipairs(newOptions or {}) do table.insert(options, tostring(v)) end
            if not keep then
                local valid = {}
                for _, v in ipairs(options) do valid[v] = true end
                if multi then
                    for k in pairs(selected) do if not valid[k] then selected[k] = nil end end
                elseif single and not valid[single] then
                    single = nil
                end
            end
            build()
        end
        function obj:GetOptions() return table.clone(options) end
        on(field.MouseButton1Click, function() if open then obj:Close() else obj:Open() end end)
        r.tap(function() if open then obj:Close() else obj:Open() end end)
        hook(function(animate) paint(animate == true) end)
        build()
        if (multi and next(selected)) or single then fire() end
        register(o, obj, r)
        return obj
    end

    function groupMeta:ColorPicker(o)
        o = o or {}
        local color = typeof(o.Default) == "Color3" and o.Default or Color3.new(1, 1, 1)
        local h, s, v = color:ToHSV()
        local r = newRow(self, o, 60)
        local swatch = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(56, 32), Text = "", AutoButtonColor = false, BackgroundColor3 = color, ZIndex = 4,
        }, { corner(7) })
        T(make("UIStroke", { Parent = swatch, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })

        local area = make("Frame", { Parent = r.fold, Position = UDim2.fromOffset(14, 2), Size = UDim2.new(1, -28, 0, 140), BackgroundTransparency = 1, ZIndex = 4 })
        local sv = make("TextButton", {
            Parent = area, Size = UDim2.fromOffset(190, 132), Text = "", AutoButtonColor = false, ZIndex = 4,
        }, { corner(8) })
        make("Frame", { Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 5 }, {
            corner(8), make("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
        })
        make("Frame", { Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(0, 0, 0), ZIndex = 6 }, {
            corner(8), make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }),
        })
        local svCursor = make("Frame", {
            Parent = sv, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ZIndex = 7,
        }, { corner("full"), make("UIStroke", { Color = rgb(255, 255, 255), Thickness = 2 }) })
        local hue = make("TextButton", {
            Parent = area, Position = UDim2.fromOffset(202, 0), Size = UDim2.fromOffset(16, 132), Text = "",
            AutoButtonColor = false, BackgroundColor3 = rgb(255, 255, 255), ZIndex = 4,
        }, { corner(8) })
        local keys = {}
        for i = 0, 6 do table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1))) end
        make("UIGradient", { Parent = hue, Rotation = 90, Color = ColorSequence.new(keys) })
        local hueCursor = make("Frame", {
            Parent = hue, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 6, 0, 6), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 5,
        }, { corner("full"), make("UIStroke", { Color = rgb(0, 0, 0), Transparency = 0.6 }) })
        local hex = make("TextBox", {
            Parent = area, Position = UDim2.fromOffset(232, 0), Size = UDim2.fromOffset(100, 30), Text = "",
            FontFace = FONTS.Medium, TextSize = 14, ClearTextOnFocus = false, ZIndex = 4,
        }, { corner(7) })
        T(hex, { BackgroundColor3 = "Field", TextColor3 = "Text" })
        local preview = make("Frame", { Parent = area, Position = UDim2.fromOffset(232, 38), Size = UDim2.fromOffset(100, 30), ZIndex = 4 }, { corner(7) })
        T(make("UIStroke", { Parent = preview, Transparency = 0.3 }), { Color = "Stroke" })

        local obj = { Type = "ColorPicker" }
        local function render()
            color = Color3.fromHSV(h, s, v)
            swatch.BackgroundColor3 = color
            preview.BackgroundColor3 = color
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCursor.Position = UDim2.fromScale(s, 1 - v)
            hueCursor.Position = UDim2.fromScale(0.5, h)
            hex.Text = "#" .. string.upper(color:ToHex())
        end
        function obj:Set(c, silent)
            if typeof(c) ~= "Color3" then return end
            h, s, v = c:ToHSV()
            render()
            if not silent then safe(o.Callback, color) end
        end
        function obj:Get() return color end

        local function dragOn(target, apply)
            on(target.InputBegan, function(input)
                local kind = input.UserInputType
                if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
                apply(input.Position)
                local move
                move = UIS.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then apply(i.Position) end
                end)
                table.insert(conns, move)
                local done
                done = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        move:Disconnect()
                        done:Disconnect()
                    end
                end)
            end)
        end
        dragOn(sv, function(p)
            s = math.clamp((p.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            render()
            safe(o.Callback, color)
        end)
        dragOn(hue, function(p)
            h = math.clamp((p.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
            render()
            safe(o.Callback, color)
        end)
        on(hex.FocusLost, function()
            local ok, c = pcall(Color3.fromHex, (hex.Text:gsub("#", "")))
            if ok and c then obj:Set(c) else render() end
        end)
        local open = false
        local function flipOpen()
            open = not open
            openFold(r, open and 148 or 0, open)
        end
        on(swatch.MouseButton1Click, flipOpen)
        r.tap(flipOpen)
        render()
        register(o, obj, r)
        return obj
    end

    function groupMeta:Input(o)
        o = o or {}
        local r = newRow(self, o, 220)
        local field = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(220, 30), ZIndex = 4,
        }, { corner(7) })
        T(field, { BackgroundColor3 = "Field" })
        local stroke = T(make("UIStroke", { Parent = field, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local box = make("TextBox", {
            Parent = field, Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -22, 1, 0), BackgroundTransparency = 1,
            Text = o.Default and tostring(o.Default) or "", PlaceholderText = o.Placeholder and tostring(o.Placeholder) or "",
            FontFace = FONTS.Regular, TextSize = 15, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
            ClipsDescendants = true, ZIndex = 5,
        })
        r.tap(function() box:CaptureFocus() end)
        T(box, { TextColor3 = "Text", PlaceholderColor3 = "Faint" })
        if o.Numeric then
            on(box:GetPropertyChangedSignal("Text"), function()
                local clean = box.Text:gsub("[^%d%.%-]", "")
                if clean ~= box.Text then box.Text = clean end
            end)
        end
        on(box.Focused, function() tw(stroke, 0.2, { Color = theme.Accent, Transparency = 0, Thickness = 1.5 }) end)
        local obj = { Type = "Input" }
        on(box.FocusLost, function(enter)
            tw(stroke, 0.25, { Color = theme.Separator, Transparency = 0.4, Thickness = 1 })
            safe(o.Callback, o.Numeric and tonumber(box.Text) or box.Text, enter)
        end)
        function obj:Set(t, silent)
            box.Text = tostring(t or "")
            if not silent then safe(o.Callback, o.Numeric and tonumber(box.Text) or box.Text, false) end
        end
        function obj:Get() return o.Numeric and tonumber(box.Text) or box.Text end
        register(o, obj, r)
        return obj
    end

    function groupMeta:Keybind(o)
        o = o or {}
        local r = newRow(self, o, 110)
        local entry = { key = toKey(o.Default) }
        local cap
        if MOBILE then
            local run = make("TextButton", {
                Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(72, 36), Text = "Run", FontFace = FONTS.Semi, TextSize = 15,
                AutoButtonColor = false, ZIndex = 4,
            }, { corner(9) })
            T(run, { BackgroundColor3 = "Field", TextColor3 = "Accent" })
            local rs = make("UIScale", { Parent = run })
            local function fireRun()
                tw(rs, 0.08, { Scale = 0.92 })
                task.delay(0.08, function() tw(rs, 0.25, { Scale = 1 }, Enum.EasingStyle.Back) end)
                entry.press(true)
                task.delay(0.1, function() entry.press(false) end)
            end
            on(run.MouseButton1Click, fireRun)
            r.tap(fireRun)
            cap = { set = function() end }
        end
        if not MOBILE then local _; _, cap = keycap(r.ctrl, entry.key, function(k)
            if k == nil and o.AllowNone == false then return entry.key end
            entry.key = k
            safe(o.Changed, k)
            return k
        end) end
        local obj = { Type = "Keybind" }
        function entry.press(down)
            if obj.Locked then return end
            if o.Hold then
                safe(o.Callback, down)
            elseif down then
                safe(o.Callback)
            end
        end
        table.insert(binds, entry)
        function obj:Set(k)
            entry.key = toKey(k)
            cap.set(entry.key)
        end
        function obj:Get() return entry.key end
        register(o, obj, r)
        return obj
    end

    function groupMeta:Button(o, callback)
        if type(o) ~= "table" then o = { Name = o, Callback = callback } end
        local r = newRow(self, o, 14)
        r.row.ClipsDescendants = true
        T(r.name, { TextColor3 = o.Danger and "Danger" or "Accent" })
        local arrow = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 1, ZIndex = 5,
        })
        for i, rot in ipairs({ 45, -45 }) do
            T(make("Frame", {
                Parent = arrow, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(5, i == 1 and 3 or 7),
                Size = UDim2.fromOffset(6, 1.6), Rotation = rot, BorderSizePixel = 0, ZIndex = 5,
            }), { BackgroundColor3 = "Faint" })
        end
        local hit = make("TextButton", {
            Parent = r.row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 8,
        })
        local nameScale = make("UIScale", { Parent = r.name })
        on(hit.MouseButton1Down, function() tw(nameScale, 0.1, { Scale = 0.97 }) end)
        on(hit.MouseButton1Up, function() tw(nameScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
        on(hit.MouseLeave, function() tw(nameScale, 0.2, { Scale = 1 }) end)
        on(hit.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            -- the ripple is drawn on the window, not inside the row: anything growing inside a row makes the row grow
            local total = fitScale.Scale * popScale.Scale
            local rp, rs = r.row.AbsolutePosition, r.row.AbsoluteSize
            local box = make("Frame", {
                Parent = main, BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3,
                Position = UDim2.fromOffset((rp.X - main.AbsolutePosition.X) / total, (rp.Y - main.AbsolutePosition.Y) / total),
                Size = UDim2.fromOffset(rs.X / total, rs.Y / total),
            })
            local x = (input.Position.X - rp.X) / total
            local y = (input.Position.Y - rp.Y) / total
            local ripple = make("Frame", {
                Parent = box, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y),
                Size = UDim2.fromOffset(0, 0), BackgroundColor3 = o.Danger and theme.Danger or theme.Accent,
                BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 2,
            }, { corner("full") })
            local d = r.row.AbsoluteSize.X / total * 2.2
            tw(ripple, 0.6, { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
            task.delay(0.62, function() box:Destroy() end)
        end)
        on(hit.MouseButton1Click, function() safe(o.Callback) end)
        on(hit.MouseEnter, function() tw(r.hover, 0.15, { BackgroundTransparency = theme == FeatherLite.Themes.Parchment and 0.97 or 0.965 }) end)
        on(hit.MouseLeave, function() tw(r.hover, 0.25, { BackgroundTransparency = 1 }) end)
        local obj = { Type = "Button" }
        function obj:SetText(t) r.name.Text = tostring(t) end
        function obj:SetLocked(v)
            obj.Locked = v == true
            r.lock(obj.Locked)
        end
        lastBuild = os.clock()
        return obj
    end

    function groupMeta:Label(text)
        local o = type(text) == "table" and text or { Text = text }
        local r = newRow(self, { Name = tostring(o.Text or "") }, 0)
        r.name.FontFace = FONTS.Regular
        r.name.TextSize = 14
        T(r.name, { TextColor3 = "SubText" })
        local obj = { Type = "Label" }
        function obj:Set(t) r.name.Text = tostring(t) end
        function obj:Get() return r.name.Text end
        return obj
    end

    function groupMeta:Paragraph(o)
        o = type(o) == "table" and o or { Title = tostring(o) }
        local r = newRow(self, { Name = o.Title or "", Description = o.Text or o.Content or "" }, 0)
        r.name.FontFace = FONTS.Semi
        local obj = { Type = "Paragraph" }
        function obj:Set(t) if r.desc then r.desc.Text = tostring(t) end end
        function obj:SetTitle(t) r.name.Text = tostring(t) end
        return obj
    end

    function Window:SetTheme(name)
        if not FeatherLite.Themes[name] then return end
        themeName = name
        theme = FeatherLite.Themes[name]
        for i = #themed, 1, -1 do
            local inst, map = themed[i][1], themed[i][2]
            if inst.Parent == nil then
                table.remove(themed, i)
            else
                local goal = {}
                for prop, role in pairs(map) do goal[prop] = theme[role] end
                tw(inst, 0.35, goal, Enum.EasingStyle.Quad)
            end
        end
        for _, fn in ipairs(hooks) do fn(true) end
        refreshTabColors(true)
    end
    function Window:GetTheme() return themeName end

    function Window:SetTransparency(a)
        alpha = math.clamp(tonumber(a) or 0, 0, 0.8)
        applyAlpha()
    end

    local function collectConfig()
        local data = { flags = {}, binds = {} }
        for flag, el in pairs(Window.Flags) do
            if el.Get then data.flags[flag] = encode(el:Get()) end
            if el.GetBind then data.binds[flag] = encode(el:GetBind()) end
        end
        return data
    end

    -- same settings always give the same text, so autosave can tell when something changed
    local function stable(v)
        if type(v) == "table" then
            local items = {}
            for k, x in pairs(v) do table.insert(items, { tostring(k), x }) end
            table.sort(items, function(a, b) return a[1] < b[1] end)
            local out = {}
            for _, it in ipairs(items) do table.insert(out, it[1] .. "=" .. stable(it[2])) end
            return "{" .. table.concat(out, ",") .. "}"
        end
        return tostring(v)
    end
    local function configSnapshot() return stable(collectConfig()) end

    function Window:SaveConfig(name)
        name = tostring(name or ""):gsub("[^%w%-_ ]", "")
        if name == "" then return false end
        FS.write(configDir .. "/" .. name .. ".json", HttpService:JSONEncode(collectConfig()))
        return true
    end

    function Window:LoadConfig(name)
        local data = FS.json(configDir .. "/" .. tostring(name) .. ".json")
        if type(data) ~= "table" then return false end
        for flag, v in pairs(data.flags or {}) do
            local el = Window.Flags[flag]
            if el and el.Set then pcall(el.Set, el, decode(v)) end
        end
        for flag, k in pairs(data.binds or {}) do
            local el = Window.Flags[flag]
            if el and el.SetBind then pcall(el.SetBind, el, decode(k)) end
        end
        return true
    end

    function Window:ListConfigs() return FS.configs(configDir) end

    function Window:OnUnload(fn) table.insert(unloadFns, fn) end

    function Window:Unload(instant)
        if not alive then return end
        autoSaveHalt = true -- unloading turns toggles off; don't save that
        for _, t in ipairs(toggles) do
            if t:Get() then t:Set(false) end
        end
        for _, fn in ipairs(unloadFns) do safe(fn) end
        alive = false
        listening = nil
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns)
        restoreMouse()
        local i = table.find(registry, Window)
        if i then table.remove(registry, i) end
        if instant then
            gui:Destroy()
            return
        end
        tw(popScale, 0.22, { Scale = 0.85 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tw(shadow, 0.2, { ImageTransparency = 1 })
        tw(pillScale, 0.2, { Scale = 0 })
        task.delay(0.24, function() gui:Destroy() end)
    end

    settingsTab = setmetatable({ name = "Settings", groups = {}, order = 0 }, tabMeta)
    settingsTab.page = makePage()
    settingsTab.button = settingsRow
    settingsTab.matches = true
    do
        local badge = make("Frame", {
            Parent = settingsRow, AnchorPoint = MOBILE and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5),
            Position = MOBILE and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 7, 0.5, 0),
            Size = MOBILE and UDim2.fromOffset(32, 32) or UDim2.fromOffset(24, 24), BackgroundTransparency = 1, BackgroundColor3 = rgb(142, 142, 147), ZIndex = 5,
        }, { corner(6) })
        local gear = make("ImageLabel", {
            Parent = badge, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = MOBILE and UDim2.fromOffset(20, 20) or UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1, Image = iconFor("Settings"), ImageColor3 = theme.SideSub, ScaleType = Enum.ScaleType.Fit, ZIndex = 6,
        })
        settingsTab.icon = gear
        local gearScale = make("UIScale", { Parent = badge })
        settingsTab.label = make("TextLabel", {
            Parent = settingsRow, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -46, 1, 0), BackgroundTransparency = 1,
            Visible = not MOBILE, Text = "Settings", FontFace = FONTS.Medium, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = theme.SideText, ZIndex = 5,
        })
        on(settingsRow.MouseEnter, function()
            tw(gearScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Back)
            tw(gear, 0.6, { Rotation = gear.Rotation + 90 }, Enum.EasingStyle.Back)
        end)
        on(settingsRow.MouseLeave, function() tw(gearScale, 0.2, { Scale = 1 }) end)
        on(settingsRow.MouseButton1Click, function()
            gearScale.Scale = 0.85
            tw(gearScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            selectTab(settingsTab)
        end)
    end

    if COMPACT then
        -- gear button in the header: toggles between the page and Settings
        local lastTab
        local gearBtn = make("ImageButton", {
            Parent = header, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -(18 + CLOSE + 6), 0.5, 2),
            Size = UDim2.fromOffset(CLOSE, CLOSE), BackgroundTransparency = 1, Image = iconFor("Settings"),
            ScaleType = Enum.ScaleType.Fit, AutoButtonColor = false, ZIndex = 6,
        }, { pad(8, 8, 8, 8) })
        T(gearBtn, { ImageColor3 = "SubText" })
        local spin = 0
        on(gearBtn.MouseEnter, function()
            spin = spin + 90
            tw(gearBtn, 0.5, { Rotation = spin }, Enum.EasingStyle.Back)
        end)
        on(gearBtn.MouseButton1Click, function()
            if current == settingsTab then
                if lastTab then selectTab(lastTab) end
            else
                lastTab = current
                selectTab(settingsTab)
            end
        end)
        pageTitle.Size = UDim2.new(1, -(60 + CLOSE * 2 + 6), 1, -4)

        -- no sidebar, so the logo, title and credit live in the header instead of the page title
        pageTitle.Visible = false
        brandMark.Parent = header
        brandMark.Position = UDim2.fromOffset(20, subtitle and 15 or 17)
        brandTitle.Parent = header
        brandTitle.Position = UDim2.fromOffset(54, subtitle and 9 or 14)
        brandTitle.Size = UDim2.new(1, -(54 + CLOSE * 2 + 40), 0, 22)
        brandTitle.TextSize = 18
        brandTitle.Visible = true
        T(brandTitle, { TextColor3 = "Text" })
        if brandSub then
            brandSub.Parent = header
            brandSub.Position = UDim2.fromOffset(54, 32)
            brandSub.Size = UDim2.new(1, -(54 + CLOSE * 2 + 40), 0, 14)
            brandSub.Visible = true
        end
        local logoText = brandMark:FindFirstChildOfClass("TextLabel")
        if logoText then T(logoText, { TextColor3 = "Accent" }) end
    end

    local appearance = settingsTab:Group("Appearance")
    appearance:Dropdown({
        Name = "Theme", Options = FeatherLite.ThemeOrder, Default = themeName,
        Callback = function(v)
            if v and v ~= themeName then
                Window:SetTheme(v)
                savePrefs()
            end
        end,
    })
    appearance:Slider({
        Name = "Transparency", Description = "How see-through the window background is.",
        Min = 0, Max = 60, Step = 5, Suffix = "%", Default = math.floor(alpha * 100 + 0.5),
        Callback = function(v)
            Window:SetTransparency(v / 100)
            savePrefs()
        end,
    })
    appearance:Slider({
        Name = "Menu size", Min = 70, Max = 130, Step = 5, Suffix = "%", Default = math.floor(userScale * 100 + 0.5),
        Callback = function(v)
            userScale = v / 100
            fit()
            savePrefs()
        end,
    })

    local menu = settingsTab:Group("Menu")
    if not MOBILE then menu:Keybind({
        Name = "Menu key", Description = "Opens and closes this window.", Default = menuKey, AllowNone = false,
        Changed = function(k)
            if k then
                menuKey = k
                savePrefs()
            end
        end,
    }) end
    menu:Toggle({
        Name = "Notifications", Default = notifyOn,
        Callback = function(v)
            notifyOn = v
            savePrefs()
        end,
    })
    -- unload shouldnt turn notifications off
    table.remove(toggles, #toggles)

    local configs = settingsTab:Group({ Name = "Configs", Description = "Autosave keeps the selected config up to date and Autoload loads it when the script starts. Menu settings are separate." })
    local cfgName = configs:Input({ Name = "Name", Placeholder = "my config" })
    local function configNames()
        local names = Window:ListConfigs()
        if not table.find(names, activeConfig) then table.insert(names, 1, activeConfig) end
        return names
    end
    local cfgList = configs:Dropdown({ Name = "Saved configs", Options = configNames(), Default = activeConfig })
    configs:Button({
        Name = "Save",
        Callback = function()
            local name = cfgName:Get() ~= "" and cfgName:Get() or cfgList:Get()
            if Window:SaveConfig(name) then
                cfgList:SetOptions(configNames(), true)
                cfgList:Set(name, true)
                activeConfig = name
                savePrefs()
                Window:Notify({ Title = "Config saved", Text = tostring(name) })
            else
                Window:Notify({ Title = "Type a name first" })
            end
        end,
    })
    configs:Button({
        Name = "Load",
        Callback = function()
            local name = cfgList:Get()
            if name and Window:LoadConfig(name) then
                activeConfig = name
                savePrefs()
                Window:Notify({ Title = "Config loaded", Text = name })
            else
                Window:Notify({ Title = "Pick a saved config first" })
            end
        end,
    })
    configs:Button({
        Name = "Delete", Danger = true,
        Callback = function()
            local name = cfgList:Get()
            if not name then return end
            Window:Dialog({
                Title = "Delete " .. name .. "?",
                Buttons = { { Text = "Cancel" }, { Text = "Delete", Danger = true, Callback = function()
                    local path = configDir .. "/" .. name .. ".json"
                    FS.delete(path)
                    if FS.read(path) ~= nil then
                        Window:Notify({ Title = "Couldn't delete", Text = "Your executor can't delete files (no delfile)." })
                        return
                    end
                    if name == activeConfig then
                        -- the deleted one was the selected one: move to another, or start a fresh Default
                        local rest = Window:ListConfigs()
                        activeConfig = rest[1] or "Default"
                        if not rest[1] then Window:SaveConfig(activeConfig) end
                        savePrefs()
                    end
                    cfgList:SetOptions(configNames())
                    cfgList:Set(activeConfig, true)
                    Window:Notify({ Title = "Config deleted", Text = name })
                end } },
            })
        end,
    })
    configs:Toggle({
        Name = "Autosave", Description = "Saves your changes to the selected config as you make them.",
        Default = autoSave,
        Callback = function(v)
            autoSave = v
            savePrefs()
        end,
    })
    table.remove(toggles, #toggles)
    configs:Toggle({
        Name = "Autoload", Description = "Loads the selected config when the script starts.",
        Default = autoLoad,
        Callback = function(v)
            autoLoad = v
            savePrefs()
        end,
    })
    table.remove(toggles, #toggles)

    -- Configs = false: scripts that save their own settings don't need this group
    if opts.Configs == false then
        for _, g in ipairs(settingsTab.groups) do
            if g.name == "Configs" then g.frame.Visible = false end
        end
    end

    local script = settingsTab:Group("Script")
    script:Button({
        Name = "Unload", Danger = true, Description = "Turns every feature off and removes the menu.",
        Callback = function()
            Window:Dialog({
                Title = "Unload " .. title .. "?",
                Text = "Every feature is turned off and the menu is removed.",
                Buttons = { { Text = "Cancel" }, { Text = "Unload", Danger = true, Callback = function() Window:Unload() end } },
            })
        end,
    })

    -- waits until the script stops adding stuff, then loads the active config (Autoload), makes sure it
    -- exists ("Default" the first time), and from then on writes changes back to it (Autosave)
    task.spawn(function()
        while alive and os.clock() - lastBuild < 0.6 do task.wait(0.2) end
        if not alive then return end
        local exists = FS.read(configDir .. "/" .. activeConfig .. ".json") ~= nil
        if autoLoad and exists then
            Window:LoadConfig(activeConfig)
            task.wait(0.3)
        end
        local last = configSnapshot()
        if not exists then
            Window:SaveConfig(activeConfig)
            cfgList:SetOptions(configNames(), true)
        end
        while alive and not autoSaveHalt do
            task.wait(1.5)
            if autoSave and alive and not autoSaveHalt then
                local now = configSnapshot()
                if now ~= last then
                    last = now
                    Window:SaveConfig(activeConfig)
                end
            end
        end
    end)

    task.spawn(function()
        if opts.Splash ~= false then
            local splash = make("Frame", {
                Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(320, 178), BackgroundTransparency = 1, ZIndex = 70,
            }, { corner(16) })
            T(splash, { BackgroundColor3 = "Window" })
            local sScale = make("UIScale", { Parent = splash, Scale = 0.9 })
            local sStroke = T(make("UIStroke", { Parent = splash, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
            local plume, vane, shaft = mark(splash, 44, {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 30), ZIndex = 71, Rotation = -25,
            })
            local plumeScale = make("UIScale", { Parent = plume, Scale = 0.6 })
            vane.ImageTransparency, shaft.ImageTransparency = 1, 1
            local word = make("TextLabel", {
                Parent = splash, Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
                Text = title, FontFace = FONTS.Bold, TextSize = 30, TextTransparency = 1, ZIndex = 71,
            })
            T(word, { TextColor3 = "Text" })
            local sub = make("TextLabel", {
                Parent = splash, Position = UDim2.fromOffset(0, 118), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
                Text = subtitle or "Loading", FontFace = FONTS.Regular, TextSize = 13, TextTransparency = 1, ZIndex = 71,
            })
            T(sub, { TextColor3 = "SubText" })
            local barBack = make("Frame", {
                Parent = splash, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 148), Size = UDim2.fromOffset(180, 4),
                BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 71,
            }, { corner("full") })
            T(barBack, { BackgroundColor3 = "Track" })
            local barFill = make("Frame", { Parent = barBack, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 72 }, { corner("full") })
            T(barFill, { BackgroundColor3 = "Accent" })

            tw(sScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(splash, 0.3, { BackgroundTransparency = 0 })
            tw(sStroke, 0.3, { Transparency = 0.35 })
            tw(barBack, 0.3, { BackgroundTransparency = 0 })
            tw(vane, 0.4, { ImageTransparency = 0 })
            tw(shaft, 0.4, { ImageTransparency = 0 })
            tw(plumeScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(plume, 0.9, { Rotation = 0 }, Enum.EasingStyle.Elastic)
            word.Position = UDim2.fromOffset(0, 90)
            tw(word, 0.5, { TextTransparency = 0, Position = UDim2.fromOffset(0, 80) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.15)
            tw(sub, 0.5, { TextTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.25)
            tw(barFill, 1.1, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0.2)
            task.wait(1.45)
            tw(sScale, 0.25, { Scale = 0.92 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            for _, x in ipairs({ splash, barBack, barFill }) do tw(x, 0.25, { BackgroundTransparency = 1 }) end
            tw(sStroke, 0.25, { Transparency = 1 })
            tw(word, 0.2, { TextTransparency = 1 })
            tw(sub, 0.2, { TextTransparency = 1 })
            tw(vane, 0.2, { ImageTransparency = 1 })
            tw(shaft, 0.2, { ImageTransparency = 1 })
            task.wait(0.22)
            splash:Destroy()
        end
        if alive then
            if not current then selectTab(settingsTab) end
            Window:Toggle(true)
        end
    end)

    table.insert(registry, Window)
    return Window
end

return FeatherLite
