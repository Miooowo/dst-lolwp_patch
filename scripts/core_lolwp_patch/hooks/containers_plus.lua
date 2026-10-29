--[[
Author: Miooowo
Date: 2025-08-07 02:56:40
LastEditors: Miooowo
LastEditTime: 2025-08-09 03:41:11
Description: Although I rarely use github, I still registered it: https://github.com/Miooowo

Copyright (c) 2025 by Miooowo, All Rights Reserved. 
--]]
local modid = 'lolwp_patch'
local containers = require "containers"
local params = containers.params
local default_pos = Vector3(390, -300, 0)

local function itemtest_eyestone(container, item, slot)
    if item == nil then
        return false
    end
    local tagprefix = 'lol_wp_s9_eyestone_'
    local itm_prefab = item and item.prefab
    if itm_prefab and container.inst:HasTag(tagprefix..itm_prefab) then
        return false -- 检查唯一性
    end
    --[[ -- 临时让所有项链都能放入(若有问题,后续再移除)
    -- 不用移除了,加了mod设置了
    if not TUNING[string.upper('CONFIG_'..modid..'eyestone_allow_lolamulet_only')] then
        local item_slot = item.components.equippable and item.components.equippable.equipslot
        if item_slot then
            if EQUIPSLOTS.NECK then -- 如果开启了额外装备栏
                if item_slot == EQUIPSLOTS.NECK then
                    return true
                end
            end
            if EQUIPSLOTS.BODY and (item:HasTag('amulet') or string.find(itm_prefab or '', 'amulet') ) then -- 如果没开额外装备栏,并且是身体位置的装备,需要判断它是不是项链,使用amulet这个tag,或者名字里有amulet,应该不会有孬子,名字里写了amulet结果不是项链吧
                return true
            end
        end
    end ]]
    if itm_prefab and item:HasTag(itm_prefab..'_nofiniteuses') then
        return false
    end
    -- 有这个标签的物品才能放入, 且满足判断条件
    if item:HasTag('lol_wp_s9_eyestone_confirm_amulet') then
        if item.cangoineyestone then
            return item.cangoineyestone(item,container.inst) -- 如果不满足条件 则直接返回
        end
        -- 没有特殊条件时,才仅靠tag 判断
        return true
    end
    
    return false
end


local eyestone_high = GetModConfigData(modid..'_eyestonehigh_container_plus') --槽位数量
local eyestone_low = GetModConfigData(modid..'_eyestonelow_container_plus') --槽位数量

local SLOT_ATLAS = 'images/slotbg/eyestone_slotbg.xml'
local SLOT_IMAGE = 'eyestone_slotbg.tex'
-- 比 3/6/9 档的 75 稍紧，格子往中间收一点
local SLOT_SPACING = 68
-- 眼石槽位图在界面上的边长，以及 ui_chest_3x3 不缩放时内框大约能包住的边长
local SLOT_VISUAL = 57
local FRAME_INNER = 256
local FRAME_PAD = 18

---从左到右、从上到下铺格子。底图仍用 3x3 箱子，按格子实际宽高分别缩放，避免只拉高后上下留黑边。
---@param param_tbl table
---@param cols integer
---@param rows integer
---@param pos Vector3
---@param dragtype string
local function setup_grid(param_tbl, cols, rows, pos, dragtype)
    local spacing = SLOT_SPACING
    param_tbl.widget.animbank = 'ui_chest_3x3'
    param_tbl.widget.animbuild = 'ui_chest_3x3'
    param_tbl.widget.pos = pos
    param_tbl.widget.dragtype_drag = dragtype
    -- 原模组的拖拽只认 lol_wp 打过标、且字段名是 dragtype_drag 的界面
    param_tbl.widget.dst_lan_from_whichmod = 'lol_wp'
    param_tbl.widget.slotpos = {}
    param_tbl.widget.slotbg = {}
    local x0 = -spacing * (cols - 1) / 2
    local y0 = spacing * (rows - 1) / 2
    -- 内腔上沿留白比下沿多，格子略往上，避免顶上单独一条黑边
    local y_bias = 8
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            table.insert(param_tbl.widget.slotpos, Vector3(x0 + col * spacing, y0 - row * spacing + y_bias, 0))
            table.insert(param_tbl.widget.slotbg, { atlas = SLOT_ATLAS, image = SLOT_IMAGE })
        end
    end
    local w = (cols - 1) * spacing + SLOT_VISUAL
    local h = (rows - 1) * spacing + SLOT_VISUAL
    local sx = (w + FRAME_PAD) / FRAME_INNER
    local sy = (h + FRAME_PAD) / FRAME_INNER
    -- 3 列或 3 行已经和原箱子贴合，不再缩小，免得玫瑰边框被压扁
    if cols <= 3 then sx = 1 end
    if rows <= 3 then sy = 1 end
    param_tbl.widget.lolwp_bgscale = Vector3(sx, sy, 1)
end

