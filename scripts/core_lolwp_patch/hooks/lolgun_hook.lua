-- --------------------------------- 收集者容器扩展 -----------------------------------
if TUNING.COLLECTOR_INFINITESTACK then
    AddPrefabPostInit("lol_wp_s13_collector", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        if inst.components.container ~= nil then
            -- 加上 upgradeable 组件
            if inst.components.upgradeable == nil then
                inst:AddComponent("upgradeable")
                inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST  -- 这里可以自定义类型

                -- 定义升级时的效果
                inst.components.upgradeable.onupgradefn = function(inst, doer, item)
                    if inst.components.container ~= nil then
                        inst.components.container:EnableInfiniteStackSize(true)
                    end
                end
                inst.components.upgradeable:SetOnUpgradeFn(inst.components.upgradeable.onupgradefn)
            end
        end
    end)
end