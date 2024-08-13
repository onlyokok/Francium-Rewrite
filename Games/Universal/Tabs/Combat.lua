local Tab = {}

function Tab:Construct()
    
end

function Tab:Setup(Package, Window)
    self.Package = Package

    self.Window = Window
    self.Tab = Window:Tab({Name = "Combat"})

    self:Construct()
end

return Tab