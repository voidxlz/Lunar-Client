local LunarGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FPSLabel = Instance.new("TextLabel")
local PingLabel = Instance.new("TextLabel")
local StorageLabel = Instance.new("TextLabel")
local DragButton = Instance.new("TextButton")

-- Configuração do GUI
LunarGui.Name = "LunarClient"
LunarGui.Parent = game.CoreGui

Frame.Parent = LunarGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark mode
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.5, -110, 0.5, -70)
Frame.Active = true
Frame.Draggable = true
Frame.Selectable = true
Frame.ClipsDescendants = true
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0

-- Bordas arredondadas
local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 12)

Title.Parent = Frame
Title.Text = "Lunar Client"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)

-- Função para criar labels com cores chroma
local function createLabel(name, parent, position)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = parent
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = position
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

FPSLabel = createLabel("FPSLabel", Frame, UDim2.new(0, 10, 0, 40))
PingLabel = createLabel("PingLabel", Frame, UDim2.new(0, 10, 0, 70))
StorageLabel = createLabel("StorageLabel", Frame, UDim2.new(0, 10, 0, 100))

-- Função para atualizar cores chroma
local function updateChromaColor(label, value, maxValue)
    local ratio = math.clamp(value / maxValue, 0, 1)
    local hue = (1 - ratio) * 0.3 -- Gradiente de cor chroma (verde para vermelho)
    label.TextColor3 = Color3.fromHSV(hue, 1, 1)
end

-- Função para calcular FPS
local RunService = game:GetService("RunService")
local fps = 60
local lastUpdate = tick()

RunService.RenderStepped:Connect(function(step)
    fps = math.floor(1 / step)
    if tick() - lastUpdate >= 0.5 then
        FPSLabel.Text = "FPS: " .. fps
        updateChromaColor(FPSLabel, fps, 60) -- Assumindo 60 como FPS máximo
        lastUpdate = tick()
    end
end)

-- Função para calcular o Ping
local function getPing()
    local stats = game:GetService("Stats")
    return math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
end

local function updateStats()
    local ping = getPing()
    PingLabel.Text = "Ping: " .. ping .. " ms"
    updateChromaColor(PingLabel, ping, 200) -- Assumindo 200 ms como Ping máximo
    
    local memory = collectgarbage("count") / 1024
    StorageLabel.Text = "Armazenamento: " .. string.format("%.2f", memory) .. " MB"
    updateChromaColor(StorageLabel, memory, 100) -- Assumindo 100 MB como máximo
end

game:GetService("RunService").Stepped:Connect(function()
    if tick() - lastUpdate >= 0.5 then
        updateStats()
    end
end)

-- Melhorando o desempenho
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic -- Reduz efeitos visuais
        obj.Reflectance = 0
    end
end

game.Lighting.GlobalShadows = false -- Desativa sombras
game.Lighting.FogEnd = 1000000 -- Remove neblina
game.Lighting.Brightness = 1 -- Ajusta brilho
game.Lighting.TimeOfDay = "14:00:00" -- Mantém iluminação fixa

-- Desativando efeitos que consomem desempenho
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("Texture") and v.Transparency < 1 then
        v.Transparency = 1
    end
end

print("[Lunar Client] Otimização ativada!")
