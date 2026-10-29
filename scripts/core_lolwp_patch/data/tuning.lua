--[[
Author: Miooowo
Date: 2025-08-06 14:02:51
LastEditors: Miooowo
LastEditTime: 2025-08-07 15:23:25
Description: Although I rarely use github, I still registered it: https://github.com/Miooowo

Copyright (c) 2025 by Miooowo, All Rights Reserved. 
--]]
local modid = 'lolwp_patch'
TUNING.MOD_LOLWP_PATCH = {
    ---@type table<PrefabID,{type: 'finiteuses'|'armor'|'fueled', repair_percent: table<PrefabID,number>, cantequip_whennodurability: boolean|nil, autounequip_whennodurability: boolean|nil}>
    REPAIR_COMMON = { -- 官方的三个组件的修理, finiteuses armor fueled, 给一堆物品时, 尽可能多的消耗物品来修理
        -- spear = {
        --     type = 'finiteuses', -- 组件ID
        --     repair_percent = { -- 键为物品prefabID, 值为修理百分比
        --         flint = .2,
        --     },
        --     cantequip_whennodurability = false, -- 是否在耐久用尽时不允许装备,如果你得物品在耐久耗尽时,就直接被移除了,这个就不用填了,只有在耐久用尽,要保留物品时才填这个
        --     autounequip_whennodurability = false, -- 是否在耐久用尽时自动卸下到库存中
        -- },
    },
}

-- TUNING.HEARTSTEEL_CD = GetModConfigData(modid.."_heartsteel_cd")
-- TUNING.HEARTSTEEL_CHARGECD = GetModConfigData(modid.."_heartsteel_chargecd")
TUNING.AMPLIFYING_TOME_NOFINITEUSES = GetModConfigData(modid.."_amplifying_tome_finiteuses")
TUNING.DEATH_NOLOSE = GetModConfigData(modid.."_deathnolose")
TUNING.RIFTMAKER_FOR_WANDA = GetModConfigData(modid..'_riftmaker_for_wanda')
TUNING.BLOODAXE_FOR_WANDA = GetModConfigData(modid..'_bloodaxe_for_wanda')
TUNING.TEARS_WICKERBOTTOM = GetModConfigData(modid..'_tears_of_the_goddess')

--
--TUNING.EYESTONE_SHADOW = GetModConfigData(modid..'_shadow_eyestone')

-- ----------------------------------- 龙心 --------------------------------------
TUNING.DRAGONHEART_REDUCETIMING = GetModConfigData(modid..'_dragonheart_reducetiming')

-- ---------------------------------- 近战武器 ---------------------------------- --
-- 黑色切割者 黑切
TUNING.BLACKCUTTER_CUSTOM_MULT = GetModConfigData(modid..'blcakcutter_custom_mult')
-- 链锯剑
TUNING.ALCHEMY_CHAINSAW_FOR_WINONA = GetModConfigData(modid..'alchemy_chainsaw_for_winona')
TUNING.LOL_WP_S27_FEVER_REMOVE_FINITEUSES = GetModConfigData(modid..'_lol_wp_s27_fever')

-- ---------------------------------- 枪炮武器 -------------------------------------
-- 收集者
TUNING.COLLECTOR_INFINITESTACK = GetModConfigData(modid..'collector_infinitestack')
TUNING.COLLECTOR_BLESSING = GetModConfigData(modid..'collector_blessing')

-- ---------------------------------- 眼石调整 -------------------------------------
--TUNING.EYESTONEHIGH_CONTAINER_PLUS = GetModConfigData(modid..'_eyestonehigh_container_plus') --槽位数量
TUNING.ADD_EYESTONE_EQUIPSLOTS=GetModConfigData(modid.."_eyestone_slot")--是否加入眼石栏