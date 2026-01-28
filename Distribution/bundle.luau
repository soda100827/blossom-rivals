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
then _state.logger:warn('Drawing API not available; Visuals disabled.')_state.
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
RunService=game:GetService('RunService')local UserInputService=game:GetService(
'UserInputService')local Workspace=game:GetService('Workspace')local Maid=(
__DARKLUA_BUNDLE_MODULES.b())local AIMBOT_RENDER_STEP='BlossomAimbot'local
AIMBOT_RENDER_PRIORITY=Enum.RenderPriority.Last.Value local MAX_SMOOTHNESS=100
local MIN_SMOOTHNESS=1 local FOV_CIRCLE_SIDES=100 local Aimbot={}Aimbot.__index=
Aimbot local _maid=nil local _state={client=nil,settings={isEnabled=false,
shouldTeamCheck=true,shouldAliveCheck=true,shouldWallCheck=true,shouldShowFov=
false,fovRadius=100,fovColor=Color3.fromRGB(255,255,255),smoothness=1,targetPart
='Head',isDebug=false},target=nil,lockedTarget=nil,fovCircle=nil,
defaultAutoRotate=nil,hasAutoRotateOverride=false,defaultMouseSensitivity=nil,
hasMouseSensitivityOverride=false,cameraController=nil}local _signals={}
local function _getMouseLocation()return UserInputService:GetMouseLocation()end
local function _getScreenCenter()local camera=Workspace.CurrentCamera if not
camera then return _getMouseLocation()end local viewport=camera.ViewportSize
return Vector2.new(viewport.X/2,viewport.Y/2)end local function
_getAimScreenPosition(isAiming)if isAiming then return _getScreenCenter()end
return _getMouseLocation()end local function _getLocalHumanoid()local
localPlayer=Players.LocalPlayer if not localPlayer then return nil end local
character=localPlayer.Character if not character then return nil end local
humanoid=character:FindFirstChildOfClass('Humanoid')if humanoid and humanoid:
IsA('Humanoid')then return humanoid end return nil end local function
_getLocalRootPart()local localPlayer=Players.LocalPlayer if not localPlayer then
return nil end local character=localPlayer.Character if not character then
return nil end local rootPart=character:FindFirstChild('HumanoidRootPart')if
rootPart and rootPart:IsA('BasePart')then return rootPart end return nil end
local function _getCameraController()if _state.cameraController then return
_state.cameraController end local localPlayer=Players.LocalPlayer if not
localPlayer then return nil end local playerScripts=localPlayer:FindFirstChild(
'PlayerScripts')if not playerScripts then return nil end local controllers=
playerScripts:FindFirstChild('Controllers')if not controllers then return nil
end local cameraModule=controllers:FindFirstChild('CameraController')if not
cameraModule or not cameraModule:IsA('ModuleScript')then return nil end local
success,result=pcall(function()return require(cameraModule)end)if not success
then return nil end _state.cameraController=result return result end
local function _setAutoRotateOverride(shouldDisable)local humanoid=
_getLocalHumanoid()if not humanoid then return end if shouldDisable then if not
_state.hasAutoRotateOverride then _state.defaultAutoRotate=humanoid.AutoRotate
_state.hasAutoRotateOverride=true end humanoid.AutoRotate=false return end if
_state.hasAutoRotateOverride then humanoid.AutoRotate=_state.defaultAutoRotate==
nil and true or _state.defaultAutoRotate _state.hasAutoRotateOverride=false end
end local function _setMouseSensitivityOverride(shouldDisable)if shouldDisable
then if not _state.hasMouseSensitivityOverride then _state.
defaultMouseSensitivity=UserInputService.MouseDeltaSensitivity _state.
hasMouseSensitivityOverride=true end UserInputService.MouseDeltaSensitivity=0
return end if _state.hasMouseSensitivityOverride then if _state.
defaultMouseSensitivity~=nil then UserInputService.MouseDeltaSensitivity=_state.
defaultMouseSensitivity end _state.hasMouseSensitivityOverride=false end end
local function _isOnScreen(position)local camera=Workspace.CurrentCamera if not
camera then return false,Vector2.zero end local screenPos,onScreen=camera:
WorldToViewportPoint(position)return onScreen,Vector2.new(screenPos.X,screenPos.
Y)end local function _isVisible(targetPart,origin)local params=RaycastParams.
new()if Players.LocalPlayer and Players.LocalPlayer.Character then params.
FilterDescendantsInstances={Players.LocalPlayer.Character,Workspace.
CurrentCamera}else params.FilterDescendantsInstances={Workspace.CurrentCamera}
end params.FilterType=Enum.RaycastFilterType.Exclude params.IgnoreWater=true
local direction=targetPart.Position-origin local result=Workspace:Raycast(origin
,direction,params)if result then return result.Instance:IsDescendantOf((
targetPart.Parent))end return true end local function _getBestTarget(
aimScreenPos)local camera=Workspace.CurrentCamera local localPlayer=Players.
LocalPlayer if not camera or not localPlayer then return nil end local
bestTarget=nil local closestDistance=_state.settings.fovRadius for _,player in
ipairs(Players:GetPlayers())do if player==localPlayer then continue end if
_state.settings.shouldTeamCheck and player.Team==localPlayer.Team then continue
end local character=player.Character if not character then continue end local
humanoid=character:FindFirstChild('Humanoid')if _state.settings.shouldAliveCheck
then if not humanoid or not humanoid:IsA('Humanoid')or humanoid.Health<=0 then
continue end end local targetPart=character:FindFirstChild(_state.settings.
targetPart)if not targetPart or not targetPart:IsA('BasePart')then continue end
local onScreen,screenPos=_isOnScreen(targetPart.Position)if not onScreen then
continue end if _state.settings.shouldWallCheck then local origin=camera.CFrame.
Position if not _isVisible(targetPart,origin)then continue end end local
distance=(screenPos-aimScreenPos).Magnitude if distance<closestDistance then
closestDistance=distance bestTarget=player end end return bestTarget end
local function _isTargetValid(target,isAiming)local camera=Workspace.
CurrentCamera local localPlayer=Players.LocalPlayer if not camera or not
localPlayer then return false end if target==localPlayer then return false end
if _state.settings.shouldTeamCheck and target.Team==localPlayer.Team then return
false end local character=target.Character if not character then return false
end local humanoid=character:FindFirstChild('Humanoid')if _state.settings.
shouldAliveCheck then if not humanoid or not humanoid:IsA('Humanoid')or humanoid
.Health<=0 then return false end end local targetPart=character:FindFirstChild(
_state.settings.targetPart)if not targetPart or not targetPart:IsA('BasePart')
then return false end if not isAiming then local onScreen=_isOnScreen(targetPart
.Position)if not onScreen then return false end end if _state.settings.
shouldWallCheck then local origin=camera.CFrame.Position if not _isVisible(
targetPart,origin)then return false end end return true end local function
_updateFOV(aimScreenPos)if not _state.fovCircle then return end _state.fovCircle
.Visible=_state.settings.shouldShowFov _state.fovCircle.Radius=_state.settings.
fovRadius _state.fovCircle.Color=_state.settings.fovColor _state.fovCircle.
Position=aimScreenPos end local function _applyCameraControllerRotation(
targetPosition)local camera=Workspace.CurrentCamera if not camera then return
end local controller=_getCameraController()if not controller then return end
local targetCFrame=CFrame.lookAt(camera.CFrame.Position,targetPosition)local
pitch,yaw,_=targetCFrame:ToOrientation()local targetRotation=Vector2.new(pitch,
yaw)if controller.ApplyRotationDelta and controller.Rotation~=nil then local
smoothness=math.clamp(_state.settings.smoothness,MIN_SMOOTHNESS,MAX_SMOOTHNESS)
local alpha=smoothness/MAX_SMOOTHNESS local delta=(targetRotation-controller.
Rotation)*alpha controller:ApplyRotationDelta(delta)elseif controller.
SetRotation then controller:SetRotation(targetRotation)elseif controller.
Rotation~=nil then controller.Rotation=targetRotation end end local function
_syncCameraControllerRotation()local camera=Workspace.CurrentCamera if not
camera then return end local controller=_getCameraController()if not controller
then return end local pitch,yaw,_=camera.CFrame:ToOrientation()if controller.
SetRotation then controller:SetRotation(Vector2.new(pitch,yaw))elseif controller
.Rotation~=nil then controller.Rotation=Vector2.new(pitch,yaw)end end
local function _resetAimState()_setAutoRotateOverride(false)
_setMouseSensitivityOverride(false)_state.lockedTarget=nil
_syncCameraControllerRotation()end local function _applyCameraAim(camera,
targetPosition,deltaTime)local smoothness=math.clamp(_state.settings.smoothness,
MIN_SMOOTHNESS,MAX_SMOOTHNESS)local isInstant=smoothness>=MAX_SMOOTHNESS local
targetCFrame=CFrame.lookAt(camera.CFrame.Position,targetPosition)if isInstant
then camera.CFrame=targetCFrame return end local duration=(MAX_SMOOTHNESS-
smoothness)/MAX_SMOOTHNESS if duration<=0 then camera.CFrame=targetCFrame return
end local alpha=math.clamp(deltaTime/duration,0,1)camera.CFrame=camera.CFrame:
Lerp(targetCFrame,alpha)end local function _applyCharacterAim(targetPosition)
local rootPart=_getLocalRootPart()if not rootPart then return end local
flatTarget=Vector3.new(targetPosition.X,rootPart.Position.Y,targetPosition.Z)
rootPart.CFrame=CFrame.lookAt(rootPart.Position,flatTarget)end local function
_applyMouseAim(camera,targetPosition)local smoothness=math.clamp(_state.settings
.smoothness,MIN_SMOOTHNESS,MAX_SMOOTHNESS)local _,screenPos=_isOnScreen(
targetPosition)local mousePos=_getMouseLocation()local delta=screenPos-mousePos
local mouseDivisor=(MAX_SMOOTHNESS-smoothness)/5+1 local env=(getfenv())local
mousemoverel=env.mousemoverel or(env.input and env.input.mousemoverel)if
mousemoverel then mousemoverel(delta.X/mouseDivisor,delta.Y/mouseDivisor)end end
local function _aimAt(target,deltaTime)local character=target.Character if not
character then return end local targetPart=character:FindFirstChild(_state.
settings.targetPart)if not targetPart or not targetPart:IsA('BasePart')then
return end local camera=Workspace.CurrentCamera if not camera then return end
local targetPosition=(targetPart).Position local controller=
_getCameraController()if controller then _setAutoRotateOverride(false)
_setMouseSensitivityOverride(false)_applyCameraControllerRotation(targetPosition
)return else _setAutoRotateOverride(true)_applyCharacterAim(targetPosition)
_setMouseSensitivityOverride(true)_applyCameraAim(camera,targetPosition,
deltaTime)_applyMouseAim(camera,targetPosition)end if _state.settings.isDebug
and _state.client.Logger then _state.client.Logger:info('Aiming at:',target.Name
,'| Dist:',math.floor((targetPosition-camera.CFrame.Position).Magnitude))end end
local function _connect()_maid:DoCleaning()local env=(getfenv())if env.Drawing
then local circle=env.Drawing.new('Circle')circle.Thickness=1 circle.NumSides=
FOV_CIRCLE_SIDES circle.Filled=false circle.Transparency=1 _state.fovCircle=
circle _maid:GiveTask(function()if _state.fovCircle then _state.fovCircle:
Remove()_state.fovCircle=nil end end)end RunService:BindToRenderStep(
AIMBOT_RENDER_STEP,AIMBOT_RENDER_PRIORITY,function(deltaTime)local isAiming=
UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)local
aimScreenPos=_getAimScreenPosition(isAiming)_updateFOV(aimScreenPos)if not
_state.settings.isEnabled then _resetAimState()return end if not isAiming then
_resetAimState()return end local target=_state.lockedTarget if target and not
_isTargetValid(target,isAiming)then target=nil end if not target then target=
_getBestTarget(aimScreenPos)end if not target then _resetAimState()return end
_state.lockedTarget=target _aimAt(target,deltaTime)end)_maid:GiveTask(function()
RunService:UnbindFromRenderStep(AIMBOT_RENDER_STEP)end)end function Aimbot.init(
self,client)_state.client=client _maid=Maid.new()_connect()end function Aimbot.
cleanup(self)_resetAimState()_maid:DoCleaning()end function Aimbot.toggle(self,
state)_state.settings.isEnabled=state if not state then _resetAimState()end end
function Aimbot.setTeamCheck(self,state)_state.settings.shouldTeamCheck=state
end function Aimbot.setAliveCheck(self,state)_state.settings.shouldAliveCheck=
state end function Aimbot.setWallCheck(self,state)_state.settings.
shouldWallCheck=state end function Aimbot.setShowFOV(self,state)_state.settings.
shouldShowFov=state end function Aimbot.setFOVRadius(self,radius)_state.settings
.fovRadius=radius end function Aimbot.setFOVColor(self,color)_state.settings.
fovColor=color end function Aimbot.setSmoothness(self,value)_state.settings.
smoothness=value end function Aimbot.setTargetPart(self,partName)_state.settings
.targetPart=partName end function Aimbot.setDebug(self,state)_state.settings.
isDebug=state end return Aimbot end function __DARKLUA_BUNDLE_MODULES.g()local v
=__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do local function
__modImpl()local RunService=game:GetService('RunService')local Maid=(
__DARKLUA_BUNDLE_MODULES.b())local REPO_URL=
[[https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/]]local
Interface={}Interface.__index=Interface local _maid=nil local _state={client=nil
,logger=nil,library=nil,themeManager=nil,saveManager=nil,isMounted=false,
playerControls=nil,debugEnabled=true}local _signals={}local function _debugLog(
...)if not _state.debugEnabled then return end local logger=_state.logger if
logger and logger.info then logger:info(...)else print(...)end end
local function _updatePlayerControls()if not _state.playerControls then return
end local getfenvAny=getfenv local env=(getfenvAny(0))local getgenvFunc=env.
getgenv local toggles=(getgenvFunc and getgenvFunc().Toggles)or _G.Toggles local
options=(getgenvFunc and getgenvFunc().Options)or _G.Options if not toggles or
not options then _debugLog('PlayerControls: Toggles/Options missing',toggles~=
nil,options~=nil)end for _,control in ipairs(_state.playerControls)do local
toggle=toggles and toggles[control.toggleId]local gate=toggle and toggle.Value==
true local active=false if gate then local keybind=options and options[control.
keybindId]if keybind and keybind.GetState then active=keybind:GetState()else
active=false end end if control.last~=active then control.last=active control.
setter(active)_debugLog('PlayerControls',control.toggleId,'gate',gate,'active',
active,'keybind',control.keybindId)end end end local function _httpGet(url)
return(game):HttpGet(url)end local function _loadRemote(path,logger)local source
=_httpGet(REPO_URL..path)local chunk,err=loadstring(source)if not chunk then if
logger then logger:error('UI load failed:',err)end error('UI load failed: '..
tostring(err))end return chunk()end local function _setNotifyMuted(library,
shouldMute)if shouldMute then library.Notify=library.Notify or function()end
library._blossomNotify=library._blossomNotify or library.Notify library.Notify=
function()end return end if library._blossomNotify then library.Notify=library.
_blossomNotify end end local function _getLibraryVisible(library)if type(library
.Opened)=='boolean'then return library.Opened end if type(library.Visible)==
'boolean'then return library.Visible end if type(library.IsOpen)=='boolean'then
return library.IsOpen end return true end local function _runAutoload(library,
saveManager,isSilent)local wasVisible=_getLibraryVisible(library)if isSilent
then _setNotifyMuted(library,true)if wasVisible then pcall(function()library:
Toggle()end)end end pcall(function()saveManager:LoadAutoloadConfig()end)if
isSilent then if wasVisible then pcall(function()library:Toggle()end)end
_setNotifyMuted(library,false)end end local function _connect()_maid:DoCleaning(
)local updateConn=RunService.RenderStepped:Connect(function()
_updatePlayerControls()end)_maid:GiveTask(updateConn)end local function _mount()
if _state.isMounted then return end _state.isMounted=true local logger=_state.
logger local library=_loadRemote('Library.lua',logger)local themeManager=
_loadRemote('addons/ThemeManager.lua',logger)local saveManager=_loadRemote(
'addons/SaveManager.lua',logger)_state.library=library _state.themeManager=
themeManager _state.saveManager=saveManager local window=library:CreateWindow({
Title='Blossom '.._state.client.Version,Center=true,AutoShow=not _state.client.
IsSilent,TabPadding=8,MenuFadeTime=0.2})local tabs={main=window:AddTab('Main'),
visuals=window:AddTab('Visuals'),misc=window:AddTab('Misc'),uiSettings=window:
AddTab('UI Settings')}local aimbotGroup=tabs.main:AddLeftGroupbox('Aimbot')
aimbotGroup:AddToggle('AimbotEnabled',{Text='Enabled',Default=false,Callback=
function(state)local mod=_state.client.Modules.Aimbot if mod and mod.toggle then
mod:toggle(state)end end})aimbotGroup:AddToggle('AimbotTeamCheck',{Text=
'Team Check',Default=true,Callback=function(state)local mod=_state.client.
Modules.Aimbot if mod and mod.setTeamCheck then mod:setTeamCheck(state)end end})
aimbotGroup:AddToggle('AimbotWallCheck',{Text='Wall Check',Default=true,Callback
=function(state)local mod=_state.client.Modules.Aimbot if mod and mod.
setWallCheck then mod:setWallCheck(state)end end})aimbotGroup:AddToggle(
'AimbotAliveCheck',{Text='Alive Check',Default=true,Callback=function(state)
local mod=_state.client.Modules.Aimbot if mod and mod.setAliveCheck then mod:
setAliveCheck(state)end end})aimbotGroup:AddToggle('AimbotShowFOV',{Text=
'Show FOV',Default=false,Callback=function(state)local mod=_state.client.Modules
.Aimbot if mod and mod.setShowFOV then mod:setShowFOV(state)end end}):
AddColorPicker('AimbotFOVColor',{Default=Color3.fromRGB(255,255,255),Title=
'FOV Color',Callback=function(value)local mod=_state.client.Modules.Aimbot if
mod and mod.setFOVColor then mod:setFOVColor(value)end end})aimbotGroup:
AddSlider('AimbotFOVRadius',{Text='FOV Radius',Default=100,Min=10,Max=1000,
Rounding=0,Callback=function(value)local mod=_state.client.Modules.Aimbot if mod
and mod.setFOVRadius then mod:setFOVRadius(value)end end})aimbotGroup:AddSlider(
'AimbotSmoothness',{Text='Smoothness (High = Fast)',Default=50,Min=1,Max=100,
Rounding=1,Callback=function(value)local mod=_state.client.Modules.Aimbot if mod
and mod.setSmoothness then mod:setSmoothness(value)end end})aimbotGroup:
AddDropdown('AimbotTargetPart',{Values={'Head','HumanoidRootPart','UpperTorso'},
Default=1,Multi=false,Text='Target Part',Callback=function(value)local mod=
_state.client.Modules.Aimbot if mod and mod.setTargetPart then mod:
setTargetPart(value)end end})aimbotGroup:AddToggle('AimbotDebug',{Text=
'Debug Mode',Default=false,Callback=function(state)local mod=_state.client.
Modules.Aimbot if mod and mod.setDebug then mod:setDebug(state)end end})local
espGroup=tabs.visuals:AddLeftGroupbox('ESP')espGroup:AddToggle('VisualsToggle',{
Text='Visuals (ESP)',Default=false,Callback=function(state)local mod=_state.
client.Modules.Visuals if mod and mod.toggle then mod:toggle(state)end if mod
and mod.setEspEnabled then mod:setEspEnabled(state)end end})espGroup:AddToggle(
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
_updatePlayerControls()end})playerFlyToggle:AddKeyPicker('PlayerFlyKeybind',{
Default='F',NoUI=false,Text='Fly Keybind',SyncToggleState=false,Callback=
function()_updatePlayerControls()end})playerGroup:AddSlider('PlayerFlySpeed',{
Text='Fly Speed',Default=50,Min=5,Max=200,Rounding=0,Callback=function(value)
local mod=_state.client.Modules.Player if mod and mod.setFlySpeed then mod:
setFlySpeed(value)end end})local playerNoclipToggle=playerGroup:AddToggle(
'PlayerNoclip',{Text='Noclip',Default=false,Callback=function(state)
_updatePlayerControls()end})playerNoclipToggle:AddKeyPicker(
'PlayerNoclipKeybind',{Default='N',NoUI=false,Text='Noclip Keybind',
SyncToggleState=false,Callback=function()_updatePlayerControls()end})local
playerWalkSpeedToggle=playerGroup:AddToggle('PlayerWalkSpeedEnabled',{Text=
'Walk Speed',Default=false,Callback=function(state)_updatePlayerControls()end})
playerWalkSpeedToggle:AddKeyPicker('PlayerWalkSpeedKeybind',{Default='T',NoUI=
false,Text='Walk Speed Keybind',SyncToggleState=false,Callback=function()
_updatePlayerControls()end})playerGroup:AddSlider('PlayerWalkSpeed',{Text=
'Walk Speed',Default=16,Min=0,Max=200,Rounding=0,Callback=function(value)local
mod=_state.client.Modules.Player if mod and mod.setWalkSpeed then mod:
setWalkSpeed(value)end end})local playerJumpPowerToggle=playerGroup:AddToggle(
'PlayerJumpPowerEnabled',{Text='Jump Power',Default=false,Callback=function(
state)_updatePlayerControls()end})playerJumpPowerToggle:AddKeyPicker(
'PlayerJumpPowerKeybind',{Default='Y',NoUI=false,Text='Jump Power Keybind',
SyncToggleState=false,Callback=function()_updatePlayerControls()end})playerGroup
:AddSlider('PlayerJumpPower',{Text='Jump Power',Default=50,Min=0,Max=200,
Rounding=0,Callback=function(value)local mod=_state.client.Modules.Player if mod
and mod.setJumpPower then mod:setJumpPower(value)end end})_state.playerControls=
{{toggleId='PlayerFly',keybindId='PlayerFlyKeybind',last=nil,setter=function(
active)local mod=_state.client.Modules.Player if mod and mod.setFlyEnabled then
mod:setFlyEnabled(active)end end},{toggleId='PlayerNoclip',keybindId=
'PlayerNoclipKeybind',last=nil,setter=function(active)local mod=_state.client.
Modules.Player if mod and mod.setNoclipEnabled then mod:setNoclipEnabled(active)
end end},{toggleId='PlayerWalkSpeedEnabled',keybindId='PlayerWalkSpeedKeybind',
last=nil,setter=function(active)local mod=_state.client.Modules.Player if mod
and mod.setWalkSpeedEnabled then mod:setWalkSpeedEnabled(active)end end},{
toggleId='PlayerJumpPowerEnabled',keybindId='PlayerJumpPowerKeybind',last=nil,
setter=function(active)local mod=_state.client.Modules.Player if mod and mod.
setJumpPowerEnabled then mod:setJumpPowerEnabled(active)end end}}
_updatePlayerControls()local miscGroup=tabs.misc:AddLeftGroupbox('Auto Load')
miscGroup:AddToggle('TeleportQueue',{Text='Auto Load',Default=false,Callback=
function(enabled)_state.client:setTeleportQueue(enabled)end})miscGroup:
AddToggle('SilentMode',{Text='Silent Mode',Default=false,Callback=function(
enabled)_setNotifyMuted(library,enabled)_state.client:setSilent(enabled)end})
_runAutoload(library,saveManager,false)logger:info('UI mounted successfully')end
function Interface.init(self,client)_state.client=client _state.logger=client.
Logger _maid=Maid.new()_connect()_mount()end function Interface.cleanup(self)
_maid:DoCleaning()if _state.library then _state.library:Unload()end _state.
isMounted=false end return Interface end function __DARKLUA_BUNDLE_MODULES.h()
local v=__DARKLUA_BUNDLE_MODULES.cache.h if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c end end end local
ReplicatedFirst=game:GetService('ReplicatedFirst')local Players=game:GetService(
'Players')local RunService=game:GetService('RunService')local Logger=
__DARKLUA_BUNDLE_MODULES.a()local Maid=__DARKLUA_BUNDLE_MODULES.b()local Signal=
__DARKLUA_BUNDLE_MODULES.c()local BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau]]
local CLIENT_MODULE_NAME='Client'local CONTROLLER_NAMES={'PlayerDataController',
'ComplianceController','FunctionsController','MiscController',
'UserInterfaceController','MonetizationController','EnemyController',
'CameraController','MechanicsController','FighterController',
'SpectateController','TightropeController','EntityController','DuelController',
'GameComponentsController','ControlsController','LeaderboardController',
'LobbyController','QueuePadController','LightingController',
'ShootingRangeController','CoreGuiController','MusicController',
'MobileController','ShopController','ProximityPromptController',
'PlayerInteractionController','DebugController','MatchmakingController',
'ChattingController','EventController','PrivateServerController',
'TestingController','ShadyChickenController','WrapController',
'ScavengerHuntController','SocialController','FFlagController','AudioController'
,'BirthdayController','ArcadeController','EmoteController','SeasonController'}
local MODULES={{name='Visuals',loader=(__DARKLUA_BUNDLE_MODULES.e())},{name=
'Player',loader=(__DARKLUA_BUNDLE_MODULES.f())},{name='Aimbot',loader=(
__DARKLUA_BUNDLE_MODULES.g())},{name='Interface',loader=(
__DARKLUA_BUNDLE_MODULES.h())}}local Client={}Client.__index=Client local _maid=
Maid.new()local _state={isRunning=false,shouldTeleportQueue=false,isSilent=(
function()local getfenvAny=getfenv local g=(getfenvAny(0))return g.BlossomSilent
or(g.getgenv and g.getgenv().BlossomSilent)or false end)(),logger=nil}local
_signals={started=Signal.new(),stopped=Signal.new()}local _modules={}
local function _disableAnalyticsPipeline(logger)local success,err=pcall(function
()local controller=ReplicatedFirst:FindFirstChild('AnalyticsPipelineController')
if not controller then controller=ReplicatedFirst:WaitForChild(
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
end end local function _waitForClientLoaded()local localPlayer=Players.
LocalPlayer while not localPlayer do RunService.Heartbeat:Wait()localPlayer=
Players.LocalPlayer end local playerScripts=localPlayer:WaitForChild(
'PlayerScripts')local clientModule=playerScripts:WaitForChild(CLIENT_MODULE_NAME
)if not clientModule:IsA('ModuleScript')then return end local ok,client=pcall(
function()return require(clientModule)end)if not ok or type(client)~='table'then
return end while true do local allLoaded=true for _,name in ipairs(
CONTROLLER_NAMES)do if client[name]==nil then allLoaded=false break end end if
allLoaded then break end RunService.Heartbeat:Wait()end end local function
_getModuleInit(moduleResult)return moduleResult.init or moduleResult.Init end
local function _getModuleCleanup(moduleResult)return moduleResult.cleanup or
moduleResult.Cleanup end function Client.loadModule(self,name,moduleOrPath)if
_modules[name]then _state.logger:warn('Module already loaded:',name)return end
local loader=function()if type(moduleOrPath)=='string'then local dynamicRequire=
require return dynamicRequire(moduleOrPath)end return moduleOrPath end local
success,result=pcall(loader)if success then local moduleResult=result _modules[
name]=moduleResult local initFn=(_getModuleInit(moduleResult))if initFn then
task.spawn(function()initFn(moduleResult,self)end)end _state.logger:info(
'Loaded module:',name)else _state.logger:warn('Failed to load module:',name,
result)end end function Client.setTeleportQueue(self,shouldEnable)_state.
shouldTeleportQueue=shouldEnable if _state.isRunning then _handleTeleportQueue(
shouldEnable)end end function Client.setSilent(self,isSilent)if _state.isSilent
==isSilent then return end _state.isSilent=isSilent if _state.
shouldTeleportQueue and _state.isRunning then _handleTeleportQueue(true)end end
function Client.start(self)if _state.isRunning then return end _state.isRunning=
true _disableAnalyticsPipeline(_state.logger)_state.logger:info(
'Client initializing...')_waitForClientLoaded()for _,entry in ipairs(MODULES)do
self:loadModule(entry.name,entry.loader)end _connect()_signals.started:Fire()end
function Client.destroy(self)if not _state.isRunning then return end _state.
isRunning=false _signals.stopped:Fire()_maid:DoCleaning()for _,moduleResult in
pairs(_modules)do local cleanupFn=(_getModuleCleanup(moduleResult))if cleanupFn
then pcall(cleanupFn,moduleResult)end end _state.logger:info('Client stopped.')
end local loggerModule=(Logger)local client=((setmetatable({},Client)))client.
Version='1.0.0'client.Logger=loggerModule.new('Blossom')client.Modules=_modules
client.Started=_signals.started client.Stopped=_signals.stopped client.IsSilent=
_state.isSilent _state.logger=client.Logger return client:start()