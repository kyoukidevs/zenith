-- // Special Utils For Library, etc.
-- // Updated: 21.02.2026

return function(IsStudio)
	--#region Variables
	local DataModel = game 

	local cloneref, gethui 

	if IsStudio then
		gethui = function()
			return script.Parent 
		end

		cloneref = function(reference)
			return reference 
		end
	end

	local GetService = function(Name)
		return cloneref(DataModel:GetService(Name))
	end

	local Services = {}

	for _, Name in {"Players","TweenService","CoreGui","Workspace","ReplicatedStorage","ReplicatedFirst","RunService","UserInputService","HttpService","TextService"} do
		Services[Name] = GetService(Name)
	end

	local Client = Services.Players.LocalPlayer 
	local Mouse = Client:GetMouse()
	local Camera = Services.Workspace.CurrentCamera

	local Utility = {}

	Utility.__index = Utility 
	
	--#endregion Variables
	
	--#region Functions

	Utility.MakeDraggable = function(self, Instance)
		print("ok")
		if not Instance or typeof(Instance) ~= "Instance" or not Instance:IsA("GuiObject") then
			print("not ok")
			return 
		end

		local Dragging = false 
		local StartPos = nil  
		local InputPos = nil 
		local UIS = Services.UserInputService 

		local Update = function(Input)
			local Delta = Input.Position - InputPos 

			Instance.Position = UDim2.new(StartPos.X.Scale,StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end

		UIS.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = false 
			end
		end)

		UIS.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
				Update(Input)
			end
		end)

		Instance.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				InputPos = Input.Position
				Dragging = true 
				StartPos = Instance.Position
			end
		end)
	end

	Utility.Round = function(self, Value, Decimals)
		return math.round(Value / Decimals) * Decimals 
	end

	Utility.CommaValue = function(self, Value, Decimals)
		if Decimals < 1 then
			return string.format("%.2f", Value)
		else
			return tostring(math.floor(Value + 0.5))
		end
	end

	Utility.SafeCall = function(self, Callback, ...)
		local Success, Error = pcall(Callback, ...)

		if not Success and Error then
			warn("Zenith Stack Begin\nCall Failed: "..Error.."\nZenith Stack End")
			return false 
		end

		return true, ...
	end
	
	--#endregion Functions
	
	return Utility 
end
