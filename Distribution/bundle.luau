local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
DEFAULT_SOURCE='System'local Logger={}Logger.__index=Logger local function
formatMessage(level,source,...)local parts={...}for i,value in ipairs(parts)do
parts[i]=tostring(value)end local message=table.concat(parts,' ')return string.
format('[%s][%s] %s',level,source,message)end function Logger.new(source)local
instance=setmetatable({source=source or DEFAULT_SOURCE},Logger)return(instance)
end function Logger.info(self,...)print(formatMessage('INFO',self.source,...))
end function Logger.warn(self,...)warn(formatMessage('WARN',self.source,...))end
function Logger.error(self,...)error(formatMessage('ERROR',self.source,...),0)
end return Logger end function __DARKLUA_BUNDLE_MODULES.a()local v=
__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function
__modImpl()local Maid={}Maid.ClassName='Maid'function Maid.new()return
setmetatable({_tasks={}},Maid)end function Maid.isMaid(value)return type(value)
=='table'and value.ClassName=='Maid'end function Maid:__index(index)if Maid[
index]then return Maid[index]else return self._tasks[index]end end function Maid
:__newindex(index,newTask)if Maid[index]~=nil then error(("'%s' is reserved"):
format(tostring(index)),2)end local tasks=self._tasks local oldTask=tasks[index]
if oldTask==newTask then return end tasks[index]=newTask if oldTask then if
type(oldTask)=='function'then oldTask()elseif typeof(oldTask)==
'RBXScriptConnection'then oldTask:Disconnect()elseif oldTask.Destroy then
oldTask:Destroy()end end end function Maid:GiveTask(task)if not task then error(
'Task cannot be false or nil',2)end local taskId=#self._tasks+1 self[taskId]=
task if type(task)=='table'and not task.Destroy then warn(
'[Maid.GiveTask] - Gave table task without .Destroy\n\n'..debug.traceback())end
return taskId end function Maid:GivePromise(promise)if not promise:IsPending()
then return promise end local newPromise=promise.resolved(promise)local id=self:
GiveTask(newPromise)newPromise:Finally(function()self[id]=nil end)return
newPromise end function Maid:DoCleaning()local tasks=self._tasks for index,task
in pairs(tasks)do if typeof(task)=='RBXScriptConnection'then tasks[index]=nil
task:Disconnect()end end local index,task=next(tasks)while task~=nil do tasks[
index]=nil if type(task)=='function'then task()elseif typeof(task)==
'RBXScriptConnection'then task:Disconnect()elseif task.Destroy then task:
Destroy()end index,task=next(tasks)end end Maid.Destroy=Maid.DoCleaning return
Maid end function __DARKLUA_BUNDLE_MODULES.b()local v=__DARKLUA_BUNDLE_MODULES.
cache.b if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end
return v.c end end do local function __modImpl()local ScriptSignal={}
ScriptSignal.__index=ScriptSignal local ScriptConnection={}ScriptConnection.
__index=ScriptConnection function ScriptSignal.new()return setmetatable({_active
=true,_head=nil},ScriptSignal)end function ScriptSignal.Is(object)return typeof(
object)=='table'and getmetatable(object)==ScriptSignal end function ScriptSignal
:IsActive()return self._active==true end function ScriptSignal:Connect(handler)
assert(typeof(handler)=='function','Must be function')if self._active~=true then
return setmetatable({Connected=false,_node=nil},ScriptConnection)end local _head
=self._head local node={_signal=self,_connection=nil,_handler=handler,_next=
_head,_prev=nil}if _head~=nil then _head._prev=node end self._head=node local
connection=setmetatable({Connected=true,_node=node},ScriptConnection)node.
_connection=connection return connection end function ScriptSignal:Once(handler)
assert(typeof(handler)=='function','Must be function')local connection
connection=self:Connect(function(...)if connection==nil then return end
connection:Disconnect()connection=nil handler(...)end)return connection end
ScriptSignal.ConnectOnce=ScriptSignal.Once function ScriptSignal:Wait()local
thread do thread=coroutine.running()local connection connection=self:Connect(
function(...)if connection==nil then return end connection:Disconnect()
connection=nil if coroutine.status(thread)=='suspended'then task.spawn(thread,
...)end end)end return coroutine.yield()end function ScriptSignal:Fire(...)local
node=self._head while node~=nil do task.defer(node._handler,...)node=node._next
end end function ScriptSignal:DisconnectAll()local node=self._head while node~=
nil do local _connection=node._connection if _connection~=nil then _connection.
Connected=false _connection._node=nil node._connection=nil end node=node._next
end self._head=nil end function ScriptSignal:Destroy()if self._active~=true then
return end self:DisconnectAll()self._active=false end function ScriptConnection:
Disconnect()if self.Connected~=true then return end self.Connected=false local
_node=self._node local _prev=_node._prev local _next=_node._next if _next~=nil
then _next._prev=_prev end if _prev~=nil then _prev._next=_next else _node.
_signal._head=_next end _node._connection=nil self._node=nil end
ScriptConnection.Destroy=ScriptConnection.Disconnect return ScriptSignal end
function __DARKLUA_BUNDLE_MODULES.c()local v=__DARKLUA_BUNDLE_MODULES.cache.c if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c
end end do local function __modImpl()return nil end function
__DARKLUA_BUNDLE_MODULES.d()local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end
do local function __modImpl()local Players=game:GetService('Players')local
RunService=game:GetService('RunService')local Workspace=game:GetService(
'Workspace')local Maid=(__DARKLUA_BUNDLE_MODULES.b())local ExploitTypes=
__DARKLUA_BUNDLE_MODULES.d()local function getDrawingLib()local g=(getfenv(0))
local lib=g.Drawing if not lib and g.getgenv then lib=g.getgenv().Drawing end if
not lib then lib=rawget(_G,'Drawing')end return lib end local DRAWING=(
getDrawingLib())local DEFAULT_SETTINGS={isEspEnabled=false,shouldShowNames=true,
shouldShowWeapon=false,shouldShowDistance=false,shouldShowBoxes=true,
shouldShowSkeleton=false,shouldShowHealthbar=false,shouldShowHighlight=false,
shouldCheckTeam=false,maxDistance=2000,boxColor=Color3.new(1,1,1),textColor=
Color3.new(1,1,1),weaponColor=Color3.new(1,1,1),distanceColor=Color3.new(1,1,1),
skeletonColor=Color3.new(1,1,1),healthbarColor=Color3.new(0,1,0),
healthbarOutlineColor=Color3.new(0,0,0),nameOutlineColor=Color3.new(0,0,0),
weaponOutlineColor=Color3.new(0,0,0),distanceOutlineColor=Color3.new(0,0,0),
boxOutlineColor=Color3.new(0,0,0),skeletonOutlineColor=Color3.new(0,0,0),
highlightFill=Color3.new(1,0,0),highlightOutline=Color3.new(1,1,1),boxThickness=
1,skeletonThickness=1,textSize=12,shouldOutline=true}local R15_JOINTS={{'Head',
'UpperTorso'},{'UpperTorso','LowerTorso'},{'LowerTorso','LeftUpperLeg'},{
'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{'LowerTorso',
'RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg','RightFoot'}
,{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm',
'LeftHand'},{'UpperTorso','RightUpperArm'},{'RightUpperArm','RightLowerArm'},{
'RightLowerArm','RightHand'}}local Visuals={}Visuals.__index=Visuals local _maid
=nil local _state={client=nil,logger=nil,isEnabled=false,drawings={},highlights=
{},settings=table.clone(DEFAULT_SETTINGS)}local _signals={}local function
_getCamera()local camera=Workspace.CurrentCamera if not camera then camera=(
Workspace:WaitForChild('Camera'))end return camera end local function
_clearDrawings()for player,group in pairs(_state.drawings)do for _,drawing in
pairs(group)do if type(drawing)=='table'then for _,line in pairs(drawing)do line
:Remove()end else drawing:Remove()end end _state.drawings[player]=nil end end
local function _clearHighlights()for player,highlight in pairs(_state.highlights
)do if highlight~=nil then(highlight):Destroy()end _state.highlights[player]=nil
end end local function _clear()_clearDrawings()_clearHighlights()end
local function _removePlayer(player)local group=_state.drawings[player]if group
then for _,drawing in pairs(group)do if type(drawing)=='table'then for _,line in
pairs(drawing)do line:Remove()end else drawing:Remove()end end _state.drawings[
player]=nil end local highlight=_state.highlights[player]if highlight~=nil then(
highlight):Destroy()_state.highlights[player]=nil end end local function
_ensurePlayerDrawings(player)local existing=_state.drawings[player]if existing
then return existing end local group={name=DRAWING.new('Text'),weapon=DRAWING.
new('Text'),distance=DRAWING.new('Text'),boxOutline=DRAWING.new('Square'),box=
DRAWING.new('Square'),healthbarOutline=DRAWING.new('Square'),healthbar=DRAWING.
new('Square'),skeleton={},skeletonOutline={}}for _,key in ipairs({'name',
'weapon','distance'})do group[key].Center=true group[key].Outline=true group[key
].Visible=false end for _,key in ipairs({'box','boxOutline','healthbar',
'healthbarOutline'})do group[key].Visible=false group[key].Filled=false end
group.healthbar.Filled=true group.healthbarOutline.Filled=true for _=1,16 do
local line=DRAWING.new('Line')line.Visible=false table.insert(group.skeleton,
line)local outline=DRAWING.new('Line')outline.Visible=false table.insert(group.
skeletonOutline,outline)end _state.drawings[player]=group return group end
local function _updateHighlight(player,character)if not _state.settings.
shouldShowHighlight then local highlight=_state.highlights[player]if highlight
then highlight:Destroy()_state.highlights[player]=nil end return end local
highlight=_state.highlights[player]if not highlight then local created=Instance.
new('Highlight')created.Name='BlossomHighlight'created.FillTransparency=0.5
created.OutlineTransparency=0 created.Parent=game:GetService('CoreGui')_state.
highlights[player]=created highlight=created end if not highlight then return
end local activeHighlight=highlight local adornee=character if adornee:IsA(
'Model')then local rootPart=adornee:FindFirstChild('HumanoidRootPart')if
rootPart and rootPart:IsA('BasePart')then adornee=rootPart end end if
activeHighlight.Adornee~=adornee then activeHighlight.Adornee=adornee end
activeHighlight.FillColor=_state.settings.highlightFill activeHighlight.
OutlineColor=_state.settings.highlightOutline activeHighlight.Enabled=true end
local function _setGroupVisible(group,isVisible)for _,drawing in pairs(group)do
if type(drawing)=='table'then for _,line in pairs(drawing)do line.Visible=
isVisible end else drawing.Visible=isVisible end end end local function
_updateSkeleton(skeletonLines,skeletonOutlineLines,character)local camera=
_getCamera()local lineIndex=1 for _,pair in ipairs(R15_JOINTS)do local p1=
character:FindFirstChild(pair[1])local p2=character:FindFirstChild(pair[2])if p1
and p2 and p1:IsA('BasePart')and p2:IsA('BasePart')then local v1,o1=camera:
WorldToViewportPoint(p1.Position)local v2,o2=camera:WorldToViewportPoint(p2.
Position)if o1 and o2 then local outline=skeletonOutlineLines[lineIndex]if
outline then outline.From=Vector2.new(v1.X,v1.Y)outline.To=Vector2.new(v2.X,v2.Y
)outline.Color=_state.settings.skeletonOutlineColor outline.Thickness=_state.
settings.skeletonThickness+2 outline.Visible=true outline.ZIndex=1 end local
line=skeletonLines[lineIndex]if line then line.From=Vector2.new(v1.X,v1.Y)line.
To=Vector2.new(v2.X,v2.Y)line.Color=_state.settings.skeletonColor line.Thickness
=_state.settings.skeletonThickness line.Visible=true line.ZIndex=2 lineIndex+=1
end end end end for i=lineIndex,#skeletonLines do skeletonLines[i].Visible=false
end for i=lineIndex,#skeletonOutlineLines do skeletonOutlineLines[i].Visible=
false end end local function _render()if not _state.settings.isEspEnabled then
_clear()return end local camera=_getCamera()local localPlayer=Players.
LocalPlayer if not localPlayer then return end for _,player in ipairs(Players:
GetPlayers())do if player==localPlayer or(localPlayer.Character and player.
Character==localPlayer.Character)then continue end local character=player.
Character local humanoid=character and character:FindFirstChildOfClass(
'Humanoid')local root=character and character:FindFirstChild('HumanoidRootPart')
if not character or not root or not humanoid or humanoid.Health<=0 then
_removePlayer(player)continue end if _state.settings.shouldCheckTeam and player.
Team==localPlayer.Team then _removePlayer(player)continue end local group=
_ensurePlayerDrawings(player)local rootPart=root local distance=(rootPart.
Position-camera.CFrame.Position).Magnitude local _,onScreen=camera:
WorldToViewportPoint(rootPart.Position)if not onScreen or distance>_state.
settings.maxDistance then _setGroupVisible(group,false)local highlight=_state.
highlights[player]if highlight then highlight.Enabled=false end continue end
_updateHighlight(player,character)local rootPos=camera:WorldToViewportPoint(
rootPart.Position)local legPos=camera:WorldToViewportPoint(rootPart.Position-
Vector3.new(0,3,0))local headPos=camera:WorldToViewportPoint(rootPart.Position+
Vector3.new(0,2,0))local height=math.abs(headPos.Y-legPos.Y)*1.5 local width=
height*0.6 local boxPos=Vector2.new(rootPos.X-width/2,rootPos.Y-height/2)local
boxSize=Vector2.new(width,height)if _state.settings.shouldShowBoxes then group.
boxOutline.Size=boxSize group.boxOutline.Position=boxPos group.boxOutline.Color=
_state.settings.boxOutlineColor group.boxOutline.Thickness=_state.settings.
boxThickness+2 group.boxOutline.Visible=true group.boxOutline.ZIndex=1 group.box
.Size=boxSize group.box.Position=boxPos group.box.Color=_state.settings.boxColor
group.box.Thickness=_state.settings.boxThickness group.box.Visible=true group.
box.ZIndex=2 else group.box.Visible=false group.boxOutline.Visible=false end if
_state.settings.shouldShowHealthbar then local healthPerc=math.clamp(humanoid.
Health/humanoid.MaxHealth,0,1)local barHeight=height*healthPerc group.
healthbarOutline.Size=Vector2.new(4,height+2)group.healthbarOutline.Position=
Vector2.new(boxPos.X-6,boxPos.Y-1)group.healthbarOutline.Color=_state.settings.
healthbarOutlineColor group.healthbarOutline.Filled=true group.healthbarOutline.
Visible=true group.healthbarOutline.ZIndex=1 group.healthbar.Size=Vector2.new(2,
barHeight)group.healthbar.Position=Vector2.new(boxPos.X-5,boxPos.Y+(height-
barHeight))group.healthbar.Color=_state.settings.healthbarColor:Lerp(Color3.new(
1,0,0),1-healthPerc)group.healthbar.Filled=true group.healthbar.Visible=true
group.healthbar.ZIndex=2 else group.healthbar.Visible=false group.
healthbarOutline.Visible=false end local textOffset=0 if _state.settings.
shouldShowNames then group.name.Text=player.DisplayName or player.Name group.
name.Size=_state.settings.textSize group.name.Color=_state.settings.textColor
group.name.Outline=_state.settings.shouldOutline group.name.OutlineColor=_state.
settings.nameOutlineColor group.name.Position=Vector2.new(rootPos.X,boxPos.Y-
_state.settings.textSize-2)group.name.Visible=true else group.name.Visible=false
end if _state.settings.shouldShowWeapon then local tool=character:
FindFirstChildOfClass('Tool')if tool then group.weapon.Text=tool.Name group.
weapon.Size=_state.settings.textSize group.weapon.Color=_state.settings.
weaponColor group.weapon.Outline=_state.settings.shouldOutline group.weapon.
OutlineColor=_state.settings.weaponOutlineColor group.weapon.Position=Vector2.
new(rootPos.X,boxPos.Y+height+2+textOffset)group.weapon.Visible=true textOffset
+=_state.settings.textSize else group.weapon.Visible=false end else group.weapon
.Visible=false end if _state.settings.shouldShowDistance then group.distance.
Text=tostring(math.floor(distance))..' studs'group.distance.Size=_state.settings
.textSize group.distance.Color=_state.settings.distanceColor group.distance.
Outline=_state.settings.shouldOutline group.distance.OutlineColor=_state.
settings.distanceOutlineColor group.distance.Position=Vector2.new(rootPos.X,
boxPos.Y+height+2+textOffset)group.distance.Visible=true textOffset+=_state.
settings.textSize else group.distance.Visible=false end if _state.settings.
shouldShowSkeleton then _updateSkeleton(group.skeleton,group.skeletonOutline,
character)else for _,line in pairs(group.skeleton)do line.Visible=false end for
_,line in pairs(group.skeletonOutline)do line.Visible=false end end end end
local function _connect()_maid:DoCleaning()local removeConn=Players.
PlayerRemoving:Connect(function(player)_removePlayer(player)end)_maid:GiveTask(
removeConn)local renderConn=RunService.RenderStepped:Connect(function()_render()
end)_maid:GiveTask(renderConn)end local function _enable()if not DRAWING then
_state.logger:warn('Drawing API not available; Visuals disabled.')_state.
isEnabled=false return end _connect()end local function _disable()_maid:
DoCleaning()_clear()end function Visuals.init(self,client)_state.client=client
_state.logger=client.Logger _maid=Maid.new()end function Visuals.cleanup(self)
_state.isEnabled=false _disable()end function Visuals.toggle(self,isEnabled)if
_state.isEnabled==isEnabled then return end _state.isEnabled=isEnabled if
isEnabled then _enable()else _disable()end end function Visuals.setEspEnabled(
self,isEnabled)_state.settings.isEspEnabled=isEnabled if not isEnabled then
_clear()end end function Visuals.setShowNames(self,shouldShow)_state.settings.
shouldShowNames=shouldShow end function Visuals.setShowWeapon(self,shouldShow)
_state.settings.shouldShowWeapon=shouldShow end function Visuals.setShowDistance
(self,shouldShow)_state.settings.shouldShowDistance=shouldShow end function
Visuals.setShowBoxes(self,shouldShow)_state.settings.shouldShowBoxes=shouldShow
end function Visuals.setShowSkeleton(self,shouldShow)_state.settings.
shouldShowSkeleton=shouldShow end function Visuals.setShowHealthbar(self,
shouldShow)_state.settings.shouldShowHealthbar=shouldShow end function Visuals.
setShowHighlight(self,shouldShow)_state.settings.shouldShowHighlight=shouldShow
if not shouldShow then _clearHighlights()end end function Visuals.setTeamCheck(
self,isEnabled)_state.settings.shouldCheckTeam=isEnabled end function Visuals.
setMaxDistance(self,value)_state.settings.maxDistance=value end function Visuals
.setBoxColor(self,color)_state.settings.boxColor=color end function Visuals.
setTextColor(self,color)_state.settings.textColor=color end function Visuals.
setWeaponColor(self,color)_state.settings.weaponColor=color end function Visuals
.setDistanceColor(self,color)_state.settings.distanceColor=color end function
Visuals.setSkeletonColor(self,color)_state.settings.skeletonColor=color end
function Visuals.setHealthbarColor(self,color)_state.settings.healthbarColor=
color end function Visuals.setHealthbarOutlineColor(self,color)_state.settings.
healthbarOutlineColor=color end function Visuals.setNameOutlineColor(self,color)
_state.settings.nameOutlineColor=color end function Visuals.
setWeaponOutlineColor(self,color)_state.settings.weaponOutlineColor=color end
function Visuals.setDistanceOutlineColor(self,color)_state.settings.
distanceOutlineColor=color end function Visuals.setBoxOutlineColor(self,color)
_state.settings.boxOutlineColor=color end function Visuals.
setSkeletonOutlineColor(self,color)_state.settings.skeletonOutlineColor=color
end function Visuals.setHighlightFill(self,color)_state.settings.highlightFill=
color end function Visuals.setHighlightOutline(self,color)_state.settings.
highlightOutline=color end function Visuals.setBoxThickness(self,value)_state.
settings.boxThickness=value end function Visuals.setSkeletonThickness(self,value
)_state.settings.skeletonThickness=value end function Visuals.setTextSize(self,
value)_state.settings.textSize=value end function Visuals.setOutline(self,
isEnabled)_state.settings.shouldOutline=isEnabled end return Visuals end
function __DARKLUA_BUNDLE_MODULES.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c
end end do local function __modImpl()local Maid=(__DARKLUA_BUNDLE_MODULES.b())
local REPO_URL=
[[https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/]]local
Interface={}Interface.__index=Interface local _maid=nil local _state={client=nil
,logger=nil,library=nil,themeManager=nil,saveManager=nil,isMounted=false}local
_signals={}local function _httpGet(url)return(game):HttpGet(url)end
local function _loadRemote(path,logger)local source=_httpGet(REPO_URL..path)
local chunk,err=loadstring(source)if not chunk then if logger then logger:error(
'UI load failed:',err)end error('UI load failed: '..tostring(err))end return
chunk()end local function _setNotifyMuted(library,shouldMute)if shouldMute then
library.Notify=library.Notify or function()end library._blossomNotify=library.
_blossomNotify or library.Notify library.Notify=function()end return end if
library._blossomNotify then library.Notify=library._blossomNotify end end
local function _getLibraryVisible(library)if type(library.Opened)=='boolean'then
return library.Opened end if type(library.Visible)=='boolean'then return library
.Visible end if type(library.IsOpen)=='boolean'then return library.IsOpen end
return true end local function _runAutoload(library,saveManager,isSilent)local
wasVisible=_getLibraryVisible(library)if isSilent then _setNotifyMuted(library,
true)if wasVisible then pcall(function()library:Toggle()end)end end pcall(
function()saveManager:LoadAutoloadConfig()end)if isSilent then if wasVisible
then pcall(function()library:Toggle()end)end _setNotifyMuted(library,false)end
end local function _connect()_maid:DoCleaning()end local function _mount()if
_state.isMounted then return end _state.isMounted=true local logger=_state.
logger local library=_loadRemote('Library.lua',logger)local themeManager=
_loadRemote('addons/ThemeManager.lua',logger)local saveManager=_loadRemote(
'addons/SaveManager.lua',logger)_state.library=library _state.themeManager=
themeManager _state.saveManager=saveManager local window=library:CreateWindow({
Title='Blossom '.._state.client.Version,Center=true,AutoShow=not _state.client.
IsSilent,TabPadding=8,MenuFadeTime=0.2})local tabs={visuals=window:AddTab(
'Visuals'),misc=window:AddTab('Misc'),uiSettings=window:AddTab('UI Settings')}
local espGroup=tabs.visuals:AddLeftGroupbox('ESP')espGroup:AddToggle(
'VisualsToggle',{Text='Visuals (ESP)',Default=false,Callback=function(state)
local mod=_state.client.Modules.Visuals if mod and mod.toggle then mod:toggle(
state)if mod.setEspEnabled then mod:setEspEnabled(state)end end end}):
AddKeyPicker('EspKey',{Default='Insert',NoUI=true,Text='ESP Key'})espGroup:
AddToggle('ESPNames',{Text='Name',Default=true,Callback=function(state)local mod
=_state.client.Modules.Visuals if mod and mod.setShowNames then mod:
setShowNames(state)end end}):AddColorPicker('ESPTextColor',{Default=Color3.new(1
,1,1),Title='Text Color',Callback=function(value)local mod=_state.client.Modules
.Visuals if mod and mod.setTextColor then mod:setTextColor(value)end end}):
AddColorPicker('ESPNameOutlineColor',{Default=Color3.new(0,0,0),Title=
'Name Outline',Callback=function(value)local mod=_state.client.Modules.Visuals
if mod and mod.setNameOutlineColor then mod:setNameOutlineColor(value)end end})
espGroup:AddToggle('ESPWeapon',{Text='Weapon',Default=false,Callback=function(
state)local mod=_state.client.Modules.Visuals if mod and mod.setShowWeapon then
mod:setShowWeapon(state)end end}):AddColorPicker('ESPWeaponColor',{Default=
Color3.new(1,1,1),Title='Weapon Color',Callback=function(value)local mod=_state.
client.Modules.Visuals if mod and mod.setWeaponColor then mod:setWeaponColor(
value)end end}):AddColorPicker('ESPWeaponOutlineColor',{Default=Color3.new(0,0,0
),Title='Weapon Outline',Callback=function(value)local mod=_state.client.Modules
.Visuals if mod and mod.setWeaponOutlineColor then mod:setWeaponOutlineColor(
value)end end})espGroup:AddToggle('ESPDistance',{Text='Distance',Default=false,
Callback=function(state)local mod=_state.client.Modules.Visuals if mod and mod.
setShowDistance then mod:setShowDistance(state)end end}):AddColorPicker(
'ESPDistanceColor',{Default=Color3.new(1,1,1),Title='Distance Color',Callback=
function(value)local mod=_state.client.Modules.Visuals if mod and mod.
setDistanceColor then mod:setDistanceColor(value)end end}):AddColorPicker(
'ESPDistanceOutlineColor',{Default=Color3.new(0,0,0),Title='Distance Outline',
Callback=function(value)local mod=_state.client.Modules.Visuals if mod and mod.
setDistanceOutlineColor then mod:setDistanceOutlineColor(value)end end})espGroup
:AddToggle('ESPBoxes',{Text='Box',Default=true,Callback=function(state)local mod
=_state.client.Modules.Visuals if mod and mod.setShowBoxes then mod:
setShowBoxes(state)end end}):AddColorPicker('ESPBoxColor',{Default=Color3.new(1,
1,1),Title='Box Color',Callback=function(value)local mod=_state.client.Modules.
Visuals if mod and mod.setBoxColor then mod:setBoxColor(value)end end}):
AddColorPicker('ESPBoxOutlineColor',{Default=Color3.new(0,0,0),Title=
'Box Outline',Callback=function(value)local mod=_state.client.Modules.Visuals if
mod and mod.setBoxOutlineColor then mod:setBoxOutlineColor(value)end end})
espGroup:AddToggle('ESPSkeleton',{Text='Skeleton',Default=false,Callback=
function(state)local mod=_state.client.Modules.Visuals if mod and mod.
setShowSkeleton then mod:setShowSkeleton(state)end end}):AddColorPicker(
'ESPSkeletonColor',{Default=Color3.new(1,1,1),Title='Skeleton Color',Callback=
function(value)local mod=_state.client.Modules.Visuals if mod and mod.
setSkeletonColor then mod:setSkeletonColor(value)end end}):AddColorPicker(
'ESPSkeletonOutlineColor',{Default=Color3.new(0,0,0),Title='Skeleton Outline',
Callback=function(value)local mod=_state.client.Modules.Visuals if mod and mod.
setSkeletonOutlineColor then mod:setSkeletonOutlineColor(value)end end})espGroup
:AddToggle('ESPHealthbar',{Text='Healthbar',Default=false,Callback=function(
state)local mod=_state.client.Modules.Visuals if mod and mod.setShowHealthbar
then mod:setShowHealthbar(state)end end}):AddColorPicker('ESPHealthbarColor',{
Default=Color3.new(0,1,0),Title='Health Color',Callback=function(value)local mod
=_state.client.Modules.Visuals if mod and mod.setHealthbarColor then mod:
setHealthbarColor(value)end end}):AddColorPicker('ESPHealthbarOutlineColor',{
Default=Color3.new(0,0,0),Title='Outline Color',Callback=function(value)local
mod=_state.client.Modules.Visuals if mod and mod.setHealthbarOutlineColor then
mod:setHealthbarOutlineColor(value)end end})espGroup:AddToggle('ESPHighlight',{
Text='Highlight',Default=false,Callback=function(state)local mod=_state.client.
Modules.Visuals if mod and mod.setShowHighlight then mod:setShowHighlight(state)
end end}):AddColorPicker('ESPHighlightFill',{Default=Color3.new(1,0,0),Title=
'Fill Color',Callback=function(value)local mod=_state.client.Modules.Visuals if
mod and mod.setHighlightFill then mod:setHighlightFill(value)end end}):
AddColorPicker('ESPHighlightOutline',{Default=Color3.new(1,1,1),Title=
'Outline Color',Callback=function(value)local mod=_state.client.Modules.Visuals
if mod and mod.setHighlightOutline then mod:setHighlightOutline(value)end end})
espGroup:AddToggle('ESPBetterBounds',{Text='Better Bounds',Default=false,
Callback=function(_stateValue)end})espGroup:AddToggle('ESPShowTeammates',{Text=
'Show Teammates',Default=true,Callback=function(state)local mod=_state.client.
Modules.Visuals if mod and mod.setTeamCheck then mod:setTeamCheck(not state)end
end})espGroup:AddSlider('ESPSkeletonThickness',{Text='Skeleton Thickness',
Default=1,Min=1,Max=5,Rounding=1,Callback=function(value)local mod=_state.client
.Modules.Visuals if mod and mod.setSkeletonThickness then mod:
setSkeletonThickness(value)end end})espGroup:AddSlider('ESPTextSize',{Text=
'Text Size',Default=12,Min=10,Max=24,Rounding=0,Callback=function(value)local
mod=_state.client.Modules.Visuals if mod and mod.setTextSize then mod:
setTextSize(value)end end})espGroup:AddSlider('ESPMaxDistance',{Text=
'Max Distance',Default=2000,Min=100,Max=10000,Rounding=0,Callback=function(value
)local mod=_state.client.Modules.Visuals if mod and mod.setMaxDistance then mod:
setMaxDistance(value)end end})local menuGroup=tabs.uiSettings:AddLeftGroupbox(
'Menu')menuGroup:AddButton('Unload',function()library:Unload()end)menuGroup:
AddLabel('Menu bind'):AddKeyPicker('MenuKeybind',{Default='End',NoUI=true,Text=
'Menu keybind'})local GlobalOptions=(getgenv and getgenv().Options)or _G.Options
if GlobalOptions and GlobalOptions.MenuKeybind then library.ToggleKeybind=
GlobalOptions.MenuKeybind end themeManager:SetLibrary(library)saveManager:
SetLibrary(library)saveManager:IgnoreThemeSettings()themeManager:SetFolder(
'Blossom')saveManager:SetFolder('Blossom')saveManager:BuildConfigSection(tabs.
uiSettings)themeManager:ApplyToTab(tabs.uiSettings)local miscGroup=tabs.misc:
AddLeftGroupbox('Auto Load')miscGroup:AddToggle('TeleportQueue',{Text=
'Auto Load',Default=false,Callback=function(enabled)_state.client:
setTeleportQueue(enabled)end})miscGroup:AddToggle('SilentMode',{Text=
'Silent Mode',Default=false,Callback=function(enabled)_setNotifyMuted(library,
enabled)_state.client:setSilent(enabled)end})_runAutoload(library,saveManager,
false)logger:info('UI mounted successfully')end function Interface.init(self,
client)_state.client=client _state.logger=client.Logger _maid=Maid.new()
_connect()_mount()end function Interface.cleanup(self)_maid:DoCleaning()if
_state.library then _state.library:Unload()end _state.isMounted=false end return
Interface end function __DARKLUA_BUNDLE_MODULES.f()local v=
__DARKLUA_BUNDLE_MODULES.cache.f if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end end local
ReplicatedFirst=game:GetService('ReplicatedFirst')local Logger=
__DARKLUA_BUNDLE_MODULES.a()local Maid=__DARKLUA_BUNDLE_MODULES.b()local Signal=
__DARKLUA_BUNDLE_MODULES.c()local BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau]]
local MODULES={{name='Visuals',loader=(__DARKLUA_BUNDLE_MODULES.e())},{name=
'Interface',loader=(__DARKLUA_BUNDLE_MODULES.f())}}local Client={}Client.__index
=Client local _maid=Maid.new()local _state={isRunning=false,shouldTeleportQueue=
false,isSilent=(function()local g=(getfenv(0))return g.BlossomSilent or(g.
getgenv and g.getgenv().BlossomSilent)or false end)(),logger=nil}local _signals=
{started=Signal.new(),stopped=Signal.new()}local _modules={}local function
_disableAnalyticsPipeline(logger)local success,err=pcall(function()local
controller=ReplicatedFirst:FindFirstChild('AnalyticsPipelineController')if not
controller then controller=ReplicatedFirst:WaitForChild(
'AnalyticsPipelineController',10)end if controller then(controller).Disabled=
true logger:info('AnalyticsPipelineController Disabled')end end)if not success
then logger:warn('Failed to disable AnalyticsPipelineController:',err)end end
local function _getQueueOnTeleport()local env=(getfenv())return env.
queue_on_teleport or env.queueonteleport or(env.syn and env.syn.
queue_on_teleport)end local function _getClearTeleportQueue()local env=(getfenv(
))return env.clear_teleport_queue or env.clearteleportqueue or(env.syn and env.
syn.clear_teleport_queue)end local function _handleTeleportQueue(shouldEnable)if
shouldEnable then local queueOnTeleport=_getQueueOnTeleport()local
clearTeleportQueue=_getClearTeleportQueue()if clearTeleportQueue then
clearTeleportQueue()end if queueOnTeleport then _state.logger:info(
'Queueing auto-load script...')local silentFlag=_state.isSilent and
'getgenv().BlossomSilent = true; _G.BlossomSilent = true;'or''queueOnTeleport((
[[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):
format(silentFlag,BUNDLE_URL))else _state.logger:warn(
'queue_on_teleport function not found!')end else local clearTeleportQueue=
_getClearTeleportQueue()if clearTeleportQueue then _state.logger:info(
'Clearing teleport queue...')clearTeleportQueue()else _state.logger:warn(
'clear_teleport_queue function not found!')end end end local function _connect()
_maid:DoCleaning()if _state.shouldTeleportQueue then _handleTeleportQueue(true)
end end local function _getModuleInit(moduleResult)return moduleResult.init or
moduleResult.Init end local function _getModuleCleanup(moduleResult)return
moduleResult.cleanup or moduleResult.Cleanup end function Client.loadModule(self
,name,moduleOrPath)if _modules[name]then _state.logger:warn(
'Module already loaded:',name)return end local loader=function()if type(
moduleOrPath)=='string'then local dynamicRequire=require return dynamicRequire(
moduleOrPath)end return moduleOrPath end local success,result=pcall(loader)if
success then local moduleResult=result _modules[name]=moduleResult local initFn=
(_getModuleInit(moduleResult))if initFn then task.spawn(function()initFn(
moduleResult,self)end)end _state.logger:info('Loaded module:',name)else _state.
logger:warn('Failed to load module:',name,result)end end function Client.
setTeleportQueue(self,shouldEnable)_state.shouldTeleportQueue=shouldEnable if
_state.isRunning then _handleTeleportQueue(shouldEnable)end end function Client.
setSilent(self,isSilent)if _state.isSilent==isSilent then return end _state.
isSilent=isSilent if _state.shouldTeleportQueue and _state.isRunning then
_handleTeleportQueue(true)end end function Client.start(self)if _state.isRunning
then return end _state.isRunning=true _disableAnalyticsPipeline(_state.logger)
_state.logger:info('Client initializing...')for _,entry in ipairs(MODULES)do
self:loadModule(entry.name,entry.loader)end _connect()_signals.started:Fire()end
function Client.destroy(self)if not _state.isRunning then return end _state.
isRunning=false _signals.stopped:Fire()_maid:DoCleaning()for _,moduleResult in
pairs(_modules)do local cleanupFn=(_getModuleCleanup(moduleResult))if cleanupFn
then pcall(cleanupFn,moduleResult)end end _state.logger:info('Client stopped.')
end local loggerModule=(Logger)local client=((setmetatable({},Client)))client.
Version='1.0.0'client.Logger=loggerModule.new('Blossom')client.Modules=_modules
client.Started=_signals.started client.Stopped=_signals.stopped client.IsSilent=
_state.isSilent _state.logger=client.Logger return client:start()