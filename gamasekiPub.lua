local library = loadstring(httpget("https://raw.githubusercontent.com/sixodicor-byte/GameSexse/refs/heads/main/GameSense.lua"))()

setfpscap(300)
local window = library:Window({ Name = "Valenok" })

local tabs = {
Rage = window:Tab({ Icon = "rbxassetid://8547236654" }),
Legit = window:Tab({ Icon = "rbxassetid://8547249956" }),
Visuals = window:Tab({ Icon = "rbxassetid://8547254518" }),
Misc = window:Tab({ Icon = "rbxassetid://8547256547" }),
Skins = window:Tab({ Icon = "rbxassetid://8547258459" }),
Configs = window:Tab({ Icon = "rbxassetid://107672994153530" }),
}

local visual = tabs.Visuals:Section({ Name = "Visual", Side = "Left" })
local world = tabs.Visuals:Section({ Name = "World", Side = "Right" })
local skyboxData = loadstring(httpget("https://raw.githubusercontent.com/sixodicor-byte/GameSexse/main/SkyBoxes.lua"))()
local skyboxes = skyboxData.Presets
local skyboxNames = skyboxData.Names
local controls = {}

local function feature(control)
table.insert(controls, control)
return control
end

local enable = visual:Toggle({ Name = "Enable", Flag = "Enable", Default = false })
feature(visual:Toggle({ Name = "Team check", Flag = "TeamCheck" }))

local box = feature(visual:Toggle({ Name = "Box", Flag = "Box" }))
local boxColorPicker = box:Colorpicker({ Name = "Box", Flag = "BoxColor", Color = Color3.fromRGB(255, 255, 255) })
local boxStyle = visual:Dropdown({ Name = "Box style", Flag = "BoxStyle", Options = { "Normal", "Corner" }, Default = "Normal" })

local healthBar = feature(visual:Toggle({ Name = "Health bar", Flag = "HealthBar" }))
local healthColorLow = healthBar:Colorpicker({ Name = "Low HP", Flag = "HealthColorBottom", Color = Color3.fromRGB(0, 255, 0) })
local healthColorHigh = healthBar:Colorpicker({ Name = "High HP", Flag = "HealthColorTop", Color = Color3.fromRGB(255, 0, 0) })

local name = feature(visual:Toggle({ Name = "Name", Flag = "Name" }))
local nameColorPicker = name:Colorpicker({ Name = "Name", Flag = "NameColor", Color = Color3.fromRGB(255, 255, 255) })

local distance = feature(visual:Toggle({ Name = "Distance", Flag = "Distance" }))
local distanceColorPicker = distance:Colorpicker({ Name = "Distance", Flag = "DistanceColor", Color = Color3.fromRGB(255, 255, 255) })

local heldItem = feature(visual:Toggle({ Name = "Held item", Flag = "HeldItem" }))
local heldItemColorPicker = heldItem:Colorpicker({ Name = "Held item", Flag = "HeldItemColor", Color = Color3.fromRGB(255, 255, 255) })

local droppedItem = world:Toggle({ Name = "Dropped item", Flag = "DroppedItem" })
local droppedItemColorPicker = droppedItem:Colorpicker({ Name = "Dropped item", Flag = "DroppedItemColor", Color = Color3.fromRGB(255, 255, 255) })
local customSkybox = world:Toggle({ Name = "Custom sky box", Flag = "CustomSkybox" })
local skyboxSelector = world:Dropdown({ Name = "Skybox", Flag = "Skybox", Options = skyboxNames, Default = skyboxNames[1], Scrolling = true })

local chams = feature(visual:Toggle({ Name = "Chams", Flag = "Chams" }))
local chamsFillColorPicker = chams:Colorpicker({ Name = "Chams fill", Flag = "ChamsFill", Color = Color3.fromRGB(255, 255, 255) })
local chamsOutlineColorPicker = chams:Colorpicker({ Name = "Chams outline", Flag = "ChamsOutline", Color = Color3.fromRGB(0, 0, 0) })

local function refresh()
local on = enable.Enabled

for _, control in ipairs(controls) do
	library:SetControlVisible(control, on, "Toggle")
end
library:SetControlVisible(boxStyle, on and box.Enabled, "Dropdown")
library:SetControlVisible(skyboxSelector, customSkybox.Enabled, "Dropdown")
end

local lighting = game:GetService("Lighting")
local savedSkies
local activeSky

local function restoreSkybox()
	if activeSky then
		activeSky:Destroy()
		activeSky = nil
	end

	if savedSkies then
		for _, sky in ipairs(savedSkies) do
			sky.Parent = lighting
		end
		savedSkies = nil
	end
end

