--[[
眼石内装备耐久自动修复。
耐久低于 30% 时，按原模组修理表消耗玩家物品栏或已装备背包里的材料：
1. 材料够则修到不超过 100% 的上限（不消耗会溢出的那一次）
2. 不够则只修到刚超过 70%
3. 再不够则只修复一次
]]

local THRESHOLD = 0.30
local OVER_LINE = 0.70
local EYESTONES = {
    'lol_wp_s9_eyestone_low',
    'lol_wp_s9_eyestone_high',
}

-- 裂隙制造者走独立的添加燃料动作，不在原模组的 REPAIR 表里。
-- 噩梦燃料 +10%，纯粹恐惧 +50%。武器和护符形态都算。
local EXTRA_FINITEUSES = {
    riftmaker_weapon = {
        nightmarefuel = 0.1,
        horrorfuel = 0.5,
    },
    riftmaker_amulet = {
        nightmarefuel = 0.1,
        horrorfuel = 0.5,
    },
}

local function steps_within(percent, delta, limit)
    local n = 0
    if not delta or delta <= 0 then
        return 0
    end
    while percent + (n + 1) * delta <= limit + 1e-6 do
        n = n + 1
        if n >= 1000 then
            break
        end
    end
    return n
end

local function steps_over(percent, delta, limit)
    local n = 0
    if not delta or delta <= 0 then
        return 0
    end
    while percent + n * delta <= limit + 1e-6 do
        n = n + 1
        if n >= 1000 then
            break
        end
    end
    return n
end

local function find_player_owner(inst)
    local item = inst.components.inventoryitem
    local owner = item and item.owner
    if owner == nil then
        return nil
    end
    if owner:HasTag('player') and owner.components.inventory then
        return owner
    end
    local holder_item = owner.components.inventoryitem
    local holder = holder_item and holder_item.owner
    if holder and holder:HasTag('player') and holder.components.inventory then
        local inv = holder.components.inventory
        if inv:GetEquippedItem(EQUIPSLOTS.BODY) == owner then
            return holder
        end
        if EQUIPSLOTS.BACK and inv:GetEquippedItem(EQUIPSLOTS.BACK) == owner then
            return holder
        end
    end
    return nil
end

local function each_material_source(player, eyestone, fn)
    local inv = player.components.inventory
    if inv == nil then
        return
    end
    for _, item in pairs(inv.itemslots or {}) do
        fn(item)
    end
    if inv.activeitem then
        fn(inv.activeitem)
    end
    local function scan_equip(slot)
        if slot == nil then
            return
        end
        local equip = inv:GetEquippedItem(slot)
        if equip and equip ~= eyestone and equip.components.container then
            for _, item in pairs(equip.components.container.slots or {}) do
                fn(item)
            end
        end
    end
    scan_equip(EQUIPSLOTS.BODY)
    scan_equip(EQUIPSLOTS.BACK)
end

local function count_prefab(player, eyestone, prefab)
    local n = 0
    each_material_source(player, eyestone, function(item)
        if item and item:IsValid() and item.prefab == prefab then
            if item.components.stackable then
                n = n + item.components.stackable:StackSize()
            else
                n = n + 1
            end
        end
    end)
    return n
end

