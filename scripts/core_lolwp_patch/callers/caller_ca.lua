---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lolwp_patch'

local data,change = _require('core_'..modid..'/data/componentactions')

API.CA:main(data,change)