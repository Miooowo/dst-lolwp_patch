-- hide
-- 功能(无需修改): alt写的修改攻速模块 修正版

---@type SourceModifierList
local SourceModifierList = require("util/sourcemodifierlist")

---@class ent
---@field lolwp_patch_atkspeedmodifier_val netvar
---@field lolwp_patch_atkspeedmodifier_modifier SourceModifierList
---@field Modifier_lolwp_patch_atkspeedmodifier fun(self,src:ent,m:number,key:string) # 直接在服务器调用这个实体的方法,来增加攻速,注意是 加算修饰
---@field RemoveModifier_lolwp_patch_atkspeedmodifier fun(self,src:ent,key:string) # 在服务器调用这个实体的方法,来移除攻速修饰

AddPlayerPostInit(function (inst)
    inst.lolwp_patch_atkspeedmodifier_val = net_float(inst.GUID, "lolwp_patch_atkspeedmodifier")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.lolwp_patch_atkspeedmodifier_modifier = SourceModifierList(inst,0,SourceModifierList.additive)
    function inst:Modifier_lolwp_patch_atkspeedmodifier(src,m,key)
        inst.lolwp_patch_atkspeedmodifier_modifier:SetModifier(src,m,key)
        local res = inst.lolwp_patch_atkspeedmodifier_modifier:Get()
        inst.lolwp_patch_atkspeedmodifier_val:set(res)
    end
    function inst:RemoveModifier_lolwp_patch_atkspeedmodifier(src,key)
        inst.lolwp_patch_atkspeedmodifier_modifier:RemoveModifier(src,key)
        local res = inst.lolwp_patch_atkspeedmodifier_modifier:Get()
        inst.lolwp_patch_atkspeedmodifier_val:set(res)
    end
end)


AddComponentPostInit("playervision", function(self)
    local player = self.inst
    local doer = player
    local orangeperiod
    local function isAttackingSG(inst, statename)
        return statename == "attack" or inst.sg and inst.sg:HasStateTag("attack")
            and inst.sg:HasStateTag("abouttoattack")
    end
    doer:ListenForEvent("newstate",
    ---comment
    ---@param inst ent
    ---@param data any
    function(inst, data)
        if not inst.sg then return end
        local statename = data and data.statename
        if inst.lolwp_patch_remove_sgtag_task then
            inst.lolwp_patch_remove_sgtag_task:Cancel()
            inst.AnimState:SetDeltaTimeMultiplier(1)
            if orangeperiod then
                local combat = inst.components.combat or inst.replica.combat
                combat.min_attack_period = orangeperiod
            end
        end
        if isAttackingSG(inst, statename) then
            local timeout = inst.sg.timeout or 0.5 --防止某些模组没写timeout
            local combat = inst.components.combat or inst.replica.combat
            orangeperiod = orangeperiod or combat.min_attack_period or TUNING.WILSON_ATTACK_PERIOD
            local orange_attackspeed = 1 / timeout -- 2.5
            -- local new_attackspeed = orange_attackspeed * (inst.MOD_LOL_WP_ATKSPEED or 1)
            local res = (inst.lolwp_patch_atkspeedmodifier and inst.lolwp_patch_atkspeedmodifier:Get()) or (inst.lolwp_patch_atkspeedmodifier_val and inst.lolwp_patch_atkspeedmodifier_val:value()) or 0
            res = res + 1
            local new_attackspeed = orange_attackspeed * res
            local newperiod = 1 / new_attackspeed
            combat.min_attack_period = newperiod
            inst.AnimState:SetDeltaTimeMultiplier(math.min(2.5, (new_attackspeed / orange_attackspeed)))
            inst.lolwp_patch_remove_sgtag_task = inst:DoTaskInTime(newperiod,
                function()
                    inst.sg:RemoveStateTag("attack")
                    inst.sg:AddStateTag("idle")
                    if TheWorld.ismastersim then
                        inst:PerformBufferedAction()
                    end
                    inst.sg:RemoveStateTag("abouttoattack")
                end)
        end
    end)
end)