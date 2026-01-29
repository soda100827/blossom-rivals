--!strict

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants

--// Types
type CosmeticOptions = {
	inverted: boolean?,
	favoritesOnly: boolean?,
}

export type UnlockAllFeature = {
	init: (self: UnlockAllFeature, client: any) -> (),
	cleanup: (self: UnlockAllFeature) -> (),
	run: (self: UnlockAllFeature) -> (),
}

--// Private state
local UnlockAll = {}
UnlockAll.__index = UnlockAll

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	isActive: boolean,
	player: Player?,
	controllers: Instance?,
	enumLibrary: any?,
	cosmeticLibrary: any?,
	itemLibrary: any?,
	dataController: any?,
	fighterController: any?,
	equipped: { [string]: { [string]: any } },
	favorites: { [string]: { [string]: boolean } },
	constructingWeapon: string?,
	viewingProfile: Player?,
	lastUsedWeapon: string?,
	originals: { [string]: any },
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isActive = false,
		player = nil,
		controllers = nil,
		enumLibrary = nil,
		cosmeticLibrary = nil,
		itemLibrary = nil,
		dataController = nil,
		fighterController = nil,
		equipped = {},
		favorites = {},
		constructingWeapon = nil,
		viewingProfile = nil,
		lastUsedWeapon = nil,
		originals = {},
	}
local _signals = {}

--// Private helpers
local function _getEnv()
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return env, genv
end

local function _cloneCosmetic(name: string, cosmeticType: string, options: CosmeticOptions?): any?
	local cosmeticLibrary = _state.cosmeticLibrary
	if not cosmeticLibrary then
		return nil
	end
	local base = cosmeticLibrary.Cosmetics[name]
	if not base then
		return nil
	end
	local data = {}
	for key, value in pairs(base) do
		data[key] = value
	end
	data.Name = name
	data.Type = data.Type or cosmeticType
	data.Seed = data.Seed or math.random(1, 1000000)
	local enumLibrary = _state.enumLibrary
	if enumLibrary then
		local success, enumId = pcall(enumLibrary.ToEnum, enumLibrary, name)
		if success and enumId then
			data.Enum = enumId
			data.ObjectID = data.ObjectID or enumId
		end
	end
	if options then
		if options.inverted ~= nil then
			data.Inverted = options.inverted
		end
		if options.favoritesOnly ~= nil then
			data.OnlyUseFavorites = options.favoritesOnly
		end
	end
	return data
end

local function _saveConfig()
	local client = _state.client
	if not client or not client.saveUnlockAllConfig then
		return
	end

	local equippedConfig = {}
	for weapon, cosmetics in pairs(_state.equipped) do
		equippedConfig[weapon] = {}
		for cosmeticType, cosmeticData in pairs(cosmetics) do
			if cosmeticData and cosmeticData.Name then
				equippedConfig[weapon][cosmeticType] = {
					name = cosmeticData.Name,
					seed = cosmeticData.Seed,
					inverted = cosmeticData.Inverted,
				}
			end
		end
	end

	client:saveUnlockAllConfig(equippedConfig, _state.favorites)
end

local function _loadConfig()
	local client = _state.client
	if not client or not client.loadUnlockAllConfig then
		return
	end

	local config = client:loadUnlockAllConfig()
	if not config then
		return
	end
	if config.equipped then
		for weapon, cosmetics in pairs(config.equipped) do
			_state.equipped[weapon] = {}
			for cosmeticType, cosmeticData in pairs(cosmetics) do
				local cloned = _cloneCosmetic(cosmeticData.name, cosmeticType, {
					inverted = cosmeticData.inverted,
				})
				if cloned then
					cloned.Seed = cosmeticData.seed
					_state.equipped[weapon][cosmeticType] = cloned
				end
			end
		end
	end
	_state.favorites = config.favorites or {}
end

local function _patchCosmeticLibrary()
	local cosmeticLibrary = _state.cosmeticLibrary
	if not cosmeticLibrary then
		return
	end

	cosmeticLibrary.OwnsCosmeticNormally = function()
		return true
	end
	cosmeticLibrary.OwnsCosmeticUniversally = function()
		return true
	end
	cosmeticLibrary.OwnsCosmeticForWeapon = function()
		return true
	end

	if not _state.originals.ownsCosmetic then
		_state.originals.ownsCosmetic = cosmeticLibrary.OwnsCosmetic
	end

	local originalOwnsCosmetic = _state.originals.ownsCosmetic
	cosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
		if name:find("MISSING_") and originalOwnsCosmetic then
			return originalOwnsCosmetic(self, inventory, name, weapon)
		end
		return true
	end
