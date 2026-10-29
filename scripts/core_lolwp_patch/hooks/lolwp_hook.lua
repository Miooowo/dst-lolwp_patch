-- AddPrefabPostInit("fx_lol_heartsteel", function(inst)
--     if not GLOBAL.TheWorld.ismastersim then
--         return
--     end
--     inst.stage = TUNING.HEARTSTEEL_CHARGECD or 4
--     --print("心之钢充能"..inst.stage)
-- end)

--[[
if TUNING.HEARTSTELL_WOLFGANG then
-- -------------------------------- 心之钢加力量值上限 ------------------------------- --
AddComponentPostInit("lol_heartsteel_data", function(self)
    -- 保存原始函数
    local old_onequip = self.onequip
    local old_onunequip = self.onunequip

    -- 修改 onequip 函数
    function self:onequip(inst, owner)
        -- 调用原始逻辑
        old_onequip(self, inst, owner)

        -- 新增逻辑：判断装备者是否具有 mightiness 组件
        if owner.components.mightiness then
            local lol_heartsteel_num = inst.components.lol_heartsteel_num and inst.components.lol_heartsteel_num:GetNum() or 0
            print("心之钢层数"..lol_heartsteel_num)
            local extra_max = lol_heartsteel_num -- 额外增加的上限
            local mightiness_max = owner.components.mightiness.max
            if extra_max <= 155 then
                mightiness_max = owner.components.mightiness.max + extra_max
            elseif extra_max > 155 then
                mightiness_max = owner.components.mightiness.max + 155
            end
            if owner.components.mightiness:GetOverMax() < mightiness_max then
                owner.components.mightiness:SetOverMax(mightiness_max)
            end
            print("增加上限"..mightiness_max)
        end
    end

    -- 修改 onunequip 函数
    function self:onunequip(inst, owner)
        -- 调用原始逻辑
        old_onunequip(self, inst, owner)

        -- 新增逻辑：还原 mightiness 组件的修改
        if owner.components.mightiness then
            local lol_heartsteel_num = inst.components.lol_heartsteel_num and inst.components.lol_heartsteel_num:GetNum() or 0
            local extra_max = lol_heartsteel_num -- 额外减少的上限
            local mightiness_max = owner.components.mightiness.max
            if extra_max <= 155 then
                mightiness_max = owner.components.mightiness.max - extra_max
            elseif extra_max > 155 then
                mightiness_max = owner.components.mightiness.max - 155
            end
            if owner.components.mightiness:GetOverMax() > mightiness_max then
                owner.components.mightiness:SetOverMax(mightiness_max)
            end
        end
    end
end)
-- -------------------------------------------------------------------------- --
end
]]
--[[
if TUNING.EYESTONE_SHADOW then
--旺达增强：为眼石增加暗影物品标签
    local function AddCustomListeners(inst)
        -- 原始 itemget 逻辑 hook
        local old_itemget = inst.event_listeners and inst.event_listeners.itemget
        inst:ListenForEvent("itemget", function(inst, data)
            if old_itemget then
                -- 执行原始逻辑
                for _, fn in ipairs(old_itemget) do
                    fn(inst, data)
                end
            end

            -- 自定义逻辑
            if data and data.item then
                local item = data.item
                if item:HasTag("shadow") or item:HasTag("shadow_item") then
                    print("Custom logic: Adding shadow tags based on container content")
                    if not inst:HasTag("shadow") then
                        inst:AddTag("shadow")
                    end
                    if not inst:HasTag("shadow_item") then
                        inst:AddTag("shadow_item")
                    end
                end
            end
        end)

        -- 原始 itemlose 逻辑 hook
        local old_itemlose = inst.event_listeners and inst.event_listeners.itemlose
        inst:ListenForEvent("itemlose", function(inst, data)
            if old_itemlose then
                -- 执行原始逻辑
                for _, fn in ipairs(old_itemlose) do
                    fn(inst, data)
                end
            end

            -- 自定义逻辑
            local has_shadow_item = false
            if inst.components.container then
                for _, item in pairs(inst.components.container.slots) do
                    if item and (item:HasTag("shadow") or item:HasTag("shadow_item")) then
                        has_shadow_item = true
                        break
                    end
                end
            end

            if not has_shadow_item then
                print("Custom logic: Removing shadow tags based on container content")
                inst:RemoveTag("shadow")
                inst:RemoveTag("shadow_item")
            end
        end)
    end

    -- 在目标 prefab 上添加 Hook
    AddPrefabPostInit("lol_wp_s9_eyestone_high", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end
        if inst and inst.components.container then
            AddCustomListeners(inst)
        end
    end)
    AddPrefabPostInit("lol_wp_s9_eyestone_low", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end
        if inst and inst.components.container then
            AddCustomListeners(inst)
        end
    end)
end
]]
if TUNING.RIFTMAKER_FOR_WANDA then
-- 裂隙制造者旺达优化
    AddComponentPostInit('combat', function(self)
        -- 获取原始 hook 的函数
        local original_hooked_function = self.GetAttacked

        -- 替换为新的函数
        self.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage, ...)
            ---@type ent
            local victim = self.inst

            -- 调用原始函数，获取返回值
            local modified_attacker, modified_damage, modified_weapon, modified_stimuli, modified_spdamage, args =
                original_hooked_function(self, attacker, damage, weapon, stimuli, spdamage, ...)

            -- 如果攻击者是旺达，进行特殊逻辑处理
            if attacker and attacker.prefab == "wanda" then
                -- 检查是否装备了护符
                local has_riftmaker_amulet = false
                local equips, found = LOLWP_S:findEquipments(attacker, "riftmaker_amulet")
                if found then
                    has_riftmaker_amulet = true
                    for _, equip in pairs(equips) do
                        -- 旺达消耗半点耐久
                        if equip.components.finiteuses then
                            equip.components.finiteuses:Use(0.5)
                        end
                    end
                end

                local amuletineyestone = LOLWP_U:getEquipInEyeStone(attacker, "riftmaker_amulet")
                if amuletineyestone then
                    has_riftmaker_amulet = true
                    if amuletineyestone.components.finiteuses then
                        amuletineyestone.components.finiteuses:Use(-0.5)
                    end
                end

                -- 如果旺达装备了护符，则取消理智消耗
                if has_riftmaker_amulet then
                    -- 不执行理智消耗逻辑
                    return modified_attacker, modified_damage, modified_weapon, modified_stimuli, modified_spdamage, args
                end
            end

            -- 返回原始或修改后的结果
            return modified_attacker, modified_damage, modified_weapon, modified_stimuli, modified_spdamage, args
        end
    end)
