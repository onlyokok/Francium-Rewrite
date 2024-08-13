local Tab = {}

function Tab:Construct()
    local Settings = self.Tab:Section({Name = "Settings", Side = "Left"}) do
        Settings:Toggle({
            Name = "Enabled",
            Status = true,
            Flag = "EspEnabled",
            Callback = function(Value)
                self.Package.Addons.Esp.Enabled = Value
            end
        })

        Settings:Toggle({
            Name = "Limit Distance",
            Status = false,
            Flag = "EspLimitDistance",
            Callback = function(Value)
                self.Package.Addons.Esp.LimitDistance = Value
            end
        })

        Settings:Slider({
            Name = "Maximum Distance",
            Flag = "EspMaximumDistance",
            Min = 0,
            Max = 20000,
            Value = 20000,
            Float = 1,
            Callback = function(Value)
                self.Package.Addons.Esp.MaxDistance = Value
            end
        })

        Settings:Toggle({
            Name = "Filter Team",
            Status = false,
            Flag = "EspFilterTeam",
            Callback = function(Value)
                self.Package.Addons.Esp.CheckTeam = Value
            end
        })

        Settings:Toggle({
            Name = "Use Team Color",
            Status = false,
            Flag = "EspUseTeamColor",
            Callback = function(Value)
                self.Package.Addons.Esp.UseTeamColor = Value
            end
        })

        local Fonts = {
            UI = 0,
            System = 1,
            Plex = 2,
            Monospace = 3
        }

        Settings:Dropdown({
            Name = "Text Font", 
            Values = {["UI"] = 0, ["System"] = 1, ["Plex"] = 2, ["Monospace"] = 3},
            Value = "Monospace", 
            Flag = "EspTextFont", 
            Callback = function(Value)
                self.Package.Addons.Esp.TextFont = Fonts[Value]
            end
        })

        Settings:Slider({
            Name = "Text Size",
            Flag = "EspTextSize",
            Min = 10,
            Max = 20,
            Value = 12,
            Float = 1,
            Callback = function(Value)
                self.Package.Addons.Esp.TextSize = Value
            end
        })
    end

    local Players = self.Tab:Section({Name = "Players", Side = "Right"}) do
        Players:Toggle({
            Name = "Name Text",
            Status = false,
            Flag = "EspNameText",
            Callback = function(Value)
                self.Package.Addons.Esp.Name = Value
            end
        }):Colorpicker({
            Name = "Name Text Color", 
            Flag = "EspNameTextColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.NameColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Show Distance",
            Status = false,
            Flag = "EspDistance",
            Callback = function(Value)
                self.Package.Addons.Esp.ShowDistance = Value
            end
        })

        Players:Toggle({
            Name = "Misc Text",
            Status = false,
            Flag = "EspMiscText",
            Callback = function(Value)
                self.Package.Addons.Esp.Misc = Value
            end
        }):Colorpicker({
            Name = "Misc Text Color", 
            Flag = "EspMiscTextColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.MiscColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Boxes",
            Status = false,
            Flag = "EspBoxes",
            Callback = function(Value)
                self.Package.Addons.Esp.Box = Value
            end
        }):Colorpicker({
            Name = "Box Color", 
            Flag = "EspBoxColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.BoxColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Health Bars",
            Status = false,
            Flag = "EspHealthBars",
            Callback = function(Value)
                self.Package.Addons.Esp.HealthBar = Value
            end
        })

        Players:Toggle({
            Name = "Health Text",
            Status = false,
            Flag = "EspHealthText",
            Callback = function(Value)
                self.Package.Addons.Esp.HealthText = Value
            end
        }):Colorpicker({
            Name = "Health Text Color", 
            Flag = "EspHealthTextColor", 
            Color = Color3.fromRGB(0, 255, 0),
            Callback = function(Value)
                self.Package.Addons.Esp.HealthTextColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Chams",
            Status = false,
            Flag = "EspChams",
            Callback = function(Value)
                self.Package.Addons.Esp.Chams = Value
            end
        }):Colorpicker({
            Name = "Chams Color", 
            Flag = "EspChamsColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.ChamsColor = Value.c
                self.Package.Addons.Esp.ChamsTransparency = Value.a
            end
        })
    end
end

function Tab:Setup(Package, Window)
    self.Package = Package

    self.Window = Window
    self.Tab = Window:Tab({Name = "Visuals"})

    self:Construct()
end

return Tab