end

local function _patchDataController()
	local dataController = _state.dataController
	if not dataController then
		return
	end

	if not _state.originals.dataGet then
		_state.originals.dataGet = dataController.Get
	end
	if not _state.originals.dataGetWeaponData then
		_state.originals.dataGetWeaponData = dataController.GetWeaponData
	end

	local originalGet = _state.originals.dataGet
	local originalGetWeaponData = _state.originals.dataGetWeaponData

	dataController.Get = function(self, key)
		local data = originalGet(self, key)
		if key == "CosmeticInventory" then
			local proxy = {}
			if data then
				for k, v in pairs(data) do
					proxy[k] = v
				end
			end
			return setmetatable(proxy, {
				__index = function()
					return true
				end,
			})
		end
		if key == "FavoritedCosmetics" then
			local result = data and table.clone(data) or {}
			for weapon, favs in pairs(_state.favorites) do
				result[weapon] = result[weapon] or {}
				for name, isFav in pairs(favs) do
					result[weapon][name] = isFav
				end
			end
			return result
		end
		return data
	end

	dataController.GetWeaponData = function(self, weaponName)
		local data = originalGetWeaponData(self, weaponName)
		if not data then
			return nil
		end
		local merged = {}
		for key, value in pairs(data) do
			merged[key] = value
		end
		merged.Name = weaponName
		if _state.equipped[weaponName] then
			for cosmeticType, cosmeticData in pairs(_state.equipped[weaponName]) do
				merged[cosmeticType] = cosmeticData
			end
		end
		return merged
	end
end

local function _hookNamecall()
	local env, genv = _getEnv()
	local hookmetamethod = (genv.hookmetamethod or env.hookmetamethod) :: any
	local getnamecallmethod = (genv.getnamecallmethod or env.getnamecallmethod) :: any
	if not hookmetamethod or not getnamecallmethod then
		return
	end
	if _state.originals.namecall then
		return
	end

	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local dataRemotes = remotes and remotes:FindFirstChild("Data")
	local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
	local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
	local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
	local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
	local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")
	if not equipRemote then
		return
	end

	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		if getnamecallmethod() ~= "FireServer" then
			return oldNamecall(self, ...)
		end

		local args = { ... }
		if useItemRemote and self == useItemRemote then
			local objectID = args[1]
			local fighterController = _state.fighterController
			local player = _state.player
			if fighterController and player then
				pcall(function()
					local fighter = fighterController:GetFighter(player)
					if fighter and fighter.Items then
						for _, item in pairs(fighter.Items) do
							if item:Get("ObjectID") == objectID then
								_state.lastUsedWeapon = item.Name
								break
							end
						end
					end
				end)
			end
		end

		if self == equipRemote then
			local weaponName = args[1]
			local cosmeticType = args[2]
			local cosmeticName = args[3]
			local options = args[4] or {}
			if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
				local inventory = _state.dataController and _state.dataController:Get("CosmeticInventory")
				if inventory and rawget(inventory, cosmeticName) then
					return oldNamecall(self, ...)
				end
			end

			_state.equipped[weaponName] = _state.equipped[weaponName] or {}
			if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
				_state.equipped[weaponName][cosmeticType] = nil
				if not next(_state.equipped[weaponName]) then
					_state.equipped[weaponName] = nil
				end
			else
				local cloned = _cloneCosmetic(cosmeticName, cosmeticType, {
					inverted = options.IsInverted,
					favoritesOnly = options.OnlyUseFavorites,
				})
				if cloned then
					_state.equipped[weaponName][cosmeticType] = cloned
				end
			end

			task.defer(function()
				pcall(function()
					_state.dataController.CurrentData:Replicate("WeaponInventory")
				end)
				task.wait(0.2)
				_saveConfig()
			end)
			return
		end

		if self == favoriteRemote then
			_state.favorites[args[1]] = _state.favorites[args[1]] or {}
			_state.favorites[args[1]][args[2]] = args[3] or nil
			_saveConfig()
			task.spawn(function()
				pcall(function()
					_state.dataController.CurrentData:Replicate("FavoritedCosmetics")
				end)
			end)
			return
		end

		return oldNamecall(self, ...)
	end)

	_state.originals.namecall = oldNamecall