local function applySkybox(name)
	local properties = skyboxes[name]
	if not properties then
		return
	end

	if not savedSkies then
		savedSkies = {}
		for _, child in ipairs(lighting:GetChildren()) do
			if child:IsA("Sky") then
				table.insert(savedSkies, child)
				child.Parent = nil
			end
		end
	end

	if activeSky then
		activeSky:Destroy()
	end

	activeSky = Instance.new("Sky")
	for property, value in pairs(properties) do
		activeSky[property] = value
	end
	activeSky.Parent = lighting
end

customSkybox.Callback = function(on)
	refresh()
	if on then
		applySkybox(library.Flags[skyboxSelector.Flag])
	else
		restoreSkybox()
	end
end

skyboxSelector.Callback = function(name)
	if customSkybox.Enabled then
		applySkybox(name)
	end
end

enable.Callback = refresh
box.Callback = refresh
chams.Callback = refresh
name.Callback = refresh
distance.Callback = refresh
refresh()

local legit = tabs.Legit:Section({ Name = "Legit bot", Side = "Left" })

local legitControls = {}

local function legitFeature(control, item)
table.insert(legitControls, { control = control, item = item or "Toggle" })
return control
end

local aimbot = legit:Toggle({ Name = "Enable", Flag = "Aimbot", Default = false })

aimbot:Keybind({
	Name = "Enable";
	Flag = "AimbotBind";
})

legitFeature(legit:Dropdown({ Name = "Hitbox", Flag = "Hitbox", Multi = true, Options = { "Head", "Body", "Arms", "Legs" }, Default = {} }), "Dropdown")
legitFeature(legit:Dropdown({ Name = "Checks", Flag = "Checks", Multi = true, Options = { "Visible", "Team", "Smoke", "Flash", "Scope", "Air" }, Default = {} }), "Dropdown")

local fov = legitFeature(legit:Slider({ Name = "FOV", Flag = "Fov", Min = 1, Max = 180, Default = 30 }), "Slider")
local fovColor = legitFeature(legit:Colorpicker({ Name = "FOV", Flag = "FovColor", Color = Color3.fromRGB(255, 255, 255) }), "ColorpickerObject")
fovColor.Items.ColorpickerObject.Parent = fov.Items.Slider
fovColor.Items.ColorpickerObject.Position = UDim2.new(1, -8, 0, 4)
fovColor.Items.ColorpickerObject.AnchorPoint = Vector2.new(1, 0.5)

legitFeature(legit:Slider({ Name = "Smooth", Flag = "Smooth", Min = 1, Max = 10, Default = 1 }), "Slider")
legitFeature(legit:Toggle({ Name = "Auto wall", Flag = "AutoWall" }), "Toggle")

local function refreshLegit()
local on = aimbot.Enabled

for _, entry in ipairs(legitControls) do
	library:SetControlVisible(entry.control, on, entry.item)
end
end

aimbot.Callback = refreshLegit
refreshLegit()

local triggerBot = tabs.Legit:Section({ Name = "Trigger bot", Side = "Right" })

local triggerControls = {}

local function triggerFeature(control, item)
table.insert(triggerControls, { control = control, item = item or "Toggle" })
return control
end

local trigger = triggerBot:Toggle({ Name = "Enable", Flag = "Trigger", Default = false })

trigger:Keybind({
	Name = "Enable";
	Flag = "TriggerBind";
})

triggerFeature(triggerBot:Dropdown({ Name = "Hitbox", Flag = "TriggerHitbox", Multi = true, Options = { "Head", "Body", "Arms", "Legs" }, Default = {} }), "Dropdown")
triggerFeature(triggerBot:Dropdown({ Name = "Checks", Flag = "TriggerChecks", Multi = true, Options = { "Visible", "Team", "Smoke", "Flash", "Scope", "Air" }, Default = { "Visible" } }), "Dropdown")
triggerFeature(triggerBot:Toggle({ Name = "Auto wall", Flag = "TriggerAutoWall" }), "Toggle")

local function refreshTrigger()
local on = trigger.Enabled

for _, entry in ipairs(triggerControls) do
	library:SetControlVisible(entry.control, on, entry.item)
end
end

trigger.Callback = refreshTrigger
refreshTrigger()

local misc = tabs.Misc:Section({ Name = "misc", Side = "Left" })

local thirdPersonControls = {}
local fovControls = {}

local function miscFeature(list, control, item)
table.insert(list, { control = control, item = item or "Toggle" })
return control
end

local thirdPerson = misc:Toggle({ Name = "Third person", Flag = "ThirdPerson", Default = false })

local thirdPersonBind = thirdPerson:Keybind({
	Name = "Third person";
	Flag = "ThirdPersonBind";
})

