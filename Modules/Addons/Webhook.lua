local Webhook = {}

export type Webhook = {
    Url : string,
    Content : string,
    Embeds : {}
}

function Webhook.New(Options)
    local self : Webhook = {}

    self.Url = Options.Url;
    self.Content = Options.Content;
    self.Embeds = Options.Embeds;

    return self
end

function Webhook.Send(self : Webhook)
    local Success, Value = pcall(function()
        local HttpService = game:GetService("HttpService")

        return request({
            Url = self.Url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = self.Content,
                embeds = self.Embeds
            })
        })
    end)

    return Value
end

--[[
    local New = Webhook.New({
        Url = "",
        Content = "",
        Embeds = {
            [1] = {
                title = "Embed Title",
                type = "rich",
                color = tonumber(#FFFFFF),
                fields = {
                    [1] = {
                        name = "Field Name",
                        value = "Field Value",
                        inline = false
                    }
                },
                footer = {
                    text = "Footer Text",
                    icon_url = ""
                }
            }
        }
    })
]]

return Webhook