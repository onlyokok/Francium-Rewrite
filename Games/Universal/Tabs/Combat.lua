local Tab = {}

function Tab:Construct()
    local function GetClosestPlayerToMouse(MaxDistance, IgnoreTeam)
        local UserInputService = game:GetService("UserInputService")
        local CurrentCamera = workspace.CurrentCamera

        local ClosestPlayer, ClosestDistance = nil, math.huge

        for _,Player in next, game.Players:GetPlayers() do
            if Player.Character 
            and Player.Character 
            and Player.Character:FindFirstChild("HumanoidRootPart") 
            and Player.Character:FindFirstChild("Humanoid")
            and Player.Character:FindFirstChild("Humanoid").Health > 0 then
                if not IgnoreTeam or (Player.Team ~= game.Players.LocalPlayer.Team) then
                    local Vector, OnScreen = CurrentCamera:WorldToViewportPoint(Player.Character:GetPivot().Position)
                
                    if OnScreen then
                        local MouseLocation = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        local Magnitude = (Vector2.new(Vector.X, Vector.Y) - MouseLocation).Magnitude

                        if (Magnitude < ClosestDistance) and (Magnitude <= MaxDistance) then
                            ClosestPlayer = Player
                            ClosestDistance = Magnitude
                        end
                    end
                end
            end
        end

        return ClosestPlayer, ClosestDistance
    end

    local Aimlock = self.Tab:Section({Name = "Aimlock", Side = "Left"}) do
        Aimlock:Toggle({
            Name = "Enabled",
            Status = false,
            Flag = "AimlockEnabled",
        })

        Aimlock:Toggle({
            Name = "Check If Scoping",
            Status = false,
            Flag = "AimlockCheckIfScoping",
        })

        Aimlock:Toggle({
            Name = "Ignore Team",
            Status = false,
            Flag = "AimlockIgnoreTeam",
        })

        Aimlock:Dropdown({
            Name = "Body Part", 
            Values = {"Head", "HumanoidRootPart"},
            Value = "Head", 
            Flag = "AimlockBodyPart", 
        })

        Aimlock:Toggle({
            Name = "Show Field Of View",
            Status = true,
            Flag = "AimlockShowFieldOfView",
        })

        Aimlock:Slider({
            Name = "Field Of View Size",
            Flag = "AimlockFieldOfViewSize",
            Min = 50,
            Max = 1000,
            Value = 200,
            Float = 1,
        })

        Aimlock:Toggle({
            Name = "Smoothing",
            Status = false,
            Flag = "AimlockSmoothing",
        })

        Aimlock:Slider({
            Name = "Smoothness",
            Flag = "AimlockSmoothness",
            Min = 1,
            Max = 10,
            Value = 1,
            Float = 1,
        })

        local FieldOfView = Drawing.new("Circle")
        FieldOfView.Filled = false
        FieldOfView.Thickness = 1
        FieldOfView.Radius = Flags.AimlockFieldOfViewSize
        FieldOfView.NumSides = 64
        FieldOfView.Color = Color3.fromRGB(255, 255, 255)

        task.spawn(function()
            while task.wait() do
                if Flags.AimlockEnabled then
                    local ClosestPlayer, ClosestDistance = GetClosestPlayerToMouse(Flags.AimlockFieldOfViewSize, Flags.AimbotIgnoreTeam)

                    if ClosestPlayer then
                        local BodyPart = ClosestPlayer.Character[Flags.AimlockBodyPart]

                        if BodyPart then
                            if Flags.AimlockCheckIfScoping then
                                if game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                                    if Flags.AimlockSmoothing then
                                        game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(Flags.AimbotSmoothness / 20), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, BodyPart.Position)}):Play()
                                    else
                                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, BodyPart.Position)
                                    end
                                end
                            else
                                if Flags.AimlockSmoothing then
                                    game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(Flags.AimbotSmoothness / 20), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, BodyPart.Position)}):Play()
                                else
                                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, BodyPart.Position)
                                end
                            end
                        end
                    end

                    if Flags.AimlockShowFieldOfView then
                        FieldOfView.Visible = true

                        FieldOfView.Radius = Flags.AimlockFieldOfViewSize

                        local UserInputService = game:GetService("UserInputService")
                        FieldOfView.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    else
                        FieldOfView.Visible = false
                    end
                else
                    FieldOfView.Visible = false
                end
            end
        end)
    end

    local StickyMouse = self.Tab:Section({Name = "Sticky Mouse", Side = "Right"}) do
        
    end
end

function Tab:Setup(Package, Window)
    self.Package = Package

    self.Window = Window
    self.Tab = Window:Tab({Name = "Combat"})

    self:Construct()
end

return Tab