local distanceSlider = miscFeature(thirdPersonControls, misc:Slider({ Name = "Distance", Flag = "ThirdPersonDistance", Min = 1, Max = 100, Default = 8 }), "Slider")

local camera = game:GetService("Workspace").CurrentCamera
local runService = game:GetService("RunService")
local baseFov = camera and camera.FieldOfView or 70

local fovChanger = misc:Toggle({ Name = "Fov changer", Flag = "FovChanger", Default = false })
local fovSlider = miscFeature(fovControls, misc:Slider({ Name = "Fov", Flag = "FovChangerValue", Min = 60, Max = 120, Default = math.clamp(math.floor(baseFov + 0.5), 60, 120) }), "Slider")

local fovConnection

local players = game:GetService("Players")
local lp = players.LocalPlayer
local userInputService = game:GetService("UserInputService")

local thirdPersonYaw = 0
local thirdPersonPitch = 0
local thirdPersonActive = false
local originalCameraType

local function updateCharacter()
	local character = lp.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.AutoRotate = true
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.LocalTransparencyModifier = 0
		end
	end
end

local function updateCamera()
	local currentCamera = game:GetService("Workspace").CurrentCamera
	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not (currentCamera and root) then
		return
	end

	local delta = userInputService:GetMouseDelta()
	thirdPersonYaw -= delta.X * 0.01
	thirdPersonPitch = math.clamp(thirdPersonPitch - delta.Y * 0.01, -1.4, 1.4)

	local focus = root.Position + Vector3.new(0, 1.5, 0)
	local rotation = CFrame.fromEulerAnglesYXZ(thirdPersonPitch, thirdPersonYaw, 0)
	local position = focus - rotation.LookVector * distanceSlider.Value

	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = CFrame.new(position, focus)

	updateCharacter()
end

local function setThirdPersonActive(active)
	if active == thirdPersonActive then
		return
	end

	if active then
		local currentCamera = game:GetService("Workspace").CurrentCamera
		local character = lp.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if currentCamera and root then
			local look = currentCamera.CFrame.LookVector
			thirdPersonYaw = math.atan2(-look.X, -look.Z)
			thirdPersonPitch = math.asin(math.clamp(look.Y, -1, 1))
			originalCameraType = currentCamera.CameraType
		end

		thirdPersonActive = true
		runService:BindToRenderStep("thirdPerson", Enum.RenderPriority.Camera.Value + 1, updateCamera)
	else
		thirdPersonActive = false
		runService:UnbindFromRenderStep("thirdPerson")

		local currentCamera = game:GetService("Workspace").CurrentCamera

		if currentCamera and originalCameraType then
			currentCamera.CameraType = originalCameraType
		end
	end
end

local function updateThirdPerson()
	setThirdPersonActive(thirdPerson.Enabled and thirdPersonBind.Active == true)
end

local function refreshMisc()
	for _, entry in ipairs(thirdPersonControls) do
		library:SetControlVisible(entry.control, thirdPerson.Enabled, entry.item)
	end

	for _, entry in ipairs(fovControls) do
		library:SetControlVisible(entry.control, fovChanger.Enabled, entry.item)
	end
end

local function applyFov()
	if camera then
		camera.FieldOfView = fovSlider.Value
	end
end

fovSlider.Callback = function()
	if fovChanger.Enabled then
		applyFov()
	end
end

thirdPersonBind.Callback = updateThirdPerson

thirdPerson.Callback = function()
	refreshMisc()
	updateThirdPerson()
end

fovChanger.Callback = function(on)
	refreshMisc()

	if on then
		applyFov()

		if not fovConnection then
			fovConnection = library:Connection(runService.RenderStepped, applyFov)
		end
	else
		if fovConnection then
			fovConnection:Disconnect()
			fovConnection = nil
		end

		if camera then
			camera.FieldOfView = baseFov
		end
	end
end

refreshMisc()

local interface = tabs.Misc:Section({ Name = "Interface", Side = "Right" })
local movement = tabs.Misc:Section({ Name = "Movement", Side = "Right" })

local interfaceControls = {}

local function interfaceFeature(control, item)
table.insert(interfaceControls, { control = control, item = item or "Toggle" })
return control
end

local watermark = interface:Toggle({ Name = "Watermark", Flag = "Watermark" })

interface:Toggle({
Name = "Keybind list";
Flag = "KeybindList";
Callback = function(on)
library:ToggleKeybindList(on)
end;
})

local watermarkOptions = interfaceFeature(interface:Dropdown({ Name = "Watermark", Flag = "WatermarkOptions", Multi = true, Options = { "fps", "ping", "time", "cfg" }, Default = { "fps", "ping", "time" } }), "Dropdown")

watermarkOptions.Callback = function(selected)
local set = {}

