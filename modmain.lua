---@diagnostic disable: lowercase-global, undefined-global, trailing-space

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

---@type string
local modid = 'lolwp_patch' -- 定义唯一modid

---@type LAN_TOOL_COORDS
COORDS_lolwp_patch = require('core_'..modid..'/utils/coords')
---@type LAN_TOOL_SUGARS
SUGAR_lolwp_patch = require('core_'..modid..'/utils/sugar')

rawset(GLOBAL,'COORDS_lolwp_patch',COORDS_lolwp_patch)
rawset(GLOBAL,'SUGAR_lolwp_patch',SUGAR_lolwp_patch)

PrefabFiles = {
	-- 'lolwp_patch_module_buffs',
	-- 'lolwp_patch_module_dishes',
	-- 'lolwp_patch_module_particle',

}

---@type asset[]
Assets = {

}
-- 导入mod配置
for _,v in ipairs({
	'_lang',
	'gallop_breaker_bright_shadow',
	'gallop_hydra_bright_shadow',
	'lol_wp_trinity_bright_shadow',
	'lol_wp_warmogarmor_bright_shadow',
	'alchemy_chainsaw_bright_shadow',
	'lol_wp_s24_portable',

}) do TUNING[string.upper('CONFIG_'..modid..v)] = GetModConfigData(modid..v) end

-- 导入常量表
-- mod设置的常量都整理在这
modimport('scripts/core_'..modid..'/data/tuning.lua')

-- 导入工具
modimport('scripts/core_'..modid..'/utils/_register.lua')

-- 导入功能API
modimport('scripts/core_'..modid..'/api/_register.lua')

-- 导入语言文件
modimport('scripts/core_'..modid..'/languages/'..TUNING[string.upper('CONFIG_'..modid..'_LANG')]..'.lua')

-- 导入人物
-- modimport('scripts/data_avatar/data_avatar_xxx.lua')

-- 导入调用器
-- modimport('scripts/core_'..modid..'/callers/caller_attackperiod.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_badge.lua')
modimport('scripts/core_'..modid..'/callers/caller_ca.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_changeactionsg.lua')
modimport('scripts/core_'..modid..'/callers/caller_container.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_dish.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_keyhandler.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_onlyusedby.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_recipes.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_stack.lua')


-- 导入零散功能模块 (自用 可以无视) (如果你要启用某个模块, 先看该manager文件里面的置顶注释)
-- modimport('scripts/core_lolwp_patch/managers/atk_speed_from_alt.lua') -- 功能(无需修改): alt写的修改攻速模块 修正版
-- modimport('scripts/core_lolwp_patch/managers/bugfix_aoetargeting.lua') -- 当你使用官方组件来写技能时,貌似会因为没有正确移除 reticule 组件,导致玩家的轮盘施法放不出来,本文件就是用来修复这个bug的
-- modimport('scripts/core_lolwp_patch/managers/bugfix_souljump.lua') -- 当你使用官方组件来写武器技能时, 会导致和 小恶魔的灵魂跳跃 冲突, 具体我忘了, 总之这个文件就是用来修复这个bug的
-- modimport('scripts/core_lolwp_patch/managers/build_data_transfer.lua') -- 功能(需要填写): 制作物品过程涉及数据传输 (只能传输1件原材料的数据)
-- modimport('scripts/core_lolwp_patch/managers/cantequip_whennodurability.lua') -- 功能(无需修改): 本文件用来管理,装备耐久用尽时的逻辑
-- modimport('scripts/core_lolwp_patch/managers/cd_in_itemtile.lua') -- 功能(无需修改): 在物品栏以数字形式显示的cd
-- modimport('scripts/core_lolwp_patch/managers/dmg_sys.lua') -- 管理: 用这个文件管理伤害处理吧
-- modimport('scripts/core_lolwp_patch/managers/event_hook.lua') -- 功能(需要填写): 勾 event
-- modimport('scripts/core_lolwp_patch/managers/invincible.lua') -- 功能(无需修改): 设置无敌的
modimport('scripts/core_lolwp_patch/managers/is_mod_enabled.lua') -- 功能(无需修改): 判断某个mod有没有开启 的前置
-- modimport('scripts/core_lolwp_patch/managers/last_atk_weapon.lua') -- 功能(无需修改): 获取攻击者上次使用的武器
modimport('scripts/core_lolwp_patch/managers/misc.lua') -- 杂项
-- modimport('scripts/core_lolwp_patch/managers/participate_kill.lua') -- 功能(无需修改): 联合击杀(参与击杀), 判断生物死亡时, 某个玩家有没有贡献伤害(参与战斗)
-- modimport('scripts/core_lolwp_patch/managers/quick_announce.lua') -- 功能(需要填写): alt + 左键点击库存物品宣告
-- modimport('scripts/core_lolwp_patch/managers/sort_recipes.lua') -- 功能(需要填写): 给配方排序
modimport('scripts/core_lolwp_patch/managers/trade.lua') -- 功能(无需修改,但需要填写其他地方): 添加通用的交易升级功能


-- 导入UI
modimport('scripts/core_'..modid..'/ui/eyestone_slot.lua')
-- modimport('scripts/core_'..modid..'/ui/ui_pause.lua')


-- 注册客机组件

-- 导入钩子 It's my勾
---@type string[]
local files_hook = {
	--'wandahook'
	'lolwp_hook', -- 老版本的hook都在这，新版另写
	'lolgun_hook', -- 枪炮hook合集
	'lolmelee_hook', -- 新增的近战武器hook文件
	'containers_plus', -- 容器格子拓展
	'eyestone_autorepair', -- 眼石内装备耐久自动修复
	'lol_wp_pedia_amulet', -- 图鉴追加护符装备
	'pedia_jump', -- Alt 双击跳到对应图鉴
	'wanderingtrader_hook', -- 流浪商人增强
}
for _,v in ipairs(files_hook) do
	modimport('scripts/core_'..modid..'/hooks/'..v..'.lua')
end

-- 旺达增强
if TUNING.BLOODAXE_FOR_WANDA then
    modimport('scripts/core_'..modid..'/hooks/wandahook.lua')
end

AddClassPostConstruct("widgets/containerwidget", function(self)
    local old_Open = self.Open

    function self:Open(container, doer, ...)
        if old_Open ~= nil then
            old_Open(self, container, doer, ...)
        end

        local replica = container and container.replica and container.replica.container
        local widget = replica and replica.GetWidget and replica:GetWidget()
        local scale = widget and widget.lolwp_bgscale
        if scale and self.bganim ~= nil then
            self.bganim:SetScale(scale.x, scale.y, 1)
        end
        if container and container.prefab == "lol_wp_s24_masterwork_portable" then
            if self.bganim ~= nil then
                self.bganim:SetScale(1.6, 1.6, 1) -- 拉大一点，避免格子超出
            end
        end
    end
end)