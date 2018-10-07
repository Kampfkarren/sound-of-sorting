local Frame = script.Parent.Parent.Frame
local Source = script.Parent

local Util = require(Source.Util)

local Algorithms = Source.Algorithms
local Display = Frame.Display
local Menu = Frame.Menu

local Inner = Frame.Menu.Inner

local InnerMenuButtonTemplate = Inner.Template

local algorithms = {}
local currentAlgorithm

local function setVisible(shouldSeeDisplay)
	Display.Visible = shouldSeeDisplay
	Menu.Visible = not shouldSeeDisplay

	if currentAlgorithm and not shouldSeeDisplay then
		currentAlgorithm:Destroy()
	end
end

setVisible(false)

Display.Back.MouseButton1Click:connect(function()
	setVisible(false)
end)

for _, algorithm in pairs(Algorithms:GetChildren()) do
	algorithms[algorithm.Name] = require(algorithm)
end

-- Generate menu buttons for each algorithm
for name, algorithm in pairs(algorithms) do
	local button = InnerMenuButtonTemplate:Clone()

	button.Name = name
	button.Text = name
	button.Visible = true

	button.MouseButton1Click:connect(function()
		setVisible(true)
		currentAlgorithm = Util.SetupGraph()
		algorithm.Do(currentAlgorithm)
	end)

	button.Parent = Inner
end
