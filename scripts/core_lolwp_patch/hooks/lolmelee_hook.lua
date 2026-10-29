local modid = 'lolwp_patch'
-- ----------------------------------- 黑切 --------------------------------------
if TUNING.BLACKCUTTER_CUSTOM_MULT then
    -- 保存原始动作函数
    local old_gallop_blackcutter_fn = GLOBAL.ACTIONS.GALLOP_BLACKCUTTER.fn

    -- Hook 并替换动作函数
    GLOBAL.ACTIONS.GALLOP_BLACKCUTTER.fn = function(act)
        local doer = act.doer
        local target = act.target
        local pt = doer:GetPosition()
        if target and target:IsValid() then
            pt = pt + (target:GetPosition() - pt) * 0.8
        end
        if pt then
            local dmg = 10 -- 默认伤害值
            local weapon = doer.components.inventory and doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
            if not weapon or weapon:HasTag("gallop_blackcutter_discharge") then
                return false
            end
            
            -- 自定义伤害逻辑：修改目标伤害数值计算方式
            local custom_mult = 1
            if doer.components.sanity ~= nil and doer.components.sanity:IsInsanityMode() then
                local rate = 150 / Lerp(136, 150, doer.components.sanity:GetPercent())
                custom_mult = custom_mult * rate
                --print("自定义倍率为", custom_mult)
            end
            --local custom_mult = 150/136 -- 自定义伤害倍数
            local skillcd = weapon.gallop_blackcutter_cd or 10
            if doer.components.skilltreeupdater then 
                if doer.components.skilltreeupdater:CountSkillTag("shadow_favor") > 2 then
                    skillcd = skillcd * 0.25
                elseif doer.components.skilltreeupdater:CountSkillTag("shadow_favor") == 2 then
                    skillcd = skillcd * 0.5
                elseif doer.components.skilltreeupdater:CountSkillTag("shadow_favor") == 1 then
                    skillcd = skillcd * 0.75
                else
                    skillcd = skillcd or 10
                end
            end
            --print("技能cd为"..skillcd)
            if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
                local dmg = (target.gallop_blackcutter_stack or 1) * 136 * custom_mult -- 增加自定义倍数
                local mult = doer.components.combat.externaldamagemultipliers:Get() * (doer.components.combat.damagemultiplier or 1)
                target.components.health:DoDelta(-dmg * mult, false, weapon.prefab, false, nil, true)

                if target.sg ~= nil then
                    target:PushEvent("attacked", { attacker = doer, damage = dmg, weapon = weapon })
                end

                target:DoTaskInTime(GLOBAL.FRAMES, function()
                    if target.components.health ~= nil and target.components.health:IsDead() then
                        if weapon.components.rechargeable then
                            weapon.components.rechargeable:Discharge(0)
                        end
                        local trap = GLOBAL.SpawnPrefab("gallop_blackcutter_trap")
                        trap.Transform:SetPosition(target:GetPosition():Get())
                        trap:TryTrapTarget({})
                    end
                end)

                -- 视觉效果
                local fx = GLOBAL.SpawnPrefab("cavehole_flick")
                fx.Transform:SetPosition(target:GetPosition():Get())
                fx.Transform:SetScale(1.2, 1.2, 1.2)
                GLOBAL.SpawnPrefab("chester_transform_fx").Transform:SetPosition(target:GetPosition():Get())
                GLOBAL.SpawnPrefab("groundpound_fx").Transform:SetPosition(target:GetPosition():Get())
                GLOBAL.SpawnPrefab("voidcloth_boomerang_launch_fx").Transform:SetPosition(target:GetPosition():Get())
            end

            if weapon.components.rechargeable then
                weapon.components.rechargeable:Discharge(skillcd)
            end
            if weapon.components.finiteuses then
                weapon.components.finiteuses:Use(1)
            end

            if doer.SoundEmitter then
                doer.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/hammer_smash')
            end

            return true
        end
        return false
    end
end

