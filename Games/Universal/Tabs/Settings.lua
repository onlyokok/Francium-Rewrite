local Tab = {}

function Tab:Construct()
    local ConfigsSection = self.Tab:Section({
        Name = "Configurations"
    }) do
        local ConfigDropdown = ConfigsSection:List({Name = "Configs", Values = {}, Value = "-", Flag = "config_dropdown", Size = 190, Callback = function(v)
            if self.Package.Interface.Library.ConfigFlags["config_name"] then
                self.Package.Interface.Library.ConfigFlags["config_name"].Set(v)
            end
        end})
        ConfigsSection:Textbox({Name = "Config Name", Value = "", Flag = "config_name"})
        ConfigsSection:Button({Name = "Save Config", Confirm = true, Callback = function()
            local ConfigName = self.Package.Interface.Library.Flags["config_name"]
    
            self.Package.Interface.Library:Notify({
                Text = ("Successfully %s config (%s)!"):format(isfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`) and "saved" or "created", ConfigName)
            })
    
            writefile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`, self.Package.Interface.Library:GetConfig())
    
            local _, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
            ConfigDropdown.Refresh(FileNames)
    
            ConfigDropdown.Set(ConfigName)
        end})
        ConfigsSection:Button({Name = "Load Config", Confirm = true, Callback = function()
            local ConfigName = self.Package.Interface.Library.Flags["config_name"]
    
            if isfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`) then
                self.Package.Interface.Library:LoadConfig(readfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`))
    
                self.Package.Interface.Library:Notify({
                    Text = ("Successfully loaded config (%s)!"):format(ConfigName)
                })
            else
                self.Package.Interface.Library:Notify({
                    Text = ("Couldn't find config (%s)!"):format(ConfigName)
                })
            end
    
            local _, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
            ConfigDropdown.Refresh(FileNames)
        end})
        ConfigsSection:Button({Name = "Reset Config", Confirm = true, Callback = function()
            local ConfigName = self.Package.Interface.Library.Flags["config_name"]
    
            if isfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`) then
                writefile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`, "")
    
                self.Package.Interface.Library:Notify({
                    Text = ("Successfully reseted config (%s)!"):format(ConfigName)
                })    
            else
                self.Package.Interface.Library:Notify({
                    Text = ("Couldn't find config (%s)!"):format(ConfigName)
                })
            end
    
            local Files, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
            ConfigDropdown.Refresh(FileNames)
        end})
        ConfigsSection:Button({Name = "Delete Config", Confirm = true, Callback = function()
            local ConfigName = self.Package.Interface.Library.Flags["config_name"]
    
            if isfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`) then
                delfile(`{self.Package.Interface.Library.Folder}/Configs/{ConfigName}.txt`)
    
                self.Package.Interface.Library:Notify({
                    Text = ("Successfully deleted config (%s)!"):format(ConfigName)
                })
            else
                self.Package.Interface.Library:Notify({
                    Text = ("Couldn't find config (%s)!"):format(ConfigName)
                })
            end
    
            local _, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
            ConfigDropdown.Refresh(FileNames)
    
            ConfigDropdown.Set(FileNames[1])
        end})
        ConfigsSection:Button({Name = "Refresh Config", Confirm = true, Callback = function()
            local _, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
            ConfigDropdown.Refresh(FileNames)
        end})
    
        local _, FileNames = self.Package.Interface.Library.Utility.GetFiles("Configs", {".txt"})
    
        ConfigDropdown.Refresh(FileNames)
    end
    
    local ExtraSection = self.Tab:Section({
        Name = "Extra",
        Side = "Right"
    }) do
        local Watermark = self.Window.Watermark
        local KeybindList = self.Window.KeybindList
    
        ExtraSection:Keybind({
            Name = "Menu Keybind",
            Flag = "menu_keybind",
            Key = Enum.KeyCode.RightShift,
            Ignore = true,
            Value = true,
            Callback = function(v)
                self.Package.Interface.Library:Show(v)
            end
        })
        ExtraSection:Button({Name = "Rejoin Game", Confirm = true, Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end})
        ExtraSection:Button({Name = "Join New Game", Confirm = true, Callback = function()
            local Notification = self.Package.Interface.Library:Notify({
                Text = "Looking for a server...",
                Time = 9e9,
                Animation = "Bounce"
            })
    
            while taskwait() do
                local Success, Servers = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(
                        game:HttpGet(
                            ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(
                                game.PlaceId
                            )
                        )
                    )
                end)
    
                if not Success then
                    Notification.Text = "Failed to get server list."
                    Notification.Type = "Warning"
                    Notification.ClockTime = os.clock() + 5
    
                    break
                end
            end
        end})
        ExtraSection:Button({Name = "Copy Join Script", Confirm = true, Callback = function()
            self.Package.Interface.Library:Notify({
                Text = "Successfully copied join script to clipboard!"
            })
    
            setclipboard(
                stringformat(
                    'game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")',
                    game.PlaceId,
                    game.JobId
                )
            )
        end})
        ExtraSection:Toggle({
            Name = "Keybinds List",
            Status = true,
            Flag = "menu_keybinds_list",
            Callback = function(v)
                if KeybindList then
                    KeybindList.SetVisibility(v)
                end
            end
        })
        ExtraSection:Toggle({
            Name = "Watermark",
            Status = true,
            Flag = "menu_watermark",
            Callback = function(v)
                if Watermark then
                    Watermark.SetVisibility(v)
                end
            end
        })
        ExtraSection:Textbox({Name = "Watermark Text", Value = Watermark.Text, Flag = "menu_watermark_text", Callback = function(v)
            if Watermark then
                Watermark.SetText(v)
            end
        end}) 
        ExtraSection:Slider({
            Name = "Watermark Tick Rate",
            Flag = "menu_watermark_tickrate",
            Min = 0,
            Max = 1000,
            Value = 200,
            Float = 1,
            Callback = function(v)
                if Watermark then
                    Watermark.SetTickRate(v / 1000)
                end
            end
        })
        ExtraSection:Slider({
            Name = "Tween Speed",
            Flag = "menu_tween_speed",
            Min = 0,
            Max = 1000,
            Value = 100,
            Float = 1,
            Callback = function(v)
                self.Package.Interface.Library.TweenSpeed = v / 1000
            end
        })
        ExtraSection:Slider({
            Name = "Lerp Speed",
            Flag = "menu_lerp_speed",
            Min = 0,
            Max = 1000,
            Value = 100,
            Float = 1,
            Callback = function(v)
                self.Package.Interface.Library.LerpSpeed = v / 1000
            end
        })
    
        local TweenStyles = {}
    
        for _,v in Enum.EasingStyle:GetEnumItems() do
            TweenStyles[#TweenStyles + 1] = tostring(v):gsub("Enum.EasingStyle.", "")
        end
    
        ExtraSection:Dropdown({Name = "Easing Style", Values = TweenStyles, Value = "Quad", Flag = "menu_easing_style", Callback = function(v)
            self.Package.Interface.Library.TweenEasingStyle = Enum.EasingStyle[v]
        end})
    
        local ThemeColorpickers = {}
        for _,v in self.Package.Interface.Library.Theme do
            ThemeColorpickers[_] = ExtraSection:Colorpicker({Name = _, Flag = _ .. "_theme", Color = v, Callback = function(v)
                self.Package.Interface.Library:ChangeTheme(_, v.c)
            end})
        end
    
        ExtraSection:Button({Name = "Reset Theme", Confirm = true, Callback = function()
            for _,v in self.Package.Interface.Library.OriginalTheme do
                self.Package.Interface.Library:ChangeTheme(_, v)
    
                ThemeColorpickers[_].Set(v)
            end
        end})
    end
end

function Tab:Setup(Package, Window)
    self.Package = Package

    self.Window = Window
    self.Tab = Window:Tab({Name = "Settings"})

    self:Construct()
end

return Tab