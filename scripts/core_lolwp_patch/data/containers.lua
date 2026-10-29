---@diagnostic disable: lowercase-global, undefined-global, trailing-space

---@type data_containerUI
local params = {}

-- ==================== 通用配置 ====================

-- ✅ 全局可放行的标签（优先级高）
local ACCEPT_TAGS = rawget(_G, "LOLWP_CONTAINER_ACCEPT_TAGS") or {
    "weapon", "armor",
    "flute", -- 排箫
    "explosive", -- 火药
    "trap", -- 陷阱
    "boatcannon_ammo", -- 船炮弹药
    "mine", -- 地雷
    "gestaltprotection", -- 启迪头冠类
    "amulet", --护符类
}

-- ✅ 可放行的预制物列表（火魔杖等）
local ACCEPT_PREFABS = rawget(_G, "LOLWP_CONTAINER_ACCEPT_PREFABS") or {
    "amulet", -- 红护符
    "blueamulet", -- 蓝护符
    "purpleamulet",
    "orangeamulet",
    "greenamulet",
    "yellowamulet", -- 魔光护符
    ---
    "opalstaff", --唤月
    "yellowstaff",
    "telestaff", -- 传送
    "greenstaff",


}

-- 检测是否有可接受的标签
local function item_has_any_accept_tag(item)
    if not item then
        return false
    end
    for i = 1, #ACCEPT_TAGS do
        if item:HasTag(ACCEPT_TAGS[i]) then
            return true
        end
    end
    return false
end

-- 检测是否在可接受的预制物白名单中
local function item_is_accepted_prefab(item)
    if not item or not item.prefab then
        return false
    end
    for i = 1, #ACCEPT_PREFABS do
        if item.prefab == ACCEPT_PREFABS[i] then
            return true
        end
    end
    return false
end

-- ==================== 海克斯宝箱 ====================

params.lol_wp_s24_hextechchest_portable_1 = {
    widget = {
        animbank = 'ui_chest_3x3',
        animbuild = 'ui_chest_3x3',
        pos = Vector3(200, 0, 0),
        slotpos = {},
        slotbg = {},
        dragtype_drag = 'lol_wp_s24_hextechchest_portable',
    },
    type = 'lol_wp_s24_hextechchest_portable',
    itemtestfn = function(container, item, slot)
        -- ✅ 标签白名单优先放行
        if item_has_any_accept_tag(item) then
            return true
        end
        -- ✅ 预制物白名单放行
        if item_is_accepted_prefab(item) then
            return true
        end
        -- ✅ 自定义或有组件的物品放行
        if item and ((item.lol_wp_mod_item and not item.lol_wp_mod_item_unique_container)
            or item.components.weapon
            or item.components.armor) then
            return true
        end
        return false
    end,
}

for y = 3, 1, -1 do
    for x = 1, 3 do
        table.insert(params.lol_wp_s24_hextechchest_portable_1.widget.slotpos,
            Vector3(80 * (x - 1) - 80, 80 * (y - 1) - 80, 0))
    end
end

-- ==================== 杰作宝箱 ====================
params.lol_wp_s24_masterwork_portable_1 = {
    widget = {
        animbank = 'ui_chest_3x3',
        animbuild = 'ui_chest_3x3',
        pos = Vector3(200, 0, 0),
        slotpos = {},
        slotbg = {},
        dragtype_drag = 'lol_wp_s24_masterwork_portable',
    },
    type = 'lol_wp_s24_masterwork_portable',
    itemtestfn = function(container, item, slot)
        if item_has_any_accept_tag(item) then
            return true
        end
        if item_is_accepted_prefab(item) then
            return true
        end
        if item and ((item.lol_wp_mod_item and not item.lol_wp_mod_item_unique_container)
            or item.components.weapon
            or item.components.armor) then
            return true
        end
        return false
    end,
}

-- ✅ 构建 5x5 格子
local spacing = 75  -- 格子间距
for y = 5, 1, -1 do
    for x = 1, 5 do
        local xpos = spacing * (x - 1) - spacing * 2
        local ypos = spacing * (y - 1) - spacing * 2
        table.insert(params.lol_wp_s24_masterwork_portable_1.widget.slotpos, Vector3(xpos, ypos, 0))
    end
end

-- ==================== 返回 ====================
return params
