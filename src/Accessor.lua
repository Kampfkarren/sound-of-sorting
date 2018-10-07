local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local Boop = SoundService.Boop

local ACCESSOR_LABEL_FORMAT = "Indexes: %d, Swaps: %d"
local COLOR_DEFAULT = Color3.new(0.8, 0.8, 0.8)
local COLOR_INDEX = Color3.new(1, 0, 0)
local COLOR_SWAP = Color3.new(0, 0, 1)
local INTERVAL_STEPS = 1
local TRANSACTION_INDEX = "INDEX"
local TRANSACTION_SET = "SET"
local TRANSACTION_SWAP = "SWAP"

local Accessor = {}
Accessor.__index = Accessor

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function playSound(value, size)
	local boop = Boop:Clone()
	boop.PitchShift.Octave = lerp(0.5, 2, value / size)
	boop.Parent = workspace
	boop:Play()
	Debris:AddItem(boop, 0.5)
end

function Accessor:CreateIndex(index)
	return {
		transaction = TRANSACTION_INDEX,
		index = index
	}
end

function Accessor:Index(index)
	return self:Transaction({
		self:CreateIndex(index)
	})
end

function Accessor:CreateSwap(index1, index2)
	return {
		transaction = TRANSACTION_SWAP,
		index1 = index1,
		index2 = index2
	}
end

function Accessor:Swap(index1, index2)
	return self:Transaction({
		self:CreateSwap(index1, index2)
	})
end

function Accessor:CreateSet(index, value)
	return {
		transaction = TRANSACTION_SET,
		index = index,
		value = value
	}
end

function Accessor:Set(index, value)
	return self:Transaction({
		self:CreateSet(index, value)
	})
end

function Accessor:SetMark(key, index, color)
	if self.marks[key] then
		self.marks[key].BackgroundColor3 = COLOR_DEFAULT
		self.marked[self.marks[key]] = nil
	end

	if index then
		local entry = self.entries[index]
		entry.BackgroundColor3 = color
		self.marked[entry] = true
		self.marks[key] = entry
	end
end

function Accessor:Destroy()
	self.destroyed = true
end

function Accessor:Transaction(transaction)
	if self.destroyed then
		-- Easiest way to make the function uses the Accessor stop working...error!
		error("Transaction after destruction (this is normal).")
	end

	for _, reset in pairs(self.resetColor) do
		if not self.marked[reset] then
			reset.BackgroundColor3 = COLOR_DEFAULT
		end
	end

	self.resetColor = {}

	local values = {}

	for _, action in pairs(transaction) do
		local value

		if action.transaction == TRANSACTION_INDEX then
			local entry = self.entries[action.index]
			value = tonumber(entry.Name)
			entry.BackgroundColor3 = COLOR_INDEX
			self.resetColor[#self.resetColor + 1] = entry
			playSound(value, self.length)
			self.indexes = self.indexes + 1
		elseif action.transaction == TRANSACTION_SWAP then
			local entry1, entry2 = self.entries[action.index1], self.entries[action.index2]
			entry1.LayoutOrder, entry2.LayoutOrder = entry2.LayoutOrder, entry1.LayoutOrder
			self.entries[entry1.LayoutOrder], self.entries[entry2.LayoutOrder] = entry1, entry2
			self.swaps = self.swaps + 1
			playSound(entry1.LayoutOrder, self.length)
			playSound(entry2.LayoutOrder, self.length)
			entry1.BackgroundColor3 = COLOR_SWAP
			entry2.BackgroundColor3 = COLOR_SWAP
			self.resetColor[#self.resetColor + 1] = entry1
			self.resetColor[#self.resetColor + 1] = entry2
		elseif action.transaction == TRANSACTION_SET then
			local entry = self.entries[action.index]
			entry.LayoutOrder = action.value
			self.entries[action.value] = entry
		end

		values[#values + 1] = value
	end

	self.label.Text = ACCESSOR_LABEL_FORMAT:format(self.indexes, self.swaps)

	for _ = 1, INTERVAL_STEPS do
		RunService.Stepped:wait()
	end

	return unpack(values)
end

function Accessor.new(entries, label)
	label.Text = ACCESSOR_LABEL_FORMAT:format(0, 0)

	return setmetatable({
		indexes = 0,
		entries = entries,
		label = label,
		length = #entries,
		marked = {},
		marks = {},
		resetColor = {},
		swaps = 0,
	}, Accessor)
end

return Accessor