local function consume_prefab(player, eyestone, prefab, amount)
    local left = amount
    local found = {}
    each_material_source(player, eyestone, function(item)
        if item and item:IsValid() and item.prefab == prefab then
            found[#found + 1] = item
        end
    end)
    for _, item in ipairs(found) do
        if left <= 0 then
            break
        end
        if item:IsValid() then
            if item.components.stackable then
                local size = item.components.stackable:StackSize()
                local take = math.min(size, left)
                if take >= size then
                    item:Remove()
                else
                    item.components.stackable:Get(take):Remove()
                end
                left = left - take
            else
                item:Remove()
                left = left - 1
            end
        end
    end
    return left <= 0
end

local function repair_sources(item)
    local db = TUNING.MOD_LOL_WP
    if db == nil or item.prefab == nil then
        return nil
    end
    local extra = item.components.finiteuses and EXTRA_FINITEUSES[item.prefab]
    if extra then
        return 'finiteuses', extra
    end
    local id = string.upper(item.prefab)
    if item.components.finiteuses and db.REPAIR and db.REPAIR[id] then
        return 'finiteuses', db.REPAIR[id]
    end
    if item.components.armor and db.REPAIR_ARMOR and db.REPAIR_ARMOR[id] then
        return 'armor', db.REPAIR_ARMOR[id]
    end
    if item.components.fueled and db.REPAIR_FUELED and db.REPAIR_FUELED[id] then
        return 'fueled', db.REPAIR_FUELED[id]
    end
    return nil
end

local function sorted_materials(recipe)
    local list = {}
    for key, delta in pairs(recipe) do
        if type(delta) == 'number' and delta > 0 then
            list[#list + 1] = { prefab = string.lower(key), delta = delta }
        end
    end
    table.sort(list, function(a, b)
        if a.delta == b.delta then
            return a.prefab < b.prefab
        end
        return a.delta < b.delta
    end)
    return list
end

local function play_repair_sound(player, prefab)
    if player.SoundEmitter == nil then
        return
    end
    local sound = (prefab == 'nightmarefuel' or prefab == 'horrorfuel') and 'dontstarve/common/nightmareAddFuel' or 'aqol/new_test/metal'
    player.SoundEmitter:PlaySound(sound)
end

local function try_repair_item(player, eyestone, item)
    if item == nil or not item:IsValid() then
        return
    end
    local comp_name, recipe = repair_sources(item)
    if comp_name == nil then
        return
    end
    local comp = item.components[comp_name]
    local percent = comp and comp.GetPercent and comp:GetPercent()
    if percent == nil or percent >= THRESHOLD then
        return
    end

    local options = {}
    for _, mat in ipairs(sorted_materials(recipe)) do
        options[#options + 1] = {
            prefab = mat.prefab,
            delta = mat.delta,
            have = count_prefab(player, eyestone, mat.prefab),
            n_full = steps_within(percent, mat.delta, 1),
            n_over = steps_over(percent, mat.delta, OVER_LINE),
        }
    end

    local chosen, count
    for _, opt in ipairs(options) do
        if opt.n_full >= 1 and opt.have >= opt.n_full then
            chosen, count = opt, opt.n_full
            break
        end
    end
    if chosen == nil then
        for _, opt in ipairs(options) do
            if opt.n_over >= 1 and opt.have >= opt.n_over then
                chosen, count = opt, opt.n_over
                break
            end
        end
    end
    if chosen == nil then
        for _, opt in ipairs(options) do
            if opt.have >= 1 then
                chosen, count = opt, 1
                break
            end
        end
    end
    if chosen == nil then
        return
    end

    if not consume_prefab(player, eyestone, chosen.prefab, count) then
        return
    end
    comp:SetPercent(math.min(1, percent + chosen.delta * count))
    if item:HasTag(item.prefab .. '_nofiniteuses') then
        item:RemoveTag(item.prefab .. '_nofiniteuses')
    end
    if EXTRA_FINITEUSES[item.prefab] and item.components.equippable then
        item.components.equippable.restrictedtag = nil
    end
    if comp_name == 'fueled' then
        if item.lol_wp_whentakefuel ~= nil then
            item.lol_wp_whentakefuel(item)
        end
        if item.components.equippable ~= nil and item.components.equippable:IsEquipped() and item.components.fueled then
            item.components.fueled:StartConsuming()
        end
    end
    item:PushEvent('lol_wp_repair')
    play_repair_sound(player, chosen.prefab)
end

local function try_repair_eyestone(inst)
    local container = inst.components.container
    if container == nil then
        return
    end
    local player = find_player_owner(inst)
    if player == nil then
        return
    end
    for slot = 1, container:GetNumSlots() do
        try_repair_item(player, inst, container:GetItemInSlot(slot))
    end
end

for _, prefab in ipairs(EYESTONES) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:DoPeriodicTask(1, try_repair_eyestone)
    end)
end
