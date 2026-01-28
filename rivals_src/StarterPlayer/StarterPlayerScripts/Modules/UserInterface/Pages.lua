local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.CONSTANTS)
local v_u_6 = require(v1.Modules.DebugLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_14 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_15 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("PageSystem"))
local v_u_16 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_17 = {}
v_u_17.__index = v_u_17
function v_u_17._new()
	local v18 = v_u_17
	local v19 = setmetatable({}, v18)
	v19.Frame = v_u_16:GetTo("MainFrame", "Pages")
	v19.PageSystem = v_u_15.new(v19.Frame)
	v19._welcomeback_popped_up = false
	v19._patchnotes_popped_up = false
	v19._mobileduels_popped_up = false
	v19._delay_next_popup = nil
	v19:_Init()
	return v19
end
function v_u_17.GetDefaultElement(p20)
	return p20.PageSystem:GetDefaultElement()
end
function v_u_17.CloseRequest(p21)
	p21.PageSystem:CloseRequest()
end
function v_u_17.OpenPickWeaponsPage(p22)
	p22.PageSystem:OpenPage(
		v_u_8:Get("Settings Pick Weapons List") == "List" and "PickWeaponsList" or "PickWeapons",
		true
	)
end
function v_u_17._UpdateVisibility(p23)
	p23.Frame.Visible = not v_u_3.MenuIsOpen
end
function v_u_17._CheckInterruption(p24)
	if p24.PageSystem.CurrentPage then
		if
			v_u_14:IsVisible() and p24.PageSystem.CurrentPage.Name ~= "PickEmote"
			or (v_u_13.Enabled or v_u_12.EditorEnabled)
		then
			p24.PageSystem:CloseCurrentPage()
		end
	end
end
function v_u_17._CheckPopUps(p25)
	if p25.PageSystem.CurrentPage then
		return
	else
		wait(1)
		if p25._delay_next_popup then
			local _ = p25._delay_next_popup
			p25._delay_next_popup = nil
			wait(p25._delay_next_popup)
		end
		if not v_u_11:GetDuel(v_u_4.LocalPlayer) then
			local v26 = v_u_8:GetStatistic("StatisticDuelsPlayed")
			if p25._welcomeback_popped_up or not v_u_8:Get("WelcomeBackGiftReady") then
				if
					p25._patchnotes_popped_up or (v_u_8:Get("LastPatchNotesVersion") == v_u_5.GAME_VERSION or v26 <= 3)
				then
					if
						p25._mobileduels_popped_up
						or (v_u_5.IS_MOBILE_SERVER or (v26 <= 0 or (v26 > 3 or v_u_9.CurrentControls ~= "Touch")))
					then
						if
							v26 > 10
							and v_u_5.IS_HUB_SERVER
							and (
								v_u_7:IsAprilFools() and v_u_8:Get("AprilFoolsDialogAcknowledged") == -1
								or not v_u_7:IsAprilFools() and v_u_8:Get("AprilFoolsDialogAcknowledged") ~= -1
							)
						then
							p25.PageSystem:OpenPage("DialogAprilFools", true)
						end
					else
						p25._mobileduels_popped_up = true
						p25.PageSystem:OpenPage("MobileDuels", true)
					end
				else
					p25._patchnotes_popped_up = true
					p25.PageSystem:OpenPage("PatchNotes", true)
				end
			else
				p25._welcomeback_popped_up = true
				p25._delay_next_popup = 9
				p25.PageSystem:OpenPage("WelcomeBack", true)
			end
			p25._patchnotes_popped_up = true
		end
	end
end
function v_u_17._PickWeapons(p27)
	local v28 = v_u_10:GetFighter(v_u_4.LocalPlayer)
	if v28 then
		local v29 = v_u_11:GetDuel(v_u_4.LocalPlayer)
		local v30 = #v28.Items == 0 and v28:Get("CanPickWeapons")
		if v30 then
			v30 = v28:IsAlive()
		end
		local v31 = v29 and v29.LocalDueler
		if v31 then
			v31 = v29.LocalDueler:GetStaggeredSpawnsTurn()
		end
		if v30 then
			if not p27.PageSystem.CurrentPage then
				p27:OpenPickWeaponsPage()
				return
			end
		elseif not v31 then
			for _, v32 in pairs({ "PickWeapons", "PickWeaponsList" }) do
				local v33 = p27.PageSystem:GetPage(v32)
				if v33 and v33:IsOpen() then
					p27.PageSystem:CloseCurrentPage()
				end
			end
		end
	end