end


--暗黑封印和杀人书不掉层
AddComponentPostInit("lol_wp_s11_darkseal_num", function(self)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if TUNING.DEATH_NOLOSE then
        local function ondeath_lol_wp_s11_darkseal(player)
            local equips,found = LOLWP_S:findEquipments(player,'lol_wp_s11_darkseal')
            if found then
                for _,equip in ipairs(equips) do
                    if equip.components.lol_wp_s11_darkseal_num then
                        --print("黑暗封印死亡不掉层！")
                        --equip.components.lol_wp_s11_darkseal_num:DoDelta(-db.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK)
                    end
                end
            end
            local ineyestone = LOLWP_U:getEquipInEyeStone(player,'lol_wp_s11_darkseal')
            if ineyestone then
                if ineyestone.components.lol_wp_s11_darkseal_num then
                    --print("黑暗封印死亡不掉层！")
                    --ineyestone.components.lol_wp_s11_darkseal_num:DoDelta(-db.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK)
                end
            end
        end

        function self:WhenEquip(inst,owner)
            owner:ListenForEvent('death',ondeath_lol_wp_s11_darkseal)
        end
        function self:WhenUnequip(inst,owner)
            owner:RemoveEventCallback('death',ondeath_lol_wp_s11_darkseal)
        end
    end
end)

AddComponentPostInit("lol_wp_s11_mejaisoulstealer_num", function(self)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if TUNING.DEATH_NOLOSE then
        local function ondeath_lol_wp_s11_mejaisoulstealer(player)
            local equips,found = LOLWP_S:findEquipments(player,'lol_wp_s11_mejaisoulstealer')
            if found then
                for _,equip in ipairs(equips) do
                    if equip.components.lol_wp_s11_mejaisoulstealer_num then
                        --print("杀人书死亡不掉层！")
                    end
                end
            end
            local ineyestone = LOLWP_U:getEquipInEyeStone(player,'lol_wp_s11_mejaisoulstealer')
            if ineyestone then
                if ineyestone.components.lol_wp_s11_mejaisoulstealer_num then
                    --print("杀人书死亡不掉层！")
                end
            end
        end

        function self:WhenEquip(inst,owner)
            owner:ListenForEvent('death',ondeath_lol_wp_s11_mejaisoulstealer)
        end
        function self:WhenUnequip(inst,owner)
            owner:RemoveEventCallback('death',ondeath_lol_wp_s11_mejaisoulstealer)
        end
    end
end)

--增幅法典移除耐久
AddPrefabPostInit("lol_wp_s11_amplifyingtome", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    
    if TUNING.MOD_LOL_WP.AMPLIFYINGTOME.FINITEUSES and inst.components.finiteuses then
        inst:RemoveComponent("finiteuses")
    end
end)

if TUNING.TEARS_WICKERBOTTOM then
-- -------------------------------- 薇克巴顿女神泪强化 ------------------------------- --
    AddComponentPostInit("combat", function(self)
        local old_GetAttacked = self.GetAttacked
        ---comment
        ---@param attacker ent
        ---@param damage any
        ---@param weapon any
        ---@param stimuli any
        ---@param spdamage any
        ---@param ... unknown
        ---@return unknown
        function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
            if attacker and attacker:HasTag("player") then
                local equips, found = LOLWP_S:findEquipments(attacker, 'lol_wp_s7_tearsofgoddess')
                if found then
                    for _, v in pairs(equips) do
                        if v.components.rechargeable and v.components.rechargeable:IsCharged() and v.components.lol_wp_s7_tearsofgoddess then
                            local cooldown = TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.CD
                            -- 如果装备者是 Wickerbottom，减少冷却时间
                            if attacker.prefab == "wickerbottom" then
                                cooldown = cooldown * 0.5
                            end
                            v.components.lol_wp_s7_tearsofgoddess:DoDelta(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.NUM_PER_HIT, attacker)
                            v.components.rechargeable:Discharge(cooldown)
                        end
                    end
                end

                local eyestone_itm = LOLWP_U:getEquipInEyeStone(attacker, 'lol_wp_s7_tearsofgoddess')
                if eyestone_itm then
                    if eyestone_itm.components.rechargeable and eyestone_itm.components.rechargeable:IsCharged() and eyestone_itm.components.lol_wp_s7_tearsofgoddess then
                        local cooldown = TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.CD
                        -- 如果装备者是 Wickerbottom，减少冷却时间
                        if attacker.prefab == "wickerbottom" then
                            cooldown = cooldown * 0.5
                        end
                        eyestone_itm.components.lol_wp_s7_tearsofgoddess:DoDelta(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.NUM_PER_HIT, attacker)
                        eyestone_itm.components.rechargeable:Discharge(cooldown)
                    end
                end
            end

            return old_GetAttacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
        end
    end)
-- ---------------------------------------------------------------------------------- --
end