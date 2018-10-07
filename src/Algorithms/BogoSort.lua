local BogoSort = {}

function BogoSort.Shuffle(accessor)
	for number = accessor.length,1,-1 do
		local swap = Random.new():NextInteger(1, number)
		accessor:Swap(number, swap)
	end
end

function BogoSort.Sorted(accessor)
	for index = 1, accessor.length - 1 do
		local here, there = accessor:Transaction({
			accessor:CreateIndex(index),
			accessor:CreateIndex(index + 1)
		})

		if here > there then
			return false
		end
	end

	return true
end

function BogoSort.Do(accessor)
	while not BogoSort.Sorted(accessor) do
		BogoSort.Shuffle(accessor)
	end
end

return BogoSort
