---@class replica_components
---@field event_trigger_lolwp_patch replica_event_trigger_lolwp_patch

---@class replica_event_trigger_lolwp_patch
---@field inst ent
---@field event_name netvar
---@field type netvar
---@field trigger netvar
local event_trigger_lolwp_patch = Class(
---@param self replica_event_trigger_lolwp_patch
---@param inst ent
function(self, inst)
    self.inst = inst
    self.event_name = net_string(inst.GUID, "event_trigger_lolwp_patch.event_name")
    self.type = net_string(inst.GUID, "event_trigger_lolwp_patch.type")
    self.trigger = net_bool(inst.GUID, "event_trigger_lolwp_patch.trigger",'event_trigger_lolwp_patch_triggered')
end)

function event_trigger_lolwp_patch:SetEventName(event_name)
    self.event_name:set(event_name)
end

function event_trigger_lolwp_patch:GetEventName()
    return self.event_name:value()
end

function event_trigger_lolwp_patch:SetType(type)
    self.type:set(type)
end

function event_trigger_lolwp_patch:GetType()
    return self.type:value()
end

function event_trigger_lolwp_patch:Trigger(value)
    return self.trigger:set(value)
end

return event_trigger_lolwp_patch