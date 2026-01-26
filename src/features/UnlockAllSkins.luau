--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local UnlockAllSkins = {
	Enabled = false,
	Installed = false,
	Player = nil,
	PlayerScripts = nil,
	Controllers = nil,
	EnumLibrary = nil,
	CosmeticLibrary = nil,
	ItemLibrary = nil,
	DataController = nil,
	FighterController = nil,
	ClientItem = nil,
	ClientViewModel = nil,
	ViewProfile = nil,
	ClientEntity = nil,
	LastUsedWeapon = nil,
	ConstructingWeapon = nil,
	ViewingProfile = nil,
	Equipped = {},
	Favorites = {},
	Originals = {},
	FinisherCache = {},
}

local CONFIG_DIR = "BlossomUnlockAll"
local CONFIG_FILE = CONFIG_DIR .. "/config.json"

local function safeRequire(moduleRef)
	local ok, result = pcall(require, moduleRef)
	if ok then
		return result
	end
	return nil
end

function UnlockAllSkins:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
	self.Player = Players.LocalPlayer
	if self.Player then
		self.PlayerScripts = self.Player:WaitForChild("PlayerScripts", 10)
		self.Controllers = self.PlayerScripts and self.PlayerScripts:WaitForChild("Controllers", 10) or nil
	end
end

function UnlockAllSkins:Toggle(state: boolean)
	if self.Enabled == state then
		return
	end
	self.Enabled = state
	if state then
		self:EnsureInstalled()
		self:LoadConfig()
		self:ReplicateInventory()
	else
		self:ReplicateInventory()
	end
end

