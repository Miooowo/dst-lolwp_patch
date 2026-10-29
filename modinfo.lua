-- 本地化
local modname = 'lolwp_patch'
local yesorno = {
    {'是',true},
    {'否',false},
}
local yesorno_en = {
    {'Yes',true},
    {'No',false},
}
local LANGS = {
    ['zh'] = {
        name = '英雄联盟武器补丁',
        description = '对模组英雄联盟武器进行调整修改。\n本次更新：\n1. 部分装备光明强化更新。\n2. 薇诺娜链锯剑强化！\n3. 为两种眼石添加了槽位数配置！',
        config = {
            -- {'设置的id','设置的名称','聚焦时显示的提示',默认值,{
            --     {选项一,值},
            --     {选项二,值}
            -- }},
            --
            {'语言'},
            {modname..'_lang','语言','语言','cn',{
                {'简体中文','cn'},
                {'English','en'}
            }},

            {'光明与黑暗更新'},
            {modname..'gallop_breaker_bright_shadow','破舰者光明转','给予亮茄粉碎者强化10点位面伤害和10%阵营加伤。',
            true,yesorno},
            {modname..'gallop_hydra_bright_shadow','巨型九头蛇光明转','给予亮茄剑强化30点位面伤害和10%阵营加伤。',
            true,yesorno},
            {modname..'lol_wp_trinity_bright_shadow','三相之力光明转','给予亮茄魔杖强化10点位面伤害和10%阵营加伤。',
            true,yesorno},
            {modname..'lol_wp_warmogarmor_bright_shadow','狂徒铠甲光明转','给予亮茄盔甲强化10点位面防御和10%阵营减伤。',
            true,yesorno},
            {modname..'alchemy_chainsaw_bright_shadow','链锯剑光明转','给予亮茄剑强化30点位面伤害和10%阵营加伤。',
            true,yesorno},

            -- {'心之钢调整'},
            -- {modname..'_heartsteel_cd','心之钢CD','调整心之钢CD',30,{
            --     {'1秒',1},
            --     {'5秒',5},
            --     {'10秒',10},
            --     {'30秒',30},
            --     {'60秒',60},
            --     {'120秒',120},
            --     {'240秒',240}
            -- }},
            -- --
            -- {modname..'_heartsteel_chargecd','心之钢快速充能','调整心之钢充能',3,{
            --     {'3次',3},
            --     {'2次',4},
            -- }},
            --
            --{modname..'_heartsteel_wolfgang','心之钢增加力量值上限','进健身房健身生效',true,yesorno},

            {'近战武器调整'},
            {modname..'blcakcutter_custom_mult','黑色切割者调整','精神值百分比影响断头台的额外伤害倍率，空san时为(150/136)倍',
            true,yesorno},
            {modname..'alchemy_chainsaw_for_winona','薇诺娜链锯剑强化','薇诺娜使用炼金朋克链锯剑将增加25%的伤害，并减少15%的耐久消耗',
            true,yesorno},
            { modname .. '_lol_wp_s27_fever', '狂热耐久移除', '移除狂热的耐久',
            true,yesorno},

            {'枪炮武器调整'},
            {modname..'collector_infinitestack','收集者容器扩展','给予弹性空间制造器升级收集者容器，堆叠上限++++++++',
            true,yesorno},
            {modname..'collector_blessing','福光收集者','收集者光明转，给予嚎弹炮获得位面伤害加成！',
            true,yesorno},

            {'魔法道具调整'},
            {modname..'_tears_of_the_goddess','薇克巴顿女神泪强化','当薇克巴顿装配女神泪时，获得充能减半收益',true,yesorno},
            {modname..'_riftmaker_for_wanda','旺达裂隙制造者强化','移除攻击时扣除精神值，并且消耗耐久减半',true,yesorno},
            {modname..'_bloodaxe_for_wanda','旺达渴血战斧调整','增强物理基础伤害，但是攻击拳击袋会扣血',true,yesorno},
            {modname..'_amplifying_tome_finiteuses','取消增幅典籍耐久','取消后无需注意耐久',true,yesorno},
            {modname..'_deathnolose','死亡不掉层',"'黑暗封印'与'梅贾的窃魂卷'死亡不掉层数",true,yesorno},

            {'护符调整'},
            {modname..'_dragonheart_reducetiming','龙心计时加速','使用红宝石，鳞片，岩浆虫卵或龙心右键龙心加速',true,yesorno},

            {'眼石调整'},
            --{modname..'_shadow_eyestone','眼石增加暗影物品标签','当眼石内具有暗影物品时增加暗影物品标签',true,yesorno},
            {modname..'_eyestone_slot','眼石栏','独立专属于眼石的槽位',false,yesorno},
            {modname..'_eyestonelow_container_plus','戒备眼石槽位数量','选择戒备眼石槽位数量',3,{
                {'3',3},
                {'6',6},
                {'9',9},
                {'12',12},
                {'16',16},
            }},
            {modname..'_eyestonehigh_container_plus','警觉眼石槽位数量','选择警觉眼石槽位数量',6,{
                {'6',6},
                {'9',9},
                {'12',12},
                {'15',15},
                {'16',16},
                {'20',20},
                {'25',25},
            }},

            {'其他容器调整'},
            { modname .. 'lol_wp_s24_portable', '海克斯和杰作宝箱全装备放置', '海克斯和杰作宝箱理论上可以放入所有武器和护甲', true, yesorno },

        }
    },
    ['en'] = {
        name = 'lolwp_patch',
        description = 'Adjustments to the lol weapons',
        config = {
            --
            {'LANGUAGE'},
            {modname..'_lang','language','choose language','en',{
                {'简体中文','cn'},
                {'English','en'}
            }},

            {'Light and Dark Update'},
            {modname..'gallop_breaker_bright_shadow','Shipbreaker Bright upgrade','Gives Gallop Crusher 10 points of Planar Damage and 10% increased damage from faction.',
            true,yesorno_en},
            {modname..'gallop_hydra_bright_shadow','Giant Hydra Bright upgrade','Gives Brightshade Sword 30 points of Planar Damage and 10% increased damage from faction.',
            true,yesorno_en},
            {modname..'lol_wp_trinity_bright_shadow','Trinity Force Bright upgrade','Gives Brightshade Staff 10 points of Planar Damage and 10% increased damage from faction.',
            true,yesorno_en},
            {modname..'lol_wp_warmogarmor_bright_shadow',"Warmog's Armor Bright upgrade",'Gives Brightshade Armor 10 points of Planar Defense and 10% Faction Damage Reduction.',
            true,yesorno_en},
            {modname..'alchemy_chainsaw_bright_shadow','Chainsaw Sword Bright upgrade','Gives Brightshade Sword 30 points of Planar Damage and 10% Faction Damage Increase.',
            true,yesorno_en},

            -- {'Heartsteel'},
            -- {modname..'_heartsteel_cd','Heartsteel CD','Adjust Heartsteel CD',30,{
            --     {'1 Second',1},
            --     {'5 Second',5},
            --     {'10 Second',10},
            --     {'30 Second',30},
            --     {'60 Second',60},
            --     {'120 Second',120},
            --     {'240 Second',240}
            -- }},
            --
            -- {modname..'_heartsteel_chargecd','Heartsteel Charge','Adjust Heartsteel Charge',3,{
            --     {'3 Times',3},
            --     {'2 Times',4},
            -- }},
            --
            --{modname..'_heartsteel_wolfgang','Heartsteel Add Mightiness','Wolfgang Mightiness+',true,
            --    yesorno_en,
            --},

            {'Melee Weapons'},
            {modname..'blcakcutter_custom_mult','Black Cutter Adjust','Spirit percentage affects the additional damage of the headcrab',
            true,yesorno_en,
            },
            {modname..'alchemy_chainsaw_for_winona','Winona Chainsaw Enhancement',"Winona's Alchemy Punk Chainsaw increases damage by 25% and reduces durability by 15%",
            true,yesorno_en},
            {modname..'lol_wp_s27_fever','Fever finiteuses remove','Remove the finiteuses of Fever',true,yesorno_en},

            {'Gun Weapons'},
            {modname..'collector_infinitestack','collector infinitestack','Use the Elastispacer to upgrade the container and increase the stacking limit',
            true,yesorno_en},
            {modname..'collector_blessing','blessing collector','The Collector turns to lunar: gives Howlitzer to add planar damage bonus!',
            true,yesorno_en},

            {'Magic Items'},
            {modname..'_tears_of_the_goddess','Tears of the Goddess Adjust','When Goddess Tears are equipped by Wickerbottom, get a half charge bonus',true,
                yesorno_en,
            },
            {modname..'_riftmaker_for_wanda','Wanda Riftmaker Adjust','Remove the cost of spirit when attacking and the durability cost is halved',true,
                yesorno_en,
            },
            {modname..'_bloodaxe_for_wanda','Wanda Bloodaxe Adjust','Enhanced Physical Base Damage, but attack punchbag will lost age',true,
                yesorno_en,
            },
            {modname..'_amplifying_tome_finiteuses','Cancel Amplifying Tome finiteuses','',true,
                yesorno_en,
            },
            {modname..'_deathnolose','Death does not lose layers',"'Dark Seal' and 'Mejai's Soulstealer' will not lose stacks when dying",true,
                yesorno_en,
            },

            {'Eye Stone'},
            --{modname..'_shadow_eyestone','Eye Stone Add Shadow Item Tag','Add Shadow Item Tag to allow Wanda to get the bonus',true,
            --    yesorno_en,
            --},
            {modname..'_eyestone_slot','EyeStone Equip Slots','Extra independent EyeStone Equip Slots.',false,yesorno_en},
            {modname..'_eyestonelow_container_plus','Guardian Eye Stone slot','Number of slot',3,{
                {'3',3},
                {'6',6},
                {'9',9},
                {'12',12},
                {'16',16},
            }},
            {modname..'_eyestonehigh_container_plus','Alert Eye Stone slot','Number of slot',6,{
                {'6',6},
                {'9',9},
                {'12',12},
                {'15',15},
                {'16',16},
                {'20',20},
                {'25',25},
            }},

            {'Other Container Adjust'},
            { modname .. 'lol_wp_s24_portable', 'All Equipment Placement in Hextech and Masterwork Chest', 'The Hextech and Masterwork Chest can theoretically place all weapons and armor', true, yesorno_en },
        }
    }
}

