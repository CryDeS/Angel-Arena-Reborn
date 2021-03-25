require('lib/random/random_types')

RandomGeneratorFactory = RandomGeneratorFactory or class({})

local factoryData = {
	["uniform"] = random_std_uniform,
	["normal"]  = random_normal
}

function RandomGeneratorFactory:GetGenerator(name)
	return factoryData[name]
end