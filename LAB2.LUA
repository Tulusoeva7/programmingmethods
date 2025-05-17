function generateSteps(N)
    local steps = {}
    local step = 1
    while step < N do
        table.insert(steps, step)
        step = step * 2
    end
    return steps
end

function sortWithSteps(arr, steps)
    local comparisons = 0
    for _, step in ipairs(steps) do
        for i = step + 1, #arr do
            local j = i
            while j > step and arr[j] < arr[j - step] do
                arr[j], arr[j - step] = arr[j - step], arr[j]
                j = j - step
                comparisons = comparisons + 1
            end
            comparisons = comparisons + math.floor((i - 1) / step)
        end
    end
    return arr, comparisons
end

math.randomseed(os.time())
local N = 10
local arr = {}
for i = 1, N do
    arr[i] = math.random(0, 99)
end

print("Исходный массив:")
for _, v in ipairs(arr) do
    io.write(v .. " ")
end
print()

local steps = generateSteps(N)
print("Массив шагов:")
for _, v in ipairs(steps) do
    io.write(v .. " ")
end
print()

local sortedArr, comparisons = sortWithSteps({table.unpack(arr)}, steps)

print("Отсортированный массив:")
for _, v in ipairs(sortedArr) do
    io.write(v .. " ")
end
print()

print("Количество сравнений:", comparisons)
