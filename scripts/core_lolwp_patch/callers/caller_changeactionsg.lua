---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lolwp_patch'

local data = _require('core_'..modid..'/data/changeactionsg')

API.CHANGEACTIONSG:main(data)