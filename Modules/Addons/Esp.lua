getgenv().Esp = {
    Settings = {
        Enabled = true,
        LimitDistance = false,
        MaxDistance = 9e9,
        CheckTeam = false,
        UseTeamColor = false,
        ShowDistance = false,
        Box = false,
        BoxColor = Color3.fromRGB(255, 255, 255),
        HealthBar = false,
        Name = false,
        NameColor = Color3.new(1.000000, 1.000000, 1.000000),
        Misc = false,
        MiscColor = Color3.fromRGB(255, 255, 255),
        HealthText = false,
        HealthTextColor = Color3.fromRGB(0, 255, 0),
        TextFont = 3,
        TextSize = 12,
        Chams = false,
        ChamsColor = Color3.fromRGB(255, 255, 255),
        ChamsTransparency = 0.25
    },
    Groups = {},
    Cache = {}
}

Esp.__index = Esp

function Esp.New(Player)
    local self = setmetatable({
        Player = Player,
        Drawings = {},
        Misc = "",
        Connection = nil
    }, Esp)

    self:Construct()
    self:Render()

    self.Index = #Esp.Cache + 1
    Esp.Cache[self.Index] = self

    return self
end

local DrawingTypes = {
    "Circle",
    "Square",
    "Triangle",
    "Image",
    "Quad",
    "Text",
    "Line"
}

function Esp:_Create(Type, Properties)
    local drawing;

    if table.find(DrawingTypes, Type) then
        drawing = Drawing.new(Type)
    else
        drawing = Instance.new(Type)
    end

    for Property, Value in next, Properties do
        drawing[Property] = Value
    end

    return drawing
end

function Esp:Remove()
    for _,drawing in next, self.Drawings do
        drawing:Remove()
    end

    table.remove(Esp.Cache, self.Index)
    self.Connection:Disconnect()
end

function Esp:Construct()
    self.Drawings.Box = self:_Create("Square", {
        Visible = false,
        Filled = false,
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        ZIndex = 2
    })

    self.Drawings.BoxOutline = self:_Create("Square", {
        Visible = false,
        Filled = false,
        Thickness = 1,
        Color = Color3.new(0, 0, 0),
        ZIndex = 1
    })

    self.Drawings.HealthBarBackground = self:_Create("Square", {
        Visible = false,
        Filled = true,
        Thickness = 1,
        Color = Color3.new(0, 0, 0),
        ZIndex = 1
    })

    self.Drawings.HealthBar = self:_Create("Square", {
        Visible = false,
        Filled = true,
        Thickness = 1,
        Color = Color3.new(0, 1, 0),
        ZIndex = 2
    })

    self.Drawings.Name = self:_Create("Text", {
        Visible = false,
        Outline = true,
        Color = Color3.new(1, 1, 1),
        Size = Esp.Settings.TextSize,
        Font = Esp.Settings.TextFont,
        Center = true,
        ZIndex = 3
    })

    self.Drawings.Misc = self:_Create("Text", {
        Visible = false,
        Outline = true,
        Text = "Empty",
        Color = Color3.new(1, 1, 1),
        Size = Esp.Settings.TextSize,
        Font = Esp.Settings.TextFont,
        Center = true,
        ZIndex = 3
    })

    self.Drawings.HealthText = self:_Create("Text", {
        Visible = false,
        Outline = true,
        Text = "",
        Color = Color3.new(1, 1, 1),
        Size = 10,
        Font = Esp.Settings.TextFont,
        Center = true,
        ZIndex = 3
    })

    self.Drawings.Highlight = self:_Create("Highlight", {
        Parent = game:GetService("CoreGui"),
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        OutlineTransparency = 1,
        FillColor = Esp.Settings.ChamsColor,
        FillTransparency = Esp.Settings.ChamsTransparency,
    })
end

