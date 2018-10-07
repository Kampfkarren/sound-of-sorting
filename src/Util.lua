local Util = {}

local Frame = script.Parent.Parent.Frame

local Display = Frame.Display

local Graph = Display.Graph

local graphEntry = Instance.new("Frame")
graphEntry.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
graphEntry.BorderSizePixel = 0

local ENTRIES_IN_ARRAY = 125
local RANDOM_SEED = 0xDEADBEEF

-- This makes sure all algorithms use the same shuffled set of numbers.
local shuffledNumbers = {}
local shuffleRandom = Random.new(RANDOM_SEED)

-- Fisher-Yates shuffle
for number = 1,ENTRIES_IN_ARRAY do
	shuffledNumbers[number] = number
end

for number = ENTRIES_IN_ARRAY,1,-1 do
	local swap = shuffleRandom:NextInteger(1, number)
	shuffledNumbers[number], shuffledNumbers[swap] = shuffledNumbers[swap], shuffledNumbers[number]
end

Util.Accessor = require(script.Parent.Accessor)

function Util.SetupGraph()
	-- Clear old entries
	for _, thing in pairs(Graph:GetChildren()) do
		if thing:IsA("Frame") then
			thing:Destroy()
		end
	end

	local entries = {}

	-- Add entries
	for number = 1, ENTRIES_IN_ARRAY do
		local entry = graphEntry:Clone()
		local shuffle = shuffledNumbers[number]
		entry.LayoutOrder = number
		entry.Name = shuffle
		entry.Size = UDim2.new(1 / ENTRIES_IN_ARRAY, 0, shuffle / ENTRIES_IN_ARRAY, 0)
		entry.Parent = Graph
		entries[number] = entry
	end

	return Util.Accessor.new(entries, Display.AccessorInfo)
end

return Util
