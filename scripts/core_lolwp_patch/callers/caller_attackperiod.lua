---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lolwp_patch'

local data = _require('core_'..modid..'/data/attackperiod')

API.ATKPERIOD:main(data)