local SelectionSort = {}

local MARK_COLOR = Color3.new(0, 1, 0)

function SelectionSort.Do(accessor)
	for startIndex = 1, accessor.length do
		local minimum = startIndex
		local atMinimum = accessor:Index(minimum)

		accessor:SetMark("Minimum", minimum, MARK_COLOR)

		for index = startIndex + 1, accessor.length do
			local atThisIndex = accessor:Index(index)

			if atMinimum > atThisIndex then
				minimum = index
				atMinimum = atThisIndex
				accessor:SetMark("Minimum", minimum, MARK_COLOR)
			end
		end

		accessor:Swap(minimum, startIndex)
	end
end

return SelectionSort
