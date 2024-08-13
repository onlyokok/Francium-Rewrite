local Tab = {}

function Tab:Construct()
    local Settings = self.Tab:Section({Name = "Settings", Side = "Left"}) do
        Settings:Toggle({
            Name = "Enabled",
            Status = true,
            Flag = "EspEnabled",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.Enabled = Value
            end
        })

        Settings:Toggle({
            Name = "Limit Distance",
            Status = false,
            Flag = "EspLimitDistance",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.LimitDistance = Value
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
                self.Package.Addons.Esp.Settings.MaxDistance = Value
            end
        })

        Settings:Toggle({
            Name = "Filter Team",
            Status = false,
            Flag = "EspFilterTeam",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.CheckTeam = Value
            end
        })

        Settings:Toggle({
            Name = "Use Team Color",
            Status = false,
            Flag = "EspUseTeamColor",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.UseTeamColor = Value
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
                self.Package.Addons.Esp.Settings.TextFont = Fonts[Value]
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
                self.Package.Addons.Esp.Settings.TextSize = Value
            end
        })
    end

    local Players = self.Tab:Section({Name = "Players", Side = "Right"}) do
        Players:Toggle({
            Name = "Name Text",
            Status = false,
            Flag = "EspNameText",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.Name = Value
            end
        }):Colorpicker({
            Name = "Name Text Color", 
            Flag = "EspNameTextColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.NameColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Show Distance",
            Status = false,
            Flag = "EspDistance",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.ShowDistance = Value
            end
        })

        Players:Toggle({
            Name = "Misc Text",
            Status = false,
            Flag = "EspMiscText",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.Misc = Value
            end
        }):Colorpicker({
            Name = "Misc Text Color", 
            Flag = "EspMiscTextColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.MiscColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Boxes",
            Status = false,
            Flag = "EspBoxes",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.Box = Value
            end
        }):Colorpicker({
            Name = "Box Color", 
            Flag = "EspBoxColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.BoxColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Health Bars",
            Status = false,
            Flag = "EspHealthBars",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.HealthBar = Value
            end
        })

        Players:Toggle({
            Name = "Health Text",
            Status = false,
            Flag = "EspHealthText",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.HealthText = Value
            end
        }):Colorpicker({
            Name = "Health Text Color", 
            Flag = "EspHealthTextColor", 
            Color = Color3.fromRGB(0, 255, 0),
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.HealthTextColor = Value.c
            end
        })

        Players:Toggle({
            Name = "Chams",
            Status = false,
            Flag = "EspChams",
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.Chams = Value
            end
        }):Colorpicker({
            Name = "Chams Color", 
            Flag = "EspChamsColor", 
            Color = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                self.Package.Addons.Esp.Settings.ChamsColor = Value.c
                self.Package.Addons.Esp.Settings.ChamsTransparency = Value.a
            end
        })
    end

    for _,Player in next, game.Players:GetPlayers() do
        if Player ~= game.Players.LocalPlayer then
            self.Package.Addons.Esp.New(Player)
        end
    end

    game.Players.PlayerAdded:Connect(function(Player)
        self.Package.Addons.Esp.New(Player)
        print("Made Esp.Settings for " .. Player)
    end)

    game.Players.PlayerRemoving:Connect(function(Player)
        for _,Cached in next, self.Package.Addons.Esp.Cache do
            if Cached.Player == Player then
                Cached:Remove()
            end
        end
    end)
end

function Tab:Setup(Package, Window)
    self.Package = Package
    
    self.Window = Window
    self.Tab = Window:Tab({Name = "Visuals"})

    self:Construct()
end

return Tab