end

local function _patchClientItem()
	local player = _state.player
	if not player then
		return
	end

	local success, clientItem = pcall(function()
		return require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
	end)
	if not success or not clientItem or not clientItem._CreateViewModel then
		return
	end
	if _state.originals.createViewModel then
		return
	end

	_state.originals.createViewModel = clientItem._CreateViewModel
	clientItem._CreateViewModel = function(self, viewmodelRef)
		local weaponName = self.Name
		local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
		_state.constructingWeapon = (weaponPlayer == player) and weaponName or nil
		local hasSkin = _state.equipped[weaponName] and _state.equipped[weaponName].Skin
		if weaponPlayer == player and hasSkin and viewmodelRef then
			local dataKey = self:ToEnum("Data")
			local skinKey = self:ToEnum("Skin")
			local nameKey = self:ToEnum("Name")
			if viewmodelRef[dataKey] then
				viewmodelRef[dataKey][skinKey] = _state.equipped[weaponName].Skin
				viewmodelRef[dataKey][nameKey] = _state.equipped[weaponName].Skin.Name
			elseif viewmodelRef.Data then
				viewmodelRef.Data.Skin = _state.equipped[weaponName].Skin
				viewmodelRef.Data.Name = _state.equipped[weaponName].Skin.Name
			end
		end
		local result = _state.originals.createViewModel(self, viewmodelRef)
		_state.constructingWeapon = nil
		return result
	end
end

local function _patchClientViewModel()
	local player = _state.player
	if not player then
		return
	end

	local viewModelModule =
		player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
	if not viewModelModule then
		return
	end

	local clientViewModel = require(viewModelModule)
	if clientViewModel.GetWrap and not _state.originals.getWrap then
		_state.originals.getWrap = clientViewModel.GetWrap
		clientViewModel.GetWrap = function(self)
			local weaponName = self.ClientItem and self.ClientItem.Name
			local weaponPlayer = self.ClientItem
				and self.ClientItem.ClientFighter
				and self.ClientItem.ClientFighter.Player
			if
				weaponName
				and weaponPlayer == player
				and _state.equipped[weaponName]
				and _state.equipped[weaponName].Wrap
			then
				return _state.equipped[weaponName].Wrap
			end
			return _state.originals.getWrap(self)
		end
	end

	if not _state.originals.viewModelNew then
		_state.originals.viewModelNew = clientViewModel.new
		clientViewModel.new = function(replicatedData, clientItem)
			local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
			local weaponName = _state.constructingWeapon or clientItem.Name
			if weaponPlayer == player and _state.equipped[weaponName] then
				local replicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
				local dataKey = replicatedClass:ToEnum("Data")
				replicatedData[dataKey] = replicatedData[dataKey] or {}
				local cosmetics = _state.equipped[weaponName]
				if cosmetics.Skin then
					replicatedData[dataKey][replicatedClass:ToEnum("Skin")] = cosmetics.Skin
				end
				if cosmetics.Wrap then
					replicatedData[dataKey][replicatedClass:ToEnum("Wrap")] = cosmetics.Wrap
				end
				if cosmetics.Charm then
					replicatedData[dataKey][replicatedClass:ToEnum("Charm")] = cosmetics.Charm
				end
			end
			local result = _state.originals.viewModelNew(replicatedData, clientItem)
			local hasWrap = _state.equipped[weaponName] and _state.equipped[weaponName].Wrap
			if weaponPlayer == player and hasWrap and result._UpdateWrap then
				result:_UpdateWrap()
				task.delay(0.1, function()
					if not result._destroyed then
						result:_UpdateWrap()
					end
				end)
			end
			return result
		end
	end
end

local function _patchItemLibrary()
	local itemLibrary = _state.itemLibrary
	if not itemLibrary or _state.originals.getViewModelImage then
		return
	end
	_state.originals.getViewModelImage = itemLibrary.GetViewModelImageFromWeaponData
	itemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
		if not weaponData then
			return _state.originals.getViewModelImage(self, weaponData, highRes)
		end
		local weaponName = weaponData.Name
		local shouldShowSkin = false
		if weaponData.Skin and _state.equipped[weaponName] then
			shouldShowSkin = weaponData.Skin == _state.equipped[weaponName].Skin
		elseif _state.viewingProfile == _state.player and _state.equipped[weaponName] then
			shouldShowSkin = _state.equipped[weaponName].Skin ~= nil
		end
		if shouldShowSkin and _state.equipped[weaponName] and _state.equipped[weaponName].Skin then
			local skinInfo = self.ViewModels[_state.equipped[weaponName].Skin.Name]
			if skinInfo then
				return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image
			end
		end
		return _state.originals.getViewModelImage(self, weaponData, highRes)
	end