end
function v_u_17._DuelAdded(p_u_34, p35)
	if p35:GetDueler(v_u_4.LocalPlayer) then
		p35:GetDataChangedSignal("StaggeredSpawnsOrder"):Connect(function()
			p_u_34:_PickWeapons()
		end)
		p_u_34:_PickWeapons()
	end
end
function v_u_17._HookLocalFighter(p_u_36)
	local v_u_37 = v_u_10:WaitForLocalFighter()
	v_u_37:GetDataChangedSignal("IsInDuel"):Connect(function()
		if v_u_37:Get("IsInDuel") and p_u_36.PageSystem.CurrentPage then
			p_u_36.PageSystem:CloseCurrentPage()
		end
	end)
	v_u_37:GetDataChangedSignal("CanPickWeapons"):Connect(function()
		p_u_36:_PickWeapons()
	end)
	v_u_37.EntityRemoved:Connect(function()
		p_u_36:_PickWeapons()
	end)
	v_u_37.ItemRemoved:Connect(function()
		p_u_36:_PickWeapons()
	end)
	v_u_37.ItemAdded:Connect(function()
		p_u_36:_PickWeapons()
	end)
	local function v39(p38)
		p38.Died:Connect(function()
			p_u_36:_PickWeapons()
		end)
		p_u_36:_PickWeapons()
	end
	v_u_37.EntityAdded:Connect(v39)
	if v_u_37.Entity then
		task.defer(v39, v_u_37.Entity)
	end
end
function v_u_17._Setup(_)
	task.defer(function()
		if not v_u_6:HasBasicAccess(v_u_4.LocalPlayer.UserId, v_u_8:Get("GroupRank")) then
			v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages"):WaitForChild("Debug"):Destroy()
			v_u_4.LocalPlayer.PlayerScripts.UserInterface
				:WaitForChild("Prompts")
				:WaitForChild("SendOfflineGiftRewards")
				:Destroy()
		end
		--[[
        if not v_u_5.HAS_MODERATOR_ACCESS(v_u_8:Get("GroupRank")) then
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages"):WaitForChild("Moderation"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts"):WaitForChild("Kick"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts"):WaitForChild("Ban"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts"):WaitForChild("Unban"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts"):WaitForChild("Pardon"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts"):WaitForChild("InspectBanLogs"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanLogSlot"):Destroy()
            v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanDropdown"):Destroy()
        end
        --]]
	end)
end
function v_u_17._Init(p_u_40)
	p_u_40.PageSystem.PagesActivity:Connect(function()
		v_u_12:SetPageSystemActive(p_u_40.PageSystem.CurrentPage ~= nil)
	end)
	p_u_40.PageSystem.PageOpened:Connect(function()
		v_u_2:EnableGamepadCursor(p_u_40:GetDefaultElement())
	end)
	p_u_40.PageSystem.PageClosed:Connect(function(p41)
		v_u_2:DisableGamepadCursor()
		task.defer(p_u_40._CheckPopUps, p_u_40)
		if p41 ~= p_u_40.PageSystem:GetPage("PickWeapons") and p41 ~= p_u_40.PageSystem:GetPage("PickWeaponsList") then
			task.defer(p_u_40._PickWeapons, p_u_40)
		end
	end)
	v_u_14.VisibilityChanged:Connect(function()
		p_u_40:_CheckInterruption()
	end)
	v_u_13.EnabledChanged:Connect(function()
		p_u_40:_CheckInterruption()
	end)
	v_u_12.EditorEnabledChanged:Connect(function()
		p_u_40:_CheckInterruption()
	end)
	v_u_9.ControlsChanged:Connect(function()
		p_u_40:_CheckPopUps()
	end)
	v_u_8:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
		p_u_40:_CheckPopUps()
	end)
	v_u_8:GetDataChangedSignal("AprilFoolsDialogAcknowledged"):Connect(function()
		p_u_40:_CheckPopUps()
	end)
	v_u_11.LocalPlayerLeftDuel:Connect(function()
		p_u_40:_CheckPopUps()
	end)
	v_u_3:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
		p_u_40:_UpdateVisibility()
	end)
	p_u_40:_Setup()
	p_u_40:_UpdateVisibility()
	task.defer(p_u_40._CheckPopUps, p_u_40)
	task.defer(p_u_40._HookLocalFighter, p_u_40)
end
return v_u_17._new()