-- ---------------------------------- 戒备眼石 -------------------------------------
local function s_eyestone(eyestone_low)
    if eyestone_low == 3 then 
        params.lol_wp_s9_eyestone_low_1 = {
            widget = {
                animbank = 'ui_chest_3x1',
                animbuild = 'ui_chest_3x1',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
                dragtype_drag_drag = 'lol_wp_s9_eyestone_low',
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }

        for x = 0, 2 do
            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotpos, Vector3(-162+ 13 + (x+1)*75, 0, 0))
            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
        end
    end
    if eyestone_low == 6 then 
        params.lol_wp_s9_eyestone_low_1 = {
            widget = {
                animbank = 'ui_chest_3x2',
                animbuild = 'ui_chest_3x2',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
                dragtype_drag_drag = 'lol_wp_s9_eyestone_low',
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }

        for x = 0, 2 do
            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotpos, Vector3(-162+ 13 + (x+1)*75, 75-35, 0))
            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotpos, Vector3(-162+ 13 + (x+1)*75, 0-35, 0))

            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
            table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})

        end
    end
    if eyestone_low == 9 then 
       
        params.lol_wp_s9_eyestone_low_1 = {
            widget = {
                animbank = 'ui_chest_3x3',   -- 改成 3x3 的UI
                animbuild = 'ui_chest_3x3',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
                dragtype_drag_drag = 'lol_wp_s9_eyestone_low',
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }

        -- 生成 3x3 的 9 格子
        for y = 0, 2 do
            for x = 0, 2 do
                local slot_x = -162 + 13 + (x+1)*75
                local slot_y = 75 - (y * 75) + 5   -- 每行往下排
                table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotpos, Vector3(slot_x, slot_y, 0))

                table.insert(params.lol_wp_s9_eyestone_low_1.widget.slotbg, {
                    atlas = 'images/slotbg/eyestone_slotbg.xml',
                    image = 'eyestone_slotbg.tex'
                })
            end
        end
    end
    if eyestone_low == 12 or eyestone_low == 16 then
        local rows = eyestone_low == 12 and 3 or 4
        params.lol_wp_s9_eyestone_low_1 = {
            widget = {
                animbank = 'ui_chest_3x3',
                animbuild = 'ui_chest_3x3',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        local pos = eyestone_low == 12 and Vector3(300, -80, 0) or Vector3(260, 30, 0)
        setup_grid(params.lol_wp_s9_eyestone_low_1, 4, rows, pos, 'lol_wp_s9_eyestone_low')
    end
end

s_eyestone(eyestone_low)
if params.lol_wp_s9_eyestone_low_1 and params.lol_wp_s9_eyestone_low_1.widget then
    params.lol_wp_s9_eyestone_low_1.widget.dst_lan_from_whichmod = 'lol_wp'
    params.lol_wp_s9_eyestone_low_1.widget.dragtype_drag = 'lol_wp_s9_eyestone_low'
end
AddPrefabPostInit("lol_wp_s9_eyestone_low", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated =function (inst)
			inst.replica.container:WidgetSetup("lol_wp_s9_eyestone_low_1")
		end
		return inst
	end
	if inst.components.container then
		inst.components.container:WidgetSetup("lol_wp_s9_eyestone_low_1")
	end
    if TUNING.ADD_EYESTONE_EQUIPSLOTS then
        if inst.components.equippable then
            if inst:HasTag("amulet") then
                inst:RemoveTag("amulet") -- 移除原有的 amulet 标签
            end
            inst.components.equippable.equipslot = EQUIPSLOTS.EYESTONE or EQUIPSLOTS.AMULET or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY 
        end
    end
end)

-- --------------------------------- 警觉眼石配置 ------------------------------------
local function g_eyestone(eyestone_high)
    if eyestone_high == 6 then 
        params.lol_wp_s9_eyestone_high_1 = {
            widget = {
                animbank = 'ui_chest_3x2',
                animbuild = 'ui_chest_3x2',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
                dragtype_drag_drag = 'lol_wp_s9_eyestone_high',
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }

        for x = 0, 2 do
            table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(-162+ 13 + (x+1)*75, 75-35, 0))
            table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(-162+ 13 + (x+1)*75, 0-35, 0))

            table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
            table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})

        end
    end
    if eyestone_high == 9 then 
       
        params.lol_wp_s9_eyestone_high_1 = {
            widget = {
                animbank = 'ui_chest_3x3',   -- 改成 3x3 的UI
                animbuild = 'ui_chest_3x3',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
                dragtype_drag_drag = 'lol_wp_s9_eyestone_high',
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }

        -- 生成 3x3 的 9 格子
        for y = 0, 2 do
            for x = 0, 2 do
                local slot_x = -162 + 13 + (x+1)*75
                local slot_y = 75 - (y * 75) + 5   -- 每行往下排
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(slot_x, slot_y, 0))

                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg, {
                    atlas = 'images/slotbg/eyestone_slotbg.xml',
                    image = 'eyestone_slotbg.tex'
                })
            end
        end
    end
    if eyestone_high == 12 then 
        params.lol_wp_s9_eyestone_high_1 = {
            widget =
            {
                slotbg = {},
                slotpos = {},
                animbank = "ui_chester_shadow_3x4",
                animbuild = "ui_chester_shadow_3x4",
                pos = default_pos,
                dragtype_drag="lol_wp_s9_eyestone_high",
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        for y = 3, 0, -1 do
            for x =  0, 2  do
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 40 , 0))
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
            end
        end
    end
    if eyestone_high == 14 then 
        params.lol_wp_s9_eyestone_high_1 = {
            widget =
            {
                slotbg = {},
                slotpos = {},
                animbank = "ui_krampusbag_2x8",
                animbuild = "ui_krampusbag_2x8",
                pos = default_pos,
                dragtype_drag="lol_wp_s9_eyestone_high",
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        for y = 6 , 0 , -1 do
            for x =  0, 1 do
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(80 * x - 80 * 2  - 5 , 80 * y - 80 * 2 - 67, 0))
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
            end
        end
    end
    if eyestone_high == 15 then 
    
        params.lol_wp_s9_eyestone_high_1 = {
            widget =
            {
                slotbg = {},
                slotpos = {},
                animbank = "ui_tacklecontainer_3x5",
                animbuild = "ui_tacklecontainer_3x5",
                pos = default_pos,
                dragtype_drag="lol_wp_s9_eyestone_high",
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        for y = 4, 0, -1 do
            for x =  0, 2  do
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 -125 , 0))
                table.insert(params.lol_wp_s9_eyestone_high_1.widget.slotbg,{atlas = 'images/slotbg/eyestone_slotbg.xml', image = 'eyestone_slotbg.tex'})
            end
        end
    end
    if eyestone_high == 16 then
        params.lol_wp_s9_eyestone_high_1 = {
            widget = {
                animbank = 'ui_chest_3x3',
                animbuild = 'ui_chest_3x3',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        setup_grid(params.lol_wp_s9_eyestone_high_1, 4, 4, Vector3(260, 30, 0), 'lol_wp_s9_eyestone_high')
    end
    if eyestone_high == 20 or eyestone_high == 25 then
        local rows = eyestone_high == 20 and 4 or 5
        params.lol_wp_s9_eyestone_high_1 = {
            widget = {
                animbank = 'ui_chest_3x3',
                animbuild = 'ui_chest_3x3',
                slotbg = {},
                slotpos = {},
                pos = default_pos,
            },
            type = 'eyestone',
            itemtestfn = itemtest_eyestone,
        }
        local pos = eyestone_high == 20 and Vector3(220, 70, 0) or Vector3(180, 130, 0)
        setup_grid(params.lol_wp_s9_eyestone_high_1, 5, rows, pos, 'lol_wp_s9_eyestone_high')
    end
end

g_eyestone(eyestone_high)
if params.lol_wp_s9_eyestone_high_1 and params.lol_wp_s9_eyestone_high_1.widget then
    params.lol_wp_s9_eyestone_high_1.widget.dst_lan_from_whichmod = 'lol_wp'
    params.lol_wp_s9_eyestone_high_1.widget.dragtype_drag = 'lol_wp_s9_eyestone_high'
end
AddPrefabPostInit("lol_wp_s9_eyestone_high", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated =function (inst)
			inst.replica.container:WidgetSetup("lol_wp_s9_eyestone_high_1")
		end
		return inst
	end
	if inst.components.container then
		inst.components.container:WidgetSetup("lol_wp_s9_eyestone_high_1")
	end
    if TUNING.ADD_EYESTONE_EQUIPSLOTS then
        if inst.components.equippable then
            if inst:HasTag("amulet") then
                inst:RemoveTag("amulet") -- 移除原有的 amulet 标签
            end
            inst.components.equippable.equipslot = EQUIPSLOTS.EYESTONE or EQUIPSLOTS.AMULET or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY 
        end
    end
end)

-- ---------------------------------- 海克斯和杰作宝箱 -------------------------------------
if TUNING[string.upper('CONFIG_'..modid..'lol_wp_s24_portable')] then
    AddPrefabPostInit("lol_wp_s24_hextechchest_portable", function(inst)
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated =function (inst)
                inst.replica.container:WidgetSetup("lol_wp_s24_hextechchest_portable_1")
            end
            return inst
        end
        if inst.components.container then
            inst.components.container:WidgetSetup("lol_wp_s24_hextechchest_portable_1")
        end
    end)
    AddPrefabPostInit("lol_wp_s24_masterwork_portable", function(inst)
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated =function (inst)
                inst.replica.container:WidgetSetup("lol_wp_s24_masterwork_portable_1")
            end
            return inst
        end
        if inst.components.container then
            inst.components.container:WidgetSetup("lol_wp_s24_masterwork_portable_1")
        end
    end)
end