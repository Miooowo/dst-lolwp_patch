local modid = 'lolwp_patch'
---@type {main:table<PrefabID,data_trade_item[]>,map:table<PrefabID,table<PrefabID,data_trade_item_fixed>>}
local tradedata = {}
local function AddNamePrefix(item, prefix)
    if item.displaynamefn == nil then
        local oldname = item.name or STRINGS.NAMES[string.upper(item.prefab)]
        item.displaynamefn = function(inst)
            local name = oldname or inst:GetBasicDisplayName()
            if string.sub(name, 1, #prefix) ~= prefix then
                return prefix .. name
            else
                return name
            end
        end
    end
end
-- 通用升级逻辑
local upgrade_fns = {
    planar_to_shadow_01 = { --亮茄粉碎者 锤镐 --亮茄魔杖
        label = "光明转",
        max = 1,
        fn = function(item, trader, doer, after_num)
            if doer.components.talker then
                doer.components.talker:Say("迎接光明！")
            end
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, 10*after_num, "upgrade_shadow")

            if not trader.components.damagetypebonus then
                trader:AddComponent("damagetypebonus")
            end
            trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + after_num * 0.1)
        end,
        fn_load = function(trader, total_num)
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, 10*total_num, "upgrade_shadow")

            if total_num > 0 then
                if not trader.components.damagetypebonus then
                    trader:AddComponent("damagetypebonus")
                end
                trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + total_num * 0.1)
            end
        end,
    },
    planar_to_shadow_01_1 = { --亮茄魔杖 三相
        label = "光明转",
        max = 1,
        fn = function(item, trader, doer, after_num)
            local real_wp = trader.real_weapon or trader
            if doer.components.talker then
                doer.components.talker:Say("迎接光明！")
            end
            if not real_wp.components.planardamage then
                real_wp:AddComponent("planardamage")
            end
            real_wp.components.planardamage:AddBonus(real_wp, 10*after_num, "upgrade_shadow")

            if not real_wp.components.damagetypebonus then
                real_wp:AddComponent("damagetypebonus")
            end
            real_wp.components.damagetypebonus:AddBonus("shadow_aligned", real_wp, 1 + after_num * 0.1)

            -- 给外观武器加名字前缀
            AddNamePrefix(trader, "神光·")
        end,
        fn_load = function(trader, total_num)
            local real_wp = trader.real_weapon or trader
            if not real_wp.components.planardamage then
                real_wp:AddComponent("planardamage")
            end
            real_wp.components.planardamage:AddBonus(real_wp, 10*total_num, "upgrade_shadow")

            if total_num > 0 then
                if not real_wp.components.damagetypebonus then
                    real_wp:AddComponent("damagetypebonus")
                end
                real_wp.components.damagetypebonus:AddBonus("shadow_aligned", real_wp, 1 + total_num * 0.1)
                -- 给外观武器加名字前缀
                AddNamePrefix(trader, "神光·")
            end
        end,
    },

    planar_to_shadow_02 = { --亮茄剑
        label = "光明转",
        max = 1,
        fn = function(item, trader, doer, after_num)
            if doer.components.talker then
                doer.components.talker:Say("迎接光明！")
            end
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, 30*after_num, "upgrade_shadow")

            if not trader.components.damagetypebonus then
                trader:AddComponent("damagetypebonus")
            end
            trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + after_num * 0.1)
        end,
        fn_load = function(trader, total_num)
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, 30*total_num, "upgrade_shadow")

            if total_num > 0 then
                if not trader.components.damagetypebonus then
                    trader:AddComponent("damagetypebonus")
                end
                trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + total_num * 0.1)
            end
        end,
    },

    planar_to_lunar = {
        label = "增加位面伤害(对月亮)",
        max = 15,
        fn = function(item, trader, doer, after_num)
            if doer.components.talker then
                doer.components.talker:Say("你的武器增加了 1 点位面伤害，并对月亮阵营 +1% 伤害")
            end
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, after_num, "upgrade_lunar")

            if not trader.components.damagetypebonus then
                trader:AddComponent("damagetypebonus")
            end
            trader.components.damagetypebonus:AddBonus("lunar_aligned", trader, 1 + after_num * 0.01)
        end,
        fn_load = function(trader, total_num)
            if not trader.components.planardamage then
                trader:AddComponent("planardamage")
            end
            trader.components.planardamage:AddBonus(trader, total_num, "upgrade_lunar")

            if total_num > 0 then
                if not trader.components.damagetypebonus then
                    trader:AddComponent("damagetypebonus")
                end
                trader.components.damagetypebonus:AddBonus("lunar_aligned", trader, 1 + total_num * 0.01)
            end
        end,
    },

    planar_the_shadow_01 = { --亮茄甲
        label = "光明转",
        max = 1,
        fn = function(item, trader, doer, after_num)
            if doer.components.talker then
                doer.components.talker:Say("迎接光明！")
            end
            if not trader.components.planardefense then
                trader:AddComponent("planardefense")
            end

            trader.components.planardefense:AddBonus(trader, 10*after_num, "upgrade_shadow")

            if not trader.components.damagetyperesist then
                trader:AddComponent("damagetyperesist")
            end
            trader.components.damagetyperesist:AddResist("shadow_aligned", trader, 1 - after_num * 0.1)
        end,
        fn_load = function(trader, total_num)
            if not trader.components.planardefense then
                trader:AddComponent("planardefense")
            end
            trader.components.planardefense:AddBonus(trader, 10*total_num, "upgrade_shadow")

            if total_num > 0 then
                if not trader.components.damagetyperesist then
                trader:AddComponent("damagetyperesist")
            end
            trader.components.damagetyperesist:AddResist("shadow_aligned", trader, 1 - total_num * 0.1)
            end
        end,
    },

    planar_the_lunar = {
        label = "增加位面防御(对月亮)",
        max = 10,
        fn = function(item, trader, doer, after_num)
            if doer.components.talker then
                doer.components.talker:Say("你的护甲增加了 1 点位面防御，并对月亮阵营 +1% 减伤")
            end
            if not trader.components.planardefense then
                trader:AddComponent("planardefense")
            end
            trader.components.planardefense:AddBonus(trader, after_num, "upgrade_lunar")

            if not trader.components.damagetyperesist then
                trader:AddComponent("damagetyperesist")
            end
            trader.components.damagetyperesist:AddResist("lunar_aligned", trader, 1 - after_num * 0.01)
        end,
        fn_load = function(trader, total_num)
            if not trader.components.planardefense then
                trader:AddComponent("planardefense")
            end
            trader.components.planardefense:AddBonus(trader, total_num, "upgrade_lunar")

            if total_num > 0 then
                if not trader.components.damagetyperesist then
                    trader:AddComponent("damagetyperesist")
                end
                trader.components.damagetyperesist:AddResist("lunar_aligned", trader, 1 - total_num * 0.01)
            end
        end,
    },
    armor_lunarplant = {
        label = "获得反伤效果",
        max = 1,
        fn = function(item, trader, doer, after_num)
                if trader.components.damagereflect == nil then
                    trader:AddComponent("damagereflect")
                    trader.components.damagereflect.defaultdamage = 10
                end
                trader.components.damagereflect.defaultdamage = trader.components.damagereflect.defaultdamage + 10 * after_num
                if doer.components.talker then
                    doer.components.talker:Say("你的盔甲现在能反弹伤害了！")
                end
            end,
        fn_load = function(trader, total_num)
            
                if trader.components.damagereflect then
                    trader.components.damagereflect.defaultdamage = trader.components.damagereflect.defaultdamage + 10*total_num
                end
        end
    },
}