end

local function _patchViewProfile()
	local player = _state.player
	if not player then
		return
	end

	local success, viewProfile = pcall(function()
		return require(player.PlayerScripts.Modules.Pages.ViewProfile)
	end)
	if not success or not viewProfile or not viewProfile.Fetch then
		return
	end
	if _state.originals.viewProfileFetch then
		return
	end

	_state.originals.viewProfileFetch = viewProfile.Fetch
	viewProfile.Fetch = function(self, targetPlayer)
		_state.viewingProfile = targetPlayer
		return _state.originals.viewProfileFetch(self, targetPlayer)
	end
end

local function _patchClientEntity()
	local player = _state.player
	if not player then
		return
	end

	local success, clientEntity = pcall(function()
		return require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity)
	end)
	if not success or not clientEntity or not clientEntity.ReplicateFromServer then
		return
	end
	if _state.originals.replicateFromServer then
		return
	end

	_state.originals.replicateFromServer = clientEntity.ReplicateFromServer
	clientEntity.ReplicateFromServer = function(self, action, ...)
		if action == "FinisherEffect" then
			local args = { ... }
			local killerName = args[3]
			local decodedKiller = killerName
			if type(killerName) == "userdata" and _state.enumLibrary and _state.enumLibrary.FromEnum then
				local ok, decoded = pcall(_state.enumLibrary.FromEnum, _state.enumLibrary, killerName)
				if ok and decoded then
					decodedKiller = decoded
				end
			end
			local isOurKill = tostring(decodedKiller) == player.Name
				or tostring(decodedKiller):lower() == player.Name:lower()
			local isFinisherEquipped = _state.lastUsedWeapon
				and _state.equipped[_state.lastUsedWeapon]
				and _state.equipped[_state.lastUsedWeapon].Finisher
			if isOurKill and isFinisherEquipped then
				local finisherData = _state.equipped[_state.lastUsedWeapon].Finisher
				local finisherEnum = finisherData.Enum
				if not finisherEnum and _state.enumLibrary then
					local ok, result = pcall(_state.enumLibrary.ToEnum, _state.enumLibrary, finisherData.Name)
					if ok and result then
						finisherEnum = result
					end
				end
				if finisherEnum then
					args[1] = finisherEnum
					return _state.originals.replicateFromServer(self, action, table.unpack(args))
				end
			end
		end
		return _state.originals.replicateFromServer(self, action, ...)
	end
end

local function _connect()
	_maid:DoCleaning()
end

--// Public API
function UnlockAll.init(self: UnlockAllFeature, client: any): ()
	_state.client = client
	_state.logger = client.Logger
	_maid = Maid.new()
	_connect()
end

function UnlockAll.cleanup(self: UnlockAllFeature): ()
	if _maid then
		_maid:DoCleaning()
	end
	_state.isActive = false
end

function UnlockAll.run(self: UnlockAllFeature): ()
	if _state.isActive then
		return
	end
	_state.isActive = true

	local player = Players.LocalPlayer
	if not player then
		_state.logger:warn("UnlockAll: LocalPlayer missing.")
		_state.isActive = false
		return
	end
	_state.player = player

	local playerScripts = player:WaitForChild("PlayerScripts")
	local controllers = playerScripts:WaitForChild("Controllers")
	_state.controllers = controllers

	local enumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
	if enumLibrary then
		enumLibrary:WaitForEnumBuilder()
	end

	_state.enumLibrary = enumLibrary
	_state.cosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
	_state.itemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
	_state.dataController = require(controllers:WaitForChild("PlayerDataController", 10))
	if not _state.dataController then
		_state.logger:warn("UnlockAll: DataController missing.")
		_state.isActive = false
		return
	end

	pcall(function()
		_state.fighterController = require(controllers:WaitForChild("FighterController", 10))
	end)

	_patchCosmeticLibrary()
	_patchDataController()
	_hookNamecall()
	_patchClientItem()
	_patchClientViewModel()
	_patchItemLibrary()
	_patchViewProfile()
	_patchClientEntity()
	_loadConfig()
end

return UnlockAll
