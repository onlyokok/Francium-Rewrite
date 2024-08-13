return function(Package)
    local Stem = `https://raw.githubusercontent.com/onlyokok/Francium-Rewrite/main/Games/Universal`
    local Tabs = `{Stem}/Tabs`

    local Window = Package.Interface.Library:Window({
        Name = "Francium Rewrite", 
        Watermark = true, 
        Keybinds = true, 
        Size = Vector2.new(625, 520) 
    })

    local Combat = loadstring(game:HttpGet(`{Tabs}/Combat.lua`))()
    Combat:Setup(Package, Window)

    local Visuals = loadstring(game:HttpGet(`{Tabs}/Visuals.lua`))()
    Visuals:Setup(Package, Window)

    local Settings = loadstring(game:HttpGet(`{Tabs}/Settings.lua`))()
    Settings:Setup(Package, Window)
end