function Esp:Render()
    self.Connection = game:GetService("RunService").RenderStepped:Connect(function()
        if self.Player.Character and self.Player.Character:FindFirstChild("HumanoidRootPart") and self.Player.Character:FindFirstChild("Humanoid") then
            local CurrentCamera = workspace.CurrentCamera

            local HumanoidRootPart = self.Player.Character.HumanoidRootPart
            local Humanoid = self.Player.Character.Humanoid

            local Offset = Vector3.new(0, 3, 0)

            local RootVector, RootVisible = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
            local HeadVector, HeadVisible = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position + Offset)
            local LegVector, LegVisible = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Offset)

            local Height = (HeadVector.Y - LegVector.Y) * 0.95
            local Width = Height * 0.75

            local Distance = math.round((CurrentCamera.CFrame.Position - HumanoidRootPart.Position).Magnitude)

            local Visible = Esp.Settings.Enabled and RootVisible and HeadVisible and LegVisible

            if Esp.Settings.CheckTeam then
                Visible = Visible and (self.Player.Team ~= game.Players.LocalPlayer.Team)
            end

            if Esp.Settings.LimitDistance then
                Visible = Visible and (Distance <= Esp.Settings.MaxDistance)
            end

            local HealthDecimal = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)

            if Visible then
                self.Drawings.Box.Size = Vector2.new(Width, Height)
                self.Drawings.Box.Position = Vector2.new(RootVector.X - (Width / 2), RootVector.Y - (Height / 2))
                self.Drawings.Box.Color = Esp.Settings.UseTeamColor and self.Player.TeamColor.Color or Esp.Settings.BoxColor
                
                self.Drawings.BoxOutline.Size = Vector2.new(Width - 2, Height - 2)
                self.Drawings.BoxOutline.Position = Vector2.new((RootVector.X - (Width / 2)) + 1, (RootVector.Y - (Height / 2)) + 1)

                self.Drawings.HealthBarBackground.Size = Vector2.new(5, Height - 3)
                self.Drawings.HealthBarBackground.Position = Vector2.new(self.Drawings.Box.Position.X + self.Drawings.Box.Size.X - 9, self.Drawings.Box.Position.Y + 1)

                self.Drawings.HealthBar.Size = Vector2.new(1, Height * HealthDecimal)
                self.Drawings.HealthBar.Position = Vector2.new(self.Drawings.Box.Position.X + self.Drawings.Box.Size.X - 7, self.Drawings.Box.Position.Y)
                self.Drawings.HealthBar.Color = Color3.new(1 - HealthDecimal, HealthDecimal, 0)

                self.Drawings.Name.Position = Vector2.new(self.Drawings.Box.Position.X + (self.Drawings.Box.Size.X / 2), (self.Drawings.Box.Position.Y + self.Drawings.Box.Size.Y) - (Esp.Settings.TextSize + 5))
                self.Drawings.Name.Color = Esp.Settings.UseTeamColor and self.Player.TeamColor.Color or Esp.Settings.NameColor
                self.Drawings.Name.Text = (Esp.Settings.ShowDistance and `{self.Player.Name} [{Distance}]`) or self.Player.Name
                self.Drawings.Name.Font = Esp.Settings.TextFont
                self.Drawings.Name.Size = Esp.Settings.TextSize

                self.Drawings.Misc.Position = Vector2.new(self.Drawings.Box.Position.X + (self.Drawings.Box.Size.X / 2), self.Drawings.Box.Position.Y + 2)
                self.Drawings.Misc.Color = Esp.Settings.MiscColor
                self.Drawings.Misc.Font = Esp.Settings.TextFont
                self.Drawings.Misc.Size = Esp.Settings.TextSize
                self.Drawings.Misc.Text = self.Misc

                self.Drawings.HealthText.Position = self.Drawings.HealthBarBackground.Position + Vector2.new(-15, self.Drawings.HealthBarBackground.Size.Y - (self.Drawings.HealthBarBackground.Size.Y - self.Drawings.HealthBar.Size.Y) - 5)
                self.Drawings.HealthText.Color = Esp.Settings.HealthTextColor
                self.Drawings.HealthText.Font = Esp.Settings.TextFont
                self.Drawings.HealthText.Text = `{math.round(HealthDecimal * 100)}%`

                self.Drawings.Highlight.FillTransparency = Esp.Settings.ChamsTransparency
                self.Drawings.Highlight.FillColor = Esp.Settings.UseTeamColor and self.Player.TeamColor.Color or Esp.Settings.ChamsColor
            end

            self.Drawings.Box.Visible = Visible and Esp.Settings.Box
            self.Drawings.BoxOutline.Visible = Visible and Esp.Settings.Box
            self.Drawings.HealthBarBackground.Visible = Visible and Esp.Settings.HealthBar
            self.Drawings.HealthBar.Visible = Visible and Esp.Settings.HealthBar
            self.Drawings.Name.Visible = Visible and Esp.Settings.Name
            self.Drawings.Misc.Visible = Visible and Esp.Settings.Misc
            self.Drawings.HealthText.Visible = Visible and Esp.Settings.HealthText and HealthDecimal ~= 1
            self.Drawings.Highlight.Enabled = Visible and Esp.Settings.Chams
            self.Drawings.Highlight.Adornee = self.Player.Character
        else
            self.Drawings.Box.Visible = false
            self.Drawings.BoxOutline.Visible = false
            self.Drawings.HealthBarBackground.Visible = false
            self.Drawings.HealthBar.Visible = false
            self.Drawings.Name.Visible = false
            self.Drawings.Misc.Visible = false
            self.Drawings.HealthText.Visible = false
            self.Drawings.Highlight.Enabled = false
        end
    end)
