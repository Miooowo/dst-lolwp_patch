---@class components
---@field lolwp_patch_tradeable component_lolwp_patch_tradeable # 不用管我(这个组件是为 通用交易 功能服务的 )

---@class component_lolwp_patch_tradeable
---@field inst ent
local lolwp_patch_tradeable = Class(
---@param self component_lolwp_patch_tradeable
---@param inst ent
function(self, inst)
    self.inst = inst
end,
nil,
{
})

return lolwp_patch_tradeable