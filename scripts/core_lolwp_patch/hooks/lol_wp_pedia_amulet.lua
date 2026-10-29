--[[
给英雄联盟武器图鉴追加「护符装备」分组。
原分类保留，这里只增加一份别名条目。点击时还原到原条目，说明和检视台词不变。
]]

local AMULET_PREFABS = {
    -- 可以变成护符
    lol_wp_trinity = true,
    riftmaker_weapon = true,
    lol_wp_s13_infinity_edge = true,
    lol_wp_s10_guinsoo = true,
    lol_wp_s21_infinityorb = true,
    lol_wp_s31_reaver = true,
    lol_wp_s38_deathdance = true,
    -- 本身是护符
    lol_wp_s7_tearsofgoddess = true,
    lol_wp_s7_doranring = true,
    lol_heartsteel = true,
    lol_wp_s11_amplifyingtome = true,
    lol_wp_s11_darkseal = true,
    lol_wp_s11_mejaisoulstealer = true,
    lol_wp_s15_zhonya = true,
    lol_wp_s17_lostchapter = true,
    lol_wp_s20_frozenheart_armor = true,
    lol_wp_s21_bansheeveil = true,
    lol_wp_s21_imperialmandate = true,
    lol_wp_s23_guardianangel = true,
    lol_wp_s25_navori_amulet = true,
    lol_wp_s26_ascension_amulet = true,
    lol_wp_s26_dragonheart = true,
    lol_wp_s27_fever = true,
    lol_wp_s30_amulet_infinitehatred = true,
    lol_wp_s30_amulet_phantomdancer = true,
    lol_wp_s30_amulet_cripplingplague = true,
    lol_wp_s31_mirror = true,
    lol_wp_s33_amuletnoonquiver = true,
    lol_wp_s35_kindlegem = true,
    lol_wp_s35_glacialbuckler = true,
    lol_wp_s36_fiendishcodex = true,
    lol_wp_s7_hunteramulet = true,
    lol_wp_s37_redemption = true,
    lol_wp_s38_c44 = true,
}

local alias_to_prefab = {}

local ok_data, data = pcall(require, 'core_lol_wp/data/lol_wp_pedia')
if not ok_data or type(data) ~= 'table' or data.pedia_items == nil or data.groups_order == nil then
    return
end

local lang_id = TUNING['CONFIG_LOL_WP_LANG'] or 'cn'
local ok_lang, lang = pcall(require, 'core_lol_wp/languages/lol_wp_pedia/' .. lang_id)
if ok_lang and type(lang) == 'table' and lang.lol_wp_pedia_group then
    lang.lol_wp_pedia_group.amulet = lang_id == 'en' and 'Amulets' or '护符装备'
end

data.group_spec = data.group_spec or {}
data.group_spec.amulet = data.group_spec.amulet or {
    btn_color = { 246 / 255, 224 / 255, 35 / 255, 1 },
}

local has_group = false
for _, group in ipairs(data.groups_order) do
    if group == 'amulet' then
        has_group = true
        break
    end
end
if not has_group then
    table.insert(data.groups_order, 'amulet')
end

local existing_order = {}
for _, id in ipairs(data.pedia_items_order) do
    existing_order[#existing_order + 1] = id
end

for _, id in ipairs(existing_order) do
    local src = data.pedia_items[id]
    if AMULET_PREFABS[id] and src and src.group ~= 'amulet' then
        local alias = 'amuletpedia_' .. id
        if data.pedia_items[alias] == nil then
            data.pedia_items[alias] = {
                name = src.name,
                group = 'amulet',
                info_instead = src.info_instead,
                name_rgba = src.name_rgba,
                xml = src.xml or ('images/inventoryimages/' .. id .. '.xml'),
                tex = src.tex or (id .. '.tex'),
            }
            table.insert(data.pedia_items_order, alias)
            alias_to_prefab[alias] = id
        end
    end
end

local ok_widget, pedia_widget = pcall(require, 'core_lol_wp/widgets/lol_wp_pedia')
if ok_widget and type(pedia_widget) == 'table' and pedia_widget.SwitchItem then
    local old_SwitchItem = pedia_widget.SwitchItem
    function pedia_widget:SwitchItem(id, xml, tex, ...)
        local real = alias_to_prefab[id]
        if real then
            return old_SwitchItem(self, real, xml, tex, ...)
        end
        return old_SwitchItem(self, id, xml, tex, ...)
    end
end

AddClassPostConstruct('screens/playerhud', function(self)
    local pedia = self.lol_wp_pedia
    if pedia == nil or pedia.groups == nil or #pedia.groups <= 6 then
        return
    end
    for i, btn in ipairs(pedia.groups) do
        btn:SetPosition(-538, 180 - i * 44, 0)
    end
end)