-- ----------------------------------- 链锯剑 -------------------------------------
if TUNING.ALCHEMY_CHAINSAW_FOR_WINONA then
    AddPrefabPostInit("winona", function(inst)
        local function OnEquip(inst, data)
            local item = data and data.item
            if item and item.components.weapon and item.prefab == 'alchemy_chainsaw' then
                -- 设置磨损率为 0.85，即减少 15%
                item.components.weapon.attackwearmultipliers:SetModifier(item, 0.85, "winona_handy")
                -- 给攻击者加成 1.25 倍
                inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25, "winona_weapon_bonus")
            end
        end

        local function OnUnequip(inst, data)
            local item = data and data.item
            if item and item.components.weapon and item.prefab == 'alchemy_chainsaw' then
                -- 移除磨损率修正
                item.components.weapon.attackwearmultipliers:RemoveModifier(item, "winona_handy")
                inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "winona_weapon_bonus")
            end
        end
        inst:ListenForEvent("equip", OnEquip)
        inst:ListenForEvent("unequip", OnUnequip)
    end)
end
-- -- -------------------------------- 启迪冠破败联动修复 ----------------------------------
-- local function AddBonus(inst, weapon)
--     if inst.components.combat then
--         inst.components.combat.externaldamagemultipliers:SetModifier(inst, 2, "gallop_brokenking")
--     end
--     if inst.components.planardamage then
--         inst.components.planardamage:AddMultiplier(inst, 2, "gallop_brokenking")
--     end
--     if inst.components.talker then
--         inst.components.talker:Say(STRINGS.GALLOP_BROKENKING.LINK_ACTIVE, 2, true)
--     end
--     local fx = SpawnPrefab("moonpulse_fx")
--     fx.entity:SetParent(inst.entity)

--     weapon.link_active = true

--     if weapon and weapon.components.gallop_brokenking_frogblade_cd then
--         weapon.components.gallop_brokenking_frogblade_cd:ChangeDefaultCD(5,true)
--     end
-- end
-- local function RemoveBonus(inst, weapon)
--     if inst.components.combat then
--         inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "gallop_brokenking")
--     end
--     if inst.components.planardamage then
--         inst.components.planardamage:RemoveMultiplier(inst, "gallop_brokenking")
--     end
--     if weapon and weapon.prefab == "gallop_brokenking" then
--         weapon.link_active = nil
--     end
--     if weapon and weapon.components.gallop_brokenking_frogblade_cd then
--         weapon.components.gallop_brokenking_frogblade_cd:ChangeDefaultCD(10,true)
--     end
-- end
-- local function checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen(player)
--     local equips, found = LOLWP_S:findEquipments(player,'lol_wp_s15_crown_of_the_shattered_queen')
--     local _, found2 = LOLWP_S:findEquipments(player,'gallop_brokenking')
--     if found and found2 then

--         if not player.when_equip_brokenking_and_crown_of_the_shattered_queen_announced then
--             player.when_equip_brokenking_and_crown_of_the_shattered_queen_announced = true
--             if player.components.talker then
--                 player.components.talker:Say(STRINGS.MOD_LOL_WP.WHEN_EQUIP_BROKENKING_AND_CROWN_OF_THE_SHATTERED_QUEEN)
--             end
--         end

--         player.when_equip_brokenking_and_crown_of_the_shattered_queen = true
--     else
--         player.when_equip_brokenking_and_crown_of_the_shattered_queen = nil
--         player.when_equip_brokenking_and_crown_of_the_shattered_queen_announced = nil
--     end
-- end
-- local function OnRefreshEquip(inst, data)
--     inst:DoTaskInTime(0, function()
--         if inst == nil or inst.components.inventory == nil then
--             return
--         end
--         local hat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD2) 
--                         or inst.components.inventory:GetEquippedItem(EQUIPSLOTS.CROWN)
--                         or inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
--         local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--         if weapon and weapon.prefab == "gallop_brokenking" and hat then
--             if hat.prefab == "alterguardianhat" then 
--                 AddBonus(inst, weapon)
--             elseif hat.prefab == "gallophat2" then
--                 local item = hat.components.container and hat.components.container.slots[1]
--                 if item and item.prefab == "alterguardianhat" then
--                     AddBonus(inst, weapon)
--                 else
--                     RemoveBonus(inst, weapon)
--                 end
--             else
--                 RemoveBonus(inst, weapon)
--             end
--         else
--             RemoveBonus(inst, weapon)
--         end
--     end)
-- end