--- 构造升级配置
local function MakeUpgrade(prefab, type, overrides)
    local base = upgrade_fns[type]
    local cfg = {
        prefab = prefab,
        str = overrides and overrides.str or base.label,
        max = overrides and overrides.max or base.max,
        fn = function(item, trader, doer, after_num)
            base.fn(item, trader, doer, after_num)

            -- ★ 名字前缀逻辑（防重复）
            if overrides and overrides.prefix then
                if trader.displaynamefn == nil then
                    local oldname = trader.name or STRINGS.NAMES[string.upper(trader.prefab)]
                    trader.displaynamefn = function(inst)
                        local name = oldname or inst:GetBasicDisplayName()
                        if string.sub(name, 1, #overrides.prefix) ~= overrides.prefix then
                            return overrides.prefix .. name
                        else
                            return name
                        end
                    end
                end
            end
        end,
        fn_load = function(trader, total_num)
            base.fn_load(trader, total_num)

            -- ★ 存档加载时也加前缀
            if overrides and overrides.prefix and total_num > 0 then
                if trader.displaynamefn == nil then
                    local oldname = trader.name or STRINGS.NAMES[string.upper(trader.prefab)]
                    trader.displaynamefn = function(inst)
                        local name = oldname or inst:GetBasicDisplayName()
                        if string.sub(name, 1, #overrides.prefix) ~= overrides.prefix then
                            return overrides.prefix .. name
                        else
                            return name
                        end
                    end
                end
            end
        end
    }
    return cfg
end

---只填此表
tradedata.main = {
    -- sword_lunarplant = {
    --     { -- 1. 这是一个给`亮茄剑`金子加1点伤害的简单升级,最大值不填则无限升级
    --         prefab = 'goldnugget',
    --         max = 5,
    --         str = '增加物理伤害',
    --         state = 'dolongaction',
    --         fn = function(item,trader,doer,after_num)
    --             if trader.components.weapon then
    --                 trader.components.weapon.damage = trader.components.weapon.damage + 1
    --             end
    --         end,
    --         fn_load = function (trader, total_num)
    --             if trader.components.weapon then
    --                 trader.components.weapon.damage = trader.components.weapon.damage + total_num
    --             end
    --         end
    --     },
    --     { -- 2. 这是一个给`亮茄剑`1个燧石增加1点位面伤害的升级, 由于没填最大值, 因此可以无限升级
    --         prefab = 'flint',
    --         str = '增加位面伤害',
    --         fn = function(item,trader,doer,after_num)
    --             if doer.components.talker then
    --                 doer.components.talker:Say('你的武器增加了1点位面伤害')
    --             end
    --             if trader.components.planardamage then
    --                 trader.components.planardamage:AddBonus(trader,after_num,'upgrade_by_myself')
    --             end
    --         end,
    --         fn_load = function (trader, total_num)
    --             if trader.components.planardamage then
    --                 trader.components.planardamage:AddBonus(trader,total_num,'upgrade_by_myself')
    --             end
    --         end
    --     }
    -- },
    
    --lol_wp_s10_sunfireaegis_armor = {
    --    MakeUpgrade('armor_lunarplant','planar_to_shadow_01', {
    --        prefix = "烈日·"
    --    })
    --}
    --lol_wp_s13_infinity_edge = {
    --    MakeUpgrade('sword_lunarplant','planar_to_shadow_02', {
    --        prefix = "天顶·"
    --    })
    --}
    
}
-- -----------------------------------------------------------------------------
--                                   光明与黑暗更新                                    
-- -----------------------------------------------------------------------------

-- ----------------------------------- 光明转 -------------------------------------
if TUNING[string.upper('CONFIG_'..modid..'gallop_breaker_bright_shadow')] then
    tradedata.main.gallop_breaker = {
        MakeUpgrade('pickaxe_lunarplant','planar_to_shadow_01', {
            prefix = "采月·"
        })
    }
end
if TUNING[string.upper('CONFIG_'..modid..'gallop_hydra_bright_shadow')] then
    tradedata.main.gallop_hydra = {
        MakeUpgrade('sword_lunarplant','planar_to_shadow_02', {
            prefix = "攻影·"
        })
    }
end
if TUNING[string.upper('CONFIG_'..modid..'lol_wp_trinity_bright_shadow')] then
    tradedata.main.lol_wp_trinity = {
        MakeUpgrade('staff_lunarplant','planar_to_shadow_01_1', {
            prefix = "神光·"
        })
    }
end
if TUNING[string.upper('CONFIG_'..modid..'lol_wp_warmogarmor_bright_shadow')] then
    tradedata.main.lol_wp_warmogarmor = {
        MakeUpgrade('armor_lunarplant','planar_to_shadow_01', {
            prefix = "光明·"
        })
    }
end
if TUNING[string.upper('CONFIG_'..modid..'alchemy_chainsaw_bright_shadow')] then
    tradedata.main.alchemy_chainsaw = {
        MakeUpgrade('sword_lunarplant','planar_to_shadow_02', {
            prefix = "赛博·"
        })
    }
end

if TUNING.COLLECTOR_BLESSING then
    tradedata.main.lol_wp_s13_collector = {
        { -- 光明转
            prefab = 'houndstooth_blowpipe',
            max = 1,
            str = '光明转',
            state = 'dolongaction',
            fn = function(item,trader,doer,after_num)
                if not trader.components.planardamage then
                trader:AddComponent("planardamage")
                end
                trader.components.planardamage:AddBonus(trader, after_num*34, "bright_collector")

                if not trader.components.damagetypebonus then
                    trader:AddComponent("damagetypebonus")
                end
                trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + after_num * 0.1)

                -- 加名字前缀 "福光·"
                if trader.displaynamefn == nil then
                    -- 保存原始名字，避免叠加多次 "福光·"
                    local oldname = trader.name or STRINGS.NAMES[string.upper(trader.prefab)]
                    trader.displaynamefn = function(inst)
                        return "福光·" .. (oldname or inst:GetBasicDisplayName())
                    end
                end
            end,
            fn_load = function (trader, total_num)
                if trader.components.planardamage then
                    trader:AddComponent("planardamage")
                end
                trader.components.planardamage:AddBonus(trader, total_num, "bright_collector")

                if total_num > 0 then
                    if not trader.components.damagetypebonus then
                        trader:AddComponent("damagetypebonus")
                    end
                    trader.components.damagetypebonus:AddBonus("shadow_aligned", trader, 1 + total_num * 0.1)
                    -- 确保读档后名字也有 "福光·"
                    if trader.displaynamefn == nil then
                        local oldname = trader.name or STRINGS.NAMES[string.upper(trader.prefab)]
                        trader.displaynamefn = function(inst)
                            return "福光·" .. (oldname or inst:GetBasicDisplayName())
                        end
                    end
                end
            end
        },
        --MakeUpgrade("armorwagpunk", "planar_to_lunar"),
    }
end

-- --------------------------------- 龙心计时加速 ------------------------------------
local function reduce_dragonheart_timer(item, trader, doer, reduce_sec, msg)
    if trader.components.timer then
        local timername = STRINGS.MOD_LOL_WP.lol_wp_s26_dragonheart.attri_timer
        if trader.components.timer:TimerExists(timername) then
            local left = trader.components.timer:GetTimeLeft(timername)
            if left then
                trader.components.timer:SetTimeLeft(timername, math.max(0, left - reduce_sec))
                if doer and doer.components.talker then
                    doer.components.talker:Say(msg)
                end
            end
        end
    end
end
if TUNING.DRAGONHEART_REDUCETIMING then
    tradedata.main.lol_wp_s26_dragonheart = {
        -- { prefab = "redgem",          max = 600, str = "减少计时120秒", state = "dolongaction",
        -- fn = function(item, trader, doer, after_num)
        --     reduce_dragonheart_timer(item, trader, doer, 120, "龙心的计时减少了120秒！")
        -- end, fn_load = nil },

        { prefab = "dragon_scales",   max = 300, str = "减少计时240秒", state = "dolongaction",
        fn = function(item, trader, doer, after_num)
            reduce_dragonheart_timer(item, trader, doer, 240, "龙心的计时减少了240秒！")
        end, fn_load = nil },

        { prefab = "lavae_egg",       max = 150, str = "减少计时1天", state = "dolongaction",
        fn = function(item, trader, doer, after_num)
            reduce_dragonheart_timer(item, trader, doer, 480, "龙心的计时减少了1天！")
        end, fn_load = nil },

        { prefab = "lol_wp_s26_dragonheart", max = 15, str = "减少计时10天", state = "dolongaction",
        fn = function(item, trader, doer, after_num)
            reduce_dragonheart_timer(item, trader, doer, 480*10, "龙心的计时减少了10天！")
        end, fn_load = nil },
    }
end

---------------------------------------------------------------
tradedata.map = {}
for target,tbl in pairs(tradedata.main) do
    tradedata.map[target] = {}
    ---@cast tbl data_trade_item_fixed
    for i,v in ipairs(tbl) do
        tradedata.map[target][v.prefab] = v
        v.index = i
    end
end

return tradedata