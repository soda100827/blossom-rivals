local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
Logger={}Logger.__index=Logger function Logger.new(source)return setmetatable({
Source=source or'System'},Logger)end local function formatMessage(level,source,
...)local parts={...}for i,value in ipairs(parts)do parts[i]=tostring(value)end
local message=table.concat(parts,' ')return string.format('[%s][%s] %s',level,
source,message)end function Logger:Info(...)print(formatMessage('INFO',self.
Source,...))end function Logger:Warn(...)warn(formatMessage('WARN',self.Source,
...))end function Logger:Error(...)error(formatMessage('ERROR',self.Source,...),
0)end return Logger end function __DARKLUA_BUNDLE_MODULES.a()local v=
__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function
__modImpl()local ScriptSignal={}ScriptSignal.__index=ScriptSignal local
ScriptConnection={}ScriptConnection.__index=ScriptConnection function
ScriptSignal.new()return setmetatable({_active=true,_head=nil},ScriptSignal)end
function ScriptSignal.Is(object)return typeof(object)=='table'and getmetatable(
object)==ScriptSignal end function ScriptSignal:IsActive()return self._active==
true end function ScriptSignal:Connect(handler)assert(typeof(handler)==
'function','Must be function')if self._active~=true then return setmetatable({
Connected=false,_node=nil},ScriptConnection)end local _head=self._head local
node={_signal=self,_connection=nil,_handler=handler,_next=_head,_prev=nil}if
_head~=nil then _head._prev=node end self._head=node local connection=
setmetatable({Connected=true,_node=node},ScriptConnection)node._connection=
connection return connection end function ScriptSignal:Once(handler)assert(
typeof(handler)=='function','Must be function')local connection connection=self:
Connect(function(...)if connection==nil then return end connection:Disconnect()
connection=nil handler(...)end)return connection end ScriptSignal.ConnectOnce=
ScriptSignal.Once function ScriptSignal:Wait()local thread do thread=coroutine.
running()local connection connection=self:Connect(function(...)if connection==
nil then return end connection:Disconnect()connection=nil if coroutine.status(
thread)=='suspended'then task.spawn(thread,...)end end)end return coroutine.
yield()end function ScriptSignal:Fire(...)local node=self._head while node~=nil
do task.defer(node._handler,...)node=node._next end end function ScriptSignal:
DisconnectAll()local node=self._head while node~=nil do local _connection=node.
_connection if _connection~=nil then _connection.Connected=false _connection.
_node=nil node._connection=nil end node=node._next end self._head=nil end
function ScriptSignal:Destroy()if self._active~=true then return end self:
DisconnectAll()self._active=false end function ScriptConnection:Disconnect()if
self.Connected~=true then return end self.Connected=false local _node=self._node
local _prev=_node._prev local _next=_node._next if _next~=nil then _next._prev=
_prev end if _prev~=nil then _prev._next=_next else _node._signal._head=_next
end _node._connection=nil self._node=nil end ScriptConnection.Destroy=
ScriptConnection.Disconnect return ScriptSignal end function
__DARKLUA_BUNDLE_MODULES.b()local v=__DARKLUA_BUNDLE_MODULES.cache.b if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c end end
do local function __modImpl()local Movement={Enabled=false,Connections={}}
function Movement:Init(Client)self.Client=Client self.Logger=Client.Logger end
function Movement:Toggle(state)self.Enabled=state end function Movement:Cleanup(
)self:Toggle(false)end return Movement end function __DARKLUA_BUNDLE_MODULES.c()
local v=__DARKLUA_BUNDLE_MODULES.cache.c if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local Workspace=game:GetService('Workspace')local
LOCAL_PLAYER=Players.LocalPlayer local Camera=Workspace.CurrentCamera local
Visuals={Enabled=false,Connections={},Drawings={},Highlights={},Settings={
ESPEnabled=false,ShowNames=true,ShowWeapon=false,ShowDistance=false,ShowBoxes=
true,ShowSkeleton=false,ShowHealthbar=false,ShowHighlight=false,TeamCheck=false,
MaxDistance=2000,BoxColor=Color3.new(1,1,1),TextColor=Color3.new(1,1,1),
WeaponColor=Color3.new(1,1,1),DistanceColor=Color3.new(1,1,1),SkeletonColor=
Color3.new(1,1,1),HealthbarColor=Color3.new(0,1,0),HealthbarOutlineColor=Color3.
new(0,0,0),NameOutlineColor=Color3.new(0,0,0),WeaponOutlineColor=Color3.new(0,0,
0),DistanceOutlineColor=Color3.new(0,0,0),BoxOutlineColor=Color3.new(0,0,0),
SkeletonOutlineColor=Color3.new(0,0,0),HighlightFill=Color3.new(1,0,0),
HighlightOutline=Color3.new(1,1,1),BoxThickness=1,SkeletonThickness=1,TextSize=
12,Outline=true}}function Visuals:Init(Client)self.Client=Client self.Logger=
Client.Logger end function Visuals:Toggle(state)if self.Enabled==state then
return end self.Enabled=state if state then self:Enable()else self:Disable()end
end function Visuals:SetESPEnabled(state)self.Settings.ESPEnabled=state if not
state then self:Clear()end end function Visuals:SetShowNames(state)self.Settings
.ShowNames=state end function Visuals:SetShowWeapon(state)self.Settings.
ShowWeapon=state end function Visuals:SetShowDistance(state)self.Settings.
ShowDistance=state end function Visuals:SetShowBoxes(state)self.Settings.
ShowBoxes=state end function Visuals:SetShowSkeleton(state)self.Settings.
ShowSkeleton=state end function Visuals:SetShowHealthbar(state)self.Settings.
ShowHealthbar=state end function Visuals:SetShowHighlight(state)self.Settings.
ShowHighlight=state if not state then self:ClearHighlights()end end function
Visuals:SetTeamCheck(state)self.Settings.TeamCheck=state end function Visuals:
SetMaxDistance(value)self.Settings.MaxDistance=value end function Visuals:
SetBoxColor(color)self.Settings.BoxColor=color end function Visuals:SetTextColor
(color)self.Settings.TextColor=color end function Visuals:SetWeaponColor(color)
self.Settings.WeaponColor=color end function Visuals:SetDistanceColor(color)self
.Settings.DistanceColor=color end function Visuals:SetSkeletonColor(color)self.
Settings.SkeletonColor=color end function Visuals:SetHealthbarColor(color)self.
Settings.HealthbarColor=color end function Visuals:SetHealthbarOutlineColor(
color)self.Settings.HealthbarOutlineColor=color end function Visuals:
SetNameOutlineColor(color)self.Settings.NameOutlineColor=color end function
Visuals:SetWeaponOutlineColor(color)self.Settings.WeaponOutlineColor=color end
function Visuals:SetDistanceOutlineColor(color)self.Settings.
DistanceOutlineColor=color end function Visuals:SetBoxOutlineColor(color)self.
Settings.BoxOutlineColor=color end function Visuals:SetSkeletonOutlineColor(
color)self.Settings.SkeletonOutlineColor=color end function Visuals:
SetHighlightFill(color)self.Settings.HighlightFill=color end function Visuals:
SetHighlightOutline(color)self.Settings.HighlightOutline=color end function
Visuals:SetBoxThickness(value)self.Settings.BoxThickness=value end function
Visuals:SetSkeletonThickness(value)self.Settings.SkeletonThickness=value end
function Visuals:SetTextSize(value)self.Settings.TextSize=value end function
Visuals:SetOutline(state)self.Settings.Outline=state end function Visuals:Enable
()if not Drawing then self.Logger:Warn(
'Drawing API not available; Visuals disabled.')self.Enabled=false return end
local function onPlayerRemoving(player)self:RemovePlayer(player)end
local function onPlayerAdded(player)if player==LOCAL_PLAYER then return end end
table.insert(self.Connections,Players.PlayerAdded:Connect(onPlayerAdded))table.
insert(self.Connections,Players.PlayerRemoving:Connect(onPlayerRemoving))for _,
player in ipairs(Players:GetPlayers())do onPlayerAdded(player)end table.insert(
self.Connections,RunService.RenderStepped:Connect(function()self:Render()end))
end function Visuals:Disable()for _,conn in ipairs(self.Connections)do conn:
Disconnect()end self.Connections={}self:Clear()end function Visuals:Cleanup()
self:Disable()end function Visuals:Clear()self:ClearDrawings()self:
ClearHighlights()end function Visuals:ClearDrawings()for player,group in pairs(
self.Drawings)do self:DestroyDrawingGroup(group)self.Drawings[player]=nil end
end function Visuals:ClearHighlights()for player,hl in pairs(self.Highlights)do
hl:Destroy()self.Highlights[player]=nil end end function Visuals:RemovePlayer(
player)if self.Drawings[player]then self:DestroyDrawingGroup(self.Drawings[
player])self.Drawings[player]=nil end if self.Highlights[player]then self.
Highlights[player]:Destroy()self.Highlights[player]=nil end end function Visuals
:DestroyDrawingGroup(group)for _,drawing in pairs(group)do if type(drawing)==
'table'then for _,line in pairs(drawing)do line:Remove()end else drawing:Remove(
)end end end function Visuals:EnsurePlayerDrawings(player)if self.Drawings[
player]then return self.Drawings[player]end local group={Name=Drawing.new('Text'
),Weapon=Drawing.new('Text'),Distance=Drawing.new('Text'),BoxOutline=Drawing.
new('Square'),Box=Drawing.new('Square'),HealthbarOutline=Drawing.new('Square'),
Healthbar=Drawing.new('Square'),Skeleton={},SkeletonOutline={}}for _,key in
ipairs({'Name','Weapon','Distance'})do group[key].Center=true group[key].Outline
=true group[key].Visible=false end for _,key in ipairs({'Box','BoxOutline',
'Healthbar','HealthbarOutline'})do group[key].Visible=false group[key].Filled=
false end group.Box.Filled=false group.BoxOutline.Filled=false group.Healthbar.
Filled=true group.HealthbarOutline.Filled=true for i=1,16 do local line=Drawing.
new('Line')line.Visible=false table.insert(group.Skeleton,line)local outline=
Drawing.new('Line')outline.Visible=false table.insert(group.SkeletonOutline,
outline)end self.Drawings[player]=group return group end function Visuals:
UpdateHighlight(player,character)if not self.Settings.ShowHighlight then if self
.Highlights[player]then self.Highlights[player]:Destroy()self.Highlights[player]
=nil end return end if not self.Highlights[player]then local hl=Instance.new(
'Highlight')hl.Name='BlossomHighlight'hl.FillTransparency=0.5 hl.
OutlineTransparency=0 hl.Parent=game:GetService('CoreGui')self.Highlights[player
]=hl end local hl=self.Highlights[player]if hl.Adornee~=character then hl.
Adornee=character end hl.FillColor=self.Settings.HighlightFill hl.OutlineColor=
self.Settings.HighlightOutline hl.Enabled=true end function Visuals:Render()if
not self.Settings.ESPEnabled then self:Clear()return end for _,player in ipairs(
Players:GetPlayers())do if player==LOCAL_PLAYER then continue end local
character=player.Character local humanoid=character and character:
FindFirstChildOfClass('Humanoid')local root=character and character:
FindFirstChild('HumanoidRootPart')if not character or not root or not humanoid
or humanoid.Health<=0 then self:RemovePlayer(player)continue end if self.
Settings.TeamCheck and player.Team==LOCAL_PLAYER.Team then self:RemovePlayer(
player)continue end local group=self:EnsurePlayerDrawings(player)local screenPos
,onScreen=Camera:WorldToViewportPoint(root.Position)local distance=(root.
Position-Camera.CFrame.Position).Magnitude if not onScreen or distance>self.
Settings.MaxDistance then for _,d in pairs(group)do if type(d)=='table'then for
_,l in pairs(d)do l.Visible=false end else d.Visible=false end end if self.
Highlights[player]then self.Highlights[player].Enabled=false end continue end
self:UpdateHighlight(player,character)local scale=math.clamp(1000/distance,0.1,1
)local width,height=30*scale,50*scale local cf,size=character:GetBoundingBox()
local tl=Camera:WorldToViewportPoint((cf*CFrame.new(size.X/2,size.Y/2,0)).
Position)local tr=Camera:WorldToViewportPoint((cf*CFrame.new(-size.X/2,size.Y/2,
0)).Position)local bl=Camera:WorldToViewportPoint((cf*CFrame.new(size.X/2,-size.
Y/2,0)).Position)local br=Camera:WorldToViewportPoint((cf*CFrame.new(-size.X/2,-
size.Y/2,0)).Position)local rootPos=Camera:WorldToViewportPoint(root.Position)
local legPos=Camera:WorldToViewportPoint(root.Position-Vector3.new(0,3,0))local
headPos=Camera:WorldToViewportPoint(root.Position+Vector3.new(0,2,0))height=math
.abs(headPos.Y-legPos.Y)*1.5 width=height*0.6 local boxPos=Vector2.new(rootPos.X
-width/2,rootPos.Y-height/2)local boxSize=Vector2.new(width,height)if self.
Settings.ShowBoxes then group.BoxOutline.Size=boxSize group.BoxOutline.Position=
boxPos group.BoxOutline.Color=self.Settings.BoxOutlineColor group.BoxOutline.
Thickness=self.Settings.BoxThickness+2 group.BoxOutline.Visible=true group.
BoxOutline.ZIndex=1 group.Box.Size=boxSize group.Box.Position=boxPos group.Box.
Color=self.Settings.BoxColor group.Box.Thickness=self.Settings.BoxThickness
group.Box.Visible=true group.Box.ZIndex=2 else group.Box.Visible=false group.
BoxOutline.Visible=false end if self.Settings.ShowHealthbar then local
healthPerc=math.clamp(humanoid.Health/humanoid.MaxHealth,0,1)local barHeight=
height*healthPerc group.HealthbarOutline.Size=Vector2.new(4,height+2)group.
HealthbarOutline.Position=Vector2.new(boxPos.X-6,boxPos.Y-1)group.
HealthbarOutline.Color=self.Settings.HealthbarOutlineColor group.
HealthbarOutline.Filled=true group.HealthbarOutline.Visible=true group.
HealthbarOutline.ZIndex=1 group.Healthbar.Size=Vector2.new(2,barHeight)group.
Healthbar.Position=Vector2.new(boxPos.X-5,boxPos.Y+(height-barHeight))group.
Healthbar.Color=self.Settings.HealthbarColor:Lerp(Color3.new(1,0,0),1-healthPerc
)group.Healthbar.Filled=true group.Healthbar.Visible=true group.Healthbar.ZIndex
=2 else group.Healthbar.Visible=false group.HealthbarOutline.Visible=false end
local textYOffset=0 if self.Settings.ShowNames then group.Name.Text=player.
DisplayName or player.Name group.Name.Size=self.Settings.TextSize group.Name.
Color=self.Settings.TextColor group.Name.Outline=self.Settings.Outline group.
Name.OutlineColor=self.Settings.NameOutlineColor group.Name.Position=Vector2.
new(rootPos.X,boxPos.Y-self.Settings.TextSize-2)group.Name.Visible=true else
group.Name.Visible=false end if self.Settings.ShowWeapon then local tool=
character:FindFirstChildOfClass('Tool')if tool then group.Weapon.Text=tool.Name
group.Weapon.Size=self.Settings.TextSize group.Weapon.Color=self.Settings.
WeaponColor group.Weapon.Outline=self.Settings.Outline group.Weapon.OutlineColor
=self.Settings.WeaponOutlineColor group.Weapon.Position=Vector2.new(rootPos.X,
boxPos.Y+height+2+textYOffset)group.Weapon.Visible=true textYOffset=textYOffset+
self.Settings.TextSize else group.Weapon.Visible=false end else group.Weapon.
Visible=false end if self.Settings.ShowDistance then group.Distance.Text=math.
floor(distance)..' studs'group.Distance.Size=self.Settings.TextSize group.
Distance.Color=self.Settings.DistanceColor group.Distance.Outline=self.Settings.
Outline group.Distance.OutlineColor=self.Settings.DistanceOutlineColor group.
Distance.Position=Vector2.new(rootPos.X,boxPos.Y+height+2+textYOffset)group.
Distance.Visible=true textYOffset=textYOffset+self.Settings.TextSize else group.
Distance.Visible=false end if self.Settings.ShowSkeleton then self:
UpdateSkeleton(group.Skeleton,group.SkeletonOutline,character)else for _,l in
pairs(group.Skeleton)do l.Visible=false end for _,l in pairs(group.
SkeletonOutline)do l.Visible=false end end end end function Visuals:
UpdateSkeleton(skeletonLines,skeletonOutlineLines,character)local R15_JOINTS={{
'Head','UpperTorso'},{'UpperTorso','LowerTorso'},{'LowerTorso','LeftUpperLeg'},{
'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{'LowerTorso',
'RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg','RightFoot'}
,{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm',
'LeftHand'},{'UpperTorso','RightUpperArm'},{'RightUpperArm','RightLowerArm'},{
'RightLowerArm','RightHand'}}local lineIdx=1 for _,pair in ipairs(R15_JOINTS)do
local p1=character:FindFirstChild(pair[1])local p2=character:FindFirstChild(pair
[2])if p1 and p2 then local v1,o1=Camera:WorldToViewportPoint(p1.Position)local
v2,o2=Camera:WorldToViewportPoint(p2.Position)if o1 and o2 then local outline=
skeletonOutlineLines[lineIdx]if outline then outline.From=Vector2.new(v1.X,v1.Y)
outline.To=Vector2.new(v2.X,v2.Y)outline.Color=self.Settings.
SkeletonOutlineColor outline.Thickness=self.Settings.SkeletonThickness+2 outline
.Visible=true outline.ZIndex=1 end local line=skeletonLines[lineIdx]if line then
line.From=Vector2.new(v1.X,v1.Y)line.To=Vector2.new(v2.X,v2.Y)line.Color=self.
Settings.SkeletonColor line.Thickness=self.Settings.SkeletonThickness line.
Visible=true line.ZIndex=2 lineIdx=lineIdx+1 end end end end for i=lineIdx,#
skeletonLines do skeletonLines[i].Visible=false end for i=lineIdx,#
skeletonOutlineLines do skeletonOutlineLines[i].Visible=false end end return
Visuals end function __DARKLUA_BUNDLE_MODULES.d()local v=
__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local ReplicatedStorage=game:
GetService('ReplicatedStorage')local HttpService=game:GetService('HttpService')
local UnlockAllSkins={Enabled=false,Installed=false,Player=nil,PlayerScripts=nil
,Controllers=nil,EnumLibrary=nil,CosmeticLibrary=nil,ItemLibrary=nil,
DataController=nil,FighterController=nil,ClientItem=nil,ClientViewModel=nil,
ViewProfile=nil,ClientEntity=nil,LastUsedWeapon=nil,ConstructingWeapon=nil,
ViewingProfile=nil,Equipped={},Favorites={},Originals={},FinisherCache={}}local
CONFIG_DIR='BlossomUnlockAll'local CONFIG_FILE=CONFIG_DIR..'/config.json'
local function safeRequire(moduleRef)local ok,result=pcall(require,moduleRef)if
ok then return result end return nil end function UnlockAllSkins:Init(Client)
self.Client=Client self.Logger=Client.Logger self.Player=Players.LocalPlayer if
self.Player then self.PlayerScripts=self.Player:WaitForChild('PlayerScripts',10)
self.Controllers=self.PlayerScripts and self.PlayerScripts:WaitForChild(
'Controllers',10)or nil end end function UnlockAllSkins:Toggle(state)if self.
Enabled==state then return end self.Enabled=state if state then self:
EnsureInstalled()self:LoadConfig()self:ReplicateInventory()else self:
ReplicateInventory()end end function UnlockAllSkins:EnsureInstalled()if self.
Installed then return end self.EnumLibrary=safeRequire(ReplicatedStorage.Modules
:WaitForChild('EnumLibrary',10))if self.EnumLibrary then pcall(function()self.
EnumLibrary:WaitForEnumBuilder()end)end self.CosmeticLibrary=safeRequire(
ReplicatedStorage.Modules:WaitForChild('CosmeticLibrary',10))self.ItemLibrary=
safeRequire(ReplicatedStorage.Modules:WaitForChild('ItemLibrary',10))self.
DataController=self.Controllers and safeRequire(self.Controllers:WaitForChild(
'PlayerDataController',10))or nil pcall(function()self.FighterController=self.
Controllers and safeRequire(self.Controllers:WaitForChild('FighterController',10
))or nil end)pcall(function()local modules=self.PlayerScripts and self.
PlayerScripts:WaitForChild('Modules',10)or nil self.ClientItem=modules and
safeRequire(modules.ClientReplicatedClasses.ClientFighter.ClientItem)or nil end)
pcall(function()local modules=self.PlayerScripts and self.PlayerScripts:
WaitForChild('Modules',10)or nil local viewModelModule=modules and modules.
ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild(
'ClientViewModel')or nil self.ClientViewModel=viewModelModule and safeRequire(
viewModelModule)or nil end)pcall(function()local modules=self.PlayerScripts and
self.PlayerScripts:WaitForChild('Modules',10)or nil self.ViewProfile=modules and
safeRequire(modules.Pages.ViewProfile)or nil end)pcall(function()local modules=
self.PlayerScripts and self.PlayerScripts:WaitForChild('Modules',10)or nil self.
ClientEntity=modules and safeRequire(modules.ClientReplicatedClasses.
ClientEntity)or nil end)self:InstallCosmeticOverrides()self:
InstallDataOverrides()self:InstallRemoteHooks()self:InstallViewModelHooks()self:
InstallProfileHooks()self:InstallEntityHooks()self.Installed=true end function
UnlockAllSkins:CloneCosmetic(name,cosmeticType,options)local base=self.
CosmeticLibrary and self.CosmeticLibrary.Cosmetics and self.CosmeticLibrary.
Cosmetics[name]if not base then return nil end local data={}for key,value in
pairs(base)do data[key]=value end data.Name=name data.Type=data.Type or
cosmeticType data.Seed=data.Seed or math.random(1,1000000)if self.EnumLibrary
then local success,enumId=pcall(self.EnumLibrary.ToEnum,self.EnumLibrary,name)if
success and enumId then data.Enum=enumId data.ObjectID=data.ObjectID or enumId
end end if options then if options.inverted~=nil then data.Inverted=options.
inverted end if options.favoritesOnly~=nil then data.OnlyUseFavorites=options.
favoritesOnly end end return data end function UnlockAllSkins:SaveConfig()if not
writefile then return end pcall(function()local config={equipped={},favorites=
self.Favorites}for weapon,cosmetics in pairs(self.Equipped)do config.equipped[
weapon]={}for cosmeticType,cosmeticData in pairs(cosmetics)do if cosmeticData
and cosmeticData.Name then config.equipped[weapon][cosmeticType]={name=
cosmeticData.Name,seed=cosmeticData.Seed,inverted=cosmeticData.Inverted}end end
end makefolder(CONFIG_DIR)writefile(CONFIG_FILE,HttpService:JSONEncode(config))
end)end function UnlockAllSkins:LoadConfig()if not readfile or not isfile or not
isfile(CONFIG_FILE)then return end pcall(function()local config=HttpService:
JSONDecode(readfile(CONFIG_FILE))if config.equipped then for weapon,cosmetics in
pairs(config.equipped)do self.Equipped[weapon]={}for cosmeticType,cosmeticData
in pairs(cosmetics)do local cloned=self:CloneCosmetic(cosmeticData.name,
cosmeticType,{inverted=cosmeticData.inverted})if cloned then cloned.Seed=
cosmeticData.seed self.Equipped[weapon][cosmeticType]=cloned end end end end
self.Favorites=config.favorites or{}end)end function UnlockAllSkins:
ReplicateInventory()local data=self.DataController and self.DataController.
CurrentData if not data or not data.Replicate then return end task.defer(
function()pcall(function()data:Replicate('WeaponInventory')end)task.wait(0.2)
pcall(function()data:Replicate('FavoritedCosmetics')end)end)end function
UnlockAllSkins:InstallCosmeticOverrides()if not self.CosmeticLibrary or self.
Originals.CosmeticOverrides then return end self.Originals.CosmeticOverrides={
OwnsCosmeticNormally=self.CosmeticLibrary.OwnsCosmeticNormally,
OwnsCosmeticUniversally=self.CosmeticLibrary.OwnsCosmeticUniversally,
OwnsCosmeticForWeapon=self.CosmeticLibrary.OwnsCosmeticForWeapon,OwnsCosmetic=
self.CosmeticLibrary.OwnsCosmetic}self.CosmeticLibrary.OwnsCosmeticNormally=
function(...)if not self.Enabled then local original=self.Originals.
CosmeticOverrides.OwnsCosmeticNormally return original and original(...)end
return true end self.CosmeticLibrary.OwnsCosmeticUniversally=function(...)if not
self.Enabled then local original=self.Originals.CosmeticOverrides.
OwnsCosmeticUniversally return original and original(...)end return true end
self.CosmeticLibrary.OwnsCosmeticForWeapon=function(...)if not self.Enabled then
local original=self.Originals.CosmeticOverrides.OwnsCosmeticForWeapon return
original and original(...)end return true end self.CosmeticLibrary.OwnsCosmetic=
function(library,inventory,name,weapon)if not self.Enabled then local original=
self.Originals.CosmeticOverrides.OwnsCosmetic return original and original(
library,inventory,name,weapon)end if name and name:find('MISSING_')then local
original=self.Originals.CosmeticOverrides.OwnsCosmetic return original and
original(library,inventory,name,weapon)end return true end end function
UnlockAllSkins:InstallDataOverrides()if not self.DataController or self.
Originals.DataOverrides then return end self.Originals.DataOverrides={Get=self.
DataController.Get,GetWeaponData=self.DataController.GetWeaponData}self.
DataController.Get=function(controller,key)if not self.Enabled then return self.
Originals.DataOverrides.Get(controller,key)end local data=self.Originals.
DataOverrides.Get(controller,key)if key=='CosmeticInventory'then local proxy={}
if data then for k,v in pairs(data)do proxy[k]=v end end return setmetatable(
proxy,{__index=function()return true end})end if key=='FavoritedCosmetics'then
local result=data and table.clone(data)or{}for weapon,favs in pairs(self.
Favorites)do result[weapon]=result[weapon]or{}for name,isFav in pairs(favs)do
result[weapon][name]=isFav end end return result end return data end self.
DataController.GetWeaponData=function(controller,weaponName)if not self.Enabled
then return self.Originals.DataOverrides.GetWeaponData(controller,weaponName)end
local data=self.Originals.DataOverrides.GetWeaponData(controller,weaponName)if
not data then return nil end local merged={}for key,value in pairs(data)do
merged[key]=value end merged.Name=weaponName if self.Equipped[weaponName]then
for cosmeticType,cosmeticData in pairs(self.Equipped[weaponName])do merged[
cosmeticType]=cosmeticData end end return merged end end function UnlockAllSkins
:InstallRemoteHooks()if self.Originals.RemoteHooks then return end self.
Originals.RemoteHooks={}if not hookmetamethod then return end local remotes=
ReplicatedStorage:FindFirstChild('Remotes')local dataRemotes=remotes and remotes
:FindFirstChild('Data')local equipRemote=dataRemotes and dataRemotes:
FindFirstChild('EquipCosmetic')local favoriteRemote=dataRemotes and dataRemotes:
FindFirstChild('FavoriteCosmetic')local replicationRemotes=remotes and remotes:
FindFirstChild('Replication')local fighterRemotes=replicationRemotes and
replicationRemotes:FindFirstChild('Fighter')local useItemRemote=fighterRemotes
and fighterRemotes:FindFirstChild('UseItem')if not equipRemote then return end
local module=self local oldNamecall oldNamecall=hookmetamethod(game,'__namecall'
,function(selfObj,...)if getnamecallmethod()~='FireServer'then return
oldNamecall(selfObj,...)end if not module.Enabled then return oldNamecall(
selfObj,...)end local args={...}if useItemRemote and selfObj==useItemRemote then
local objectID=args[1]if module.FighterController and module.Player then pcall(
function()local fighter=module.FighterController:GetFighter(module.Player)if
fighter and fighter.Items then for _,item in pairs(fighter.Items)do if item:Get(
'ObjectID')==objectID then module.LastUsedWeapon=item.Name break end end end end
)end end if selfObj==equipRemote then local weaponName,cosmeticType,cosmeticName
,options=args[1],args[2],args[3],args[4]or{}if cosmeticName and cosmeticName~=
'None'and cosmeticName~=''then local inventory=module.DataController and module.
DataController:Get('CosmeticInventory')or nil if inventory and rawget(inventory,
cosmeticName)then return oldNamecall(selfObj,...)end end module.Equipped[
weaponName]=module.Equipped[weaponName]or{}if not cosmeticName or cosmeticName==
'None'or cosmeticName==''then module.Equipped[weaponName][cosmeticType]=nil if
not next(module.Equipped[weaponName])then module.Equipped[weaponName]=nil end
else local cloned=module:CloneCosmetic(cosmeticName,cosmeticType,{inverted=
options.IsInverted,favoritesOnly=options.OnlyUseFavorites})if cloned then module
.Equipped[weaponName][cosmeticType]=cloned end end task.defer(function()module:
ReplicateInventory()module:SaveConfig()end)return end if favoriteRemote and
selfObj==favoriteRemote then module.Favorites[args[1] ]=module.Favorites[args[1]
]or{}module.Favorites[args[1] ][args[2] ]=args[3]or nil module:SaveConfig()task.
spawn(function()pcall(function()if module.DataController and module.
DataController.CurrentData then module.DataController.CurrentData:Replicate(
'FavoritedCosmetics')end end)end)return end return oldNamecall(selfObj,...)end)
end function UnlockAllSkins:InstallViewModelHooks()if self.Originals.
ViewModelHooks then return end self.Originals.ViewModelHooks={}if not self.
ClientItem or not self.ClientItem._CreateViewModel then return end local module=
self self.Originals.ViewModelHooks.CreateViewModel=self.ClientItem.
_CreateViewModel self.ClientItem._CreateViewModel=function(selfObj,viewmodelRef)
if module.Enabled then local weaponName=selfObj.Name local weaponPlayer=selfObj.
ClientFighter and selfObj.ClientFighter.Player module.ConstructingWeapon=(
weaponPlayer==module.Player)and weaponName or nil if weaponPlayer==module.Player
and module.Equipped[weaponName]and module.Equipped[weaponName].Skin and
viewmodelRef then local dataKey,skinKey,nameKey=selfObj:ToEnum('Data'),selfObj:
ToEnum('Skin'),selfObj:ToEnum('Name')if viewmodelRef[dataKey]then viewmodelRef[
dataKey][skinKey]=module.Equipped[weaponName].Skin viewmodelRef[dataKey][nameKey
]=module.Equipped[weaponName].Skin.Name elseif viewmodelRef.Data then
viewmodelRef.Data.Skin=module.Equipped[weaponName].Skin viewmodelRef.Data.Name=
module.Equipped[weaponName].Skin.Name end end end local result=module.Originals.
ViewModelHooks.CreateViewModel(selfObj,viewmodelRef)module.ConstructingWeapon=
nil return result end if self.ClientViewModel and self.ClientViewModel.GetWrap
then self.Originals.ViewModelHooks.GetWrap=self.ClientViewModel.GetWrap self.
ClientViewModel.GetWrap=function(selfObj)if module.Enabled then local weaponName
=selfObj.ClientItem and selfObj.ClientItem.Name local weaponPlayer=selfObj.
ClientItem and selfObj.ClientItem.ClientFighter and selfObj.ClientItem.
ClientFighter.Player if weaponName and weaponPlayer==module.Player and module.
Equipped[weaponName]and module.Equipped[weaponName].Wrap then return module.
Equipped[weaponName].Wrap end end return module.Originals.ViewModelHooks.
GetWrap(selfObj)end end if self.ClientViewModel and self.ClientViewModel.new
then self.Originals.ViewModelHooks.NewViewModel=self.ClientViewModel.new self.
ClientViewModel.new=function(replicatedData,clientItem)local weaponPlayer=
clientItem.ClientFighter and clientItem.ClientFighter.Player local weaponName=
module.ConstructingWeapon or clientItem.Name if module.Enabled and weaponPlayer
==module.Player and module.Equipped[weaponName]then local ReplicatedClass=
require(ReplicatedStorage.Modules.ReplicatedClass)local dataKey=ReplicatedClass:
ToEnum('Data')replicatedData[dataKey]=replicatedData[dataKey]or{}local cosmetics
=module.Equipped[weaponName]if cosmetics.Skin then replicatedData[dataKey][
ReplicatedClass:ToEnum('Skin')]=cosmetics.Skin end if cosmetics.Wrap then
replicatedData[dataKey][ReplicatedClass:ToEnum('Wrap')]=cosmetics.Wrap end if
cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum('Charm')]=
cosmetics.Charm end end local result=module.Originals.ViewModelHooks.
NewViewModel(replicatedData,clientItem)if module.Enabled and weaponPlayer==
module.Player and module.Equipped[weaponName]and module.Equipped[weaponName].
Wrap and result._UpdateWrap then result:_UpdateWrap()task.delay(0.1,function()if
not result._destroyed then result:_UpdateWrap()end end)end return result end end
if self.ItemLibrary and self.ItemLibrary.GetViewModelImageFromWeaponData then
self.Originals.ViewModelHooks.GetViewModelImageFromWeaponData=self.ItemLibrary.
GetViewModelImageFromWeaponData self.ItemLibrary.GetViewModelImageFromWeaponData
=function(library,weaponData,highRes)if not module.Enabled then return module.
Originals.ViewModelHooks.GetViewModelImageFromWeaponData(library,weaponData,
highRes)end if not weaponData then return module.Originals.ViewModelHooks.
GetViewModelImageFromWeaponData(library,weaponData,highRes)end local weaponName=
weaponData.Name local shouldShowSkin=(weaponData.Skin and module.Equipped[
weaponName]and weaponData.Skin==module.Equipped[weaponName].Skin)or(module.
ViewingProfile==module.Player and module.Equipped[weaponName]and module.Equipped
[weaponName].Skin)if shouldShowSkin and module.Equipped[weaponName]and module.
Equipped[weaponName].Skin then local skinInfo=library.ViewModels[module.Equipped
[weaponName].Skin.Name]if skinInfo then return skinInfo[highRes and
'ImageHighResolution'or'Image']or skinInfo.Image end end return module.Originals
.ViewModelHooks.GetViewModelImageFromWeaponData(library,weaponData,highRes)end
end end function UnlockAllSkins:InstallProfileHooks()if self.Originals.
ProfileHooks then return end self.Originals.ProfileHooks={}if not self.
ViewProfile or not self.ViewProfile.Fetch then return end local module=self self
.Originals.ProfileHooks.Fetch=self.ViewProfile.Fetch self.ViewProfile.Fetch=
function(selfObj,targetPlayer)if module.Enabled then module.ViewingProfile=
targetPlayer else module.ViewingProfile=nil end return module.Originals.
ProfileHooks.Fetch(selfObj,targetPlayer)end end function UnlockAllSkins:
InstallEntityHooks()if self.Originals.EntityHooks then return end self.Originals
.EntityHooks={}if not self.ClientEntity or not self.ClientEntity.
ReplicateFromServer then return end local module=self self.Originals.EntityHooks
.ReplicateFromServer=self.ClientEntity.ReplicateFromServer self.ClientEntity.
ReplicateFromServer=function(selfObj,action,...)if module.Enabled and action==
'FinisherEffect'then local args={...}local killerName=args[3]local decodedKiller
=killerName if type(killerName)=='userdata'and module.EnumLibrary and module.
EnumLibrary.FromEnum then local ok,decoded=pcall(module.EnumLibrary.FromEnum,
module.EnumLibrary,killerName)if ok and decoded then decodedKiller=decoded end
end local isOurKill=tostring(decodedKiller)==module.Player.Name or tostring(
decodedKiller):lower()==module.Player.Name:lower()if isOurKill and module.
LastUsedWeapon and module.Equipped[module.LastUsedWeapon]and module.Equipped[
module.LastUsedWeapon].Finisher then local finisherData=module.Equipped[module.
LastUsedWeapon].Finisher local finisherEnum=finisherData.Enum if not
finisherEnum and module.EnumLibrary then local ok,result=pcall(module.
EnumLibrary.ToEnum,module.EnumLibrary,finisherData.Name)if ok and result then
finisherEnum=result end end if finisherEnum then args[1]=finisherEnum end end
module:PlayFinisherClient(args[1],args,selfObj)return end return module.
Originals.EntityHooks.ReplicateFromServer(selfObj,action,...)end end function
UnlockAllSkins:PlayFinisherClient(finisherId,args,entity)local logger=self.
Logger if logger then logger:Info('FinisherEffect received.')logger:Info(
'Finisher id:',finisherId,'type:',type(finisherId))logger:Info(
'Finisher entity param:',entity,'type:',typeof(entity),'luaType:',type(entity))
if args then logger:Info('Finisher args count:',#args)local maxArgs=math.min(#
args,6)for i=1,maxArgs do local valueType=type(args[i])local valueKind=''if
valueType=='userdata'then valueKind=tostring(typeof(args[i]))end logger:Info(
'Finisher arg',i,'type:',valueType,'kind:',valueKind,'value:',args[i])if
valueType=='userdata'and typeof(args[i])=='Instance'then logger:Info(
'Finisher arg',i,'class:',args[i].ClassName,'name:',args[i].Name,'parent:',args[
i].Parent)end end if#args>maxArgs then logger:Info('Finisher args truncated:',
maxArgs,'of',#args)end end end local finisherName=finisherId local finisherEnum=
nil if type(finisherId)=='userdata'and self.EnumLibrary and self.EnumLibrary.
FromEnum then finisherEnum=finisherId local ok,decoded=pcall(self.EnumLibrary.
FromEnum,self.EnumLibrary,finisherId)if ok and decoded then finisherName=decoded
end elseif type(finisherId)=='string'and self.EnumLibrary and self.EnumLibrary.
ToEnum then local ok,enumId=pcall(self.EnumLibrary.ToEnum,self.EnumLibrary,
finisherId)if ok and enumId then finisherEnum=enumId end end if type(
finisherName)~='string'then if logger then logger:Warn(
'Finisher name not a string:',finisherName)end return end if logger then logger:
Info('Finisher name:',finisherName,'enum:',finisherEnum)end local cached=self.
FinisherCache[finisherName]local finisherClass=cached if not finisherClass then
local finishersFolder=ReplicatedStorage:FindFirstChild('Modules')finishersFolder
=finishersFolder and finishersFolder:FindFirstChild('Finishers')or nil local
finisherModule=finishersFolder and finishersFolder:FindFirstChild(finisherName)
or nil if not finisherModule and finishersFolder and finisherEnum and self.
EnumLibrary and self.EnumLibrary.ToEnum then for _,child in ipairs(
finishersFolder:GetChildren())do local ok,enumId=pcall(self.EnumLibrary.ToEnum,
self.EnumLibrary,child.Name)if ok and enumId==finisherEnum then finisherModule=
child finisherName=child.Name break end end end if not finisherModule and
finishersFolder and type(finisherId)=='string'and self.EnumLibrary and self.
EnumLibrary.ToEnum then for _,child in ipairs(finishersFolder:GetChildren())do
local ok,enumId=pcall(self.EnumLibrary.ToEnum,self.EnumLibrary,child.Name)if ok
and enumId and tostring(enumId)==finisherId then finisherModule=child
finisherName=child.Name finisherEnum=enumId break end end end if not
finisherModule then if logger then logger:Warn('Finisher module not found:',
finisherName)if finishersFolder then local children=finishersFolder:GetChildren(
)logger:Info('Finishers folder children:',#children)local maxList=math.min(#
children,20)for i=1,maxList do local child=children[i]local enumText=''if self.
EnumLibrary and self.EnumLibrary.ToEnum then local ok,enumId=pcall(self.
EnumLibrary.ToEnum,self.EnumLibrary,child.Name)if ok and enumId then enumText=
tostring(enumId)end end logger:Info('Finisher candidate:',child.Name,'enum:',
enumText)end if#children>maxList then logger:Info(
'Finisher candidates truncated:',maxList,'of',#children)end else logger:Warn(
'Finishers folder not found under ReplicatedStorage.Modules')end end return end
finisherClass=safeRequire(finisherModule)if not finisherClass then if logger
then logger:Warn('Failed to require finisher module:',finisherName)end return
end self.FinisherCache[finisherName]=finisherClass end if not finisherClass.new
then if logger then logger:Warn('Finisher class missing constructor:',
finisherName)end return end local function resolveSubject(value)if typeof(value)
~='Instance'then return nil end if value:IsA('Humanoid')or value:IsA('BasePart')
then return value end if value:IsA('Player')then local character=value.Character
if character then local humanoid=character:FindFirstChildOfClass('Humanoid')if
humanoid then return humanoid end local root=character:FindFirstChild(
'HumanoidRootPart')or character.PrimaryPart if root then return root end end end
if value:IsA('Model')then local humanoid=value:FindFirstChildOfClass('Humanoid')
if humanoid then return humanoid end local root=value:FindFirstChild(
'HumanoidRootPart')or value.PrimaryPart if root then return root end end local
ancestor=value:FindFirstAncestorOfClass('Model')if ancestor then local humanoid=
ancestor:FindFirstChildOfClass('Humanoid')if humanoid then return humanoid end
local root=ancestor:FindFirstChild('HumanoidRootPart')or ancestor.PrimaryPart if
root then return root end end return nil end local function resolveEntitySubject
(entityValue)local valueType=typeof(entityValue)if valueType~='Instance'and
type(entityValue)~='table'then return nil end if entityValue.Humanoid then
return entityValue.Humanoid end if entityValue.RootPart then return entityValue.
RootPart end local model=entityValue.Model if model and typeof(model)==
'Instance'and model:IsA('Model')then local humanoid=model:FindFirstChildOfClass(
'Humanoid')if humanoid then return humanoid end local root=model:FindFirstChild(
'HumanoidRootPart')or model.PrimaryPart if root then return root end end return
nil end local function resolveSubjectFromTable(tbl,depth)if type(tbl)~='table'or
depth<=0 then return nil end for _,value in pairs(tbl)do local direct=
resolveSubject(value)if direct then return direct end if type(value)=='table'
then local nested=resolveSubjectFromTable(value,depth-1)if nested then return
nested end end end return nil end local function resolveNonLocalSubjectFromTable
(tbl,depth)if type(tbl)~='table'or depth<=0 then return nil end for _,value in
pairs(tbl)do local direct=resolveSubject(value)if direct and not isLocalSubject(
direct)then return direct end if type(value)=='table'then local nested=
resolveNonLocalSubjectFromTable(value,depth-1)if nested then return nested end
end end return nil end local function logTableSummary(tbl)if not logger or type(
tbl)~='table'then return end local count=0 for key,value in pairs(tbl)do count+=
1 if count>12 then logger:Info('Finisher table keys truncated:',count)break end
local valueType=type(value)local valueKind=''if valueType=='userdata'then
valueKind=tostring(typeof(value))end logger:Info('Finisher table key:',key,
'type:',valueType,'kind:',valueKind,'value:',value)end end local function
isLocalSubject(value)if not self.Player then return false end local character=
self.Player.Character if not character then return false end if value==character
then return true end local humanoid=character:FindFirstChildOfClass('Humanoid')
if humanoid and value==humanoid then return true end local root=character:
FindFirstChild('HumanoidRootPart')or character.PrimaryPart if root and value==
root then return true end if value:IsA('Model')and value==character then return
true end return false end local function isLocalEliminator(value)if not self.
Player or typeof(value)~='Instance'then return false end if value:IsA('Player')
then return value==self.Player end local character=self.Player.Character if not
character then return false end if value==character then return true end if
value:IsA('Model')and value==character then return true end if value:IsA(
'Humanoid')and value.Parent==character then return true end if value:IsA(
'BasePart')and value:IsDescendantOf(character)then return true end return false
end local subject=nil local subjectSource=nil if entity then if logger then
logger:Info('Finisher entity type:',typeof(entity),'luaType:',type(entity))end
subject=resolveEntitySubject(entity)if subject then subjectSource='entity'end
end if args and not subject then if type(args[4])=='table'then local tableKeys={
'Victim','Target','Subject','Character','Model','Humanoid','RootPart',
'HumanoidRootPart'}for _,key in ipairs(tableKeys)do if args[4][key]then local
candidate=resolveSubject(args[4][key])if candidate and not isLocalSubject(
candidate)then subject=candidate subjectSource='args[4].'..key break end end end
end if not subject then local candidate=resolveSubject(args[4])if candidate and
not isLocalSubject(candidate)then subject=candidate subjectSource='args[4]'end
end if not subject then local candidate=resolveSubjectFromTable(args[4],2)if
candidate and not isLocalSubject(candidate)then subject=candidate subjectSource=
'args[4] table scan'end end if not subject then local candidate=resolveSubject(
args[2])if candidate and not isLocalSubject(candidate)then subject=candidate
subjectSource='args[2]'end end if not subject then local candidate=
resolveSubject(args[3])if candidate and not isLocalSubject(candidate)then
subject=candidate subjectSource='args[3]'end end if not subject then subject=
resolveSubject(args[4])or resolveSubject(args[3])or resolveSubject(args[2])
subjectSource='fallback local'end if not subject and type(args[4])=='table'then
logTableSummary(args[4])end end if not subject then if logger then logger:Warn(
'Finisher subject not found for:',finisherName)end return end if subject and
isLocalSubject(subject)and type(args)=='table'and type(args[4])=='table'then
local nonLocal=resolveNonLocalSubjectFromTable(args[4],3)if nonLocal then
subject=nonLocal subjectSource='args[4] non-local scan'else logTableSummary(args
[4])end end if logger then logger:Info('Finisher subject resolved:',subject,
'class:',subject.ClassName,'source:',subjectSource,'isLocal:',isLocalSubject(
subject))end local eliminator=args and args[3]or nil local eliminatorIsLocal=
isLocalEliminator(eliminator)if logger then logger:Info(
'Finisher eliminator local:',eliminatorIsLocal,'eliminator:',eliminator)end if
isLocalSubject(subject)and not eliminatorIsLocal then if logger then logger:
Warn('Skipping finisher on local subject; eliminator not local:',eliminator)end
return end if eliminatorIsLocal and isLocalSubject(subject)then if logger then
logger:Warn([[Skipping finisher; subject is local while eliminator is local:]],
eliminator)end return end local finisherInstance=nil local isFinal=args and args
[2]or nil local okNew,newErr=pcall(function()finisherInstance=finisherClass.new(
subject,isFinal,eliminator)end)if not finisherInstance then local okFallback,
fallbackErr=pcall(function()finisherInstance=finisherClass.new()end)if logger
then logger:Info('Finisher constructor status:','okNew',okNew,'okFallback',
okFallback)if not okNew then logger:Warn(
'Finisher constructor failed with args:',finisherName,newErr)elseif okNew and
not finisherInstance then logger:Warn(
'Finisher constructor returned nil with args:',finisherName)end if not
okFallback then logger:Warn('Finisher constructor failed with no args:',
finisherName,fallbackErr)elseif okFallback and not finisherInstance then logger:
Warn('Finisher constructor returned nil with no args:',finisherName)end end end
if not finisherInstance then if logger then logger:Warn(
'Finisher instance not created:',finisherName)end return end if logger then
logger:Info('Finisher instance created:',finisherName)end if finisherInstance.
SetSerial and args then local serialValue=args[4]if type(serialValue)=='table'
and serialValue.Seed then serialValue=serialValue.Seed end if serialValue~=nil
then pcall(finisherInstance.SetSerial,finisherInstance,serialValue)end end if
finisherInstance.Simulate then pcall(finisherInstance.Simulate,finisherInstance)
return end if finisherInstance.PlayServer then pcall(finisherInstance.PlayServer
,finisherInstance)elseif logger then logger:Warn('Finisher missing PlayServer:',
finisherName)end if finisherInstance.PlayClient then pcall(finisherInstance.
PlayClient,finisherInstance,unpack(args))elseif logger then logger:Warn(
'Finisher missing PlayClient:',finisherName)end end return UnlockAllSkins end
function __DARKLUA_BUNDLE_MODULES.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c
end end do local function __modImpl()local repo=
[[https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/]]
local function loadRemote(path)local source=game:HttpGet(repo..path)local chunk,
err=loadstring(source)if not chunk then error('[Blossom] UI load failed: '..
tostring(err))end return chunk()end local Interface={}function Interface:Init(
Client)self.Client=Client self.Logger=Client.Logger self:Mount()end
local function setNotifyMuted(library,enabled)if enabled then library.Notify=
library.Notify or function()end library._blossomNotify=library._blossomNotify or
library.Notify library.Notify=function()end else if library._blossomNotify then
library.Notify=library._blossomNotify end end end local function
getLibraryVisible(library)if type(library.Opened)=='boolean'then return library.
Opened end if type(library.Visible)=='boolean'then return library.Visible end if
type(library.IsOpen)=='boolean'then return library.IsOpen end return true end
local function runAutoload(library,saveManager,silent)local wasVisible=
getLibraryVisible(library)if silent then setNotifyMuted(library,true)if
wasVisible then pcall(function()library:Toggle()end)end end pcall(function()
saveManager:LoadAutoloadConfig()end)if silent then if wasVisible then pcall(
function()library:Toggle()end)end setNotifyMuted(library,false)end end function
Interface:Mount()local Library=loadRemote('Library.lua')local ThemeManager=
loadRemote('addons/ThemeManager.lua')local SaveManager=loadRemote(
'addons/SaveManager.lua')self.Library=Library local window=Library:CreateWindow(
{Title='Blossom '..self.Client.Version,Center=true,AutoShow=true,TabPadding=8,
MenuFadeTime=0.2})local tabs={Main=window:AddTab('Main'),Visuals=window:AddTab(
'Visuals'),Misc=window:AddTab('Misc'),['UI Settings']=window:AddTab(
'UI Settings')}local mainGroup=tabs.Main:AddLeftGroupbox('Main')mainGroup:
AddToggle('MovementToggle',{Text='Movement Assist',Default=false,Callback=
function(state)local mod=self.Client.Modules.Movement if mod and mod.Toggle then
mod:Toggle(state)end end})local espGroup=tabs.Visuals:AddLeftGroupbox('ESP')
espGroup:AddToggle('VisualsToggle',{Text='Visuals (ESP)',Default=false,Callback=
function(state)local mod=self.Client.Modules.Visuals if mod and mod.Toggle then
mod:Toggle(state)if mod.SetESPEnabled then mod:SetESPEnabled(state)end end end})
:AddKeyPicker('EspKey',{Default='Insert',NoUI=true,Text='ESP Key'})espGroup:
AddToggle('ESPNames',{Text='Name',Default=true,Callback=function(state)local mod
=self.Client.Modules.Visuals if mod then mod:SetShowNames(state)end end}):
AddColorPicker('ESPTextColor',{Default=Color3.new(1,1,1),Title='Text Color',
Callback=function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetTextColor(value)end end}):AddColorPicker('ESPNameOutlineColor',{Default=
Color3.new(0,0,0),Title='Name Outline',Callback=function(value)local mod=self.
Client.Modules.Visuals if mod then mod:SetNameOutlineColor(value)end end})
espGroup:AddToggle('ESPWeapon',{Text='Weapon',Default=false,Callback=function(
state)local mod=self.Client.Modules.Visuals if mod then mod:SetShowWeapon(state)
end end}):AddColorPicker('ESPWeaponColor',{Default=Color3.new(1,1,1),Title=
'Weapon Color',Callback=function(value)local mod=self.Client.Modules.Visuals if
mod then mod:SetWeaponColor(value)end end}):AddColorPicker(
'ESPWeaponOutlineColor',{Default=Color3.new(0,0,0),Title='Weapon Outline',
Callback=function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetWeaponOutlineColor(value)end end})espGroup:AddToggle('ESPDistance',{Text=
'Distance',Default=false,Callback=function(state)local mod=self.Client.Modules.
Visuals if mod then mod:SetShowDistance(state)end end}):AddColorPicker(
'ESPDistanceColor',{Default=Color3.new(1,1,1),Title='Distance Color',Callback=
function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetDistanceColor(value)end end}):AddColorPicker('ESPDistanceOutlineColor',{
Default=Color3.new(0,0,0),Title='Distance Outline',Callback=function(value)local
mod=self.Client.Modules.Visuals if mod then mod:SetDistanceOutlineColor(value)
end end})espGroup:AddToggle('ESPBoxes',{Text='Box',Default=true,Callback=
function(state)local mod=self.Client.Modules.Visuals if mod then mod:
SetShowBoxes(state)end end}):AddColorPicker('ESPBoxColor',{Default=Color3.new(1,
1,1),Title='Box Color',Callback=function(value)local mod=self.Client.Modules.
Visuals if mod then mod:SetBoxColor(value)end end}):AddColorPicker(
'ESPBoxOutlineColor',{Default=Color3.new(0,0,0),Title='Box Outline',Callback=
function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetBoxOutlineColor(value)end end})espGroup:AddToggle('ESPSkeleton',{Text=
'Skeleton',Default=false,Callback=function(state)local mod=self.Client.Modules.
Visuals if mod then mod:SetShowSkeleton(state)end end}):AddColorPicker(
'ESPSkeletonColor',{Default=Color3.new(1,1,1),Title='Skeleton Color',Callback=
function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetSkeletonColor(value)end end}):AddColorPicker('ESPSkeletonOutlineColor',{
Default=Color3.new(0,0,0),Title='Skeleton Outline',Callback=function(value)local
mod=self.Client.Modules.Visuals if mod then mod:SetSkeletonOutlineColor(value)
end end})espGroup:AddToggle('ESPHealthbar',{Text='Healthbar',Default=false,
Callback=function(state)local mod=self.Client.Modules.Visuals if mod then mod:
SetShowHealthbar(state)end end}):AddColorPicker('ESPHealthbarColor',{Default=
Color3.new(0,1,0),Title='Health Color',Callback=function(value)local mod=self.
Client.Modules.Visuals if mod then mod:SetHealthbarColor(value)end end}):
AddColorPicker('ESPHealthbarOutlineColor',{Default=Color3.new(0,0,0),Title=
'Outline Color',Callback=function(value)local mod=self.Client.Modules.Visuals if
mod then mod:SetHealthbarOutlineColor(value)end end})espGroup:AddToggle(
'ESPHighlight',{Text='Highlight',Default=false,Callback=function(state)local mod
=self.Client.Modules.Visuals if mod then mod:SetShowHighlight(state)end end}):
AddColorPicker('ESPHighlightFill',{Default=Color3.new(1,0,0),Title='Fill Color',
Callback=function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetHighlightFill(value)end end}):AddColorPicker('ESPHighlightOutline',{Default=
Color3.new(1,1,1),Title='Outline Color',Callback=function(value)local mod=self.
Client.Modules.Visuals if mod then mod:SetHighlightOutline(value)end end})
espGroup:AddToggle('ESPBetterBounds',{Text='Better Bounds',Default=false,
Callback=function(state)end})espGroup:AddToggle('ESPShowTeammates',{Text=
'Show Teammates',Default=true,Callback=function(state)local mod=self.Client.
Modules.Visuals if mod then mod:SetTeamCheck(not state)end end})espGroup:
AddSlider('ESPSkeletonThickness',{Text='Skeleton Thickness',Default=1,Min=1,Max=
5,Rounding=1,Callback=function(value)local mod=self.Client.Modules.Visuals if
mod then mod:SetSkeletonThickness(value)end end})espGroup:AddSlider(
'ESPTextSize',{Text='Text Size',Default=12,Min=10,Max=24,Rounding=0,Callback=
function(value)local mod=self.Client.Modules.Visuals if mod then mod:
SetTextSize(value)end end})espGroup:AddSlider('ESPMaxDistance',{Text=
'Max Distance',Default=2000,Min=100,Max=10000,Rounding=0,Callback=function(value
)local mod=self.Client.Modules.Visuals if mod then mod:SetMaxDistance(value)end
end})local menuGroup=tabs['UI Settings']:AddLeftGroupbox('Menu')menuGroup:
AddButton('Unload',function()Library:Unload()end)menuGroup:AddLabel('Menu bind')
:AddKeyPicker('MenuKeybind',{Default='End',NoUI=true,Text='Menu keybind'})
Library.ToggleKeybind=Options.MenuKeybind ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)SaveManager:IgnoreThemeSettings()ThemeManager:
SetFolder('Blossom')SaveManager:SetFolder('Blossom')SaveManager:
BuildConfigSection(tabs['UI Settings'])ThemeManager:ApplyToTab(tabs[
'UI Settings'])local cosmeticGroup=tabs.Misc:AddLeftGroupbox('Cosmetics')
cosmeticGroup:AddToggle('UnlockAllSkins',{Text='Unlock All Skins',Default=false,
Callback=function(state)local mod=self.Client.Modules.UnlockAllSkins if mod and
mod.Toggle then mod:Toggle(state)end end})local miscGroup=tabs.Misc:
AddLeftGroupbox('Auto Load')miscGroup:AddToggle('TeleportQueue',{Text=
'Auto Load',Default=false,Callback=function(enabled)self.Client:
SetTeleportQueue(enabled)end})miscGroup:AddToggle('SilentMode',{Text=
'Silent Mode',Default=false,Callback=function(enabled)if enabled then
setNotifyMuted(Library,true)else setNotifyMuted(Library,false)end end})
runAutoload(Library,SaveManager,false)self.Logger:Info('UI mounted successfully'
)end function Interface:Cleanup()if self.Library then self.Library:Unload()end
end return Interface end function __DARKLUA_BUNDLE_MODULES.f()local v=
__DARKLUA_BUNDLE_MODULES.cache.f if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end end local Logger=
__DARKLUA_BUNDLE_MODULES.a()local Signal=__DARKLUA_BUNDLE_MODULES.b()local
BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau]]
local Client={Version='1.0.0',Logger=Logger.new('Blossom'),Events={Started=
Signal.new(),Stopped=Signal.new()},Modules={},IsRunning=false,_TeleportQueueConn
=nil}local MODULES={{Name='Movement',Path=__DARKLUA_BUNDLE_MODULES.c()},{Name=
'Visuals',Path=__DARKLUA_BUNDLE_MODULES.d()},{Name='UnlockAllSkins',Path=
__DARKLUA_BUNDLE_MODULES.e()},{Name='Interface',Path=__DARKLUA_BUNDLE_MODULES.f(
)}}local function disableAnalyticsPipeline()local success,err=pcall(function()
local rf=game:GetService('ReplicatedFirst')local controller=rf:FindFirstChild(
'AnalyticsPipelineController')if not controller then controller=rf:WaitForChild(
'AnalyticsPipelineController',10)end if controller then controller.Disabled=true
print(controller.Disabled)end end)if not success then warn(
'[Blossom] Failed to disable AnalyticsPipelineController:',err)end end function
Client:LoadModule(name,moduleOrPath)if self.Modules[name]then self.Logger:Warn(
'Module already loaded:',name)return end local loader=function()if type(
moduleOrPath)=='string'then return require(moduleOrPath)end return moduleOrPath
end local success,result=pcall(loader)if success then self.Modules[name]=result
if result.Init then task.spawn(function()result:Init(self)end)end self.Logger:
Info('Loaded module:',name)else self.Logger:Warn('Failed to load module:',name,
result)end end function Client:SetTeleportQueue(enabled)if self.
_TeleportQueueConn then self._TeleportQueueConn:Disconnect()self.
_TeleportQueueConn=nil end if not enabled then return end local queueOnTeleport=
queue_on_teleport or queueonteleport or(syn and syn.queue_on_teleport)if not
queueOnTeleport then self.Logger:Warn('queue_on_teleport not available.')return
end local success,player=pcall(function()return game:GetService('Players').
LocalPlayer end)if not success or not player then self.Logger:Warn(
'LocalPlayer not available for teleport queue.')return end self.
_TeleportQueueConn=player.OnTeleport:Connect(function(state)if state==Enum.
TeleportState.Started then queueOnTeleport(('loadstring(game:HttpGet("%s"))()'):
format(BUNDLE_URL))end end)end function Client:Start()if self.IsRunning then
return end self.IsRunning=true disableAnalyticsPipeline()self.Logger:Info(
'Client initializing...')for _,entry in ipairs(MODULES)do self:LoadModule(entry.
Name,entry.Path)end self.Events.Started:Fire()end function Client:Stop()self.
IsRunning=false self.Events.Stopped:Fire()for name,module in pairs(self.Modules)
do if module.Cleanup then pcall(module.Cleanup,module)end end self.Logger:Info(
'Client stopped.')end return Client:Start()