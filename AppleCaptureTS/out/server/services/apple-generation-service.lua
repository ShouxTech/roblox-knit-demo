-- Compiled with roblox-ts v1.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _0 = TS.import(script, TS.getModule(script, "knit").src)
local Knit = _0.KnitServer
local Maid = _0.Maid
local _1 = TS.import(script, TS.getModule(script, "services"))
local Players = _1.Players
local ServerStorage = _1.ServerStorage
local Workspace = _1.Workspace
local RoundService
local applePrefab = ServerStorage:FindFirstChild("Apple")
local appleHalfHeight = applePrefab.Size.Y * 0.5
local baseplate = Workspace:FindFirstChild("Baseplate")
local baseplateHalfWidth = baseplate.Size.X / 2
local baseplateHalfHeight = baseplate.Size.Y / 2
local AppleGenerationService = Knit.CreateService({
	Name = "AppleGenerationService",
	appleCollectors = {},
	maid = Maid.new(),
	Client = {},
	resetAppleCollectors = function(self)
		-- ▼ Map.clear ▼
		table.clear(self.appleCollectors)
		-- ▲ Map.clear ▲
	end,
	startGeneration = function(self)
		do
			local _2 = 0
			while _2 < 45 do
				local i = _2
				local collected = false
				local apple = applePrefab:Clone()
				local applePos = Vector3.new(math.random(-baseplateHalfWidth, baseplateHalfWidth), baseplateHalfHeight + appleHalfHeight, math.random(-baseplateHalfWidth, baseplateHalfWidth))
				apple.Position = applePos
				apple.Parent = Workspace
				apple.Touched:Connect(function(instance)
					local _3 = instance.Position
					local _4 = apple.Position
					local _5 = ((_3 - _4).Magnitude > 5)
					if not _5 then
						_5 = collected
					end
					if _5 then
						return nil
					end
					local plr = Players:GetPlayerFromCharacter(instance.Parent)
					if not plr then
						return nil
					end
					collected = true
					apple:Destroy()
					local _6 = self.appleCollectors
					local _7 = plr
					local collectedApples = _6[_7]
					collectedApples = collectedApples ~= 0 and collectedApples == collectedApples and collectedApples and collectedApples + 1 or 1
					local _8 = self.appleCollectors
					local _9 = plr
					local _10 = collectedApples
					-- ▼ Map.set ▼
					_8[_9] = _10
					-- ▲ Map.set ▲
					RoundService:appleCollected(plr, collectedApples)
				end)
				self.maid:GiveTask(apple)
				_2 = i
				_2 += 1
			end
		end
	end,
	stopGenerationAndClearApples = function(self)
		self.maid:DoCleaning()
	end,
	KnitInit = function(self)
		RoundService = Knit.Services.RoundService
	end,
})
return AppleGenerationService
