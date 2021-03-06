-- Compiled with roblox-ts v1.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Knit = TS.import(script, TS.getModule(script, "knit").src).KnitServer
local _0 = script.Parent
if _0 ~= nil then
	_0 = _0:FindFirstChild("services")
end
local modules = _0:GetDescendants()
for _, module in ipairs(modules) do
	if module:IsA("ModuleScript") then
		require(module)
	end
end
Knit.Start():catch(warn)
