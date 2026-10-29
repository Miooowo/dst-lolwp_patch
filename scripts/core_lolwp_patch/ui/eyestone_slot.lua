--[[
Author: Miooowo
Date: 2025-08-21 15:52:45
LastEditors: Miooowo
LastEditTime: 2025-08-22 01:02:03
Description: Although I rarely use github, I still registered it: https://github.com/Miooowo

Copyright (c) 2025 by Miooowo, All Rights Reserved. 
--]]
if TUNING.ADD_EYESTONE_EQUIPSLOTS then
	local Widget = require "widgets/widget"

	if GLOBAL.EQUIPSLOTS then
		GLOBAL.EQUIPSLOTS["EYESTONE"]="eyestone"
	else
		GLOBAL.EQUIPSLOTS=
		{
			HANDS = "hands",
			HEAD = "head",
			BODY = "body",
			BEARD = "beard",
			EYESTONE = "eyestone",
		}
	end

	local W = 68
	local SEP = 12
	local INTERSEP = 28
	AddClassPostConstruct("widgets/inventorybar",function(self, owner)
		--勋章栏
		self:AddEquipSlot(GLOBAL.EQUIPSLOTS.EYESTONE, "images/slotbg/eyestone_slotbg.xml", "eyestone_slotbg.tex")
		--融合勋章栏
		self.eyestone_inv=self.root:AddChild(Widget("eyestone_inv"))
		self.eyestone_inv:SetScale(1.5, 1.5)
		--调整人物检查按钮位置
		if self.inspectcontrol then
			local total_w, x = self:getTotalW()
			self.inspectcontrol.icon:SetPosition(-4, 6)
			self.inspectcontrol:SetPosition((total_w - W) * .5 + 3, -6, 0)
		end

		--获取total_w
		self.getTotalW = function(self)
			local inventory = self.owner.replica.inventory
			local num_slots = inventory:GetNumSlots()
			local num_equip = #self.equipslotinfo
			local num_buttons = self.controller_build and 0 or 1
			local num_slotintersep = math.ceil(num_slots / 5)
			local num_equipintersep = num_buttons > 0 and 1 or 0
			local total_w = (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
			local x=(W - total_w) * .5 + num_slots * W + (num_slots - num_slotintersep) * SEP + num_slotintersep * INTERSEP
			return total_w,x
		end
		--更新融合勋章栏位置
		self.RefreshMedalInvPos = function(self)
			local total_w, x = self:getTotalW()
			local overflow = self.owner.replica.inventory and self.owner.replica.inventory:GetOverflowContainer()--获取玩家的背包
			--判断是否有背包并且出入融合模式,有的话位置要上移一点
			local eyestone_inv_y = overflow and overflow:IsOpenedBy(self.owner) and self.integrated_backpack and 80 or 40
			for k, v in ipairs(self.equipslotinfo) do
				if v.slot == EQUIPSLOTS.EYESTONE then
					self.eyestone_inv:SetPosition(x, eyestone_inv_y, 0)
				end
				x = x + W + SEP
			end
		end
		--更新物品栏背景长度
		self.RefreshBgSize = function(self)
			-- self.bg:SetScale(1.3+(slot-4)*0.05,1,1.25)--根据格子数量缩放装备栏
			-- self.bgcover:SetScale(1.3+(slot-4)*0.05,1,1.25)
			if self.bg and self.bg.GetSize then
				local total_w,_ = self:getTotalW()
				local w,_ = self.bg:GetSize()
				self.bg:SetScale((total_w+W+SEP)/w,1,1)--根据格子数量缩放装备栏
				self.bgcover:SetScale((total_w+W+SEP)/w,1,1)
			end
		end

		local oldRefresh = self.Refresh
		local oldRebuild = self.Rebuild

		self.Refresh = function(self, ...)
			if oldRefresh then
				oldRefresh(self, ...)
			end
			self:RefreshBgSize()
		end
		
		self.Rebuild = function(self, ...)
			if oldRebuild then
				oldRebuild(self, ...)
			end
			self:RefreshBgSize()
			self:RefreshMedalInvPos()
		end
	end)
end
