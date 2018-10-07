local BubbleSort = {}

function BubbleSort.Do(accessor)
	for endIndex = accessor.length - 1, 1, -1 do
		for index = 1, endIndex do
			local number1, number2 = accessor:Transaction({
				accessor:CreateIndex(index),
				accessor:CreateIndex(index + 1)
			})

			if number1 > number2 then
				accessor:Swap(index, index + 1)
			end
		end
	end
end

return BubbleSort