-- AddPrefabPostInit("gallop_brokenking", function(inst)
--     local function onequip(inst, owner)
--         local skin_build = inst:GetSkinBuild()
--         if skin_build ~= nil then
--             owner:PushEvent("equipskinneditem", inst:GetSkinName())
--             owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "gallop_brokenking", inst.GUID, "swap_gallop_brokenking")
--         else
--             owner.AnimState:OverrideSymbol("swap_object", "gallop_brokenking", "swap_gallop_brokenking")
--         end
--         owner.AnimState:Show("ARM_carry")
--         owner.AnimState:Hide("ARM_normal")

--         inst:ListenForEvent("equip", OnRefreshEquip, owner)
--         inst:ListenForEvent("unequip", OnRefreshEquip, owner)
--         inst:ListenForEvent("gallophat2_link", OnRefreshEquip, owner)
--         inst:ListenForEvent("gallophat2_unlink", OnRefreshEquip, owner)
--         OnRefreshEquip(owner)

--         if owner.gallop_brokenking_fx == nil then
--             owner.gallop_brokenking_fx = owner:DoPeriodicTask(6 * FRAMES, do_trail, 2 * FRAMES)
--         end

--         checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen(owner)
--         owner:ListenForEvent('equip',checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen)
--         owner:ListenForEvent('unequip',checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen)

--         if owner.Modifier_common_atkspeedmodifier then
--             owner:Modifier_common_atkspeedmodifier(inst, TUNING.MOD_LOL_WP.gallop_brokenking.add_atkspeed,'gallop_brokenking')
--         end
--     end
--     local function onunequip(inst, owner)
--         owner.AnimState:Hide("ARM_carry")
--         owner.AnimState:Show("ARM_normal")
--         local skin_build = inst:GetSkinBuild()
--         if skin_build ~= nil then
--             owner:PushEvent("unequipskinneditem", inst:GetSkinName())
--         end

--         inst:RemoveEventCallback("equip", OnRefreshEquip, owner)
--         inst:RemoveEventCallback("unequip", OnRefreshEquip, owner)
--         inst:RemoveEventCallback("gallophat2_link", OnRefreshEquip, owner)
--         inst:RemoveEventCallback("gallophat2_unlink", OnRefreshEquip, owner)
--         inst.link_active = nil
--         OnRefreshEquip(owner)

--         if owner.gallop_brokenking_fx ~= nil then
--             owner.gallop_brokenking_fx:Cancel()
--             owner.gallop_brokenking_fx = nil
--         end

--         checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen(owner)
--         owner:RemoveEventCallback('equip',checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen)
--         owner:RemoveEventCallback('unequip',checkifowner_alsoequipped_lol_wp_s15_crown_of_the_shattered_queen)

--         if owner.RemoveModifier_common_atkspeedmodifier then
--             owner:RemoveModifier_common_atkspeedmodifier(inst,'gallop_brokenking')
--         end
--     end
    
--     inst:AddComponent("equippable")
--     inst.components.equippable:SetOnEquip(onequip)
--     inst.components.equippable:SetOnUnequip(onunequip)
-- end)

-- --------------------------------- 狂热移除耐久 ------------------------------------
if TUNING.LOL_WP_S27_FEVER_REMOVE_FINITEUSES then
    AddPrefabPostInit("lol_wp_s27_fever", function(inst)
        if inst.components.finiteuses then
            inst:RemoveComponent("finiteuses")
        end
    end)
else
    AddPrefabPostInit("lol_wp_s27_fever", function(inst)
        if not inst.components.finiteuses then
            inst:AddComponent("finiteuses")
        end
    end)
end