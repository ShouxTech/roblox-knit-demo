local Knit = require(game:GetService('ReplicatedStorage').Knit);

Knit.Modules = script.Parent.Modules;

for i, v in next, script.Parent.Controllers:GetDescendants() do
    if v:IsA('ModuleScript') then
        require(v);
    end;
end;

Knit.Start():Catch(warn);