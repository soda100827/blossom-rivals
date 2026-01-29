local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
RunService=game:GetService('RunService')local CoreGui=game:GetService('CoreGui')
local DEFAULT_SOURCE='System'local COLORS={Cyan='33, 161, 163',Green='0, 255, 0'
,Pink='255, 102, 153',White='255, 255, 255',Yellow='255, 215, 0',Red=
'220, 20, 60'}local Logger={}Logger.__index=Logger local function
_enableRichText()RunService.Heartbeat:Connect(function()pcall(function()local
devConsole=CoreGui:FindFirstChild('DevConsoleMaster')if devConsole then for _,
label in pairs(devConsole:GetDescendants())do if label:IsA('TextLabel')and not
label.RichText then label.RichText=true end end end end)end)end local function
formatMessage(level,source,...)local parts={...}for i,value in ipairs(parts)do
parts[i]=tostring(value)end local message=table.concat(parts,' ')local
levelColor=COLORS.White if level=='INFO'then levelColor=COLORS.White elseif
level=='SUCCESS'then levelColor=COLORS.Green elseif level=='WARN'then levelColor
=COLORS.Yellow elseif level=='ERROR'then levelColor=COLORS.Red end return string
.format(
[[<stroke color='#000000' thickness='1'><font color='rgb(%s)'><b>[%s]</b></font></stroke> <stroke color='#000000' thickness='1'><font color='rgb(%s)'><b>[%s]</b></font></stroke> <font color='rgb(%s)'>%s</font>]]
,levelColor,level,COLORS.Pink,source,COLORS.White,message)end function Logger.
new(source)local instance=setmetatable({source=source or DEFAULT_SOURCE},Logger)
return(instance)end function Logger.info(self,...)print(formatMessage('INFO',
self.source,...))end function Logger.success(self,...)print(formatMessage(
'SUCCESS',self.source,...))end function Logger.warn(self,...)warn(formatMessage(
'WARN',self.source,...))end function Logger.error(self,...)error(formatMessage(
'ERROR',self.source,...),0)end task.spawn(_enableRichText)return Logger end
function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.cache.a if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c
end end do local function __modImpl()local Maid={}Maid.ClassName='Maid'function
Maid.new()return setmetatable({_tasks={}},Maid)end function Maid.isMaid(value)
return type(value)=='table'and value.ClassName=='Maid'end function Maid:__index(
index)if Maid[index]then return Maid[index]else return self._tasks[index]end end
function Maid:__newindex(index,newTask)if Maid[index]~=nil then error((
"'%s' is reserved"):format(tostring(index)),2)end local tasks=self._tasks local
oldTask=tasks[index]if oldTask==newTask then return end tasks[index]=newTask if
oldTask then if type(oldTask)=='function'then oldTask()elseif typeof(oldTask)==
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
__DARKLUA_BUNDLE_MODULES.d()local function getDrawingLib()local getfenvAny=
getfenv local g=(getfenvAny(0))local lib=g.Drawing if not lib and g.getgenv then
lib=g.getgenv().Drawing end if not lib then lib=rawget(_G,'Drawing')end return
lib end local DEFAULT_SETTINGS={isEspEnabled=false,shouldShowNames=true,
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
{},settings=table.clone(DEFAULT_SETTINGS),overrideCheck=nil}local _signals={}
local function _getCamera()local camera=Workspace.CurrentCamera if not camera
then camera=(Workspace:WaitForChild('Camera'))end return camera end
local function _clearDrawings()for player,group in pairs(_state.drawings)do for
_,drawing in pairs(group)do if type(drawing)=='table'then for _,line in pairs(
drawing)do line:Remove()end else drawing:Remove()end end _state.drawings[player]
=nil end end local function _clearHighlights()for player,highlight in pairs(
_state.highlights)do if highlight~=nil then(highlight):Destroy()end _state.
highlights[player]=nil end end local function _clear()_clearDrawings()
_clearHighlights()end local function _removePlayer(player)local group=_state.
drawings[player]if group then for _,drawing in pairs(group)do if type(drawing)==
'table'then for _,line in pairs(drawing)do line:Remove()end else drawing:Remove(
)end end _state.drawings[player]=nil end local highlight=_state.highlights[
player]if highlight~=nil then(highlight):Destroy()_state.highlights[player]=nil
end end local function _ensurePlayerDrawings(player)local existing=_state.
drawings[player]if existing then return existing end local lib=getDrawingLib()if
not lib then return nil end local group={name=lib.new('Text'),weapon=lib.new(
'Text'),distance=lib.new('Text'),boxOutline=lib.new('Square'),box=lib.new(
'Square'),healthbarOutline=lib.new('Square'),healthbar=lib.new('Square'),
skeleton={},skeletonOutline={}}for _,key in ipairs({'name','weapon','distance'})
do group[key].Center=true group[key].Outline=true group[key].Visible=false end
for _,key in ipairs({'box','boxOutline','healthbar','healthbarOutline'})do group
[key].Visible=false group[key].Filled=false end group.healthbar.Filled=true
group.healthbarOutline.Filled=true for _=1,16 do local line=lib.new('Line')line.
Visible=false table.insert(group.skeleton,line)local outline=lib.new('Line')
outline.Visible=false table.insert(group.skeletonOutline,outline)end _state.
drawings[player]=group return group end local function _updateHighlight(player,
character)if not _state.settings.shouldShowHighlight then local highlight=_state
.highlights[player]if highlight then highlight:Destroy()_state.highlights[player
]=nil end return end local highlight=_state.highlights[player]if not highlight
then local created=Instance.new('Highlight')created.Name='BlossomHighlight'
created.FillTransparency=0.5 created.OutlineTransparency=0 created.Parent=game:
GetService('CoreGui')_state.highlights[player]=created highlight=created end if
not highlight then return end local activeHighlight=highlight local adornee=
character if adornee:IsA('Model')then local rootPart=adornee:FindFirstChild(
'HumanoidRootPart')if rootPart and rootPart:IsA('BasePart')then adornee=rootPart
end end if activeHighlight.Adornee~=adornee then activeHighlight.Adornee=adornee
end activeHighlight.FillColor=_state.settings.highlightFill activeHighlight.
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
_ensurePlayerDrawings(player)if not group then continue end local rootPart=root
local distance=(rootPart.Position-camera.CFrame.Position).Magnitude local _,
onScreen=camera:WorldToViewportPoint(rootPart.Position)if not onScreen or
distance>_state.settings.maxDistance then _setGroupVisible(group,false)local
highlight=_state.highlights[player]if highlight then highlight.Enabled=false end
continue end _updateHighlight(player,character)local rootPos=camera:
WorldToViewportPoint(rootPart.Position)local legPos=camera:WorldToViewportPoint(
rootPart.Position-Vector3.new(0,3,0))local headPos=camera:WorldToViewportPoint(
rootPart.Position+Vector3.new(0,2,0))local height=math.abs(headPos.Y-legPos.Y)*
1.5 local width=height*0.6 local boxPos=Vector2.new(rootPos.X-width/2,rootPos.Y-
height/2)local boxSize=Vector2.new(width,height)if _state.settings.
shouldShowBoxes then group.boxOutline.Size=boxSize group.boxOutline.Position=
boxPos group.boxOutline.Color=_state.settings.boxOutlineColor group.boxOutline.
Thickness=_state.settings.boxThickness+2 group.boxOutline.Visible=true group.
boxOutline.ZIndex=1 group.box.Size=boxSize group.box.Position=boxPos group.box.
Color=_state.settings.boxColor group.box.Thickness=_state.settings.boxThickness
group.box.Visible=true group.box.ZIndex=2 else group.box.Visible=false group.
boxOutline.Visible=false end if _state.settings.shouldShowHealthbar then local
healthPerc=math.clamp(humanoid.Health/humanoid.MaxHealth,0,1)local barHeight=
height*healthPerc group.healthbarOutline.Size=Vector2.new(4,height+2)group.
healthbarOutline.Position=Vector2.new(boxPos.X-6,boxPos.Y-1)group.
healthbarOutline.Color=_state.settings.healthbarOutlineColor group.
healthbarOutline.Filled=true group.healthbarOutline.Visible=true group.
healthbarOutline.ZIndex=1 group.healthbar.Size=Vector2.new(2,barHeight)group.
healthbar.Position=Vector2.new(boxPos.X-5,boxPos.Y+(height-barHeight))group.
healthbar.Color=_state.settings.healthbarColor:Lerp(Color3.new(1,0,0),1-
healthPerc)group.healthbar.Filled=true group.healthbar.Visible=true group.
healthbar.ZIndex=2 else group.healthbar.Visible=false group.healthbarOutline.
Visible=false end local textOffset=0 if _state.settings.shouldShowNames then
group.name.Text=player.DisplayName or player.Name group.name.Size=_state.
settings.textSize group.name.Color=_state.settings.textColor group.name.Outline=
_state.settings.shouldOutline group.name.OutlineColor=_state.settings.
nameOutlineColor group.name.Position=Vector2.new(rootPos.X,boxPos.Y-_state.
settings.textSize-2)group.name.Visible=true else group.name.Visible=false end if
_state.settings.shouldShowWeapon then local tool=character:
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
end)_maid:GiveTask(renderConn)end local function _enable()if not getDrawingLib()
then _state.isEnabled=false return end _connect()end local function _disable()
_maid:DoCleaning()_clear()end function Visuals.init(self,client)_state.client=
client _state.logger=client.Logger _maid=Maid.new()end function Visuals.cleanup(
self)_state.isEnabled=false _disable()end function Visuals.toggle(self,isEnabled
)if _state.isEnabled==isEnabled then return end _state.isEnabled=isEnabled if
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
isEnabled)_state.settings.shouldOutline=isEnabled end function Visuals.
setOverrideCheck(self,check)_state.overrideCheck=check end return Visuals end
function __DARKLUA_BUNDLE_MODULES.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c
end end do local function __modImpl()local Players=game:GetService('Players')
local RunService=game:GetService('RunService')local UserInputService=game:
GetService('UserInputService')local Workspace=game:GetService('Workspace')local
Maid=(__DARKLUA_BUNDLE_MODULES.b())local DEFAULT_FLY_SPEED=50 local INPUT_MAP={[
Enum.KeyCode.W]='forward',[Enum.KeyCode.S]='back',[Enum.KeyCode.A]='left',[Enum.
KeyCode.D]='right',[Enum.KeyCode.Space]='up',[Enum.KeyCode.LeftControl]='down'}
local Player={}Player.__index=Player local _maid=nil local _state={client=nil,
logger=nil,character=nil,humanoid=nil,rootPart=nil,isFlyEnabled=false,
isNoclipEnabled=false,isWalkSpeedEnabled=false,isJumpPowerEnabled=false,
walkSpeedValue=16,jumpPowerValue=50,flySpeed=DEFAULT_FLY_SPEED,defaultWalkSpeed=
nil,defaultJumpPower=nil,defaultJumpHeight=nil,defaultUseJumpPower=nil,
defaultAutoRotate=nil,defaultPlatformStand=nil,noclipParts={},characterMaid=nil,
input={forward=0,back=0,left=0,right=0,up=0,down=0}}local _signals={}
local function _getLocalPlayer()return Players.LocalPlayer end local function
_cacheDefaults(humanoid)_state.defaultWalkSpeed=humanoid.WalkSpeed _state.
defaultUseJumpPower=humanoid.UseJumpPower if humanoid.UseJumpPower then _state.
defaultJumpPower=humanoid.JumpPower _state.defaultJumpHeight=nil else _state.
defaultJumpPower=nil _state.defaultJumpHeight=humanoid.JumpHeight end _state.
defaultAutoRotate=humanoid.AutoRotate _state.defaultPlatformStand=humanoid.
PlatformStand end local function _applyWalkSpeed()local humanoid=_state.humanoid
if not humanoid then return end if _state.defaultWalkSpeed~=nil then humanoid.
WalkSpeed=_state.defaultWalkSpeed end end local function _applyJumpPower()return
end local function _restoreMovementDefaults()local humanoid=_state.humanoid if
not humanoid then return end if _state.defaultWalkSpeed~=nil then humanoid.
WalkSpeed=_state.defaultWalkSpeed end if _state.defaultUseJumpPower~=nil then
humanoid.UseJumpPower=_state.defaultUseJumpPower end if _state.
defaultUseJumpPower then if _state.defaultJumpPower~=nil then humanoid.JumpPower
=_state.defaultJumpPower end else if _state.defaultJumpHeight~=nil then humanoid
.JumpHeight=_state.defaultJumpHeight end end if _state.defaultAutoRotate~=nil
then humanoid.AutoRotate=_state.defaultAutoRotate end if _state.
defaultPlatformStand~=nil then humanoid.PlatformStand=_state.
defaultPlatformStand end end local function _setCharacter(character)_state.
character=character _state.humanoid=nil _state.rootPart=nil if not character
then return end local humanoid=character:FindFirstChildOfClass('Humanoid')if not
humanoid then humanoid=(character:WaitForChild('Humanoid',5))end local rootPart=
character:FindFirstChild('HumanoidRootPart')if not rootPart then rootPart=
character:WaitForChild('HumanoidRootPart',5)end if humanoid then _state.humanoid
=humanoid _cacheDefaults(humanoid)end if rootPart and rootPart:IsA('BasePart')
then _state.rootPart=rootPart end _applyWalkSpeed()_applyJumpPower()end
local function _applyNoclip()local character=_state.character if not character
then return end for _,part in ipairs(character:GetDescendants())do if part:IsA(
'BasePart')then if _state.noclipParts[part]==nil then _state.noclipParts[part]=
part.CanCollide end part.CanCollide=false end end end local function
_restoreNoclip()for part,original in pairs(_state.noclipParts)do if part and
part.Parent then part.CanCollide=original end end _state.noclipParts={}end
local function _applyFlyState()local humanoid=_state.humanoid if not humanoid
then return end if _state.isFlyEnabled then humanoid.PlatformStand=false
humanoid.AutoRotate=true else local rootPart=_state.rootPart if rootPart then
rootPart.AssemblyLinearVelocity=Vector3.zero rootPart.AssemblyAngularVelocity=
Vector3.zero end if _state.defaultPlatformStand~=nil then humanoid.PlatformStand
=_state.defaultPlatformStand end if _state.defaultAutoRotate~=nil then humanoid.
AutoRotate=_state.defaultAutoRotate end end end local function _getFlyMoveVector
()local camera=Workspace.CurrentCamera if not camera then return Vector3.zero
end local forward=camera.CFrame.LookVector local right=camera.CFrame.RightVector
local up=camera.CFrame.UpVector local move=forward*(_state.input.forward-_state.
input.back)+right*(_state.input.right-_state.input.left)+up*(_state.input.up-
_state.input.down)if move.Magnitude>1 then move=move.Unit end return move end
local function _onCharacterAdded(character)_state.input={forward=0,back=0,left=0
,right=0,up=0,down=0}_setCharacter(character)if _state.isFlyEnabled then
_applyFlyState()end if _state.isNoclipEnabled then _applyNoclip()end end
local function _onCharacterRemoving()_restoreNoclip()if _state.characterMaid
then _state.characterMaid:DoCleaning()_state.characterMaid=nil end _state.input=
{forward=0,back=0,left=0,right=0,up=0,down=0}_state.character=nil _state.
humanoid=nil _state.rootPart=nil end local function _onInputChanged(input,
isPressed)local keyName=INPUT_MAP[input.KeyCode]if not keyName then return end
_state.input[keyName]=isPressed and 1 or 0 end local function _bindPlayer(player
)local addedConn=player.CharacterAdded:Connect(function(character)
_onCharacterAdded(character)if _state.characterMaid then _state.characterMaid:
DoCleaning()end _state.characterMaid=Maid.new()local humanoid=_state.humanoid
local rootPart=_state.rootPart if humanoid and rootPart then local stateConn=
humanoid.StateChanged:Connect(function(_,newState)if not _state.
isJumpPowerEnabled then return end if newState==Enum.HumanoidStateType.Jumping
then local current=rootPart.AssemblyLinearVelocity local jumpVelocity=_state.
jumpPowerValue if current.Y<jumpVelocity then rootPart.AssemblyLinearVelocity=
Vector3.new(current.X,jumpVelocity,current.Z)end end end)_state.characterMaid:
GiveTask(stateConn)end end)_maid:GiveTask(addedConn)local removingConn=player.
CharacterRemoving:Connect(function()_onCharacterRemoving()end)_maid:GiveTask(
removingConn)if player.Character then _onCharacterAdded(player.Character)if
_state.characterMaid then _state.characterMaid:DoCleaning()end _state.
characterMaid=Maid.new()local humanoid=_state.humanoid local rootPart=_state.
rootPart if humanoid and rootPart then local stateConn=humanoid.StateChanged:
Connect(function(_,newState)if not _state.isJumpPowerEnabled then return end if
newState==Enum.HumanoidStateType.Jumping then local current=rootPart.
AssemblyLinearVelocity local jumpVelocity=_state.jumpPowerValue if current.Y<
jumpVelocity then rootPart.AssemblyLinearVelocity=Vector3.new(current.X,
jumpVelocity,current.Z)end end end)_state.characterMaid:GiveTask(stateConn)end
end end local function _connect()_maid:DoCleaning()local player=_getLocalPlayer(
)if player then _bindPlayer(player)else local playerAddedConn=Players.
PlayerAdded:Connect(function(addedPlayer)if addedPlayer==_getLocalPlayer()then
_bindPlayer(addedPlayer)end end)_maid:GiveTask(playerAddedConn)end local
inputBeganConn=UserInputService.InputBegan:Connect(function(input,processed)if
processed then return end _onInputChanged(input,true)end)_maid:GiveTask(
inputBeganConn)local inputEndedConn=UserInputService.InputEnded:Connect(function
(input,processed)if processed then return end _onInputChanged(input,false)end)
_maid:GiveTask(inputEndedConn)local renderConn=RunService.RenderStepped:Connect(
function()if not _state.isFlyEnabled then local rootPart=_state.rootPart local
humanoid=_state.humanoid if rootPart and humanoid and _state.isWalkSpeedEnabled
then local moveDir=humanoid.MoveDirection local horizontal=Vector3.new(moveDir.X
,0,moveDir.Z)if horizontal.Magnitude>0 then horizontal=horizontal.Unit*_state.
walkSpeedValue end local current=rootPart.AssemblyLinearVelocity rootPart.
AssemblyLinearVelocity=Vector3.new(horizontal.X,current.Y,horizontal.Z)end
return end local rootPart=_state.rootPart if not rootPart then return end local
move=_getFlyMoveVector()rootPart.AssemblyLinearVelocity=move*_state.flySpeed
rootPart.AssemblyAngularVelocity=Vector3.zero local camera=Workspace.
CurrentCamera if camera then local look=Vector3.new(camera.CFrame.LookVector.X,0
,camera.CFrame.LookVector.Z)if look.Magnitude>0.001 then rootPart.CFrame=CFrame.
new(rootPart.Position,rootPart.Position+look)end end end)_maid:GiveTask(
renderConn)local steppedConn=RunService.Stepped:Connect(function()if _state.
isNoclipEnabled then _applyNoclip()end end)_maid:GiveTask(steppedConn)end
function Player.init(self,client)_state.client=client _state.logger=client.
Logger _maid=Maid.new()_connect()end function Player.cleanup(self)_state.
isFlyEnabled=false _state.isNoclipEnabled=false _state.isWalkSpeedEnabled=false
_state.isJumpPowerEnabled=false _restoreNoclip()_restoreMovementDefaults()if
_maid then _maid:DoCleaning()end end function Player.setFlyEnabled(self,
isEnabled)if _state.isFlyEnabled==isEnabled then return end _state.isFlyEnabled=
isEnabled _applyFlyState()end function Player.setNoclipEnabled(self,isEnabled)if
_state.isNoclipEnabled==isEnabled then return end _state.isNoclipEnabled=
isEnabled if not isEnabled then _restoreNoclip()else _applyNoclip()end end
function Player.setWalkSpeedEnabled(self,isEnabled)if _state.isWalkSpeedEnabled
==isEnabled then return end _state.isWalkSpeedEnabled=isEnabled _applyWalkSpeed(
)end function Player.setJumpPowerEnabled(self,isEnabled)if _state.
isJumpPowerEnabled==isEnabled then return end _state.isJumpPowerEnabled=
isEnabled _applyJumpPower()end function Player.setWalkSpeed(self,value)_state.
walkSpeedValue=value _applyWalkSpeed()end function Player.setJumpPower(self,
value)_state.jumpPowerValue=value _applyJumpPower()end function Player.
setFlySpeed(self,value)_state.flySpeed=value end return Player end function
__DARKLUA_BUNDLE_MODULES.f()local v=__DARKLUA_BUNDLE_MODULES.cache.f if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end
do local function __modImpl()local Players=game:GetService('Players')local
Workspace=game:GetService('Workspace')local RunService=game:GetService(
'RunService')local UserInputService=game:GetService('UserInputService')local
Maid=(__DARKLUA_BUNDLE_MODULES.b())local CONSTANTS={FOV_CIRCLE_COLOR=Color3.
fromRGB(255,255,255),FOV_CIRCLE_THICKNESS=1,FOV_CIRCLE_NUM_SIDES=64,
MIN_AIM_SPEED=4,MAX_AIM_SPEED=40,MAX_SMOOTHNESS=1,TARGET_DROP_DELAY=0.15,
TARGET_DROP_FOV_MULTIPLIER=1.2,AIMBOT_RENDER_STEP_NAME='CombatAimbot'}local
Combat={}Combat.__index=Combat local _maid=nil local _state={client=nil,logger=
nil,isAimbotEnabled=false,isFovEnabled=false,fovRadius=100,fovColor=CONSTANTS.
FOV_CIRCLE_COLOR,fovTransparency=0,isTeamCheckEnabled=false,isWallCheckEnabled=
false,smoothness=0,target=nil,targetLostAt=nil,fovCircle=nil,cameraController=
nil,isInputLocked=false,mouseBehavior=nil,mouseDeltaSensitivity=nil}local
_lastLogTime=0 local function _throttleLog(...)if os.clock()-_lastLogTime>2 then
_state.logger:info(...)_lastLogTime=os.clock()end end local function _getCamera(
)local camera=Workspace.CurrentCamera if not camera then camera=(Workspace:
WaitForChild('Camera'))end return camera end local function _getLocalPlayer()
return Players.LocalPlayer end local function _getDrawingLib()local getfenvAny=
getfenv local g=(getfenvAny(0))local lib=g.Drawing if not lib and g.getgenv then
lib=g.getgenv().Drawing end if not lib then lib=rawget(_G,'Drawing')end return
lib end local function _applyInputLock(isLocked)if isLocked and _state.
smoothness<CONSTANTS.MAX_SMOOTHNESS then return end if isLocked==_state.
isInputLocked then return end if isLocked then if _state.mouseBehavior==nil then
_state.mouseBehavior=UserInputService.MouseBehavior end if _state.
mouseDeltaSensitivity==nil then _state.mouseDeltaSensitivity=UserInputService.
MouseDeltaSensitivity end UserInputService.MouseBehavior=Enum.MouseBehavior.
LockCenter UserInputService.MouseDeltaSensitivity=0 else local restoreBehavior=
_state.mouseBehavior or Enum.MouseBehavior.Default local restoreSensitivity=
_state.mouseDeltaSensitivity or 1 UserInputService.MouseBehavior=restoreBehavior
UserInputService.MouseDeltaSensitivity=restoreSensitivity _state.mouseBehavior=
nil _state.mouseDeltaSensitivity=nil end _state.isInputLocked=isLocked end
local function _isMaxSmoothness()return _state.smoothness>=CONSTANTS.
MAX_SMOOTHNESS end local function _fetchCameraController(logger)if _state.
cameraController then return end if logger then logger:info('Fetching start...')
end local playerScripts=_getLocalPlayer():WaitForChild('PlayerScripts')if not
playerScripts then return end local controllers=playerScripts:WaitForChild(
'Controllers')if not controllers then return end local camControllerScript=
controllers:WaitForChild('CameraController')if camControllerScript and
camControllerScript:IsA('ModuleScript')then local success,result=pcall(function(
)return require(camControllerScript)end)if success then _state.cameraController=
result if logger then logger:info('Success CameraController')end else if logger
then logger:error('Failed CameraController',result)end end end end
local function _updateFovCircle()local lib=_getDrawingLib()if not lib then
return end local circle=_state.fovCircle if _state.isFovEnabled then if not
circle then circle=lib.new('Circle')_state.fovCircle=circle end local c=circle c
.Thickness=CONSTANTS.FOV_CIRCLE_THICKNESS c.NumSides=CONSTANTS.
FOV_CIRCLE_NUM_SIDES c.Filled=false c.Color=_state.fovColor c.Transparency=math.
clamp(_state.fovTransparency,0,1)local mouseLocation=UserInputService:
GetMouseLocation()c.Position=mouseLocation c.Radius=_state.fovRadius c.Visible=
true else local c=circle if c then c.Visible=false end end end local function
_getTargetState(player)local camera=_getCamera()local localPlayer=
_getLocalPlayer()if player==localPlayer then return false,nil,false,math.huge
end if _state.isTeamCheckEnabled and player.Team==localPlayer.Team then return
false,nil,false,math.huge end local character=player.Character if not character
then return false,nil,false,math.huge end local humanoid=character:
FindFirstChildOfClass('Humanoid')if not humanoid or humanoid.Health<=0 then
return false,nil,false,math.huge end local head=character:FindFirstChild('Head')
if not head or not head:IsA('BasePart')then return false,nil,false,math.huge end
local headPart=head if _state.isWallCheckEnabled then local origin=camera.CFrame
.Position local direction=headPart.Position-origin local raycastParams=
RaycastParams.new()raycastParams.FilterDescendantsInstances={localPlayer.
Character,character}raycastParams.FilterType=Enum.RaycastFilterType.Exclude
local result=Workspace:Raycast(origin,direction,raycastParams)if result then
return false,nil,false,math.huge end end local screenPos,onScreen=camera:
WorldToViewportPoint(headPart.Position)if not onScreen then return true,headPart
,false,math.huge end local mouseLocation=UserInputService:GetMouseLocation()
local distance=(Vector2.new(screenPos.X,screenPos.Y)-mouseLocation).Magnitude
return true,headPart,true,distance end local function _getBestTarget()local
localPlayer=_getLocalPlayer()local bestTarget=nil local shortestDistance=_state.
fovRadius for _,player in ipairs(Players:GetPlayers())do if player==localPlayer
then continue end local isValid,headPart,onScreen,distance=_getTargetState(
player)if not isValid or not headPart or not onScreen then continue end if
distance>_state.fovRadius then continue end if distance<shortestDistance then
shortestDistance=distance bestTarget=player end end return bestTarget end
local function _resolveTarget()if _state.target then local dropRadius=_state.
fovRadius*CONSTANTS.TARGET_DROP_FOV_MULTIPLIER local isValid,headPart,onScreen,
distance=_getTargetState(_state.target)if isValid and headPart and onScreen and
distance<=dropRadius then _state.targetLostAt=nil return _state.target end if
not isValid or not headPart then _state.targetLostAt=nil _state.target=nil else
local now=os.clock()if not _state.targetLostAt then _state.targetLostAt=now end
if now-_state.targetLostAt<CONSTANTS.TARGET_DROP_DELAY then return _state.target
end _state.targetLostAt=nil _state.target=nil end end local newTarget=
_getBestTarget()_state.target=newTarget return newTarget end local function
_aimAt(target,deltaTime)if not target.Character then return end local head=
target.Character:FindFirstChild('Head')if not head or not head:IsA('BasePart')
then return end local camera=_getCamera()local targetPos=(head).Position local
currentCFrame=camera.CFrame local lookAtCFrame=CFrame.lookAt(currentCFrame.
Position,targetPos)if not _state.cameraController or not _state.cameraController
.SetRotation then local alpha=1 if not _isMaxSmoothness()then local speed=
CONSTANTS.MIN_AIM_SPEED+(1-_state.smoothness)*(CONSTANTS.MAX_AIM_SPEED-CONSTANTS
.MIN_AIM_SPEED)alpha=1-math.exp(-speed*deltaTime)end camera.CFrame=currentCFrame
:Lerp(lookAtCFrame,alpha)return end local x,y,_=lookAtCFrame:ToOrientation()
local targetRotation=Vector2.new(x,y)_throttleLog('Aiming...',targetRotation)if
_isMaxSmoothness()then _state.cameraController:SetRotation(targetRotation)elseif
_state.smoothness>0 then local currentRot=(_state.cameraController.Rotation)
local speed=CONSTANTS.MIN_AIM_SPEED+(1-_state.smoothness)*(CONSTANTS.
MAX_AIM_SPEED-CONSTANTS.MIN_AIM_SPEED)local alpha=1-math.exp(-speed*deltaTime)
local newRot=currentRot:Lerp(targetRotation,alpha)_state.cameraController:
SetRotation(newRot)else _state.cameraController:SetRotation(targetRotation)end
end local function _connect()_maid:DoCleaning()task.spawn(function()
_fetchCameraController(_state.logger)end)RunService:BindToRenderStep(CONSTANTS.
AIMBOT_RENDER_STEP_NAME,Enum.RenderPriority.Camera.Value+1,function(deltaTime)
_updateFovCircle()_throttleLog('Aimbot Status | Enabled:',_state.isAimbotEnabled
)if _state.isAimbotEnabled then local target=_resolveTarget()if target then
_applyInputLock(true)_state.logger:info('Target found:',target.Name)_aimAt(
target,deltaTime)else _applyInputLock(false)end else _state.target=nil
_applyInputLock(false)end end)_maid:GiveTask(function()RunService:
UnbindFromRenderStep(CONSTANTS.AIMBOT_RENDER_STEP_NAME)end)end local function
_disconnect()if _state.fovCircle then pcall(function()((_state.fovCircle)):
Remove()end)_state.fovCircle=nil end _state.target=nil _state.targetLostAt=nil
_applyInputLock(false)_maid:DoCleaning()end function Combat.init(self,client)
_state.client=client _state.logger=client.Logger _maid=Maid.new()_connect()end
function Combat.cleanup(self)_state.isAimbotEnabled=false _disconnect()end
function Combat.setAimbotEnabled(self,isEnabled)if _state.isAimbotEnabled==
isEnabled then return end _state.logger:info('Set Aimbot Enabled:',isEnabled)
_state.isAimbotEnabled=isEnabled if not isEnabled then _state.target=nil _state.
targetLostAt=nil _applyInputLock(false)end end function Combat.setFovEnabled(
self,isEnabled)_state.isFovEnabled=isEnabled end function Combat.setFovRadius(
self,radius)_state.fovRadius=radius end function Combat.setFovColor(self,color)
_state.fovColor=color end function Combat.setFovTransparency(self,transparency)
_state.fovTransparency=math.clamp(transparency,0,1)end function Combat.
setTeamCheckEnabled(self,isEnabled)_state.isTeamCheckEnabled=isEnabled end
function Combat.setSmoothness(self,smoothness)local wasMaxSmoothness=
_isMaxSmoothness()_state.smoothness=math.clamp(smoothness,0,CONSTANTS.
MAX_SMOOTHNESS)if wasMaxSmoothness and not _isMaxSmoothness()then
_applyInputLock(false)end end function Combat.setWallCheckEnabled(self,isEnabled
)_state.isWallCheckEnabled=isEnabled end return Combat end function
__DARKLUA_BUNDLE_MODULES.g()local v=__DARKLUA_BUNDLE_MODULES.cache.g if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end
do local function __modImpl()local Players=game:GetService('Players')local
ReplicatedStorage=game:GetService('ReplicatedStorage')local HttpService=game:
GetService('HttpService')local Maid=(__DARKLUA_BUNDLE_MODULES.b())local
SAVE_FOLDER='unlockall'local SAVE_FILE='unlockall/config.json'local UnlockAll={}
UnlockAll.__index=UnlockAll local _maid=nil local _state={client=nil,logger=nil,
isActive=false,player=nil,controllers=nil,enumLibrary=nil,cosmeticLibrary=nil,
itemLibrary=nil,dataController=nil,fighterController=nil,equipped={},favorites={
},constructingWeapon=nil,viewingProfile=nil,lastUsedWeapon=nil,originals={}}
local _signals={}local function _getEnv()local getfenvAny=getfenv local env=(
getfenvAny(0))local genv=(env.getgenv and env.getgenv())or env return env,genv
end local function _cloneCosmetic(name,cosmeticType,options)local
cosmeticLibrary=_state.cosmeticLibrary if not cosmeticLibrary then return nil
end local base=cosmeticLibrary.Cosmetics[name]if not base then return nil end
local data={}for key,value in pairs(base)do data[key]=value end data.Name=name
data.Type=data.Type or cosmeticType data.Seed=data.Seed or math.random(1,1000000
)local enumLibrary=_state.enumLibrary if enumLibrary then local success,enumId=
pcall(enumLibrary.ToEnum,enumLibrary,name)if success and enumId then data.Enum=
enumId data.ObjectID=data.ObjectID or enumId end end if options then if options.
inverted~=nil then data.Inverted=options.inverted end if options.favoritesOnly~=
nil then data.OnlyUseFavorites=options.favoritesOnly end end return data end
local function _saveConfig()local env,genv=_getEnv()local writefile=(genv.
writefile or env.writefile)local makefolder=(genv.makefolder or env.makefolder)
if not writefile then return end pcall(function()local config={equipped={},
favorites=_state.favorites}for weapon,cosmetics in pairs(_state.equipped)do
config.equipped[weapon]={}for cosmeticType,cosmeticData in pairs(cosmetics)do if
cosmeticData and cosmeticData.Name then config.equipped[weapon][cosmeticType]={
name=cosmeticData.Name,seed=cosmeticData.Seed,inverted=cosmeticData.Inverted}end
end end if makefolder then makefolder(SAVE_FOLDER)end writefile(SAVE_FILE,
HttpService:JSONEncode(config))end)end local function _loadConfig()local env,
genv=_getEnv()local readfile=(genv.readfile or env.readfile)local isfile=(genv.
isfile or env.isfile)if not readfile or not isfile or not isfile(SAVE_FILE)then
return end pcall(function()local config=HttpService:JSONDecode(readfile(
SAVE_FILE))if config.equipped then for weapon,cosmetics in pairs(config.equipped
)do _state.equipped[weapon]={}for cosmeticType,cosmeticData in pairs(cosmetics)
do local cloned=_cloneCosmetic(cosmeticData.name,cosmeticType,{inverted=
cosmeticData.inverted})if cloned then cloned.Seed=cosmeticData.seed _state.
equipped[weapon][cosmeticType]=cloned end end end end _state.favorites=config.
favorites or{}end)end local function _patchCosmeticLibrary()local
cosmeticLibrary=_state.cosmeticLibrary if not cosmeticLibrary then return end
cosmeticLibrary.OwnsCosmeticNormally=function()return true end cosmeticLibrary.
OwnsCosmeticUniversally=function()return true end cosmeticLibrary.
OwnsCosmeticForWeapon=function()return true end if not _state.originals.
ownsCosmetic then _state.originals.ownsCosmetic=cosmeticLibrary.OwnsCosmetic end
local originalOwnsCosmetic=_state.originals.ownsCosmetic cosmeticLibrary.
OwnsCosmetic=function(self,inventory,name,weapon)if name:find('MISSING_')and
originalOwnsCosmetic then return originalOwnsCosmetic(self,inventory,name,weapon
)end return true end end local function _patchDataController()local
dataController=_state.dataController if not dataController then return end if
not _state.originals.dataGet then _state.originals.dataGet=dataController.Get
end if not _state.originals.dataGetWeaponData then _state.originals.
dataGetWeaponData=dataController.GetWeaponData end local originalGet=_state.
originals.dataGet local originalGetWeaponData=_state.originals.dataGetWeaponData
dataController.Get=function(self,key)local data=originalGet(self,key)if key==
'CosmeticInventory'then local proxy={}if data then for k,v in pairs(data)do
proxy[k]=v end end return setmetatable(proxy,{__index=function()return true end}
)end if key=='FavoritedCosmetics'then local result=data and table.clone(data)or{
}for weapon,favs in pairs(_state.favorites)do result[weapon]=result[weapon]or{}
for name,isFav in pairs(favs)do result[weapon][name]=isFav end end return result
end return data end dataController.GetWeaponData=function(self,weaponName)local
data=originalGetWeaponData(self,weaponName)if not data then return nil end local
merged={}for key,value in pairs(data)do merged[key]=value end merged.Name=
weaponName if _state.equipped[weaponName]then for cosmeticType,cosmeticData in
pairs(_state.equipped[weaponName])do merged[cosmeticType]=cosmeticData end end
return merged end end local function _hookNamecall()local env,genv=_getEnv()
local hookmetamethod=(genv.hookmetamethod or env.hookmetamethod)local
getnamecallmethod=(genv.getnamecallmethod or env.getnamecallmethod)if not
hookmetamethod or not getnamecallmethod then return end if _state.originals.
namecall then return end local remotes=ReplicatedStorage:FindFirstChild(
'Remotes')local dataRemotes=remotes and remotes:FindFirstChild('Data')local
equipRemote=dataRemotes and dataRemotes:FindFirstChild('EquipCosmetic')local
favoriteRemote=dataRemotes and dataRemotes:FindFirstChild('FavoriteCosmetic')
local replicationRemotes=remotes and remotes:FindFirstChild('Replication')local
fighterRemotes=replicationRemotes and replicationRemotes:FindFirstChild(
'Fighter')local useItemRemote=fighterRemotes and fighterRemotes:FindFirstChild(
'UseItem')if not equipRemote then return end local oldNamecall oldNamecall=
hookmetamethod(game,'__namecall',function(self,...)if getnamecallmethod()~=
'FireServer'then return oldNamecall(self,...)end local args={...}if
useItemRemote and self==useItemRemote then local objectID=args[1]local
fighterController=_state.fighterController local player=_state.player if
fighterController and player then pcall(function()local fighter=
fighterController:GetFighter(player)if fighter and fighter.Items then for _,item
in pairs(fighter.Items)do if item:Get('ObjectID')==objectID then _state.
lastUsedWeapon=item.Name break end end end end)end end if self==equipRemote then
local weaponName=args[1]local cosmeticType=args[2]local cosmeticName=args[3]
local options=args[4]or{}if cosmeticName and cosmeticName~='None'and
cosmeticName~=''then local inventory=_state.dataController and _state.
dataController:Get('CosmeticInventory')if inventory and rawget(inventory,
cosmeticName)then return oldNamecall(self,...)end end _state.equipped[weaponName
]=_state.equipped[weaponName]or{}if not cosmeticName or cosmeticName=='None'or
cosmeticName==''then _state.equipped[weaponName][cosmeticType]=nil if not next(
_state.equipped[weaponName])then _state.equipped[weaponName]=nil end else local
cloned=_cloneCosmetic(cosmeticName,cosmeticType,{inverted=options.IsInverted,
favoritesOnly=options.OnlyUseFavorites})if cloned then _state.equipped[
weaponName][cosmeticType]=cloned end end task.defer(function()pcall(function()
_state.dataController.CurrentData:Replicate('WeaponInventory')end)task.wait(0.2)
_saveConfig()end)return end if self==favoriteRemote then _state.favorites[args[1
] ]=_state.favorites[args[1] ]or{}_state.favorites[args[1] ][args[2] ]=args[3]or
nil _saveConfig()task.spawn(function()pcall(function()_state.dataController.
CurrentData:Replicate('FavoritedCosmetics')end)end)return end return
oldNamecall(self,...)end)_state.originals.namecall=oldNamecall end
local function _patchClientItem()local player=_state.player if not player then
return end local success,clientItem=pcall(function()return require(player.
PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)end)if
not success or not clientItem or not clientItem._CreateViewModel then return end
if _state.originals.createViewModel then return end _state.originals.
createViewModel=clientItem._CreateViewModel clientItem._CreateViewModel=function
(self,viewmodelRef)local weaponName=self.Name local weaponPlayer=self.
ClientFighter and self.ClientFighter.Player _state.constructingWeapon=(
weaponPlayer==player)and weaponName or nil local hasSkin=_state.equipped[
weaponName]and _state.equipped[weaponName].Skin if weaponPlayer==player and
hasSkin and viewmodelRef then local dataKey=self:ToEnum('Data')local skinKey=
self:ToEnum('Skin')local nameKey=self:ToEnum('Name')if viewmodelRef[dataKey]then
viewmodelRef[dataKey][skinKey]=_state.equipped[weaponName].Skin viewmodelRef[
dataKey][nameKey]=_state.equipped[weaponName].Skin.Name elseif viewmodelRef.Data
then viewmodelRef.Data.Skin=_state.equipped[weaponName].Skin viewmodelRef.Data.
Name=_state.equipped[weaponName].Skin.Name end end local result=_state.originals
.createViewModel(self,viewmodelRef)_state.constructingWeapon=nil return result
end end local function _patchClientViewModel()local player=_state.player if not
player then return end local viewModelModule=player.PlayerScripts.Modules.
ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild(
'ClientViewModel')if not viewModelModule then return end local clientViewModel=
require(viewModelModule)if clientViewModel.GetWrap and not _state.originals.
getWrap then _state.originals.getWrap=clientViewModel.GetWrap clientViewModel.
GetWrap=function(self)local weaponName=self.ClientItem and self.ClientItem.Name
local weaponPlayer=self.ClientItem and self.ClientItem.ClientFighter and self.
ClientItem.ClientFighter.Player if weaponName and weaponPlayer==player and
_state.equipped[weaponName]and _state.equipped[weaponName].Wrap then return
_state.equipped[weaponName].Wrap end return _state.originals.getWrap(self)end
end if not _state.originals.viewModelNew then _state.originals.viewModelNew=
clientViewModel.new clientViewModel.new=function(replicatedData,clientItem)local
weaponPlayer=clientItem.ClientFighter and clientItem.ClientFighter.Player local
weaponName=_state.constructingWeapon or clientItem.Name if weaponPlayer==player
and _state.equipped[weaponName]then local replicatedClass=require(
ReplicatedStorage.Modules.ReplicatedClass)local dataKey=replicatedClass:ToEnum(
'Data')replicatedData[dataKey]=replicatedData[dataKey]or{}local cosmetics=_state
.equipped[weaponName]if cosmetics.Skin then replicatedData[dataKey][
replicatedClass:ToEnum('Skin')]=cosmetics.Skin end if cosmetics.Wrap then
replicatedData[dataKey][replicatedClass:ToEnum('Wrap')]=cosmetics.Wrap end if
cosmetics.Charm then replicatedData[dataKey][replicatedClass:ToEnum('Charm')]=
cosmetics.Charm end end local result=_state.originals.viewModelNew(
replicatedData,clientItem)local hasWrap=_state.equipped[weaponName]and _state.
equipped[weaponName].Wrap if weaponPlayer==player and hasWrap and result.
_UpdateWrap then result:_UpdateWrap()task.delay(0.1,function()if not result.
_destroyed then result:_UpdateWrap()end end)end return result end end end
local function _patchItemLibrary()local itemLibrary=_state.itemLibrary if not
itemLibrary or _state.originals.getViewModelImage then return end _state.
originals.getViewModelImage=itemLibrary.GetViewModelImageFromWeaponData
itemLibrary.GetViewModelImageFromWeaponData=function(self,weaponData,highRes)if
not weaponData then return _state.originals.getViewModelImage(self,weaponData,
highRes)end local weaponName=weaponData.Name local shouldShowSkin=false if
weaponData.Skin and _state.equipped[weaponName]then shouldShowSkin=weaponData.
Skin==_state.equipped[weaponName].Skin elseif _state.viewingProfile==_state.
player and _state.equipped[weaponName]then shouldShowSkin=_state.equipped[
weaponName].Skin~=nil end if shouldShowSkin and _state.equipped[weaponName]and
_state.equipped[weaponName].Skin then local skinInfo=self.ViewModels[_state.
equipped[weaponName].Skin.Name]if skinInfo then return skinInfo[highRes and
'ImageHighResolution'or'Image']or skinInfo.Image end end return _state.originals
.getViewModelImage(self,weaponData,highRes)end end local function
_patchViewProfile()local player=_state.player if not player then return end
local success,viewProfile=pcall(function()return require(player.PlayerScripts.
Modules.Pages.ViewProfile)end)if not success or not viewProfile or not
viewProfile.Fetch then return end if _state.originals.viewProfileFetch then
return end _state.originals.viewProfileFetch=viewProfile.Fetch viewProfile.Fetch
=function(self,targetPlayer)_state.viewingProfile=targetPlayer return _state.
originals.viewProfileFetch(self,targetPlayer)end end local function
_patchClientEntity()local player=_state.player if not player then return end
local success,clientEntity=pcall(function()return require(player.PlayerScripts.
Modules.ClientReplicatedClasses.ClientEntity)end)if not success or not
clientEntity or not clientEntity.ReplicateFromServer then return end if _state.
originals.replicateFromServer then return end _state.originals.
replicateFromServer=clientEntity.ReplicateFromServer clientEntity.
ReplicateFromServer=function(self,action,...)if action=='FinisherEffect'then
local args={...}local killerName=args[3]local decodedKiller=killerName if type(
killerName)=='userdata'and _state.enumLibrary and _state.enumLibrary.FromEnum
then local ok,decoded=pcall(_state.enumLibrary.FromEnum,_state.enumLibrary,
killerName)if ok and decoded then decodedKiller=decoded end end local isOurKill=
tostring(decodedKiller)==player.Name or tostring(decodedKiller):lower()==player.
Name:lower()local isFinisherEquipped=_state.lastUsedWeapon and _state.equipped[
_state.lastUsedWeapon]and _state.equipped[_state.lastUsedWeapon].Finisher if
isOurKill and isFinisherEquipped then local finisherData=_state.equipped[_state.
lastUsedWeapon].Finisher local finisherEnum=finisherData.Enum if not
finisherEnum and _state.enumLibrary then local ok,result=pcall(_state.
enumLibrary.ToEnum,_state.enumLibrary,finisherData.Name)if ok and result then
finisherEnum=result end end if finisherEnum then args[1]=finisherEnum return
_state.originals.replicateFromServer(self,action,table.unpack(args))end end end
return _state.originals.replicateFromServer(self,action,...)end end
local function _connect()_maid:DoCleaning()end function UnlockAll.init(self,
client)_state.client=client _state.logger=client.Logger _maid=Maid.new()
_connect()end function UnlockAll.cleanup(self)if _maid then _maid:DoCleaning()
end _state.isActive=false end function UnlockAll.run(self)if _state.isActive
then return end _state.isActive=true local player=Players.LocalPlayer if not
player then _state.logger:warn('UnlockAll: LocalPlayer missing.')_state.isActive
=false return end _state.player=player local playerScripts=player:WaitForChild(
'PlayerScripts')local controllers=playerScripts:WaitForChild('Controllers')
_state.controllers=controllers local enumLibrary=require(ReplicatedStorage.
Modules:WaitForChild('EnumLibrary',10))if enumLibrary then enumLibrary:
WaitForEnumBuilder()end _state.enumLibrary=enumLibrary _state.cosmeticLibrary=
require(ReplicatedStorage.Modules:WaitForChild('CosmeticLibrary',10))_state.
itemLibrary=require(ReplicatedStorage.Modules:WaitForChild('ItemLibrary',10))
_state.dataController=require(controllers:WaitForChild('PlayerDataController',10
))if not _state.dataController then _state.logger:warn(
'UnlockAll: DataController missing.')_state.isActive=false return end pcall(
function()_state.fighterController=require(controllers:WaitForChild(
'FighterController',10))end)_patchCosmeticLibrary()_patchDataController()
_hookNamecall()_patchClientItem()_patchClientViewModel()_patchItemLibrary()
_patchViewProfile()_patchClientEntity()_loadConfig()end return UnlockAll end
function __DARKLUA_BUNDLE_MODULES.h()local v=__DARKLUA_BUNDLE_MODULES.cache.h if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c
end end do local function __modImpl()local RunService=game:GetService(
'RunService')local Maid=(__DARKLUA_BUNDLE_MODULES.b())local REPO_URL=
[[https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/]]local
Interface={}Interface.__index=Interface local _maid=nil local _state={client=nil
,logger=nil,library=nil,themeManager=nil,saveManager=nil,isMounted=false,
controlBindings=nil}local _signals={}local function _updateControlBindings()if
not _state.controlBindings then return end local getfenvAny=getfenv local env=(
getfenvAny(0))local getgenvFunc=env.getgenv local toggles=(getgenvFunc and
getgenvFunc().Toggles)or _G.Toggles local options=(getgenvFunc and getgenvFunc()
.Options)or _G.Options if not toggles or not options then end for _,control in
ipairs(_state.controlBindings)do local toggle=toggles and toggles[control.
toggleId]local gate=toggle and toggle.Value==true local active=false if gate
then local keybind=options and options[control.keybindId]if keybind and keybind.
GetState then active=keybind:GetState()else active=false end end if control.last
~=active then control.last=active control.setter(active)end end end
local function _httpGet(url)return(game):HttpGet(url)end local function
_loadRemote(path,logger)local source=_httpGet(REPO_URL..path)local chunk,err=
loadstring(source)if not chunk then if logger then logger:error(
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
end local function _connect()_maid:DoCleaning()local updateConn=RunService.
RenderStepped:Connect(function()_updateControlBindings()end)_maid:GiveTask(
updateConn)end local function _mount()if _state.isMounted then return end _state
.isMounted=true local logger=_state.logger local library=_loadRemote(
'Library.lua',logger)local themeManager=_loadRemote('addons/ThemeManager.lua',
logger)local saveManager=_loadRemote('addons/SaveManager.lua',logger)_state.
library=library _state.themeManager=themeManager _state.saveManager=saveManager
local window=library:CreateWindow({Title='Blossom '.._state.client.Version,
Center=true,AutoShow=not _state.client.IsSilent,TabPadding=8,MenuFadeTime=0.2})
local tabs={combat=window:AddTab('Combat'),visuals=window:AddTab('Visuals'),misc
=window:AddTab('Misc'),uiSettings=window:AddTab('UI Settings')}local combatGroup
=tabs.combat:AddLeftGroupbox('Aimbot')local combatAimbotToggle=combatGroup:
AddToggle('CombatAimbotEnabled',{Text='Enabled',Default=false,Callback=function(
)_updateControlBindings()end})local combatAimbotKeybind=combatAimbotToggle:
AddKeyPicker('CombatAimbotKeybind',{Default='MouseButton2',NoUI=false,Text=
'Trigger Key',SyncToggleState=false,Callback=function()_updateControlBindings()
end})combatAimbotKeybind:AddColorPicker('CombatFovColor',{Default=Color3.
fromRGB(255,255,255),Transparency=0,Title='FOV Color',Callback=function(color,
transparency)local mod=_state.client.Modules.Combat if mod and mod.setFovColor
then mod:setFovColor(color)end if mod and mod.setFovTransparency then mod:
setFovTransparency(transparency or 0)end end})combatGroup:AddToggle(
'CombatShowFov',{Text='Show FOV',Default=false,Callback=function(state)local mod
=_state.client.Modules.Combat if mod and mod.setFovEnabled then mod:
setFovEnabled(state)end end})combatGroup:AddSlider('CombatFovRadius',{Text=
'FOV Radius',Default=100,Min=10,Max=800,Rounding=0,Callback=function(value)local
mod=_state.client.Modules.Combat if mod and mod.setFovRadius then mod:
setFovRadius(value)end end})combatGroup:AddToggle('CombatTeamCheck',{Text=
'Team Check',Default=false,Callback=function(state)local mod=_state.client.
Modules.Combat if mod and mod.setTeamCheckEnabled then mod:setTeamCheckEnabled(
state)end end})combatGroup:AddSlider('CombatSmoothness',{Text='Smoothness',
Default=0,Min=0,Max=1,Rounding=2,Callback=function(value)local mod=_state.client
.Modules.Combat if mod and mod.setSmoothness then mod:setSmoothness(value)end
end})combatGroup:AddToggle('CombatWallCheck',{Text='Wall Check',Default=false,
Callback=function(state)local mod=_state.client.Modules.Combat if mod and mod.
setWallCheckEnabled then mod:setWallCheckEnabled(state)end end})local espGroup=
tabs.visuals:AddLeftGroupbox('ESP')espGroup:AddToggle('VisualsToggle',{Text=
'Visuals (ESP)',Default=false,Callback=function(state)local mod=_state.client.
Modules.Visuals if mod and mod.toggle then mod:toggle(state)end if mod and mod.
setEspEnabled then mod:setEspEnabled(state)end end})espGroup:AddToggle(
'ESPNames',{Text='Name',Default=true,Callback=function(state)local mod=_state.
client.Modules.Visuals if mod and mod.setShowNames then mod:setShowNames(state)
end end}):AddColorPicker('ESPTextColor',{Default=Color3.new(1,1,1),Title=
'Text Color',Callback=function(value)local mod=_state.client.Modules.Visuals if
mod and mod.setTextColor then mod:setTextColor(value)end end}):AddColorPicker(
'ESPNameOutlineColor',{Default=Color3.new(0,0,0),Title='Name Outline',Callback=
function(value)local mod=_state.client.Modules.Visuals if mod and mod.
setNameOutlineColor then mod:setNameOutlineColor(value)end end})espGroup:
AddToggle('ESPWeapon',{Text='Weapon',Default=false,Callback=function(state)local
mod=_state.client.Modules.Visuals if mod and mod.setShowWeapon then mod:
setShowWeapon(state)end end}):AddColorPicker('ESPWeaponColor',{Default=Color3.
new(1,1,1),Title='Weapon Color',Callback=function(value)local mod=_state.client.
Modules.Visuals if mod and mod.setWeaponColor then mod:setWeaponColor(value)end
end}):AddColorPicker('ESPWeaponOutlineColor',{Default=Color3.new(0,0,0),Title=
'Weapon Outline',Callback=function(value)local mod=_state.client.Modules.Visuals
if mod and mod.setWeaponOutlineColor then mod:setWeaponOutlineColor(value)end
end})espGroup:AddToggle('ESPDistance',{Text='Distance',Default=false,Callback=
function(state)local mod=_state.client.Modules.Visuals if mod and mod.
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
'Menu keybind'})local getfenvAny=getfenv local env=(getfenvAny(0))local
getgenvFunc=env.getgenv local GlobalOptions=(getgenvFunc and getgenvFunc().
Options)or _G.Options if GlobalOptions and GlobalOptions.MenuKeybind then
library.ToggleKeybind=GlobalOptions.MenuKeybind end themeManager:SetLibrary(
library)saveManager:SetLibrary(library)saveManager:IgnoreThemeSettings()
themeManager:SetFolder('Blossom')saveManager:SetFolder('Blossom')saveManager:
BuildConfigSection(tabs.uiSettings)themeManager:ApplyToTab(tabs.uiSettings)local
playerGroup=tabs.misc:AddLeftGroupbox('Player')local playerFlyToggle=playerGroup
:AddToggle('PlayerFly',{Text='Fly',Default=false,Callback=function(state)
_updateControlBindings()end})playerFlyToggle:AddKeyPicker('PlayerFlyKeybind',{
Default='F',NoUI=false,Text='Fly Keybind',SyncToggleState=false,Callback=
function()_updateControlBindings()end})playerGroup:AddSlider('PlayerFlySpeed',{
Text='Fly Speed',Default=50,Min=5,Max=200,Rounding=0,Callback=function(value)
local mod=_state.client.Modules.Player if mod and mod.setFlySpeed then mod:
setFlySpeed(value)end end})local playerNoclipToggle=playerGroup:AddToggle(
'PlayerNoclip',{Text='Noclip',Default=false,Callback=function(state)
_updateControlBindings()end})playerNoclipToggle:AddKeyPicker(
'PlayerNoclipKeybind',{Default='N',NoUI=false,Text='Noclip Keybind',
SyncToggleState=false,Callback=function()_updateControlBindings()end})local
playerWalkSpeedToggle=playerGroup:AddToggle('PlayerWalkSpeedEnabled',{Text=
'Walk Speed',Default=false,Callback=function(state)_updateControlBindings()end})
playerWalkSpeedToggle:AddKeyPicker('PlayerWalkSpeedKeybind',{Default='T',NoUI=
false,Text='Walk Speed Keybind',SyncToggleState=false,Callback=function()
_updateControlBindings()end})playerGroup:AddSlider('PlayerWalkSpeed',{Text=
'Walk Speed',Default=16,Min=0,Max=200,Rounding=0,Callback=function(value)local
mod=_state.client.Modules.Player if mod and mod.setWalkSpeed then mod:
setWalkSpeed(value)end end})local playerJumpPowerToggle=playerGroup:AddToggle(
'PlayerJumpPowerEnabled',{Text='Jump Power',Default=false,Callback=function(
state)_updateControlBindings()end})playerJumpPowerToggle:AddKeyPicker(
'PlayerJumpPowerKeybind',{Default='Y',NoUI=false,Text='Jump Power Keybind',
SyncToggleState=false,Callback=function()_updateControlBindings()end})
playerGroup:AddSlider('PlayerJumpPower',{Text='Jump Power',Default=50,Min=0,Max=
200,Rounding=0,Callback=function(value)local mod=_state.client.Modules.Player if
mod and mod.setJumpPower then mod:setJumpPower(value)end end})_state.
controlBindings={{toggleId='CombatAimbotEnabled',keybindId='CombatAimbotKeybind'
,last=nil,setter=function(active)local mod=_state.client.Modules.Combat if mod
and mod.setAimbotEnabled then mod:setAimbotEnabled(active)end end},{toggleId=
'PlayerFly',keybindId='PlayerFlyKeybind',last=nil,setter=function(active)local
mod=_state.client.Modules.Player if mod and mod.setFlyEnabled then mod:
setFlyEnabled(active)end end},{toggleId='PlayerNoclip',keybindId=
'PlayerNoclipKeybind',last=nil,setter=function(active)local mod=_state.client.
Modules.Player if mod and mod.setNoclipEnabled then mod:setNoclipEnabled(active)
end end},{toggleId='PlayerWalkSpeedEnabled',keybindId='PlayerWalkSpeedKeybind',
last=nil,setter=function(active)local mod=_state.client.Modules.Player if mod
and mod.setWalkSpeedEnabled then mod:setWalkSpeedEnabled(active)end end},{
toggleId='PlayerJumpPowerEnabled',keybindId='PlayerJumpPowerKeybind',last=nil,
setter=function(active)local mod=_state.client.Modules.Player if mod and mod.
setJumpPowerEnabled then mod:setJumpPowerEnabled(active)end end}}
_updateControlBindings()local miscGroup=tabs.misc:AddLeftGroupbox('Auto Load')
miscGroup:AddToggle('TeleportQueue',{Text='Auto Load',Default=false,Callback=
function(enabled)_state.client:setTeleportQueue(enabled)end})miscGroup:
AddToggle('SilentMode',{Text='Silent Mode',Default=false,Callback=function(
enabled)_setNotifyMuted(library,enabled)_state.client:setSilent(enabled)end})
local unlockGroup=tabs.misc:AddLeftGroupbox('Unlock All')unlockGroup:AddButton(
'Unlock All',function()local mod=_state.client.Modules.UnlockAll if mod and mod.
run then mod:run()end end)_runAutoload(library,saveManager,false)end function
Interface.init(self,client)_state.client=client _state.logger=client.Logger
_maid=Maid.new()_connect()_mount()end function Interface.cleanup(self)_maid:
DoCleaning()if _state.library then _state.library:Unload()end _state.isMounted=
false end return Interface end function __DARKLUA_BUNDLE_MODULES.i()local v=
__DARKLUA_BUNDLE_MODULES.cache.i if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.i=v end return v.c end end end local
ReplicatedFirst=game:GetService('ReplicatedFirst')local Players=game:GetService(
'Players')local RunService=game:GetService('RunService')local Logger=
__DARKLUA_BUNDLE_MODULES.a()local Maid=__DARKLUA_BUNDLE_MODULES.b()local Signal=
__DARKLUA_BUNDLE_MODULES.c()local BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau]]
local CLIENT_MODULE_NAME='Client'local getfenvAny=getfenv local env=(getfenvAny(
0))local genv=(env.getgenv and env.getgenv())or env local function getGlobal(k)
return genv[k]or env[k]end local queue_on_teleport=getGlobal('queue_on_teleport'
)or getGlobal('queueonteleport')or(env.syn and env.syn.queue_on_teleport)local
clear_teleport_queue=getGlobal('clear_teleport_queue')or getGlobal(
'clearteleportqueue')or(env.syn and env.syn.clear_teleport_queue)local
getloadedmodules=getGlobal('getloadedmodules')or function()return nil end local
MODULES={{name='Visuals',loader=(__DARKLUA_BUNDLE_MODULES.e())},{name='Player',
loader=(__DARKLUA_BUNDLE_MODULES.f())},{name='Combat',loader=(
__DARKLUA_BUNDLE_MODULES.g())},{name='UnlockAll',loader=(
__DARKLUA_BUNDLE_MODULES.h())},{name='Interface',loader=(
__DARKLUA_BUNDLE_MODULES.i())}}local Client={}Client.__index=Client local _maid=
Maid.new()local _state={isRunning=false,shouldTeleportQueue=false,isSilent=genv.
BlossomSilent or env.BlossomSilent or false,logger=nil}local _signals={started=
Signal.new(),stopped=Signal.new()}local _modules={}local function
_disableAnalyticsPipeline(logger)pcall(function()local controller=
ReplicatedFirst:FindFirstChild('AnalyticsPipelineController')if not controller
then controller=ReplicatedFirst:WaitForChild('AnalyticsPipelineController',10)
end if controller then(controller).Disabled=true logger:info(
'AnalyticsPipelineController \u{be44}\u{d65c}\u{c131}\u{d654}\u{b428}.')end end)
end local function _handleTeleportQueue(shouldEnable)if shouldEnable then if
clear_teleport_queue then clear_teleport_queue()end if queue_on_teleport then
local silentFlag=_state.isSilent and
'getgenv().BlossomSilent = true; _G.BlossomSilent = true;'or''queue_on_teleport(
([[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):
format(silentFlag,BUNDLE_URL))end else if clear_teleport_queue then
clear_teleport_queue()end end end local function _connect()_maid:DoCleaning()if
_state.shouldTeleportQueue then _handleTeleportQueue(true)end end local function
_waitForClientLoaded()_state.logger:info(
'Rivals\u{c758} Client\u{b85c}\u{b4dc}\u{b97c} \u{ae30}\u{b2e4}\u{b9ac}\u{b294}\u{c911}.'
)local localPlayer=Players.LocalPlayer while not localPlayer do RunService.
Heartbeat:Wait()localPlayer=Players.LocalPlayer end local playerScripts=
localPlayer:WaitForChild('PlayerScripts')local clientModule repeat clientModule=
playerScripts:FindFirstChild(CLIENT_MODULE_NAME)if not(clientModule and
clientModule:IsA('ModuleScript'))then clientModule=nil task.wait(1)end until
clientModule local controllersFolder repeat controllersFolder=playerScripts:
FindFirstChild('Controllers')if not controllersFolder then task.wait(1)end until
controllersFolder local folder=controllersFolder local function isModuleLoaded(
mod)local loaded=getloadedmodules()if not loaded then return true end for _,v in
ipairs(loaded)do if v==mod then return true end end return false end while true
do local allLoaded=true if getloadedmodules()and not isModuleLoaded(clientModule
)then allLoaded=false else for _,child in ipairs(folder:GetChildren())do if
child:IsA('ModuleScript')then if getloadedmodules()and not isModuleLoaded(child)
then allLoaded=false break end end end end if allLoaded then break end task.
wait(0.5)end end function Client.loadModule(self,name,moduleOrPath)if _modules[
name]then return end local loader=function()if type(moduleOrPath)=='string'then
local dynamicRequire=require return dynamicRequire(moduleOrPath)end return
moduleOrPath end local success,result=pcall(loader)if success then local
moduleResult=result _modules[name]=moduleResult local initFn=moduleResult.init
or moduleResult.Init if initFn then task.spawn(function()(initFn)(moduleResult,
self)end)end else _state.logger:warn('Failed to load module:',name,result)end
end function Client.setTeleportQueue(self,shouldEnable)_state.
shouldTeleportQueue=shouldEnable if _state.isRunning then _handleTeleportQueue(
shouldEnable)end end function Client.setSilent(self,isSilent)if _state.isSilent
==isSilent then return end _state.isSilent=isSilent if _state.
shouldTeleportQueue and _state.isRunning then _handleTeleportQueue(true)end end
function Client.start(self)if _state.isRunning then return end _state.isRunning=
true _disableAnalyticsPipeline(_state.logger)_state.logger:info(
'Blossom \u{cd08}\u{ae30}\u{d654} \u{c2dc}\u{c791}\u{b428}.')
_waitForClientLoaded()for _,entry in ipairs(MODULES)do self:loadModule(entry.
name,entry.loader)end _connect()_signals.started:Fire()_state.logger:success(
'Blossom \u{b85c}\u{b4dc} \u{c644}\u{b8cc}.')end function Client.destroy(self)if
not _state.isRunning then return end _state.isRunning=false _signals.stopped:
Fire()_maid:DoCleaning()for _,moduleResult in pairs(_modules)do local cleanupFn=
moduleResult.cleanup or moduleResult.Cleanup if cleanupFn then pcall(cleanupFn,
moduleResult)end end end local loggerModule=(Logger)local client=((setmetatable(
{},Client)))client.Version='1.0.0'client.Logger=loggerModule.new('Blossom')
client.Modules=_modules client.Started=_signals.started client.Stopped=_signals.
stopped client.IsSilent=_state.isSilent _state.logger=client.Logger return
client:start()