for _, value in ipairs(selected) do
	set[value] = true
end

library.WatermarkOptions.fps = set.fps == true
library.WatermarkOptions.ping = set.ping == true
library.WatermarkOptions.time = set.time == true
library.WatermarkOptions.config = set.cfg == true
end

local function refreshInterface()
for _, entry in ipairs(interfaceControls) do
	library:SetControlVisible(entry.control, watermark.Enabled, entry.item)
end
end

watermark.Callback = function(on)
library:ToggleWatermark(on)
refreshInterface()
end

refreshInterface()

local movementControls = {}

local function movementFeature(control, item)
table.insert(movementControls, { control = control, item = item or "Toggle" })
return control
end

local bhop = movement:Toggle({ Name = "Bhop", Flag = "Bhop", Default = false })
movementFeature(movement:Slider({ Name = "Speed", Flag = "BhopSpeed", Min = 1, Max = 10 }), "Slider")

movement:Toggle({ Name = "Auto jump", Flag = "AutoJump" })

local fakeDuck = movement:Toggle({ Name = "Fake duck", Flag = "FakeDuck" })

fakeDuck:Keybind({
	Name = "Fake duck";
	Flag = "FakeDuckBind";
})

local function refreshMovement()
local on = bhop.Enabled

for _, entry in ipairs(movementControls) do
	library:SetControlVisible(entry.control, on, entry.item)
end
end

bhop.Callback = refreshMovement
refreshMovement()

local configs = tabs.Configs:Section({ Name = "Config", Side = "Left" })

local flags = library.Flags
local configFolder = library.Directory .. "/configs"

local function configPath(name)
return configFolder .. "/" .. name .. ".cfg"
end

local function listConfigs()
local files = {}

if not listfiles then
	return files
end

for _, file in ipairs(listfiles(configFolder)) do
	local name = file:match("([^/\\]+)%.cfg$")

	if name then
		table.insert(files, name)
	end
end

return files
end

configs:Textbox({ Name = "Name", Flag = "ConfigName", PlaceHolder = "config name" })
local configList = configs:Dropdown({ Name = "Config", Flag = "ConfigList", Options = listConfigs(), Default = "none" })

local function notify(text)
	library.Notifications:Create({ Name = text, LifeTime = 3 })
end

local function refreshList()
	configList.RefreshOptions(listConfigs())
end

local function saveConfig(action)
	local name = flags.ConfigName

	if not name or name == "" then
		return
	end

	writefile(configPath(name), library:GetConfig())
	refreshList()
	configList.Set(name)
	notify(name .. " config " .. action)
end

configs:Button({
Name = "Load";
Callback = function()
local name = flags.ConfigList

		if name and isfile(configPath(name)) then
			library:LoadConfig(readfile(configPath(name)))
			notify(name .. " config loaded")
		end
end;
})

configs:Button({ Name = "Create", Callback = function()
	saveConfig("created")
end })

configs:Button({ Name = "Update", Callback = function()
	saveConfig("updated")
end })

configs:Button({
Name = "Delete";
Callback = function()
local name = flags.ConfigList or flags.ConfigName

		if name and isfile(configPath(name)) then
			delfile(configPath(name))
			refreshList()
			notify(name .. " config deleted")
		end
end;
})

configs:Button({
Name = "Import";
Callback = function()
local name = flags.ConfigName
local text

pcall(function()
text = getclipboard()
end)

		if not name or name == "" or not text or text == "" then
			return
		end

		writefile(configPath(name), text)
		refreshList()
		configList.Set(name)
		notify(name .. " config imported")
	end;
})

configs:Button({
Name = "Export";
Callback = function()
		pcall(function()
			setclipboard(library:GetConfig())
		end)

		notify("config exported")
	end;
})

for _, tab in tabs do
	for _, side in ipairs({ tab.Items.Left, tab.Items.Right }) do
		local sections = {}

		for _, child in ipairs(side:GetChildren()) do
			if child:IsA("Frame") then
				table.insert(sections, child)
			end
		end

		local count = #sections

		if count > 0 then
			local offset = count > 1 and -(19 * (count - 1)) / count or 0

			for _, section in ipairs(sections) do
				section.Size = UDim2.new(1, 0, 1 / count, offset)
			end
		end
	end
end

window.ToggleMenu(true)

library.Items.DisplayOrder = 1

local espGui = Instance.new("ScreenGui")
espGui.Name = "\0"
espGui.IgnoreGuiInset = true
espGui.ResetOnSpawn = false
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
	espGui.Parent = gethui()
end)

if not espGui.Parent then
	pcall(function()
		espGui.Parent = game:GetService("CoreGui")
	end)
end

