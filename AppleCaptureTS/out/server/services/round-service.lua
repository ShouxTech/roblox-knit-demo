-- Compiled with roblox-ts v1.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _0 = TS.import(script, TS.getModule(script, "knit").src)
local Knit = _0.KnitServer
local RemoteSignal = _0.RemoteSignal
local AppleGenerationService
local INTERMISSION_TIME = 10
local ROUND_TIME = 30
local INTERMISSION_EVENT_NAME = "Intermission"
local ROUND_EVENT_NAME = "Round"
local COLLECTED_EVENT_NAME = "Collected"
local WINNER_CHOSEN_EVENT_NAME = "WinnerChosen"
local RoundService = Knit.CreateService({
	Name = "RoundService",
	Client = {
		RoundInfo = RemoteSignal.new(),
	},
	getWinner = function(self)
		local winner
		local mostCollectedApples = 0
		for plr, collectedApples in pairs(AppleGenerationService.appleCollectors) do
			if collectedApples > mostCollectedApples then
				winner = plr
				mostCollectedApples = collectedApples
			end
		end
		return { winner, mostCollectedApples }
	end,
	startIntermission = function(self)
		do
			local _1 = INTERMISSION_TIME
			while _1 > 0 do
				local i = _1
				self.Client.RoundInfo:FireAll(INTERMISSION_EVENT_NAME, i)
				wait(1)
				_1 = i
				_1 -= 1
			end
		end
	end,
	startRound = function(self)
		local roundInfoEvent = self.Client.RoundInfo
		AppleGenerationService:startGeneration()
		do
			local _1 = ROUND_TIME
			while _1 > 0 do
				local i = _1
				roundInfoEvent:FireAll(ROUND_EVENT_NAME, i)
				wait(1)
				_1 = i
				_1 -= 1
			end
		end
		AppleGenerationService:stopGenerationAndClearApples()
		roundInfoEvent:FireAll(COLLECTED_EVENT_NAME, 0)
		local _1 = self:getWinner()
		local winner = _1[1]
		local mostCollectedApples = _1[2]
		local _2 = roundInfoEvent
		local _3 = winner
		if _3 ~= nil then
			_3 = _3.Name
		end
		_2:FireAll(WINNER_CHOSEN_EVENT_NAME, _3, mostCollectedApples)
		AppleGenerationService:resetAppleCollectors()
		wait(3)
	end,
	appleCollected = function(self, plr, collectedApples)
		self.Client.RoundInfo:Fire(plr, COLLECTED_EVENT_NAME, collectedApples)
	end,
	KnitStart = function(self)
		coroutine.wrap(function()
			while true do
				self:startIntermission()
				self:startRound()
			end
		end)()
	end,
	KnitInit = function(self)
		AppleGenerationService = Knit.Services.AppleGenerationService
	end,
})
return RoundService
