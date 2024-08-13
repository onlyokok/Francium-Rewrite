local Stem = "https://raw.githubusercontent.com/onlyokok/Francium-Rewrite/main"

local Games = `{Stem}/Games`
local Modules = `{Stem}/Modules`

local Package = {
    Interface = {},
    Addons = {}
}

Package.Interface.Library = loadstring(game:HttpGet(`{Modules}/Interface/Library.lua`))()
Package.Interface.Library:Notify({
    Text = "Loaded Library",
    Time = 5,
    Type = "Normal",
    Animation = "Bounce",
})

Package.Addons.Esp = loadstring(game:HttpGet(`{Modules}/Addons/Esp.lua`))()
Package.Interface.Library:Notify({
    Text = "Loaded Addons",
    Time = 5,
    Type = "Normal",
    Animation = "Bounce",
})

local Success, Value = pcall(function()
    return game:HttpGet(`{Games}/{game.PlaceId}/Main.lua`)
end)

if Success then
    Package.Interface.Library:Notify({
        Text = "Game found, please wait while the script loads",
        Time = 5,
        Type = "Normal",
        Animation = "Bounce",
    })

    loadstring(Value)()(Package)
else
    Package.Interface.Library:Notify({
        Text = `Unable to find game under ({game.PlaceId}), please wait while the universal script loads`,
        Time = 5,
        Type = "Warning",
        Animation = "Bounce",
    })

    loadstring(game:HttpGet(`{Games}/Universal/Main.lua`))()(Package)
end