local function playerRect(character, humanoid, currentCamera)
	local root = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")

	if not (root and head) then
		return nil
	end

	local topWorld = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
	local hipHeight = humanoid.HipHeight > 0 and humanoid.HipHeight or 2
	local bottomWorld = root.Position - Vector3.new(0, root.Size.Y / 2 + hipHeight, 0)

	local topPoint, topOn = currentCamera:WorldToViewportPoint(topWorld)
	local bottomPoint, bottomOn = currentCamera:WorldToViewportPoint(bottomWorld)

	if not (topOn and bottomOn and topPoint.Z > 0 and bottomPoint.Z > 0) then
		return nil
	end

	local height = bottomPoint.Y - topPoint.Y

	if height <= 0 then
		return nil
	end

	local centerWorld = (topWorld + bottomWorld) / 2
	local right = currentCamera.CFrame.RightVector
	local leftPoint = currentCamera:WorldToViewportPoint(centerWorld - right * 1.2)
	local rightPoint = currentCamera:WorldToViewportPoint(centerWorld + right * 1.2)
	local width = math.abs(rightPoint.X - leftPoint.X)

	if width <= 0 then
		width = height * 0.6
	end

	return {
		x = math.min(leftPoint.X, rightPoint.X);
		y = topPoint.Y;
		width = width;
		height = height;
	}
end

local boxes = {}

local function createBox()
	local shadow = Drawing.new("Square")
	shadow.Filled = false
	shadow.Thickness = 1.5
	shadow.Color = Color3.new(0, 0, 0)
	shadow.Transparency = 0.1
	shadow.Visible = false
	pcall(function()
		shadow.ZIndex = 2
	end)

	local box = Drawing.new("Square")
	box.Filled = false
	box.Thickness = 1
	box.Color = Color3.new(1, 1, 1)
	box.Visible = false
	pcall(function()
		box.ZIndex = 3
	end)

	local corner = {}
	local cornerOutline = {}
	for i = 1, 8 do
		cornerOutline[i] = Drawing.new("Square")
		cornerOutline[i].Filled = true
		cornerOutline[i].Color = Color3.new(0, 0, 0)
		cornerOutline[i].Visible = false
		pcall(function()
			cornerOutline[i].ZIndex = 2
		end)
	end

	for i = 1, 8 do
		corner[i] = Drawing.new("Square")
		corner[i].Filled = true
		corner[i].Color = Color3.new(1, 1, 1)
		corner[i].Visible = false
		pcall(function()
			corner[i].ZIndex = 3
		end)
	end

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.AutomaticSize = Enum.AutomaticSize.X
	nameLabel.AnchorPoint = Vector2.new(0.5, 1)
	nameLabel.Size = UDim2.new(0, 0, 0, 18)
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0.15
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.Visible = false
	nameLabel.ZIndex = 7
	nameLabel.Parent = espGui

	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.AutomaticSize = Enum.AutomaticSize.X
	distanceLabel.AnchorPoint = Vector2.new(0.5, 0)
	distanceLabel.Size = UDim2.new(0, 0, 0, 18)
	distanceLabel.TextColor3 = Color3.new(1, 1, 1)
	distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	distanceLabel.TextStrokeTransparency = 0.15
	distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
	distanceLabel.Visible = false
	distanceLabel.ZIndex = 7
	distanceLabel.Parent = espGui

	local heldItemLabel = Instance.new("TextLabel")
	heldItemLabel.BackgroundTransparency = 1
	heldItemLabel.AutomaticSize = Enum.AutomaticSize.X
	heldItemLabel.AnchorPoint = Vector2.new(0.5, 0)
	heldItemLabel.Size = UDim2.new(0, 0, 0, 18)
	heldItemLabel.TextColor3 = Color3.new(1, 1, 1)
	heldItemLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	heldItemLabel.TextStrokeTransparency = 0.15
	heldItemLabel.TextXAlignment = Enum.TextXAlignment.Center
	heldItemLabel.Visible = false
	heldItemLabel.ZIndex = 7
	heldItemLabel.Parent = espGui

	local healthShadow = Instance.new("Frame")
	healthShadow.BackgroundColor3 = Color3.new(0, 0, 0)
	healthShadow.BackgroundTransparency = 0.25
	healthShadow.Visible = false
	healthShadow.ZIndex = 3
	healthShadow.Parent = espGui

	local healthTrack = Instance.new("Frame")
	healthTrack.BackgroundColor3 = Color3.new(0, 0, 0)
	healthTrack.BorderSizePixel = 0
	healthTrack.ClipsDescendants = true
	healthTrack.Visible = false
	healthTrack.ZIndex = 4
	healthTrack.Parent = espGui

	local healthFill = Instance.new("Frame")
	healthFill.AnchorPoint = Vector2.new(0, 1)
	healthFill.Position = UDim2.new(0, 0, 1, 0)
	healthFill.Size = UDim2.new(1, 0, 1, 0)
	healthFill.BackgroundTransparency = 1
	healthFill.BorderSizePixel = 0
	healthFill.ClipsDescendants = true
	healthFill.ZIndex = 5
	healthFill.Parent = healthTrack

	local healthFillColor = Instance.new("Frame")
	healthFillColor.AnchorPoint = Vector2.new(0, 1)
	healthFillColor.Position = UDim2.new(0, 0, 1, 0)
	healthFillColor.BackgroundColor3 = Color3.new(1, 1, 1)
	healthFillColor.BorderSizePixel = 0
	healthFillColor.ZIndex = 6
	healthFillColor.Parent = healthFill

	local healthGradient = Instance.new("UIGradient")
	healthGradient.Rotation = 90
	healthGradient.Parent = healthFillColor

	return {
		box = box,
		shadow = shadow,
		corner = corner,
		cornerOutline = cornerOutline,
		nameLabel = nameLabel,
		distanceLabel = distanceLabel,
		heldItemLabel = heldItemLabel,
		healthShadow = healthShadow,
		healthTrack = healthTrack,
		healthFill = healthFill,
		healthFillColor = healthFillColor,
		healthGradient = healthGradient,
	}