function UnlockAllSkins:EnsureInstalled()
	if self.Installed then
		return
	end

	self.EnumLibrary = safeRequire(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
	if self.EnumLibrary then
		pcall(function()
			self.EnumLibrary:WaitForEnumBuilder()
		end)
	end
	self.CosmeticLibrary = safeRequire(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
	self.ItemLibrary = safeRequire(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
	self.DataController = self.Controllers and safeRequire(self.Controllers:WaitForChild("PlayerDataController", 10))
		or nil

	pcall(function()
		self.FighterController = self.Controllers
				and safeRequire(self.Controllers:WaitForChild("FighterController", 10))
			or nil
	end)
	pcall(function()
		local modules = self.PlayerScripts and self.PlayerScripts:WaitForChild("Modules", 10) or nil
		self.ClientItem = modules and safeRequire(modules.ClientReplicatedClasses.ClientFighter.ClientItem) or nil
	end)
	pcall(function()
		local modules = self.PlayerScripts and self.PlayerScripts:WaitForChild("Modules", 10) or nil
		local viewModelModule = modules
				and modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
			or nil
		self.ClientViewModel = viewModelModule and safeRequire(viewModelModule) or nil
	end)
	pcall(function()
		local modules = self.PlayerScripts and self.PlayerScripts:WaitForChild("Modules", 10) or nil
		self.ViewProfile = modules and safeRequire(modules.Pages.ViewProfile) or nil
	end)
	pcall(function()
		local modules = self.PlayerScripts and self.PlayerScripts:WaitForChild("Modules", 10) or nil
		self.ClientEntity = modules and safeRequire(modules.ClientReplicatedClasses.ClientEntity) or nil
	end)

	self:InstallCosmeticOverrides()
	self:InstallDataOverrides()
	self:InstallRemoteHooks()
	self:InstallViewModelHooks()
	self:InstallProfileHooks()
	self:InstallEntityHooks()

	self.Installed = true
end

function UnlockAllSkins:CloneCosmetic(name, cosmeticType, options)
	local base = self.CosmeticLibrary and self.CosmeticLibrary.Cosmetics and self.CosmeticLibrary.Cosmetics[name]
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

	if self.EnumLibrary then
		local success, enumId = pcall(self.EnumLibrary.ToEnum, self.EnumLibrary, name)
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

function UnlockAllSkins:SaveConfig()
	if not writefile then
		return
	end

	pcall(function()
		local config = { equipped = {}, favorites = self.Favorites }
		for weapon, cosmetics in pairs(self.Equipped) do
			config.equipped[weapon] = {}
			for cosmeticType, cosmeticData in pairs(cosmetics) do
				if cosmeticData and cosmeticData.Name then
					config.equipped[weapon][cosmeticType] = {
						name = cosmeticData.Name,
						seed = cosmeticData.Seed,
						inverted = cosmeticData.Inverted,
					}
				end
			end
		end
		makefolder(CONFIG_DIR)
		writefile(CONFIG_FILE, HttpService:JSONEncode(config))
	end)
end

function UnlockAllSkins:LoadConfig()
	if not readfile or not isfile or not isfile(CONFIG_FILE) then
		return
	end

	pcall(function()
		local config = HttpService:JSONDecode(readfile(CONFIG_FILE))
		if config.equipped then
			for weapon, cosmetics in pairs(config.equipped) do
				self.Equipped[weapon] = {}
				for cosmeticType, cosmeticData in pairs(cosmetics) do
					local cloned =
						self:CloneCosmetic(cosmeticData.name, cosmeticType, { inverted = cosmeticData.inverted })
					if cloned then
						cloned.Seed = cosmeticData.seed
						self.Equipped[weapon][cosmeticType] = cloned
					end
				end
			end
		end
		self.Favorites = config.favorites or {}
	end)
end

function UnlockAllSkins:ReplicateInventory()
	local data = self.DataController and self.DataController.CurrentData
	if not data or not data.Replicate then
		return
	end

	task.defer(function()
		pcall(function()
			data:Replicate("WeaponInventory")
		end)
		task.wait(0.2)
		pcall(function()
			data:Replicate("FavoritedCosmetics")
		end)
	end)
end

function UnlockAllSkins:InstallCosmeticOverrides()
	if not self.CosmeticLibrary or self.Originals.CosmeticOverrides then
		return
	end

	self.Originals.CosmeticOverrides = {
		OwnsCosmeticNormally = self.CosmeticLibrary.OwnsCosmeticNormally,
		OwnsCosmeticUniversally = self.CosmeticLibrary.OwnsCosmeticUniversally,
		OwnsCosmeticForWeapon = self.CosmeticLibrary.OwnsCosmeticForWeapon,
		OwnsCosmetic = self.CosmeticLibrary.OwnsCosmetic,
	}

	self.CosmeticLibrary.OwnsCosmeticNormally = function(...)
		if not self.Enabled then
			local original = self.Originals.CosmeticOverrides.OwnsCosmeticNormally
			return original and original(...)
		end
		return true
	end
	self.CosmeticLibrary.OwnsCosmeticUniversally = function(...)
		if not self.Enabled then
			local original = self.Originals.CosmeticOverrides.OwnsCosmeticUniversally
			return original and original(...)
		end
		return true
	end
	self.CosmeticLibrary.OwnsCosmeticForWeapon = function(...)
		if not self.Enabled then
			local original = self.Originals.CosmeticOverrides.OwnsCosmeticForWeapon
			return original and original(...)
		end
		return true
	end
	self.CosmeticLibrary.OwnsCosmetic = function(library, inventory, name, weapon)
		if not self.Enabled then
			local original = self.Originals.CosmeticOverrides.OwnsCosmetic
			return original and original(library, inventory, name, weapon)
		end
		if name and name:find("MISSING_") then
			local original = self.Originals.CosmeticOverrides.OwnsCosmetic
			return original and original(library, inventory, name, weapon)
		end
		return true
	end
end

function UnlockAllSkins:InstallDataOverrides()
	if not self.DataController or self.Originals.DataOverrides then
		return
	end

	self.Originals.DataOverrides = {
		Get = self.DataController.Get,
		GetWeaponData = self.DataController.GetWeaponData,
	}

	self.DataController.Get = function(controller, key)
		if not self.Enabled then
			return self.Originals.DataOverrides.Get(controller, key)
		end
		local data = self.Originals.DataOverrides.Get(controller, key)
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
			for weapon, favs in pairs(self.Favorites) do
				result[weapon] = result[weapon] or {}
				for name, isFav in pairs(favs) do
					result[weapon][name] = isFav
				end
			end
			return result
		end
		return data
	end

	self.DataController.GetWeaponData = function(controller, weaponName)
		if not self.Enabled then
			return self.Originals.DataOverrides.GetWeaponData(controller, weaponName)
		end
		local data = self.Originals.DataOverrides.GetWeaponData(controller, weaponName)
		if not data then
			return nil
		end
		local merged = {}
		for key, value in pairs(data) do
			merged[key] = value
		end
		merged.Name = weaponName
		if self.Equipped[weaponName] then
			for cosmeticType, cosmeticData in pairs(self.Equipped[weaponName]) do
				merged[cosmeticType] = cosmeticData
			end
		end
		return merged
	end
end

function UnlockAllSkins:InstallRemoteHooks()
	if self.Originals.RemoteHooks then
		return
	end

	self.Originals.RemoteHooks = {}
	if not hookmetamethod then
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

	local module = self
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(selfObj, ...)
		if getnamecallmethod() ~= "FireServer" then
			return oldNamecall(selfObj, ...)
		end
		if not module.Enabled then
			return oldNamecall(selfObj, ...)
		end

		local args = { ... }
		if useItemRemote and selfObj == useItemRemote then
			local objectID = args[1]
			if module.FighterController and module.Player then
				pcall(function()
					local fighter = module.FighterController:GetFighter(module.Player)
					if fighter and fighter.Items then
						for _, item in pairs(fighter.Items) do
							if item:Get("ObjectID") == objectID then
								module.LastUsedWeapon = item.Name
								break
							end
						end
					end
				end)
			end
		end

		if selfObj == equipRemote then
			local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
			if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
				local inventory = module.DataController and module.DataController:Get("CosmeticInventory") or nil
				if inventory and rawget(inventory, cosmeticName) then
					return oldNamecall(selfObj, ...)
				end
			end

			module.Equipped[weaponName] = module.Equipped[weaponName] or {}
			if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
				module.Equipped[weaponName][cosmeticType] = nil
				if not next(module.Equipped[weaponName]) then
					module.Equipped[weaponName] = nil
				end
			else
				local cloned = module:CloneCosmetic(cosmeticName, cosmeticType, {
					inverted = options.IsInverted,
					favoritesOnly = options.OnlyUseFavorites,
				})
				if cloned then
					module.Equipped[weaponName][cosmeticType] = cloned
				end
			end

			task.defer(function()
				module:ReplicateInventory()
				module:SaveConfig()
			end)
			return
		end

		if favoriteRemote and selfObj == favoriteRemote then
			module.Favorites[args[1]] = module.Favorites[args[1]] or {}
			module.Favorites[args[1]][args[2]] = args[3] or nil
			module:SaveConfig()
			task.spawn(function()
				pcall(function()
					if module.DataController and module.DataController.CurrentData then
						module.DataController.CurrentData:Replicate("FavoritedCosmetics")
					end
				end)
			end)
			return
		end

		return oldNamecall(selfObj, ...)
	end)
end

function UnlockAllSkins:InstallViewModelHooks()
	if self.Originals.ViewModelHooks then
		return
	end

	self.Originals.ViewModelHooks = {}
	if not self.ClientItem or not self.ClientItem._CreateViewModel then
		return
	end

	local module = self
	self.Originals.ViewModelHooks.CreateViewModel = self.ClientItem._CreateViewModel
	self.ClientItem._CreateViewModel = function(selfObj, viewmodelRef)
		if module.Enabled then
			local weaponName = selfObj.Name
			local weaponPlayer = selfObj.ClientFighter and selfObj.ClientFighter.Player
			module.ConstructingWeapon = (weaponPlayer == module.Player) and weaponName or nil
			if
				weaponPlayer == module.Player
				and module.Equipped[weaponName]
				and module.Equipped[weaponName].Skin
				and viewmodelRef
			then
				local dataKey, skinKey, nameKey = selfObj:ToEnum("Data"), selfObj:ToEnum("Skin"), selfObj:ToEnum("Name")
				if viewmodelRef[dataKey] then
					viewmodelRef[dataKey][skinKey] = module.Equipped[weaponName].Skin
					viewmodelRef[dataKey][nameKey] = module.Equipped[weaponName].Skin.Name
				elseif viewmodelRef.Data then
					viewmodelRef.Data.Skin = module.Equipped[weaponName].Skin
					viewmodelRef.Data.Name = module.Equipped[weaponName].Skin.Name
				end
			end
		end
		local result = module.Originals.ViewModelHooks.CreateViewModel(selfObj, viewmodelRef)
		module.ConstructingWeapon = nil
		return result
	end

	if self.ClientViewModel and self.ClientViewModel.GetWrap then
		self.Originals.ViewModelHooks.GetWrap = self.ClientViewModel.GetWrap
		self.ClientViewModel.GetWrap = function(selfObj)
			if module.Enabled then
				local weaponName = selfObj.ClientItem and selfObj.ClientItem.Name
				local weaponPlayer = selfObj.ClientItem
					and selfObj.ClientItem.ClientFighter
					and selfObj.ClientItem.ClientFighter.Player
				if
					weaponName
					and weaponPlayer == module.Player
					and module.Equipped[weaponName]
					and module.Equipped[weaponName].Wrap
				then
					return module.Equipped[weaponName].Wrap
				end
			end
			return module.Originals.ViewModelHooks.GetWrap(selfObj)
		end
	end

	if self.ClientViewModel and self.ClientViewModel.new then
		self.Originals.ViewModelHooks.NewViewModel = self.ClientViewModel.new
		self.ClientViewModel.new = function(replicatedData, clientItem)
			local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
			local weaponName = module.ConstructingWeapon or clientItem.Name
			if module.Enabled and weaponPlayer == module.Player and module.Equipped[weaponName] then
				local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
				local dataKey = ReplicatedClass:ToEnum("Data")
				replicatedData[dataKey] = replicatedData[dataKey] or {}
				local cosmetics = module.Equipped[weaponName]
				if cosmetics.Skin then
					replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin
				end
				if cosmetics.Wrap then
					replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap
				end
				if cosmetics.Charm then
					replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm
				end
			end
			local result = module.Originals.ViewModelHooks.NewViewModel(replicatedData, clientItem)
			if
				module.Enabled
				and weaponPlayer == module.Player
				and module.Equipped[weaponName]
				and module.Equipped[weaponName].Wrap
				and result._UpdateWrap
			then
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

	if self.ItemLibrary and self.ItemLibrary.GetViewModelImageFromWeaponData then
		self.Originals.ViewModelHooks.GetViewModelImageFromWeaponData = self.ItemLibrary.GetViewModelImageFromWeaponData
		self.ItemLibrary.GetViewModelImageFromWeaponData = function(library, weaponData, highRes)
			if not module.Enabled then
				return module.Originals.ViewModelHooks.GetViewModelImageFromWeaponData(library, weaponData, highRes)
			end
			if not weaponData then
				return module.Originals.ViewModelHooks.GetViewModelImageFromWeaponData(library, weaponData, highRes)
			end
			local weaponName = weaponData.Name
			local shouldShowSkin = (
				weaponData.Skin
				and module.Equipped[weaponName]
				and weaponData.Skin == module.Equipped[weaponName].Skin
			)
				or (
					module.ViewingProfile == module.Player
					and module.Equipped[weaponName]
					and module.Equipped[weaponName].Skin
				)
			if shouldShowSkin and module.Equipped[weaponName] and module.Equipped[weaponName].Skin then
				local skinInfo = library.ViewModels[module.Equipped[weaponName].Skin.Name]
				if skinInfo then
					return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image
				end
			end
			return module.Originals.ViewModelHooks.GetViewModelImageFromWeaponData(library, weaponData, highRes)
		end
	end
end

function UnlockAllSkins:InstallProfileHooks()
	if self.Originals.ProfileHooks then
		return
	end

	self.Originals.ProfileHooks = {}
	if not self.ViewProfile or not self.ViewProfile.Fetch then
		return
	end

	local module = self
	self.Originals.ProfileHooks.Fetch = self.ViewProfile.Fetch
	self.ViewProfile.Fetch = function(selfObj, targetPlayer)
		if module.Enabled then
			module.ViewingProfile = targetPlayer
		else
			module.ViewingProfile = nil
		end
		return module.Originals.ProfileHooks.Fetch(selfObj, targetPlayer)
	end
end

function UnlockAllSkins:InstallEntityHooks()
	if self.Originals.EntityHooks then
		return
	end

	self.Originals.EntityHooks = {}
	if not self.ClientEntity or not self.ClientEntity.ReplicateFromServer then
		return
	end

	local module = self
	self.Originals.EntityHooks.ReplicateFromServer = self.ClientEntity.ReplicateFromServer
	self.ClientEntity.ReplicateFromServer = function(selfObj, action, ...)
		if module.Enabled and action == "FinisherEffect" then
			local args = { ... }
			local killerName = args[3]
			local decodedKiller = killerName
			if type(killerName) == "userdata" and module.EnumLibrary and module.EnumLibrary.FromEnum then
				local ok, decoded = pcall(module.EnumLibrary.FromEnum, module.EnumLibrary, killerName)
				if ok and decoded then
					decodedKiller = decoded
				end
			end
			local isOurKill = tostring(decodedKiller) == module.Player.Name
				or tostring(decodedKiller):lower() == module.Player.Name:lower()
			if
				isOurKill
				and module.LastUsedWeapon
				and module.Equipped[module.LastUsedWeapon]
				and module.Equipped[module.LastUsedWeapon].Finisher
			then
				local finisherData = module.Equipped[module.LastUsedWeapon].Finisher
				local finisherEnum = finisherData.Enum
				if not finisherEnum and module.EnumLibrary then
					local ok, result = pcall(module.EnumLibrary.ToEnum, module.EnumLibrary, finisherData.Name)
					if ok and result then
						finisherEnum = result
					end
				end
				if finisherEnum then
					args[1] = finisherEnum
					module:PlayFinisherClient(args[1], args)
					return module.Originals.EntityHooks.ReplicateFromServer(selfObj, action, unpack(args))
				end
			end
		end
		if module.Enabled and action == "FinisherEffect" then
			local args = { ... }
			module:PlayFinisherClient(args[1], args)
		end
		return module.Originals.EntityHooks.ReplicateFromServer(selfObj, action, ...)
	end
end

function UnlockAllSkins:PlayFinisherClient(finisherId, args)
	local logger = self.Logger
	if logger then
		logger:Info("FinisherEffect received.")
		logger:Info("Finisher id:", finisherId, "type:", type(finisherId))
	end

	local finisherName = finisherId
	local finisherEnum = nil
	if type(finisherId) == "userdata" and self.EnumLibrary and self.EnumLibrary.FromEnum then
		finisherEnum = finisherId
		local ok, decoded = pcall(self.EnumLibrary.FromEnum, self.EnumLibrary, finisherId)
		if ok and decoded then
			finisherName = decoded
		end
	elseif type(finisherId) == "string" and self.EnumLibrary and self.EnumLibrary.ToEnum then
		local ok, enumId = pcall(self.EnumLibrary.ToEnum, self.EnumLibrary, finisherId)
		if ok and enumId then
			finisherEnum = enumId
		end
	end

	if type(finisherName) ~= "string" then
		if logger then
			logger:Warn("Finisher name not a string:", finisherName)
		end
		return
	end
	if logger then
		logger:Info("Finisher name:", finisherName, "enum:", finisherEnum)
	end

	local cached = self.FinisherCache[finisherName]
	local finisherClass = cached
	if not finisherClass then
		local finishersFolder = ReplicatedStorage:FindFirstChild("Modules")
		finishersFolder = finishersFolder and finishersFolder:FindFirstChild("Finishers") or nil
		local finisherModule = finishersFolder and finishersFolder:FindFirstChild(finisherName) or nil
		if not finisherModule and finishersFolder and finisherEnum and self.EnumLibrary and self.EnumLibrary.ToEnum then
			for _, child in ipairs(finishersFolder:GetChildren()) do
				local ok, enumId = pcall(self.EnumLibrary.ToEnum, self.EnumLibrary, child.Name)
				if ok and enumId == finisherEnum then
					finisherModule = child
					finisherName = child.Name
					break
				end
			end
		end
		if
			not finisherModule
			and finishersFolder
			and type(finisherId) == "string"
			and self.EnumLibrary
			and self.EnumLibrary.ToEnum
		then
			for _, child in ipairs(finishersFolder:GetChildren()) do
				local ok, enumId = pcall(self.EnumLibrary.ToEnum, self.EnumLibrary, child.Name)
				if ok and enumId and tostring(enumId) == finisherId then
					finisherModule = child
					finisherName = child.Name
					finisherEnum = enumId
					break
				end
			end
		end
		if not finisherModule then
			if logger then
				logger:Warn("Finisher module not found:", finisherName)
			end
			return
		end
		finisherClass = safeRequire(finisherModule)
		if not finisherClass then
			if logger then
				logger:Warn("Failed to require finisher module:", finisherName)
			end
			return
		end
		self.FinisherCache[finisherName] = finisherClass
	end

	if not finisherClass.new then
		if logger then
			logger:Warn("Finisher class missing constructor:", finisherName)
		end
		return
	end

	local finisherInstance = nil
	pcall(function()
		finisherInstance = finisherClass.new(unpack(args))
	end)
	if not finisherInstance then
		pcall(function()
			finisherInstance = finisherClass.new()
		end)
	end

	if not finisherInstance then
		if logger then
			logger:Warn("Finisher instance not created:", finisherName)
		end
		return
	end
	if logger then
		logger:Info("Finisher instance created:", finisherName)
	end

	if finisherInstance.PlayServer then
		pcall(finisherInstance.PlayServer, finisherInstance)
	elseif logger then
		logger:Warn("Finisher missing PlayServer:", finisherName)
	end
	if finisherInstance.PlayClient then
		pcall(finisherInstance.PlayClient, finisherInstance, unpack(args))
	elseif logger then
		logger:Warn("Finisher missing PlayClient:", finisherName)
	end
end

return UnlockAllSkins
