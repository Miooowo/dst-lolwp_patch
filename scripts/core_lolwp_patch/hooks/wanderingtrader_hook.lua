--[[
Author: Miooowo
Date: 2025-08-21 15:19:36
LastEditors: Miooowo
LastEditTime: 2025-08-22 06:04:15
Description: Although I rarely use github, I still registered it: https://github.com/Miooowo

Copyright (c) 2025 by Miooowo, All Rights Reserved. 
--]]
--[[
Author: Miooowo
Date: 2025-08-21 15:19:36
LastEditors: Miooowo
LastEditTime: 2025-08-21 15:21:46
Description: Although I rarely use github, I still registered it: https://github.com/Miooowo

Copyright (c) 2025 by Miooowo, All Rights Reserved. 
--]]
-- [[ WANDERINGTRADER ]]
--配方名前缀喵
local recname = "wanderingtradershop_i2" 
--商品信息
local NewWares = {  
    ["lol_wp_s26_dragonheart"] = { --商品prefab
        min = 1, max = 3, limit = 5,    --进货最小值、进货最大值、库存最大值   （16分钟进货一次）
        ingredients = {Ingredient("dragon_scales", 255),},    --配方
        numtogive = 1,     --每次交易数量(可nil)
        des = "低价好货，走过不要错过！",   --配方描述（可nil）
    },
    ["lol_wp_s16_potion_hp"] = { --商品prefab
        min = 1, max = 3, limit = 3,    --进货最小值、进货最大值、库存最大值   （16分钟进货一次）
        ingredients = {Ingredient("ash", 3),},    --配方
        numtogive = 1,     --每次交易数量(可nil)
        des = STRINGS.RECIPE_DESC.LOL_WP_S16_POTION_HP,   --配方描述（可nil）
    },
    ["lol_wp_s6_mana_potion"] = { --商品prefab
        min = 1, max = 3, limit = 3,    --进货最小值、进货最大值、库存最大值   （16分钟进货一次）
        ingredients = {Ingredient("ash", 3),},    --配方
        numtogive = 1,     --每次交易数量(可nil)
        des = STRINGS.RECIPE_DESC.LOL_WP_S6_MANA_POTION,   --配方描述（可nil）
    },
    ["lol_wp_s6_biscuit"] = { --商品prefab
        min = 1, max = 5, limit = 8,    --进货最小值、进货最大值、库存最大值   （16分钟进货一次）
        ingredients = {Ingredient("honey", 3),},    --配方
        numtogive = 1,     --每次交易数量(可nil)
        des = STRINGS.RECIPE_DESC.LOL_WP_S6_BISCUIT,   --配方描述（可nil）
    },
    ["lol_wp_s6_porosnack"] = { --商品prefab
        min = 1, max = 5, limit = 8,    --进货最小值、进货最大值、库存最大值   （16分钟进货一次）
        ingredients = {Ingredient("forgetmelots", 1),Ingredient("honey", 2)},    --配方
        numtogive = 1,     --每次交易数量(可nil)
        des = STRINGS.RECIPE_DESC.LOL_WP_S6_POROSNACK,   --配方描述（可nil）
    },
}

for product, v in pairs(NewWares) do
    local recipename = recname..product
    STRINGS.RECIPE_DESC[string.upper(recipename)] = v.des
    v.recipe = recipename
    AddRecipe2(recipename, v.ingredients, TECH.LOST, 
    {limitedamount = true, nounlock = true, actionstr="WANDERINGTRADERSHOP", sg_state="give", 
    product = product, numtogive = v.numtogive, description = recipename})
end

local function RerollWares(inst, wares, ...)
    inst:AddWares(NewWares)
    return inst.i3o_RerollWares(inst, ...)
end

AddPrefabPostInit("wanderingtrader", function(inst)
    if inst.RerollWares then
        inst.i3o_RerollWares = inst.RerollWares
        inst.RerollWares = RerollWares
    end
end)