end

local function hideCorners(entry)
	for i = 1, 8 do
		entry.corner[i].Visible = false
		entry.cornerOutline[i].Visible = false
	end
end

local function drawCornerBox(entry, x, y, width, height, color, transparency)
	local length = math.max(1, math.floor(math.min(width, height) * 0.25))
	local lines = {
		{ x - 1, y - 1, length + 1, 3, x, y, length, 1 },
		{ x - 1, y - 1, 3, length + 1, x, y, 1, length },
		{ x + width - length, y - 1, length + 1, 3, x + width - length, y, length, 1 },
		{ x + width - 2, y - 1, 3, length + 1, x + width - 1, y, 1, length },
		{ x - 1, y + height - 2, length + 1, 3, x, y + height - 1, length, 1 },
		{ x - 1, y + height - length, 3, length + 1, x, y + height - length, 1, length },
		{ x + width - length, y + height - 2, length + 1, 3, x + width - length, y + height - 1, length, 1 },
		{ x + width - 2, y + height - length, 3, length + 1, x + width - 1, y + height - length, 1, length },
	}

	for i, line in ipairs(lines) do
		local outline = entry.cornerOutline[i]
		local segment = entry.corner[i]
		outline.Position = Vector2.new(line[1], line[2])
		outline.Size = Vector2.new(line[3], line[4])
		outline.Visible = true
		segment.Position = Vector2.new(line[5], line[6])
		segment.Size = Vector2.new(line[7], line[8])
		segment.Color = color
		segment.Transparency = transparency
		segment.Visible = true
	end
end

local function isSameTeam(player)
	if lp.Team ~= nil and player.Team ~= nil and lp.Team == player.Team then
		return true
	end

	return not lp.Neutral and not player.Neutral and lp.TeamColor == player.TeamColor
end

