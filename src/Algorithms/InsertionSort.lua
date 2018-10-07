local COLOR = Color3.new(0, 1, 0)

local InsertionSort = {}

function InsertionSort.Do(accessor)
	local marker = 1

	for index = 2, accessor.length do
		for checkSorted = marker, 1, -1 do
			local us, them = accessor:Transaction({
				accessor:CreateIndex(index),
				accessor:CreateIndex(checkSorted)
			})

			if us < them then
				accessor:Swap(index, checkSorted)
				index = checkSorted
			else
				break
			end
		end

		marker = marker + 1
	end
end

return InsertionSort
