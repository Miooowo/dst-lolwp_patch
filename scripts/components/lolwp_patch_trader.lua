local trade_data = require('core_lolwp_patch/data/trade')

---@class components
---@field lolwp_patch_trader component_lolwp_patch_trader # 不用管我(这个组件是为 通用交易 功能服务的 ) <br> `禁止`自己添加这个组件, 方法可以调用

local function on_val(self, value)
    self.inst.replica.lolwp_patch_trader.val:set(value)
end

---@class component_lolwp_patch_trader
---@field inst ent
---@field val string
---@field _last_decode_res integer[]|nil
local lolwp_patch_trader = Class(
---@param self component_lolwp_patch_trader
---@param inst ent
function(self, inst)
    self.inst = inst
    self.val = ''
    self._last_decode_res = nil
end,
nil,
{
    val = on_val,
})

function lolwp_patch_trader:OnSave()
    local data = {}
    data.val = self.val
    return data
end

function lolwp_patch_trader:OnLoad(data)
    self.val = data.val or ''

    self._last_decode_res = self:decode(self.val)
    if self._last_decode_res then
        for i,num in ipairs(self._last_decode_res) do
            local fn_load = trade_data.main[self.inst.prefab][i].fn_load
            if fn_load then
                fn_load(self.inst,num)
            end
        end
    end
end

---通过交易获得了一个物品
---@param item ent
---@param doer ent
---@return boolean
function lolwp_patch_trader:AddOne(item,doer)
    local fixed = trade_data.map[self.inst.prefab] and trade_data.map[self.inst.prefab][item.prefab] or nil
    if fixed then
        local i,max = fixed.index,fixed.max
        local args = self._last_decode_res or self:decode(self.val)
        args[i] = (args[i] or 0) + 1
        local fn = fixed.fn
        fn(item,self.inst,doer,args[i])
        self.val = self:encode(nil,args)
        self._last_decode_res = args

        SUGAR_lolwp_patch:consumeOneItem(item)
    end
    return true
end

---获取某个物品的当前数量
---@param prefab PrefabID
---@return integer
---@nodiscard
function lolwp_patch_trader:GetCurrentNum(prefab)
    local index = trade_data.map[self.inst.prefab][prefab].index
    if self._last_decode_res then
        return self._last_decode_res[index] or 0
    else
        return self:decode(self.val)[index] or 0
    end
end

---comment
---@param encoded_str string
---@param separator '|'|nil
---@return integer[]
---@nodiscard
function lolwp_patch_trader:decode(encoded_str, separator)
    local parts = {}
    for part in string.gmatch(encoded_str, "[^" .. (separator or '|') .. "]+") do
        table.insert(parts, tonumber(part))
    end
    return parts
end

---comment
---@param separator '|'|nil 
---@param args integer[]
---@return string
---@nodiscard
function lolwp_patch_trader:encode(separator, args)
    for i, v in ipairs(args) do
        args[i] = v
    end
    return table.concat(args, separator or '|')
end

return lolwp_patch_trader