local function updateBoxes()
	local enabled = library.Flags["Enable"] == true
	local boxEnabled = enabled and library.Flags["Box"] == true
	local boxStyleName = library.Flags["BoxStyle"] or "Normal"
	local healthBarEnabled = enabled and library.Flags["HealthBar"] == true
	local nameEnabled = enabled and library.Flags["Name"] == true
	local distanceEnabled = enabled and library.Flags["Distance"] == true
	local heldItemEnabled = enabled and library.Flags["HeldItem"] == true
	local chamsEnabled = enabled and library.Flags["Chams"] == true
	local teamCheck = library.Flags["TeamCheck"] == true
	local currentCamera = workspace.CurrentCamera
	local boxColor = boxColorPicker.Items.InnerObject.BackgroundColor3
	local boxTransparency = boxColorPicker.Items.InnerObject.BackgroundTransparency
	local nameColor = nameColorPicker.Items.InnerObject.BackgroundColor3
	local nameTransparency = nameColorPicker.Items.InnerObject.BackgroundTransparency
	local distanceColor = distanceColorPicker.Items.InnerObject.BackgroundColor3
	local distanceTransparency = distanceColorPicker.Items.InnerObject.BackgroundTransparency
	local heldItemColor = heldItemColorPicker.Items.InnerObject.BackgroundColor3
	local heldItemTransparency = heldItemColorPicker.Items.InnerObject.BackgroundTransparency
	local chamsFillColor = chamsFillColorPicker.Items.InnerObject.BackgroundColor3
	local fillAlpha = chamsFillColorPicker.Items.InnerObject.BackgroundTransparency
	local chamsOutlineColor = chamsOutlineColorPicker.Items.InnerObject.BackgroundColor3
	local outlineAlpha = chamsOutlineColorPicker.Items.InnerObject.BackgroundTransparency
	local healthLow = healthColorLow.Items.InnerObject.BackgroundColor3
	local healthBottomAlpha = healthColorLow.Items.InnerObject.BackgroundTransparency
	local healthHigh = healthColorHigh.Items.InnerObject.BackgroundColor3
	local healthTopAlpha = healthColorHigh.Items.InnerObject.BackgroundTransparency
	local localCharacter = lp.Character
	local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

	for _, player in ipairs(players:GetPlayers()) do
		local entry = boxes[player]

		if not entry then
			entry = createBox()
			boxes[player] = entry
		end

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		local visible = enabled
			and currentCamera ~= nil
			and player ~= players.LocalPlayer
			and humanoid ~= nil
			and humanoid.Health > 0

		if visible and teamCheck and isSameTeam(player) then
			visible = false
		end

		if chamsEnabled and visible then
			if not entry.highlight or entry.highlight.Adornee ~= character then
				if entry.highlight then
					entry.highlight:Destroy()
				end

				entry.highlight = Instance.new("Highlight")
				entry.highlight.Adornee = character
				entry.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				entry.highlight.Parent = workspace
			end

			entry.highlight.Enabled = true
			entry.highlight.FillColor = chamsFillColor
			entry.highlight.OutlineColor = chamsOutlineColor
			entry.highlight.FillTransparency = fillAlpha
			entry.highlight.OutlineTransparency = outlineAlpha
		elseif entry.highlight then
			entry.highlight.Enabled = false
		end

		local rect = visible and playerRect(character, humanoid, currentCamera) or nil

		if rect then
			local x = math.floor(rect.x)
			local y = math.floor(rect.y) - 2
			local width = math.floor(rect.width)
			local height = math.max(1, math.floor(rect.height) + 2)

			local showBox = boxEnabled and boxStyleName == "Normal"
			entry.box.Visible = showBox
			entry.shadow.Visible = showBox
			if boxEnabled then
				if boxStyleName == "Corner" then
					hideCorners(entry)
					drawCornerBox(entry, x, y, width, height, boxColor, boxTransparency)
				else
					hideCorners(entry)
					entry.box.Position = Vector2.new(x, y)
					entry.box.Size = Vector2.new(width, height)
					entry.box.Color = boxColor
					entry.box.Transparency = boxTransparency
					entry.shadow.Position = Vector2.new(x, y)
					entry.shadow.Size = Vector2.new(width, height)
				end
			else
				hideCorners(entry)
			end

			local centerX = x + width / 2
			entry.nameLabel.Visible = nameEnabled
			if nameEnabled then
				entry.nameLabel.Text = player.DisplayName
				entry.nameLabel.Position = UDim2.fromOffset(centerX, y - 2)
				entry.nameLabel.TextSize = 13
				entry.nameLabel.Font = Enum.Font.SourceSansBold
				entry.nameLabel.TextColor3 = nameColor
				entry.nameLabel.TextTransparency = nameTransparency
				entry.nameLabel.TextStrokeTransparency = math.max(0.15, nameTransparency)
			end

			entry.distanceLabel.Visible = distanceEnabled and localRoot ~= nil
			if entry.distanceLabel.Visible then
				local root = character:FindFirstChild("HumanoidRootPart")
				entry.distanceLabel.Text = tostring(math.floor((root.Position - localRoot.Position).Magnitude + 0.5))
				entry.distanceLabel.Position = UDim2.fromOffset(centerX, y + height + 2)
				entry.distanceLabel.TextSize = 13
				entry.distanceLabel.Font = Enum.Font.SourceSansBold
				entry.distanceLabel.TextColor3 = distanceColor
				entry.distanceLabel.TextTransparency = distanceTransparency
				entry.distanceLabel.TextStrokeTransparency = math.max(0.15, distanceTransparency)
			end

			local tool = character:FindFirstChildOfClass("Tool")
			entry.heldItemLabel.Visible = heldItemEnabled and tool ~= nil
			if entry.heldItemLabel.Visible then
				entry.heldItemLabel.Text = tool.Name
				entry.heldItemLabel.Position = UDim2.fromOffset(centerX, y + height + 2 + (entry.distanceLabel.Visible and 18 or 0))
				entry.heldItemLabel.TextSize = 13
				entry.heldItemLabel.Font = Enum.Font.SourceSansBold
				entry.heldItemLabel.TextColor3 = heldItemColor
				entry.heldItemLabel.TextTransparency = heldItemTransparency
				entry.heldItemLabel.TextStrokeTransparency = math.max(0.15, heldItemTransparency)
			end

			local healthRatio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
			entry.healthShadow.Visible = healthBarEnabled
			entry.healthTrack.Visible = healthBarEnabled
			if healthBarEnabled then
				local barWidth = math.clamp(height * 0.012, 1, 2)
				local barX = x - barWidth - 2
				entry.healthShadow.Position = UDim2.fromOffset(barX - 1, y - 1)
				entry.healthShadow.Size = UDim2.fromOffset(barWidth + 2, height + 2)
				entry.healthTrack.Position = UDim2.fromOffset(barX, y)
				entry.healthTrack.Size = UDim2.fromOffset(barWidth, height)
				entry.healthFill.Size = UDim2.new(1, 0, healthRatio, 0)
				entry.healthFillColor.Size = UDim2.new(1, 0, 0, height)
				entry.healthGradient.Color = ColorSequence.new(healthLow, healthHigh)
				entry.healthGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, healthBottomAlpha),
					NumberSequenceKeypoint.new(1, healthTopAlpha),
				})
			end
		else
			entry.box.Visible = false
			entry.shadow.Visible = false
			hideCorners(entry)
			entry.nameLabel.Visible = false
			entry.distanceLabel.Visible = false
			entry.heldItemLabel.Visible = false
			entry.healthShadow.Visible = false
			entry.healthTrack.Visible = false
		end
	end

	for player, entry in pairs(boxes) do
		if player.Parent == nil then
			entry.box:Remove()
			entry.shadow:Remove()
			for i = 1, 8 do
				entry.corner[i]:Remove()
				entry.cornerOutline[i]:Remove()
			end
			entry.nameLabel:Destroy()
			entry.distanceLabel:Destroy()
			entry.heldItemLabel:Destroy()
			if entry.highlight then
				entry.highlight:Destroy()
			end
			entry.healthShadow:Destroy()
			entry.healthTrack:Destroy()
			boxes[player] = nil
		end
	end