end

local InstanceEsp = {}
InstanceEsp.__index = InstanceEsp

function Esp.Instance(Group, Instance, Text)
    local self = setmetatable({
        Group = Group,
        Instance = Instance,
        Text = Text,
        Connections = {}
    }, InstanceEsp)

    if not Esp.Groups[self.Group] then
        Esp.Groups[self.Group] = {
            Enabled = false,
            Color = Color3.fromRGB(255, 255, 255),
            Content = {}
        }
    end

    self.Drawing = Esp:_Create("Text", {
        Visible = false,
        Outline = true,
        Color = Color3.new(1, 1, 1),
        Size = Esp.Settings.TextSize,
        Font = Esp.Settings.TextFont,
        Center = true,
        ZIndex = 3
    })

    self:Setup()

    self.Index = #Esp.Groups[self.Group].Content + 1
    Esp.Groups[self.Group].Content[self.Index] = self

    return self
end

function InstanceEsp:Setup()
    self.Connections.Parent = self.Instance:GetPropertyChangedSignal("Parent"):Connect(function()
        if self.Instance.Parent == nil then
            self:Remove()
        end
    end)

    self.Connections.Update = game:GetService("RunService").RenderStepped:Connect(function()
        if self.Instance then
            local CurrentCamera = workspace.CurrentCamera
            local Distance = math.round((CurrentCamera.CFrame.Position - self.Instance:GetPivot().Position).Magnitude)

            local Vector, InstanceVisible = CurrentCamera:WorldToViewportPoint(self.Instance:GetPivot().Position)
            local Visible = Esp.Settings.Enabled and Esp.Groups[self.Group].Enabled and InstanceVisible

            if Esp.Settings.LimitDistance then
                Visible = Visible and (Distance <= Esp.Settings.MaxDistance)
            end

            if Visible then
                self.Drawing.Position = Vector2.new(Vector.X, Vector.Y)
                self.Drawing.Text = Esp.Settings.ShowDistance and `{self.Text} [{Distance}]` or self.Text
                self.Drawing.Size = Esp.Settings.TextSize
                self.Drawing.Font = Esp.Settings.TextFont
                self.Drawing.Color = Esp.Groups[self.Group].Color
            end

            self.Drawing.Visible = Visible
        else
            self.Drawing.Visible = false
        end
    end)
end

function InstanceEsp:Remove()
    self.Drawing:Remove()

    for _,Connection in next, self.Connections do
        Connection:Disconnect()
    end

    table.remove(Esp.Groups[self.Group].Content, self.Index)
end

function Esp.SetGroupVisibility(Group, Value)
    if not Esp.Groups[Group] then
        Esp.Groups[Group] = {
            Enabled = Value,
            Color = Color3.fromRGB(255, 255, 255),
            Content = {}
        }
    else
        Esp.Groups[Group].Enabled = Value
    end
end

function Esp.SetGroupColor(Group, Value)
    if not Esp.Groups[Group] then
        Esp.Groups[Group] = {
            Enabled = false,
            Color = Value,
            Content = {}
        }
    else
        Esp.Groups[Group].Color = Value
    end
end

return Esp