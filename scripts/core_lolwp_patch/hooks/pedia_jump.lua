--[[
鼠标停在英雄联盟武器的装备上，快速连按两次 Alt，打开原模组图鉴并跳到对应条目。
悬浮检测参照创意工坊 3805239337：先看界面上的物品或配方，没有再看世界里的实体。
]]

if TheNet ~= nil and TheNet:IsDedicated() then
    return
end

local ok_data, data = pcall(require, 'core_lol_wp/data/lol_wp_pedia')
if not ok_data or type(data) ~= 'table' or data.pedia_items == nil or data.groups_order == nil then
    return
end

local DOUBLE_TAP_WINDOW = 0.30
local ALT_KEYS = {
    { key = KEY_LALT, id = 'left' },
    { key = KEY_RALT, id = 'right' },
}
local last_tap_at = {}

-- 图鉴只收了武器本体，护符形态要指回去
local FORM_TO_PEDIA = {
    riftmaker_amulet = 'riftmaker_weapon',
}

local function resolve_pedia_id(prefab)
    if type(prefab) ~= 'string' or prefab == '' then
        return nil
    end
    if data.pedia_items[prefab] ~= nil then
        return prefab
    end
    local mapped = FORM_TO_PEDIA[prefab]
    if mapped and data.pedia_items[mapped] ~= nil then
        return mapped
    end
    local stripped = prefab:gsub('_amulet$', '')
    if stripped ~= prefab and data.pedia_items[stripped] ~= nil then
        return stripped
    end
    return nil
end

local function group_index(group)
    for i, name in ipairs(data.groups_order) do
        if name == group then
            return i
        end
    end
    return nil
end

local function item_icon(id)
    local saved = ThePlayer and ThePlayer.jump_to_lol_pedia_btn_data and ThePlayer.jump_to_lol_pedia_btn_data[id]
    if saved then
        return saved[1], saved[2]
    end
    local entry = data.pedia_items[id]
    local tex = entry and entry.tex or (id .. '.tex')
    local xml = entry and entry.xml or ('images/inventoryimages/' .. id .. '.xml')
    return xml, tex
end

local function is_gameplay_screen()
    if ThePlayer == nil or ThePlayer.HUD == nil or TheFrontEnd == nil then
        return false
    end
    local screen = TheFrontEnd:GetActiveScreen()
    if screen == nil or type(screen.name) ~= 'string' or not screen.name:find('HUD', 1, true) then
        return false
    end
    if (type(ThePlayer.HUD.IsChatInputScreenOpen) == 'function' and ThePlayer.HUD:IsChatInputScreenOpen())
        or ThePlayer.HUD.writeablescreen ~= nil then
        return false
    end
    local controls = ThePlayer.HUD.controls
    local crafting_search = controls
        and controls.craftingmenu
        and controls.craftingmenu.craftingmenu
        and controls.craftingmenu.craftingmenu.search_box
        and controls.craftingmenu.craftingmenu.search_box.textbox
    return crafting_search == nil or not crafting_search.editing
end

local function recipe_from_widget(widget)
    if type(widget.recipe) == 'table' then
        return widget.recipe
    end
    if type(widget.data) == 'table' and type(widget.data.recipe) == 'table' then
        return widget.data.recipe
    end
    local recipe_name = type(widget.recipe_name) == 'string' and widget.recipe_name
        or type(widget.recipename) == 'string' and widget.recipename
        or nil
    if recipe_name and AllRecipes then
        return AllRecipes[recipe_name]
    end
    return nil
end

local function prefab_from_recipe(recipe)
    if type(recipe) ~= 'table' then
        return nil
    end
    if type(recipe.product) == 'string' and recipe.product ~= '' then
        return recipe.product
    end
    if type(recipe.name) == 'string' and recipe.name ~= '' then
        return recipe.name
    end
    return nil
end

local function prefab_from_hud_entity(hud_entity)
    if hud_entity == nil then
        return nil
    end
    if type(hud_entity.prefab) == 'string' then
        return hud_entity.prefab
    end
    local widget = hud_entity.widget
    local remaining = 16
    while widget ~= nil and remaining > 0 do
        if type(widget.item) == 'table' and type(widget.item.prefab) == 'string' then
            return widget.item.prefab
        end
        local from_recipe = prefab_from_recipe(recipe_from_widget(widget))
        if from_recipe then
            return from_recipe
        end
        widget = type(widget.GetParent) == 'function' and widget:GetParent() or widget.parent
        remaining = remaining - 1
    end
    return nil
end

local function hovered_prefab()
    local hud_entity = type(TheInput.GetHUDEntityUnderMouse) == 'function' and TheInput:GetHUDEntityUnderMouse() or nil
    if hud_entity ~= nil then
        return prefab_from_hud_entity(hud_entity)
    end
    local entity = type(TheInput.GetWorldEntityUnderMouse) == 'function' and TheInput:GetWorldEntityUnderMouse() or nil
    if entity ~= nil and entity.client_forward_target ~= nil then
        entity = entity.client_forward_target
    end
    if entity ~= nil and type(entity.prefab) == 'string' then
        return entity.prefab
    end
    return nil
end

local function select_group(pedia, index)
    local wrap = pedia.groups and pedia.groups[index]
    local click = wrap and wrap.btn and wrap.btn.onclick
    if click then
        click()
        return
    end
    if pedia.groups_btn_history_index and pedia.groups[pedia.groups_btn_history_index] then
        pedia.groups[pedia.groups_btn_history_index]:OnClickOtherBtn()
    end
    pedia.groups_btn_history_index = index
    pedia.groups_btn_history = data.groups_order[index]
    if pedia.ScrollSwitchGroup then
        pedia:ScrollSwitchGroup(index)
    end
end

local function open_pedia(prefab)
    local id = resolve_pedia_id(prefab)
    if id == nil or ThePlayer == nil or ThePlayer.HUD == nil or ThePlayer.ShowLOLPedia == nil then
        return
    end
    local pedia = ThePlayer.HUD.lol_wp_pedia
    local entry = data.pedia_items[id]
    local index = entry and group_index(entry.group)
    if pedia == nil or index == nil then
        return
    end
    ThePlayer:ShowLOLPedia(true)
    select_group(pedia, index)
    local xml, tex = item_icon(id)
    pedia:SwitchItem(id, xml, tex)
end

local function on_alt_released(key_id)
    if not is_gameplay_screen() then
        last_tap_at[key_id] = -math.huge
        return
    end
    local now = GetStaticTime()
    local previous = last_tap_at[key_id] or -math.huge
    if now - previous <= DOUBLE_TAP_WINDOW then
        last_tap_at[key_id] = -math.huge
        local prefab = hovered_prefab()
        if prefab then
            open_pedia(prefab)
        end
    else
        last_tap_at[key_id] = now
    end
end

for _, trigger in ipairs(ALT_KEYS) do
    local key = trigger.key
    local key_id = trigger.id
    TheInput:AddKeyUpHandler(key, function()
        on_alt_released(key_id)
    end)
end