end

library:Connection(runService.RenderStepped, updateBoxes)

local droppedItemLabels = {}
local droppedUpdateTime = 0

local function updateDroppedItems(deltaTime)
	droppedUpdateTime += deltaTime
	local updatePosition = droppedUpdateTime >= 1 / 30
	if updatePosition then
		droppedUpdateTime %= 1 / 30
	end
	local enabled = droppedItem.Enabled
	local currentCamera = workspace.CurrentCamera
	local debris = workspace:FindFirstChild("Debris")
	local weapons = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
	local color = droppedItemColorPicker.Items.InnerObject.BackgroundColor3
	local transparency = droppedItemColorPicker.Items.InnerObject.BackgroundTransparency

	if updatePosition then
		local active = {}

		if enabled and currentCamera and debris and weapons then
			for _, item in ipairs(debris:GetChildren()) do
				if item:IsA("BasePart") and weapons:FindFirstChild(item.Name) and not item:FindFirstChild("PickedUp") then
					active[item] = true
					local entry = droppedItemLabels[item]

					if not entry then
						local label = Instance.new("TextLabel")
						label.BackgroundTransparency = 1
						label.AutomaticSize = Enum.AutomaticSize.X
						label.AnchorPoint = Vector2.new(0.5, 1)
						label.Size = UDim2.new(0, 0, 0, 18)
						label.TextStrokeColor3 = Color3.new(0, 0, 0)
						label.TextXAlignment = Enum.TextXAlignment.Center
						label.Font = Enum.Font.SourceSansBold
						label.TextSize = 13
						label.ZIndex = 7
						label.Parent = espGui
						entry = { label = label }
						droppedItemLabels[item] = entry
					end

					local point, onScreen = currentCamera:WorldToViewportPoint(item.Position)
					entry.position = UDim2.fromOffset(point.X, point.Y - 2)
					entry.visible = onScreen and point.Z > 0
					entry.label.Position = entry.position
				end
			end
		end

		for item, entry in pairs(droppedItemLabels) do
			if not active[item] then
				if item.Parent ~= debris then
					entry.label:Destroy()
					droppedItemLabels[item] = nil
				else
					entry.visible = false
					entry.position = nil
				end
			end
		end
	end

	for item, entry in pairs(droppedItemLabels) do
		local label = entry.label
		label.Text = item.Name
		label.TextColor3 = color
		label.TextTransparency = transparency
		label.TextStrokeTransparency = math.max(0.15, transparency)
		label.Visible = enabled and currentCamera ~= nil and item.Parent == debris and not item:FindFirstChild("PickedUp") and entry.visible == true
	end
end

library:Connection(runService.RenderStepped, updateDroppedItems)

