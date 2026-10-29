local function OnAttackOther(inst, data)
    local oldager = inst.components.oldager
    local health = inst.components.health
    local sanity = inst.components.sanity
    local dfdmg = inst.components.combat.defaultdamage
    if inst.prefab == "wanda" and oldager ~= nil then
        if data.weapon ~= nil and data.weapon.prefab == "gallop_bloodaxe" then
            if inst.age_state == "young" and oldager.rate == 1 then
                dfdmg = dfdmg
                oldager.rate = 2
                --扣除8年龄
                health:DoDelta(-health.maxhealth*(1/3), true, data.prefab)
                --sanity:DoDelta(2, true, data.prefab)
            elseif inst.age_state == "normal" then
                dfdmg = dfdmg * 1.5
                oldager.rate = 1.25
                --扣除约2.667年龄
                health:DoDelta(-health.maxhealth*(1/9), true, data.prefab)
                --sanity:DoDelta(2, true, data.prefab)
            elseif inst.age_state == "old" then
                dfdmg = dfdmg * 2
                oldager.rate = 0.75
                --扣除约0.889年龄
                --health:DoDelta(-health.maxhealth*(1/27), true, data.prefab)
                --sanity:DoDelta(2, true, data.prefab)
            end
        end
        if data.weapon == nil then
            dfdmg = dfdmg
            oldager.rate = 1
        end
    end
end

local function AddAttackListener(inst)
    if inst.components.combat ~= nil then
        inst:ListenForEvent("onattackother", OnAttackOther)
    end
end

AddPrefabPostInit("wanda", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    --inst.components.oldager.valid_healing_causes["gallop_bloodaxe"] = false
    inst:DoTaskInTime(0, function()
        AddAttackListener(inst)
    end)
end)