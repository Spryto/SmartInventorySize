-- support for high inserter stack size bonus in bobs
local minimumStackSize = 10



local stackSizeMultiplier = 1
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local numRecipes = tablelength(data.raw["recipe"])
local numItems = tablelength(data.raw["item"])
if (numRecipes > 1000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end
if (numRecipes > 5000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end
if (numRecipes > 10000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end
if (numItems > 1000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end
if (numItems > 5000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end
if (numItems > 10000) then
	stackSizeMultiplier = stackSizeMultiplier + 1
end


-- Recipe
local recipeCount = {}
local recipeSum = {}

for recipeName, recipe in pairs (data.raw["recipe"]) do
	for index, ingredient in pairs(recipe.ingredients) do
		local name = ingredient.name or ingredient[1]
		local amount = ingredient.amount or ingredient[2]
		if (recipeSum[name] ~= nil) then
        	recipeSum[name] = recipeSum[name] + amount
        	recipeCount[name] = recipeCount[name] + 1
        else
        	recipeSum[name] = amount
        	recipeCount[name] = 1
        end
	end
end 

local recipeAverage = {}
for ingredientName, sum in pairs(recipeSum) do
	recipeAverage[ingredientName] = sum / recipeCount[ingredientName] 
end

-- Science ingredients
local scienceSum = {}
local scienceCount = {}

for techname, tech in pairs(data.raw["technology"]) do
 	for index, ingredient in pairs(tech.unit.ingredients) do

 		if (scienceSum[ingredient[1]] ~= nil) then
        	scienceSum[ingredient[1]] = scienceSum[ingredient[1]] + (ingredient[2] * tech.unit.count)
        	scienceCount[ingredient[1]] = scienceCount[ingredient[1]] + 1
        else
        	scienceSum[ingredient[1]] = (ingredient[2] * tech.unit.count)
        	scienceCount[ingredient[1]] = 1
        end
    end
end

local scienceAverage = {}
for ingredientName, sum in pairs(scienceSum) do
	scienceAverage[ingredientName] = scienceSum[ingredientName] / scienceCount[ingredientName] 
end		

local minimumForScience = 200
local minimumForIngredient = 50
function FindNiceStackSizeForRecipe(original, scienceCount, scienceAverage, recipeCount, recipeAverage)
	local size = math.max(minimumStackSize, original*stackSizeMultiplier)


	if (scienceCount ~= nil) then
		size = math.max(size, math.max(minimumForScience, math.max(math.sqrt(scienceAverage), scienceCount)))
	end

	if (recipeCount ~= nil) then
		size = math.max(size, math.max(minimumForIngredient, math.max(recipeAverage, recipeCount)))
	end

	-- find 'nice' size
	if (size <= minimumStackSize) then
		return minimumStackSize
	end
	if (size <= 25) then
		return 25
	end
	if (size <= 50) then
		return 50
	end
	if (size <= 100) then
		return 100
	end
	if (size <= 200) then
		return 200
	end
	if (size <= 500) then
		return 500
	end
	if (size <= 1000) then
		return 1000
	end
	if (size <= 2000) then
		return 2000
	end
	if (size <= 5000) then
		return 5000
	end
	if (size <= 10000) then
		return 10000
	end
	if (size <= 20000) then
		return 20000
	end
	if (size <= 50000) then
		return 50000
	end
	if (size <= 100000) then
		return 100000
	end
	if (size <= 200000) then
		return 200000
	end
	if (size <= 500000) then
		return 500000
	end
end

for itemName, item in pairs(data.raw["item"]) do
	item.stack_size = FindNiceStackSizeForRecipe(item.stack_size, scienceCount[recipeName], scienceAverage[recipeName], recipeCount[recipeName], recipeAverage[recipeName])

end

for itemName, item in pairs(data.raw["tool"]) do
	item.stack_size = FindNiceStackSizeForRecipe(item.stack_size, scienceCount[recipeName], scienceAverage[recipeName], recipeCount[recipeName], recipeAverage[recipeName])
end

for itemName, item in pairs(data.raw["item-with-entity-data"]) do
	item.stack_size = FindNiceStackSizeForRecipe(item.stack_size, scienceCount[recipeName], scienceAverage[recipeName], recipeCount[recipeName], recipeAverage[recipeName])
end

for itemName, item in pairs(data.raw["ammo"]) do
	item.stack_size = item.stack_size * 2
end

for itemName, item in pairs(data.raw["capsule"]) do
	item.stack_size = item.stack_size * 2
end

for itemName, item in pairs(data.raw["module"]) do
	item.stack_size = item.stack_size * 2
end

data.raw["rail-planner"].rail.stack_size = 400 -- todo use a better estimate of how much distance trains will need to cover


local inventorySize = data.raw["player"]["player"].inventory_size

if (numRecipes> 500) then
	inventorySize = inventorySize + 10
end
if (numRecipes > 1000) then
	inventorySize = inventorySize + 10
end
if (numRecipes > 2000) then
	inventorySize = inventorySize + 10
end
if (numRecipes > 5000) then
	inventorySize = inventorySize + 10
end
if (numRecipes > 10000) then
	inventorySize = inventorySize + 10
end

if (numItems > 1000) then
	inventorySize = inventorySize + 20
end
if (numItems > 2000) then
	inventorySize = inventorySize + 20
end
if (numItems > 3000) then
	inventorySize = inventorySize + 20
end
if (numItems > 4000) then
	inventorySize = inventorySize + 20
end
if (numItems > 5000) then
	inventorySize = inventorySize + 20
end
if (numItems > 7500) then
	inventorySize = inventorySize + 20
end
if (numItems > 10000) then
	inventorySize = inventorySize + 20
end
data.raw["player"]["player"].inventory_size = inventorySize