-- 决定当前用的语言
local cur = (locale == 'zh' or locale == 'zhr') and 'zh' or 'en'

-- mod相关信息
version = '1.6.1'
author = 'Clockcycas'
forumthread = ''
api_version = 10
priority = -1001 -- 加载优先级，越低加载越晚，默认为0
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dst_compatible = true
dont_starve_compatible = false 
reign_of_giants_compatible = false
all_clients_require_mod = true 
server_filter_tags = {}

-- 以下自动配置
name = LANGS[cur].name
description = version..'\n'..LANGS[cur].description

local config = LANGS[cur].config or {}
local _configuration_options = {}
for i = 1, #config do
    local options = {}
    if config[i][5] then
        for k = 1, #config[i][5] do
            options[k] = {description = config[i][5][k][1], data = config[i][5][k][2]}
        end
    end
    _configuration_options[i] = {
        name = config[i][1],
        label = config[i][2],
        hover = config[i][3] or '',
        default = config[i][4] or false,
        options = #options>0 and options or {{description = "", data = false}},
    }
end
mod_dependencies = {
	{
		workshop = "workshop-3319931009",
	--this is the workshop id of the mod, this will allow the end users to get prompted to download and sub dependencies
		["英雄联盟武器"] = true,
	}
}
configuration_options = _configuration_options