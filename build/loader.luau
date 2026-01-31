local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
Maid={}Maid.ClassName='Maid'function Maid.new()return setmetatable({_tasks={}},
Maid)end function Maid.isMaid(value)return type(value)=='table'and value.
ClassName=='Maid'end function Maid:__index(index)if Maid[index]then return Maid[
index]else return self._tasks[index]end end function Maid:__newindex(index,
newTask)if Maid[index]~=nil then error(("'%s' is reserved"):format(tostring(
index)),2)end local tasks=self._tasks local oldTask=tasks[index]if oldTask==
newTask then return end tasks[index]=newTask if oldTask then if type(oldTask)==
'function'then oldTask()elseif typeof(oldTask)=='RBXScriptConnection'then
oldTask:Disconnect()elseif oldTask.Destroy then oldTask:Destroy()end end end
function Maid:GiveTask(task)if not task then error('Task cannot be false or nil'
,2)end local taskId=#self._tasks+1 self[taskId]=task if type(task)=='table'and
not task.Destroy then warn(
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
Maid end function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.
cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end
return v.c end end do local function __modImpl()local CoreGui=game:GetService(
'CoreGui')local RunService=game:GetService('RunService')local Maid=(
__DARKLUA_BUNDLE_MODULES.a())local DEFAULT_SOURCE='System'local
RICHTEXT_CHECK_INTERVAL=0.5 local RICHTEXT_MAX_EMPTY_CHECKS=6 local PREFIX_LABEL
='Blossm'local COLORS={Cyan='33, 161, 163',Green='0, 255, 0',Pink=
'255, 102, 153',White='255, 255, 255',Yellow='255, 215, 0',Red='220, 20, 60'}
local Logger={}Logger.__index=Logger local _maid=Maid.new()local _state={
lastRichTextCheck=0,isRichTextConnected=false}local _emptyChecks=0 local
_signals={}local function _setRichTextOnLabels()pcall(function()local devConsole
=CoreGui:FindFirstChild('DevConsoleMaster')if not devConsole then _emptyChecks+=
1 return end _emptyChecks=0 for _,label in ipairs(devConsole:GetDescendants())do
if label:IsA('TextLabel')and not label.RichText then label.RichText=true end end
end)end local function _connect()if _state.isRichTextConnected then return end
_state.isRichTextConnected=true local conn=RunService.Heartbeat:Connect(function
()local now=os.clock()if now-_state.lastRichTextCheck<RICHTEXT_CHECK_INTERVAL
then return end _state.lastRichTextCheck=now _setRichTextOnLabels()if
_emptyChecks>=RICHTEXT_MAX_EMPTY_CHECKS then _maid:DoCleaning()_state.
isRichTextConnected=false _emptyChecks=0 end end)_maid:GiveTask(conn)end
local function _formatMessage(...)local parts={...}for i,value in ipairs(parts)
do parts[i]=tostring(value)end local message=table.concat(parts,' ')return
string.format("<font color='rgb(%s)'>[%s]:</font> %s",COLORS.Pink,PREFIX_LABEL,
message)end function Logger.new(source)_connect()local instance=setmetatable({
source=source or DEFAULT_SOURCE},Logger)return(instance)end function Logger.
Destroy()_maid:DoCleaning()_state.isRichTextConnected=false end function Logger.
info(self,...)print(_formatMessage(...))end function Logger.success(self,...)
print(_formatMessage(...))end function Logger.warn(self,...)warn(_formatMessage(
...))end function Logger.error(self,...)error(_formatMessage(...),0)end function
Logger.warnUnsupported(self,name)self:warn(string.format(
[[This executor does not support '%s'. Some features may not work as expected.]]
,name))end return Logger end function __DARKLUA_BUNDLE_MODULES.b()local v=
__DARKLUA_BUNDLE_MODULES.cache.b if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c end end do local function
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
__DARKLUA_BUNDLE_MODULES.c()local v=__DARKLUA_BUNDLE_MODULES.cache.c if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c end end
do local function __modImpl()local ExecutorUtils={}ExecutorUtils.__index=
ExecutorUtils local _maid=nil local _state={}local _signals={}function
ExecutorUtils.getGlobal(name)local getfenvAny=getfenv local env=(getfenvAny(0))
local genv=(env.getgenv and env.getgenv())or env return genv[name]or env[name]
end function ExecutorUtils.getDrawingLib()local getfenvAny=getfenv local g=(
getfenvAny(0))local lib=g.Drawing if not lib and g.getgenv then lib=g.getgenv().
Drawing end if not lib then lib=rawget(_G,'Drawing')end return lib end return
ExecutorUtils end function __DARKLUA_BUNDLE_MODULES.d()local v=
__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local Workspace=game:
GetService('Workspace')local Maid=(__DARKLUA_BUNDLE_MODULES.a())local
ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local TeamUtils={}TeamUtils.__index=
TeamUtils local _cache=(ExecutorUtils.getGlobal('cache'))local _maid=nil local
_state={}local _signals={}local _fighterController=nil local _duelController=nil
local function _clearPlayerCache(player)if _cache and _cache.iscached and _cache
.invalidate then if _cache.iscached(player)then _cache.invalidate(player)end end
end local function _connect()if not _maid then return end _maid:DoCleaning()
local removeConn=Players.PlayerRemoving:Connect(function(player)
_clearPlayerCache(player)end)_maid:GiveTask(removeConn)end local function
_getDuelController()if _duelController then return _duelController end local
localPlayer=Players.LocalPlayer if not localPlayer then return nil end local
playerScripts=localPlayer:FindFirstChild('PlayerScripts')if not playerScripts
then return nil end local controllers=playerScripts:FindFirstChild('Controllers'
)if not controllers then return nil end local duelControllerScript=controllers:
FindFirstChild('DuelController')if not(duelControllerScript and
duelControllerScript:IsA('ModuleScript'))then return nil end local success,
result=pcall(function()local dynamicRequire=require return dynamicRequire(
duelControllerScript)end)if success then _duelController=result end return
_duelController end local function _getLocalDuel()local localPlayer=Players.
LocalPlayer if not localPlayer then return nil end local duelController=
_getDuelController()if not duelController or not duelController.GetDuel then
return nil end local ok,duel=pcall(duelController.GetDuel,duelController,
localPlayer)if ok then return duel end return nil end local function
_getFighterController()if _fighterController then return _fighterController end
local localPlayer=Players.LocalPlayer if not localPlayer then return nil end
local playerScripts=localPlayer:FindFirstChild('PlayerScripts')if not
playerScripts then return nil end local controllers=playerScripts:
FindFirstChild('Controllers')if not controllers then return nil end local
fighterControllerScript=controllers:FindFirstChild('FighterController')if not(
fighterControllerScript and fighterControllerScript:IsA('ModuleScript'))then
return nil end local success,result=pcall(function()local dynamicRequire=require
return dynamicRequire(fighterControllerScript)end)if success then
_fighterController=result end return _fighterController end local function
_areTeamsEqual(teamA,teamB)return teamA~=nil and teamA==teamB end local function
_getTeamFromFighter(fighter,fallbackPlayer)if not fighter then return nil end
local getFn=fighter.Get if getFn then local ok,teamId=pcall(getFn,fighter,
'TeamID')if ok and teamId~=nil then return teamId end end local teamValue=
fighter.Team or fighter.team or fighter.TeamId or fighter.teamId or fighter.
TeamID or fighter.teamID or fighter.Side or fighter.side if teamValue~=nil then
return teamValue end local owner=fighter.Owner or fighter.owner or fighter.
Player or fighter.player if typeof(owner)=='Instance'and owner:IsA('Player')then
if fallbackPlayer and owner==fallbackPlayer then return nil end return TeamUtils
.getPlayerTeamId(owner)end return nil end local function _getFighterIsInDuel(
fighter)if not fighter then return false end local getFn=fighter.Get if getFn
then local ok,isInDuel=pcall(getFn,fighter,'IsInDuel')if ok and isInDuel~=nil
then return isInDuel==true end end local value=fighter.IsInDuel or fighter.
isInDuel if value~=nil then return value==true end return false end
local function _getFighterForPlayer(controller,player)if not controller then
return nil end local getter=controller.getFighter or controller.GetFighter or
controller.getFighterByPlayer or controller.GetFighterByPlayer or controller.
getFighterFromPlayer or controller.GetFighterFromPlayer if getter then local ok,
fighter=pcall(getter,controller,player)if ok and fighter then return fighter end
end local fighters=controller.Fighters or controller.fighters or controller.
_fighters or controller.FighterByPlayer or controller.fighterByPlayer if
fighters then return fighters[player]or fighters[player.UserId]or fighters[
tostring(player.UserId)]end return nil end function TeamUtils.getPlayerTeamId(
player)local controller=_getFighterController()local fighter=
_getFighterForPlayer(controller,player)local fighterTeam=_getTeamFromFighter(
fighter,player)return fighterTeam end function TeamUtils.getLocalDuel()return
_getLocalDuel()end function TeamUtils.isSameTeam(playerA,playerB)if playerA==
playerB then return true end local teamA=TeamUtils.getPlayerTeamId(playerA)if
teamA==nil then return false end local teamB=TeamUtils.getPlayerTeamId(playerB)
if teamB==nil then return false end return _areTeamsEqual(teamA,teamB)end
function TeamUtils.isInDuel(player)local controller=_getFighterController()local
fighter=_getFighterForPlayer(controller,player)return _getFighterIsInDuel(
fighter)end function TeamUtils.isInSameDuel(playerA,playerB)local localPlayer=
Players.LocalPlayer if localPlayer and(playerA==localPlayer or playerB==
localPlayer)then if not TeamUtils.isInDuel(localPlayer)then return false end end
local localDuel=_getLocalDuel()if localDuel and localDuel.GetDueler then local
okA,duelerA=pcall(localDuel.GetDueler,localDuel,playerA)if not okA or not
duelerA then return false end local okB,duelerB=pcall(localDuel.GetDueler,
localDuel,playerB)if not okB or not duelerB then return false end return true
end local controller=_getFighterController()local fighterA=_getFighterForPlayer(
controller,playerA)local fighterB=_getFighterForPlayer(controller,playerB)if not
fighterA or not fighterB then return false end if not _getFighterIsInDuel(
fighterA)or not _getFighterIsInDuel(fighterB)then return false end local matchA=
fighterA.Match or fighterA.MatchID or fighterA.MatchId or fighterA._match local
matchB=fighterB.Match or fighterB.MatchID or fighterB.MatchId or fighterB._match
if matchA and matchB and matchA==matchB then return true end local charA=playerA
.Character local charB=playerB.Character if charA and charB and charA.Parent==
charB.Parent and charA.Parent~=Workspace then return true end return false end
function TeamUtils.init(self,_client)_maid=Maid.new()_connect()end function
TeamUtils.Destroy(self)if _maid then _maid:DoCleaning()end _fighterController=
nil _duelController=nil end return TeamUtils end function
__DARKLUA_BUNDLE_MODULES.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end
do local function __modImpl()local Players=game:GetService('Players')local
Workspace=game:GetService('Workspace')local PlayerUtils={}PlayerUtils.__index=
PlayerUtils local _maid=nil local _state={}local _signals={}function PlayerUtils
.getLocalPlayer()return Players.LocalPlayer end function PlayerUtils.getCamera()
local camera=Workspace.CurrentCamera if not camera then camera=(Workspace:
WaitForChild('Camera'))end return camera end return PlayerUtils end function
__DARKLUA_BUNDLE_MODULES.f()local v=__DARKLUA_BUNDLE_MODULES.cache.f if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end
do local function __modImpl()local ESP_RENDER_INTERVAL=1/60 local
ESP_SKELETON_INTERVAL=1/60 local ESP_TEXT_INTERVAL=1/60 local ESP_SMOOTH_ALPHA=
0.25 local Constants={DEFAULT_SETTINGS={isEspEnabled=false,shouldShowNames=true,
shouldShowWeapon=false,shouldShowDistance=false,shouldShowBoxes=true,
shouldShowSkeleton=false,shouldShowHealthbar=false,shouldShowHighlight=false,
shouldShowTeammates=true,boxColor=Color3.new(1,1,1),textColor=Color3.new(1,1,1),
weaponColor=Color3.new(1,1,1),distanceColor=Color3.new(1,1,1),skeletonColor=
Color3.new(1,1,1),healthbarColor=Color3.new(0,1,0),healthbarOutlineColor=Color3.
new(0,0,0),nameOutlineColor=Color3.new(0,0,0),weaponOutlineColor=Color3.new(0,0,
0),distanceOutlineColor=Color3.new(0,0,0),boxOutlineColor=Color3.new(0,0,0),
skeletonOutlineColor=Color3.new(0,0,0),highlightFill=Color3.new(1,0,0),
highlightOutline=Color3.new(1,1,1),boxThickness=1,skeletonThickness=1,textSize=
12,shouldOutline=true},R15_JOINTS={{'Head','UpperTorso'},{'UpperTorso',
'LowerTorso'},{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{
'LeftLowerLeg','LeftFoot'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg',
'RightLowerLeg'},{'RightLowerLeg','RightFoot'},{'UpperTorso','LeftUpperArm'},{
'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm','LeftHand'},{'UpperTorso',
'RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'RightLowerArm','RightHand'}
},ESP_RENDER_INTERVAL=ESP_RENDER_INTERVAL,ESP_SKELETON_INTERVAL=
ESP_SKELETON_INTERVAL,ESP_TEXT_INTERVAL=ESP_TEXT_INTERVAL,ESP_SMOOTH_ALPHA=
ESP_SMOOTH_ALPHA}return Constants end function __DARKLUA_BUNDLE_MODULES.g()local
v=__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do local function
__modImpl()return{}end function __DARKLUA_BUNDLE_MODULES.h()local v=
__DARKLUA_BUNDLE_MODULES.cache.h if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c end end do local function
__modImpl()local Constants=__DARKLUA_BUNDLE_MODULES.g()local Types=
__DARKLUA_BUNDLE_MODULES.h()local _maid=nil local _signals={}local _state={
client=nil,logger=nil,isEnabled=false,drawings={},highlights={},smoothCache={},
settings=table.clone(Constants.DEFAULT_SETTINGS),overrideCheck=nil,
isEspPreviouslyEnabled=false,lastSkeletonUpdate=0,lastTextUpdate=0}return _state
end function __DARKLUA_BUNDLE_MODULES.i()local v=__DARKLUA_BUNDLE_MODULES.cache.
i if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.i=v end return v
.c end end do local function __modImpl()local Players=game:GetService('Players')
local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local PlayerUtils=
__DARKLUA_BUNDLE_MODULES.f()local TeamUtils=__DARKLUA_BUNDLE_MODULES.e()local
Constants=__DARKLUA_BUNDLE_MODULES.g()local State=__DARKLUA_BUNDLE_MODULES.i()
local Helpers={}Helpers.__index=Helpers local _maid=nil local _signals={}local
_state={}local function _setGroupVisible(group,isVisible)for _,drawing in pairs(
group)do if type(drawing)=='table'then for _,line in pairs(drawing)do line.
Visible=isVisible end else drawing.Visible=isVisible end end end local function
_lerpVector2(a,b,alpha)return a:Lerp(b,alpha)end local function _updateSkeleton(
skeletonLines,skeletonOutlineLines,character)local camera=PlayerUtils.getCamera(
)local lineIndex=1 for _,pair in ipairs(Constants.R15_JOINTS)do local p1=
character:FindFirstChild(pair[1])local p2=character:FindFirstChild(pair[2])if p1
and p2 and p1:IsA('BasePart')and p2:IsA('BasePart')then local v1,o1=camera:
WorldToViewportPoint(p1.Position)local v2,o2=camera:WorldToViewportPoint(p2.
Position)if o1 and o2 then local outline=skeletonOutlineLines[lineIndex]if
outline then outline.From=Vector2.new(v1.X,v1.Y)outline.To=Vector2.new(v2.X,v2.Y
)outline.Color=State.settings.skeletonOutlineColor outline.Thickness=State.
settings.skeletonThickness+2 outline.Visible=true outline.ZIndex=1 end local
line=skeletonLines[lineIndex]if line then line.From=Vector2.new(v1.X,v1.Y)line.
To=Vector2.new(v2.X,v2.Y)line.Color=State.settings.skeletonColor line.Thickness=
State.settings.skeletonThickness line.Visible=true line.ZIndex=2 lineIndex+=1
end end end end for i=lineIndex,#skeletonLines do skeletonLines[i].Visible=false
end for i=lineIndex,#skeletonOutlineLines do skeletonOutlineLines[i].Visible=
false end end function Helpers.clearDrawings()for player,group in pairs(State.
drawings)do for _,drawing in pairs(group)do if type(drawing)=='table'then for _,
line in pairs(drawing)do line:Remove()end else drawing:Remove()end end State.
drawings[player]=nil State.smoothCache[player]=nil end end function Helpers.
clearHighlights()for player,highlight in pairs(State.highlights)do if highlight
~=nil then(highlight):Destroy()end State.highlights[player]=nil State.
smoothCache[player]=nil end end function Helpers.clearAll()Helpers.
clearDrawings()Helpers.clearHighlights()end function Helpers.removePlayer(player
)local group=State.drawings[player]if group then for _,drawing in pairs(group)do
if type(drawing)=='table'then for _,line in pairs(drawing)do line:Remove()end
else drawing:Remove()end end State.drawings[player]=nil end local highlight=
State.highlights[player]if highlight~=nil then(highlight):Destroy()State.
highlights[player]=nil end State.smoothCache[player]=nil end function Helpers.
ensurePlayerDrawings(player)local existing=State.drawings[player]if existing
then return existing end local lib=ExecutorUtils.getDrawingLib()if not lib then
return nil end local group={name=lib.new('Text'),weapon=lib.new('Text'),distance
=lib.new('Text'),boxOutline=lib.new('Square'),box=lib.new('Square'),
healthbarOutline=lib.new('Square'),healthbar=lib.new('Square'),skeleton={},
skeletonOutline={}}for _,key in ipairs({'name','weapon','distance'})do group[key
].Center=true group[key].Outline=true group[key].Visible=false end for _,key in
ipairs({'box','boxOutline','healthbar','healthbarOutline'})do group[key].Visible
=false group[key].Filled=false end group.healthbar.Filled=true group.
healthbarOutline.Filled=true for _=1,16 do local line=lib.new('Line')line.
Visible=false table.insert(group.skeleton,line)local outline=lib.new('Line')
outline.Visible=false table.insert(group.skeletonOutline,outline)end State.
drawings[player]=group return group end function Helpers.updateHighlight(player,
character)if not State.settings.shouldShowHighlight then local highlight=State.
highlights[player]if highlight then highlight:Destroy()State.highlights[player]=
nil end return end local highlight=State.highlights[player]if not highlight then
local created=Instance.new('Highlight')created.Name='BlossomHighlight'created.
FillTransparency=0.5 created.OutlineTransparency=0 created.Parent=game:
GetService('CoreGui')State.highlights[player]=created highlight=created end if
not highlight then return end local activeHighlight=highlight local adornee=
character if adornee:IsA('Model')then local rootPart=adornee:FindFirstChild(
'HumanoidRootPart')if rootPart and rootPart:IsA('BasePart')then adornee=rootPart
end end if activeHighlight.Adornee~=adornee then activeHighlight.Adornee=adornee
end activeHighlight.FillColor=State.settings.highlightFill activeHighlight.
OutlineColor=State.settings.highlightOutline activeHighlight.Enabled=true end
function Helpers.render()local settings=State.settings local overrideCheck=State
.overrideCheck if overrideCheck and not overrideCheck()then if State.
isEspPreviouslyEnabled then Helpers.clearAll()State.isEspPreviouslyEnabled=false
end return end if not settings.isEspEnabled then if State.isEspPreviouslyEnabled
then Helpers.clearAll()State.isEspPreviouslyEnabled=false end return end State.
isEspPreviouslyEnabled=true local camera=PlayerUtils.getCamera()local
localPlayer=Players.LocalPlayer if not localPlayer then return end if not
TeamUtils.isInDuel(localPlayer)then if State.isEspPreviouslyEnabled then Helpers
.clearAll()State.isEspPreviouslyEnabled=false end return end local now=os.clock(
)local shouldUpdateSkeleton=now-State.lastSkeletonUpdate>=Constants.
ESP_SKELETON_INTERVAL if shouldUpdateSkeleton then State.lastSkeletonUpdate=now
end local shouldUpdateText=now-State.lastTextUpdate>=Constants.ESP_TEXT_INTERVAL
if shouldUpdateText then State.lastTextUpdate=now end for _,player in ipairs(
Players:GetPlayers())do if player==localPlayer or(localPlayer.Character and
player.Character==localPlayer.Character)then continue end if not TeamUtils.
isInSameDuel(localPlayer,player)then Helpers.removePlayer(player)continue end
local character=player.Character local humanoid=character and character:
FindFirstChildOfClass('Humanoid')local root=character and character:
FindFirstChild('HumanoidRootPart')if not character or not root or not humanoid
or humanoid.Health<=0 then Helpers.removePlayer(player)continue end if not
settings.shouldShowTeammates and TeamUtils.isSameTeam(player,localPlayer)then
Helpers.removePlayer(player)continue end local group=Helpers.
ensurePlayerDrawings(player)if not group then continue end local rootPart=root
local distance=(rootPart.Position-camera.CFrame.Position).Magnitude local _,
onScreen=camera:WorldToViewportPoint(rootPart.Position)if not onScreen then
_setGroupVisible(group,false)local highlight=State.highlights[player]if
highlight then highlight.Enabled=false end continue end Helpers.updateHighlight(
player,character)local rootPos=camera:WorldToViewportPoint(rootPart.Position)
local legPos=camera:WorldToViewportPoint(rootPart.Position-Vector3.new(0,3,0))
local headPos=camera:WorldToViewportPoint(rootPart.Position+Vector3.new(0,2,0))
local height=math.abs(headPos.Y-legPos.Y)*1.5 local width=height*0.6 local
boxPos=Vector2.new(rootPos.X-width/2,rootPos.Y-height/2)local boxSize=Vector2.
new(width,height)local smooth=State.smoothCache[player]if not smooth then smooth
={rootPos=Vector2.new(rootPos.X,rootPos.Y),boxPos=boxPos,boxSize=boxSize}State.
smoothCache[player]=smooth end local alpha=Constants.ESP_SMOOTH_ALPHA smooth.
rootPos=_lerpVector2(smooth.rootPos,Vector2.new(rootPos.X,rootPos.Y),alpha)
smooth.boxPos=_lerpVector2(smooth.boxPos,boxPos,alpha)smooth.boxSize=
_lerpVector2(smooth.boxSize,boxSize,alpha)local smoothedRootPos=smooth.rootPos
local smoothedBoxPos=smooth.boxPos local smoothedBoxSize=smooth.boxSize if
settings.shouldShowBoxes then group.boxOutline.Size=smoothedBoxSize group.
boxOutline.Position=smoothedBoxPos group.boxOutline.Color=settings.
boxOutlineColor group.boxOutline.Thickness=settings.boxThickness+2 group.
boxOutline.Visible=true group.boxOutline.ZIndex=1 group.box.Size=smoothedBoxSize
group.box.Position=smoothedBoxPos group.box.Color=settings.boxColor group.box.
Thickness=settings.boxThickness group.box.Visible=true group.box.ZIndex=2 else
group.box.Visible=false group.boxOutline.Visible=false end if settings.
shouldShowHealthbar then local healthPerc=math.clamp(humanoid.Health/humanoid.
MaxHealth,0,1)local barHeight=smoothedBoxSize.Y*healthPerc group.
healthbarOutline.Size=Vector2.new(4,smoothedBoxSize.Y+2)group.healthbarOutline.
Position=Vector2.new(smoothedBoxPos.X-6,smoothedBoxPos.Y-1)group.
healthbarOutline.Color=settings.healthbarOutlineColor group.healthbarOutline.
Filled=true group.healthbarOutline.Visible=true group.healthbarOutline.ZIndex=1
group.healthbar.Size=Vector2.new(2,barHeight)group.healthbar.Position=Vector2.
new(smoothedBoxPos.X-5,smoothedBoxPos.Y+(smoothedBoxSize.Y-barHeight))group.
healthbar.Color=settings.healthbarColor:Lerp(Color3.new(1,0,0),1-healthPerc)
group.healthbar.Filled=true group.healthbar.Visible=true group.healthbar.ZIndex=
2 else group.healthbar.Visible=false group.healthbarOutline.Visible=false end if
shouldUpdateText then local textOffset=0 if settings.shouldShowNames then group.
name.Text=player.DisplayName or player.Name group.name.Size=settings.textSize
group.name.Color=settings.textColor group.name.Outline=settings.shouldOutline
group.name.OutlineColor=settings.nameOutlineColor group.name.Position=Vector2.
new(smoothedRootPos.X,smoothedBoxPos.Y-settings.textSize-2)group.name.Visible=
true else group.name.Visible=false end if settings.shouldShowWeapon then local
tool=character:FindFirstChildOfClass('Tool')if tool then group.weapon.Text=tool.
Name group.weapon.Size=settings.textSize group.weapon.Color=settings.weaponColor
group.weapon.Outline=settings.shouldOutline group.weapon.OutlineColor=settings.
weaponOutlineColor group.weapon.Position=Vector2.new(smoothedRootPos.X,
smoothedBoxPos.Y+smoothedBoxSize.Y+2+textOffset)group.weapon.Visible=true
textOffset+=settings.textSize else group.weapon.Visible=false end else group.
weapon.Visible=false end if settings.shouldShowDistance then group.distance.Text
=tostring(math.floor(distance))..' studs'group.distance.Size=settings.textSize
group.distance.Color=settings.distanceColor group.distance.Outline=settings.
shouldOutline group.distance.OutlineColor=settings.distanceOutlineColor group.
distance.Position=Vector2.new(smoothedRootPos.X,smoothedBoxPos.Y+smoothedBoxSize
.Y+2+textOffset)group.distance.Visible=true textOffset+=settings.textSize else
group.distance.Visible=false end end if settings.shouldShowSkeleton then if
shouldUpdateSkeleton then _updateSkeleton(group.skeleton,group.skeletonOutline,
character)end else for _,line in pairs(group.skeleton)do line.Visible=false end
for _,line in pairs(group.skeletonOutline)do line.Visible=false end end end end
return Helpers end function __DARKLUA_BUNDLE_MODULES.j()local v=
__DARKLUA_BUNDLE_MODULES.cache.j if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.j=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local
Maid=(__DARKLUA_BUNDLE_MODULES.a())local Helpers=__DARKLUA_BUNDLE_MODULES.j()
local State=__DARKLUA_BUNDLE_MODULES.i()local Types=__DARKLUA_BUNDLE_MODULES.h()
local Constants=__DARKLUA_BUNDLE_MODULES.g()local ESP_RENDER_INTERVAL=Constants.
ESP_RENDER_INTERVAL local Visuals={}Visuals.__index=Visuals local _maid=nil
local _signals={}local _state={lastRender=0}local function _connect()_maid:
DoCleaning()local removeConn=Players.PlayerRemoving:Connect(function(player)
Helpers.removePlayer(player)end)_maid:GiveTask(removeConn)local renderConn=
RunService.RenderStepped:Connect(function()local now=os.clock()if now-_state.
lastRender<ESP_RENDER_INTERVAL then return end _state.lastRender=now Helpers.
render()end)_maid:GiveTask(renderConn)end local function _enable()if not
ExecutorUtils.getDrawingLib()then State.isEnabled=false return end _connect()end
local function _disable()_maid:DoCleaning()Helpers.clearAll()end function
Visuals.init(self,client)State.client=client State.logger=client.Logger _maid=
Maid.new()end function Visuals.Destroy(self)State.isEnabled=false _disable()end
function Visuals.toggle(self,isEnabled)if State.isEnabled==isEnabled then return
end State.isEnabled=isEnabled if isEnabled then _enable()else _disable()end end
function Visuals.setEspEnabled(self,isEnabled)State.settings.isEspEnabled=
isEnabled if not isEnabled then Helpers.clearAll()end end function Visuals.
setShowNames(self,shouldShow)State.settings.shouldShowNames=shouldShow end
function Visuals.setShowWeapon(self,shouldShow)State.settings.shouldShowWeapon=
shouldShow end function Visuals.setShowDistance(self,shouldShow)State.settings.
shouldShowDistance=shouldShow end function Visuals.setShowBoxes(self,shouldShow)
State.settings.shouldShowBoxes=shouldShow end function Visuals.setShowSkeleton(
self,shouldShow)State.settings.shouldShowSkeleton=shouldShow end function
Visuals.setShowHealthbar(self,shouldShow)State.settings.shouldShowHealthbar=
shouldShow end function Visuals.setShowHighlight(self,shouldShow)State.settings.
shouldShowHighlight=shouldShow if not shouldShow then Helpers.clearHighlights()
end end function Visuals.setShowTeammates(self,shouldShow)State.settings.
shouldShowTeammates=shouldShow end function Visuals.setBoxColor(self,color)State
.settings.boxColor=color end function Visuals.setTextColor(self,color)State.
settings.textColor=color end function Visuals.setWeaponColor(self,color)State.
settings.weaponColor=color end function Visuals.setDistanceColor(self,color)
State.settings.distanceColor=color end function Visuals.setSkeletonColor(self,
color)State.settings.skeletonColor=color end function Visuals.setHealthbarColor(
self,color)State.settings.healthbarColor=color end function Visuals.
setHealthbarOutlineColor(self,color)State.settings.healthbarOutlineColor=color
end function Visuals.setNameOutlineColor(self,color)State.settings.
nameOutlineColor=color end function Visuals.setWeaponOutlineColor(self,color)
State.settings.weaponOutlineColor=color end function Visuals.
setDistanceOutlineColor(self,color)State.settings.distanceOutlineColor=color end
function Visuals.setBoxOutlineColor(self,color)State.settings.boxOutlineColor=
color end function Visuals.setSkeletonOutlineColor(self,color)State.settings.
skeletonOutlineColor=color end function Visuals.setHighlightFill(self,color)
State.settings.highlightFill=color end function Visuals.setHighlightOutline(self
,color)State.settings.highlightOutline=color end function Visuals.
setBoxThickness(self,value)State.settings.boxThickness=value end function
Visuals.setSkeletonThickness(self,value)State.settings.skeletonThickness=value
end function Visuals.setTextSize(self,value)State.settings.textSize=value end
function Visuals.setOutline(self,isEnabled)State.settings.shouldOutline=
isEnabled end function Visuals.setOverrideCheck(self,check)State.overrideCheck=
check end return Visuals end function __DARKLUA_BUNDLE_MODULES.k()local v=
__DARKLUA_BUNDLE_MODULES.cache.k if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.k=v end return v.c end end do local function
__modImpl()local Constants={DEFAULT_FLY_SPEED=50,INPUT_MAP={[Enum.KeyCode.W]=
'forward',[Enum.KeyCode.S]='back',[Enum.KeyCode.A]='left',[Enum.KeyCode.D]=
'right',[Enum.KeyCode.Space]='up',[Enum.KeyCode.LeftControl]='down'}}return
Constants end function __DARKLUA_BUNDLE_MODULES.l()local v=
__DARKLUA_BUNDLE_MODULES.cache.l if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.l=v end return v.c end end do local function
__modImpl()return{}end function __DARKLUA_BUNDLE_MODULES.m()local v=
__DARKLUA_BUNDLE_MODULES.cache.m if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.m=v end return v.c end end do local function
__modImpl()local Constants=__DARKLUA_BUNDLE_MODULES.l()local Types=
__DARKLUA_BUNDLE_MODULES.m()local _maid=nil local _signals={}local _state={
client=nil,logger=nil,character=nil,humanoid=nil,rootPart=nil,isFlyEnabled=false
,isNoclipEnabled=false,isWalkSpeedEnabled=false,isJumpPowerEnabled=false,
walkSpeedValue=16,jumpPowerValue=50,flySpeed=Constants.DEFAULT_FLY_SPEED,
defaultWalkSpeed=nil,defaultJumpPower=nil,defaultJumpHeight=nil,
defaultUseJumpPower=nil,defaultAutoRotate=nil,defaultPlatformStand=nil,
noclipParts={},characterMaid=nil,input={forward=0,back=0,left=0,right=0,up=0,
down=0},isSlideBoostEnabled=false,slideBoostMultiplier=1,spoofDevice='None',
isSpoofDeviceEnabled=false,isAntiFlashEnabled=false,isSoundSpammerEnabled=false,
soundSpammerType='DoubleJump'}return _state end function
__DARKLUA_BUNDLE_MODULES.n()local v=__DARKLUA_BUNDLE_MODULES.cache.n if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.n=v end return v.c end end
do local function __modImpl()local PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local
Constants=__DARKLUA_BUNDLE_MODULES.l()local State=__DARKLUA_BUNDLE_MODULES.n()
local Helpers={}Helpers.__index=Helpers local _maid=nil local _signals={}local
_state={cachedNoclipParts={}}function Helpers.resetInput()State.input={forward=0
,back=0,left=0,right=0,up=0,down=0}end function Helpers.cacheDefaults(humanoid)
State.defaultWalkSpeed=humanoid.WalkSpeed State.defaultUseJumpPower=humanoid.
UseJumpPower if humanoid.UseJumpPower then State.defaultJumpPower=humanoid.
JumpPower State.defaultJumpHeight=nil else State.defaultJumpPower=nil State.
defaultJumpHeight=humanoid.JumpHeight end State.defaultAutoRotate=humanoid.
AutoRotate State.defaultPlatformStand=humanoid.PlatformStand end function
Helpers.applyWalkSpeed()local humanoid=State.humanoid if not humanoid then
return end if State.defaultWalkSpeed~=nil then humanoid.WalkSpeed=State.
defaultWalkSpeed end end function Helpers.applyJumpPower()return end function
Helpers.restoreMovementDefaults()local humanoid=State.humanoid if not humanoid
then return end if State.defaultWalkSpeed~=nil then humanoid.WalkSpeed=State.
defaultWalkSpeed end if State.defaultUseJumpPower~=nil then humanoid.
UseJumpPower=State.defaultUseJumpPower end if State.defaultUseJumpPower then if
State.defaultJumpPower~=nil then humanoid.JumpPower=State.defaultJumpPower end
else if State.defaultJumpHeight~=nil then humanoid.JumpHeight=State.
defaultJumpHeight end end if State.defaultAutoRotate~=nil then humanoid.
AutoRotate=State.defaultAutoRotate end if State.defaultPlatformStand~=nil then
humanoid.PlatformStand=State.defaultPlatformStand end end function Helpers.
setCharacter(character)State.character=character State.humanoid=nil State.
rootPart=nil if not character then return end local humanoid=character:
FindFirstChildOfClass('Humanoid')if not humanoid then humanoid=(character:
WaitForChild('Humanoid',5))end local rootPart=character:FindFirstChild(
'HumanoidRootPart')if not rootPart then rootPart=character:WaitForChild(
'HumanoidRootPart',5)end if humanoid then State.humanoid=humanoid Helpers.
cacheDefaults(humanoid)end if rootPart and rootPart:IsA('BasePart')then State.
rootPart=rootPart end Helpers.applyWalkSpeed()Helpers.applyJumpPower()end
function Helpers.applyNoclip()local character=State.character if not character
then return end if#_state.cachedNoclipParts==0 then for _,part in ipairs(
character:GetDescendants())do if part:IsA('BasePart')then table.insert(_state.
cachedNoclipParts,part)end end end for _,part in ipairs(_state.cachedNoclipParts
)do if part:IsA('BasePart')then if State.noclipParts[part]==nil then State.
noclipParts[part]=part.CanCollide end part.CanCollide=false end end end function
Helpers.restoreNoclip()_state.cachedNoclipParts={}for part,original in pairs(
State.noclipParts)do if part and part.Parent then part.CanCollide=original end
end State.noclipParts={}end function Helpers.applyFlyState()local humanoid=State
.humanoid if not humanoid then return end if State.isFlyEnabled then humanoid.
PlatformStand=false humanoid.AutoRotate=true else local rootPart=State.rootPart
if rootPart then rootPart.AssemblyLinearVelocity=Vector3.zero rootPart.
AssemblyAngularVelocity=Vector3.zero end if State.defaultPlatformStand~=nil then
humanoid.PlatformStand=State.defaultPlatformStand end if State.defaultAutoRotate
~=nil then humanoid.AutoRotate=State.defaultAutoRotate end end end function
Helpers.getFlyMoveVector()local camera=PlayerUtils.getCamera()local forward=
camera.CFrame.LookVector local right=camera.CFrame.RightVector local up=camera.
CFrame.UpVector local move=forward*(State.input.forward-State.input.back)+right*
(State.input.right-State.input.left)+up*(State.input.up-State.input.down)if move
.Magnitude>1 then move=move.Unit end return move end function Helpers.
onCharacterAdded(character)Helpers.resetInput()Helpers.setCharacter(character)
_state.cachedNoclipParts={}if State.isFlyEnabled then Helpers.applyFlyState()end
if State.isNoclipEnabled then Helpers.applyNoclip()end end function Helpers.
onCharacterRemoving()Helpers.restoreNoclip()if State.characterMaid then State.
characterMaid:DoCleaning()State.characterMaid=nil end Helpers.resetInput()State.
character=nil State.humanoid=nil State.rootPart=nil end function Helpers.
onInputChanged(input,isPressed)local keyName=Constants.INPUT_MAP[input.KeyCode]
if not keyName then return end State.input[keyName]=isPressed and 1 or 0 end
function Helpers.getReplicatedClassModule()local replicatedStorage=game:
GetService('ReplicatedStorage')local modules=replicatedStorage:WaitForChild(
'Modules',5)if not modules then return nil end local replicatedClass=modules:
WaitForChild('ReplicatedClass',5)if not replicatedClass then return nil end
local success,result=pcall(function()local dynamicRequire=require return
dynamicRequire(replicatedClass)end)return success and result or nil end function
Helpers.getControlsController()local player=PlayerUtils.getLocalPlayer()if not
player then return nil end local playerScripts=player:WaitForChild(
'PlayerScripts',5)if not playerScripts then return nil end local controllers=
playerScripts:WaitForChild('Controllers',5)if not controllers then return nil
end local controlsController=controllers:WaitForChild('ControlsController',5)if
not controlsController then return nil end local success,result=pcall(function()
local dynamicRequire=require return dynamicRequire(controlsController)end)return
success and result or nil end function Helpers.getFlashedModule()local player=
PlayerUtils.getLocalPlayer()if not player then return nil end local
playerScripts=player:WaitForChild('PlayerScripts',5)if not playerScripts then
return nil end local modules=playerScripts:WaitForChild('Modules',5)if not
modules then return nil end local clientReplicatedClasses=modules:WaitForChild(
'ClientReplicatedClasses',5)if not clientReplicatedClasses then return nil end
local clientFighter=clientReplicatedClasses:WaitForChild('ClientFighter',5)if
not clientFighter then return nil end local fighterInterface=clientFighter:
WaitForChild('FighterInterface',5)if not fighterInterface then return nil end
local flashed=fighterInterface:WaitForChild('Flashed',5)if not flashed then
return nil end local success,result=pcall(function()local dynamicRequire=require
return dynamicRequire(flashed)end)return success and result or nil end function
Helpers.getMechanicsController()local player=PlayerUtils.getLocalPlayer()if not
player then return nil end local playerScripts=player:WaitForChild(
'PlayerScripts',5)if not playerScripts then return nil end local controllers=
playerScripts:WaitForChild('Controllers',5)if not controllers then return nil
end local mechanicsController=controllers:WaitForChild('MechanicsController',5)
if not mechanicsController then return nil end local success,result=pcall(
function()local dynamicRequire=require return dynamicRequire(mechanicsController
)end)return success and result or nil end function Helpers.getSetControlsRemote(
)local replicatedStorage=game:GetService('ReplicatedStorage')local remotes=
replicatedStorage:WaitForChild('Remotes',5)if not remotes then return nil end
local replication=remotes:WaitForChild('Replication',5)if not replication then
return nil end local fighter=replication:WaitForChild('Fighter',5)if not fighter
then return nil end return fighter:WaitForChild('SetControls',5)end function
Helpers.getPlayMechanicsSoundRemote()local replicatedStorage=game:GetService(
'ReplicatedStorage')local remotes=replicatedStorage:WaitForChild('Remotes',5)if
not remotes then return nil end local replication=remotes:WaitForChild(
'Replication',5)if not replication then return nil end local fighter=replication
:WaitForChild('Fighter',5)if not fighter then return nil end return fighter:
WaitForChild('PlayMechanicsSound',5)end return Helpers end function
__DARKLUA_BUNDLE_MODULES.o()local v=__DARKLUA_BUNDLE_MODULES.cache.o if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.o=v end return v.c end end
do local function __modImpl()local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()
local HookUtils={}HookUtils.__index=HookUtils local _maid=nil local _state={}
local _signals={}function HookUtils.safeHook(targetTable,targetKey,replacement,
logger,maid)local targetFunc=targetTable[targetKey]if not targetFunc or type(
targetFunc)~='function'then return nil end local hookfunction=ExecutorUtils.
getGlobal('hookfunction')or ExecutorUtils.getGlobal('replaceclosure')local
newcclosure=ExecutorUtils.getGlobal('newcclosure')or function(f)return f end
local wrapped=newcclosure(replacement)if hookfunction then local success,old=
pcall(function()return hookfunction(targetFunc,wrapped)end)if success then if
maid then maid:GiveTask(function()local restoreHook=ExecutorUtils.getGlobal(
'hookfunction')or ExecutorUtils.getGlobal('replaceclosure')if restoreHook then
pcall(function()restoreHook(targetFunc,old)end)else targetTable[targetKey]=old
end end)end return old end if logger and logger.warnUnsupported then logger:
warnUnsupported('hookfunction')elseif logger then logger:warn(
[[This executor does not support 'hookfunction'. Some features may not work as expected.]]
)end else if logger and logger.warnUnsupported then logger:warnUnsupported(
'hookfunction')elseif logger then logger:warn(
[[This executor does not support 'hookfunction'. Some features may not work as expected.]]
)end end targetTable[targetKey]=wrapped if maid then maid:GiveTask(function()if
targetTable[targetKey]==wrapped then targetTable[targetKey]=targetFunc end end)
end return targetFunc end return HookUtils end function __DARKLUA_BUNDLE_MODULES
.p()local v=__DARKLUA_BUNDLE_MODULES.cache.p if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.p=v end return v.c end end do local function
__modImpl()local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local HookUtils=
__DARKLUA_BUNDLE_MODULES.p()local State=__DARKLUA_BUNDLE_MODULES.n()local
Helpers=__DARKLUA_BUNDLE_MODULES.o()local PlayerMods={}PlayerMods.__index=
PlayerMods local _maid=nil local _signals={}local _state={lastSoundSpam=0}
function PlayerMods.setup(maid)_maid=maid local checkcaller=ExecutorUtils.
getGlobal('checkcaller')or function()return false end local isRunning=true if
_maid then _maid:GiveTask(function()isRunning=false end)end task.spawn(function(
)if not isRunning then return end local replicatedClassMod=Helpers.
getReplicatedClassModule()if replicatedClassMod then local oldGet oldGet=
HookUtils.safeHook(replicatedClassMod,'Get',function(self,key)if not
checkcaller()then if key=='SlidingSpeedMax'and State.isSlideBoostEnabled then
return 3*State.slideBoostMultiplier end end return oldGet(self,key)end,State.
logger,_maid)end local controlsController=Helpers.getControlsController()local
setControlsRemote=Helpers.getSetControlsRemote()if controlsController and
setControlsRemote then local oldSetControls oldSetControls=HookUtils.safeHook(
controlsController,'SetControls',function(self,device)if not checkcaller()and
State.isSpoofDeviceEnabled and State.spoofDevice~='None'then device=State.
spoofDevice setControlsRemote:FireServer(device)end return oldSetControls(self,
device)end,State.logger,_maid)end task.spawn(function()local playSoundRemote=
Helpers.getPlayMechanicsSoundRemote()while isRunning do if State.
isSoundSpammerEnabled and playSoundRemote then local now=os.clock()if now-_state
.lastSoundSpam>=0.5 then _state.lastSoundSpam=now pcall(function()
playSoundRemote:FireServer(State.soundSpammerType)end)end end task.wait(0.1)end
end)local flashedMod=Helpers.getFlashedModule()if flashedMod then local
oldAttemptToFlash oldAttemptToFlash=HookUtils.safeHook(flashedMod,
'AttemptToFlash',function(self,...)if not checkcaller()and State.
isAntiFlashEnabled then return end return oldAttemptToFlash(self,...)end,State.
logger,_maid)local oldFlash oldFlash=HookUtils.safeHook(flashedMod,'Flash',
function(self,...)if not checkcaller()and State.isAntiFlashEnabled then return
end return oldFlash(self,...)end,State.logger,_maid)end end)end return
PlayerMods end function __DARKLUA_BUNDLE_MODULES.q()local v=
__DARKLUA_BUNDLE_MODULES.cache.q if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.q=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local UserInputService=game:GetService(
'UserInputService')local Workspace=game:GetService('Workspace')local Maid=(
__DARKLUA_BUNDLE_MODULES.a())local Helpers=__DARKLUA_BUNDLE_MODULES.o()local
PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local State=__DARKLUA_BUNDLE_MODULES.n()
local Types=__DARKLUA_BUNDLE_MODULES.m()local PlayerMods=
__DARKLUA_BUNDLE_MODULES.q()local NOCLIP_UPDATE_INTERVAL=0.1 local Player={}
Player.__index=Player local _maid=nil local _signals={}local _state={
lastNoclipUpdate=0,hasRenderLoop=false,hasSteppedLoop=false}local function
_connect()_maid:DoCleaning()local function _bindCharacter()if State.
characterMaid then State.characterMaid:DoCleaning()end State.characterMaid=Maid.
new()local humanoid=State.humanoid local rootPart=State.rootPart if humanoid and
rootPart then local stateConn=humanoid.StateChanged:Connect(function(_,newState)
if not State.isJumpPowerEnabled then return end if newState==Enum.
HumanoidStateType.Jumping then local current=rootPart.AssemblyLinearVelocity
local jumpVelocity=State.jumpPowerValue if current.Y<jumpVelocity then rootPart.
AssemblyLinearVelocity=Vector3.new(current.X,jumpVelocity,current.Z)end end end)
State.characterMaid:GiveTask(stateConn)end end local function
_handleCharacterAdded(character)Helpers.onCharacterAdded(character)
_bindCharacter()end local function _handleCharacterRemoving()Helpers.
onCharacterRemoving()end local function _attachPlayer(player)local addedConn=
player.CharacterAdded:Connect(function(character)_handleCharacterAdded(character
)end)_maid:GiveTask(addedConn)local removingConn=player.CharacterRemoving:
Connect(function()_handleCharacterRemoving()end)_maid:GiveTask(removingConn)if
player.Character then _handleCharacterAdded(player.Character)end end local
player=PlayerUtils.getLocalPlayer()if player then _attachPlayer(player)else
local playerAddedConn=Players.PlayerAdded:Connect(function(addedPlayer)if
addedPlayer==PlayerUtils.getLocalPlayer()then _attachPlayer(addedPlayer)end end)
_maid:GiveTask(playerAddedConn)end local inputBeganConn=UserInputService.
InputBegan:Connect(function(input,processed)if processed then return end Helpers
.onInputChanged(input,true)end)_maid:GiveTask(inputBeganConn)local
inputEndedConn=UserInputService.InputEnded:Connect(function(input,processed)if
processed then return end Helpers.onInputChanged(input,false)end)_maid:GiveTask(
inputEndedConn)local renderConn=RunService.RenderStepped:Connect(function()if
not State.isFlyEnabled then local rootPart=State.rootPart local humanoid=State.
humanoid if rootPart and humanoid and State.isWalkSpeedEnabled then local
moveDir=humanoid.MoveDirection local horizontal=Vector3.new(moveDir.X,0,moveDir.
Z)if horizontal.Magnitude>0 then horizontal=horizontal.Unit*State.walkSpeedValue
end local current=rootPart.AssemblyLinearVelocity rootPart.
AssemblyLinearVelocity=Vector3.new(horizontal.X,current.Y,horizontal.Z)end
return end local rootPart=State.rootPart if not rootPart then return end local
move=Helpers.getFlyMoveVector()rootPart.AssemblyLinearVelocity=move*State.
flySpeed rootPart.AssemblyAngularVelocity=Vector3.zero local camera=Workspace.
CurrentCamera if camera then local look=Vector3.new(camera.CFrame.LookVector.X,0
,camera.CFrame.LookVector.Z)if look.Magnitude>0.001 then rootPart.CFrame=CFrame.
new(rootPart.Position,rootPart.Position+look)end end end)_maid:GiveTask(
renderConn)_state.hasRenderLoop=true local steppedConn=RunService.Stepped:
Connect(function()if State.isNoclipEnabled then local now=os.clock()if now-
_state.lastNoclipUpdate>=NOCLIP_UPDATE_INTERVAL then _state.lastNoclipUpdate=now
Helpers.applyNoclip()end end end)_maid:GiveTask(steppedConn)_state.
hasSteppedLoop=true end function Player.init(self,client)State.client=client
State.logger=client.Logger _maid=Maid.new()_connect()PlayerMods.setup(_maid)end
function Player.Destroy(self)State.isFlyEnabled=false State.isNoclipEnabled=
false State.isWalkSpeedEnabled=false State.isJumpPowerEnabled=false Helpers.
restoreNoclip()Helpers.restoreMovementDefaults()if _maid then _maid:DoCleaning()
end end function Player.setFlyEnabled(self,isEnabled)if State.isFlyEnabled==
isEnabled then return end State.isFlyEnabled=isEnabled Helpers.applyFlyState()
end function Player.setNoclipEnabled(self,isEnabled)if State.isNoclipEnabled==
isEnabled then return end State.isNoclipEnabled=isEnabled if not isEnabled then
Helpers.restoreNoclip()else Helpers.applyNoclip()end end function Player.
setWalkSpeedEnabled(self,isEnabled)if State.isWalkSpeedEnabled==isEnabled then
return end State.isWalkSpeedEnabled=isEnabled Helpers.applyWalkSpeed()end
function Player.setJumpPowerEnabled(self,isEnabled)if State.isJumpPowerEnabled==
isEnabled then return end State.isJumpPowerEnabled=isEnabled Helpers.
applyJumpPower()end function Player.setWalkSpeed(self,value)State.walkSpeedValue
=value Helpers.applyWalkSpeed()end function Player.setJumpPower(self,value)State
.jumpPowerValue=value Helpers.applyJumpPower()end function Player.setFlySpeed(
self,value)State.flySpeed=value end function Player.setSlideBoostEnabled(self,
isEnabled)State.isSlideBoostEnabled=isEnabled end function Player.
setSlideBoostMultiplier(self,multiplier)State.slideBoostMultiplier=multiplier
end function Player.setSpoofDevice(self,device)State.spoofDevice=device local
setControlsRemote=Helpers.getSetControlsRemote()if setControlsRemote and State.
isSpoofDeviceEnabled and device~='None'then setControlsRemote:FireServer(device)
end end function Player.setSpoofDeviceEnabled(self,isEnabled)State.
isSpoofDeviceEnabled=isEnabled local setControlsRemote=Helpers.
getSetControlsRemote()if setControlsRemote and isEnabled and State.spoofDevice~=
'None'then setControlsRemote:FireServer(State.spoofDevice)end end function
Player.setAntiFlashEnabled(self,isEnabled)State.isAntiFlashEnabled=isEnabled end
function Player.setSoundSpammerEnabled(self,isEnabled)State.
isSoundSpammerEnabled=isEnabled end function Player.setSoundSpammerType(self,
soundType)State.soundSpammerType=soundType end return Player end function
__DARKLUA_BUNDLE_MODULES.r()local v=__DARKLUA_BUNDLE_MODULES.cache.r if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.r=v end return v.c end end
do local function __modImpl()return{}end function __DARKLUA_BUNDLE_MODULES.s()
local v=__DARKLUA_BUNDLE_MODULES.cache.s if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.s=v end return v.c end end do local function
__modImpl()local TARGETING_UPDATE_INTERVAL=1/30 local Constants={
TARGETING_UPDATE_INTERVAL=TARGETING_UPDATE_INTERVAL,FOV_CIRCLE_COLOR=Color3.
fromRGB(255,255,255),FOV_CIRCLE_THICKNESS=1,FOV_CIRCLE_NUM_SIDES=64,
MIN_AIM_SPEED=4,MAX_AIM_SPEED=40,MAX_SMOOTHNESS=1,TARGET_DROP_DELAY=0.15,
TARGET_DROP_FOV_MULTIPLIER=1.2,AIMBOT_RENDER_STEP_NAME='CombatAimbot'}return
Constants end function __DARKLUA_BUNDLE_MODULES.t()local v=
__DARKLUA_BUNDLE_MODULES.cache.t if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.t=v end return v.c end end do local function
__modImpl()local Types=__DARKLUA_BUNDLE_MODULES.s()local Constants=
__DARKLUA_BUNDLE_MODULES.t()local _maid=nil local _signals={}local _state={
client=nil,logger=nil,isAimbotEnabled=false,isSilentAimEnabled=false,
isRagebotEnabled=false,isFovEnabled=true,isSilentAimFovEnabled=true,fovRadius=
100,silentAimFovRadius=100,fovColor=Constants.FOV_CIRCLE_COLOR,silentAimFovColor
=Constants.FOV_CIRCLE_COLOR,fovTransparency=0,silentAimFovTransparency=0,
silentHitChance=100,targetPart='Head',isManipulationEnabled=false,
isAntiKatanaEnabled=false,isClosestPositionEnabled=true,closestPositionWhitelist
={'Head','UpperTorso','LowerTorso','LeftUpperArm','RightUpperArm','LeftUpperLeg'
,'RightUpperLeg','LowerTorso'},isWallCheckEnabled=false,smoothness=0,
isNoRecoilEnabled=false,isNoSpreadEnabled=false,isNoMuzzleFlashEnabled=false,
attackCooldownMultiplier=100,isMeleeAttackCooldownEnabled=false,
meleeAttackCooldownMultiplier=100,isMeleeSkillCooldownEnabled=false,
meleeSkillCooldownMultiplier=100,isMeleeAuraEnabled=false,isTeleportAuraEnabled=
false,target=nil,silentTarget=nil,targetLostAt=nil,silentTargetLostAt=nil,
fovCircle=nil,silentAimFovCircle=nil,cameraController=nil,fighterController=nil,
isRemoteHooked=false,isUtilityHooked=false,isCameraShakerHooked=false,
isGunModsHooked=false,isInputLocked=false,mouseBehavior=nil,
mouseDeltaSensitivity=nil,ragebotSavedSilentAimEnabled=nil,
ragebotSavedAttackCooldownMultiplier=nil}return _state end function
__DARKLUA_BUNDLE_MODULES.u()local v=__DARKLUA_BUNDLE_MODULES.cache.u if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.u=v end return v.c end end
do local function __modImpl()local Players=game:GetService('Players')local
UserInputService=game:GetService('UserInputService')local ReplicatedStorage=game
:GetService('ReplicatedStorage')local PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()
local State=__DARKLUA_BUNDLE_MODULES.u()local Constants=__DARKLUA_BUNDLE_MODULES
.t()local Helpers={}Helpers.__index=Helpers local _maid=nil local _signals={}
local _state={}function Helpers.getUtility()local modules=ReplicatedStorage:
WaitForChild('Modules',5)if not modules then return nil end local utility=
modules:WaitForChild('Utility',5)if not utility then return nil end local
success,result=pcall(function()local dynamicRequire=require return
dynamicRequire(utility)end)return success and result or nil end function Helpers
.getGameplayUtility()local modules=ReplicatedStorage:WaitForChild('Modules',5)if
not modules then return nil end local utility=modules:WaitForChild(
'GameplayUtility',5)if not utility then return nil end local success,result=
pcall(function()local dynamicRequire=require return dynamicRequire(utility)end)
return success and result or nil end function Helpers.getCameraShaker()local
localPlayer=Players.LocalPlayer if not localPlayer then return nil end local
playerScripts=localPlayer:WaitForChild('PlayerScripts',5)if not playerScripts
then return nil end local modules=playerScripts:WaitForChild('Modules',5)if not
modules then return nil end local cameraShaker=modules:WaitForChild(
'CameraShaker',5)if not cameraShaker then return nil end local success,result=
pcall(function()local dynamicRequire=require return dynamicRequire(cameraShaker)
end)return success and result or nil end function Helpers.applyInputLock(
isLocked)if isLocked and State.smoothness<Constants.MAX_SMOOTHNESS then return
end if isLocked==State.isInputLocked then return end if isLocked then if State.
mouseBehavior==nil then State.mouseBehavior=UserInputService.MouseBehavior end
if State.mouseDeltaSensitivity==nil then State.mouseDeltaSensitivity=
UserInputService.MouseDeltaSensitivity end UserInputService.MouseBehavior=Enum.
MouseBehavior.LockCenter UserInputService.MouseDeltaSensitivity=0 else local
restoreBehavior=State.mouseBehavior or Enum.MouseBehavior.Default local
restoreSensitivity=State.mouseDeltaSensitivity or 1 UserInputService.
MouseBehavior=restoreBehavior UserInputService.MouseDeltaSensitivity=
restoreSensitivity State.mouseBehavior=nil State.mouseDeltaSensitivity=nil end
State.isInputLocked=isLocked end function Helpers.isMaxSmoothness()return State.
smoothness>=Constants.MAX_SMOOTHNESS end function Helpers.fetchCameraController(
logger)if State.cameraController then return end local player=PlayerUtils.
getLocalPlayer()if not player then return end local playerScripts=player:
WaitForChild('PlayerScripts')if not playerScripts then return end local
controllers=playerScripts:WaitForChild('Controllers')if not controllers then
return end local camControllerScript=controllers:WaitForChild('CameraController'
)if camControllerScript and camControllerScript:IsA('ModuleScript')then local
success,result=pcall(function()local dynamicRequire=require return
dynamicRequire(camControllerScript)end)if success then State.cameraController=
result else if logger then logger:error('Failed CameraController',result)end end
end end function Helpers.fetchFighterController(logger)if State.
fighterController then return end local player=PlayerUtils.getLocalPlayer()if
not player then return end local playerScripts=player:WaitForChild(
'PlayerScripts',10)if not playerScripts then return end local controllers=
playerScripts:WaitForChild('Controllers',10)if not controllers then return end
local fighterControllerScript=controllers:WaitForChild('FighterController',5)if
fighterControllerScript and fighterControllerScript:IsA('ModuleScript')then
local success,result=pcall(function()local dynamicRequire=require return
dynamicRequire(fighterControllerScript)end)if success then State.
fighterController=result end end end function Helpers.getGunModule()local player
=PlayerUtils.getLocalPlayer()if not player then return nil end local
playerScripts=player:WaitForChild('PlayerScripts',5)if not playerScripts then
return nil end local modules=playerScripts:WaitForChild('Modules',5)if not
modules then return nil end local itemTypes=modules:WaitForChild('ItemTypes',5)
if not itemTypes then return nil end local gun=itemTypes:WaitForChild('Gun',5)if
not gun then return nil end local success,result=pcall(function()local
dynamicRequire=require return dynamicRequire(gun)end)return success and result
or nil end function Helpers.getClientItemModule()local player=PlayerUtils.
getLocalPlayer()if not player then return nil end local playerScripts=player:
WaitForChild('PlayerScripts',5)if not playerScripts then return nil end local
modules=playerScripts:WaitForChild('Modules',5)if not modules then return nil
end local clientReplicatedClasses=modules:WaitForChild('ClientReplicatedClasses'
,5)if not clientReplicatedClasses then return nil end local clientFighter=
clientReplicatedClasses:WaitForChild('ClientFighter',5)if not clientFighter then
return nil end local clientItem=clientFighter:WaitForChild('ClientItem',5)if not
clientItem then return nil end local success,result=pcall(function()local
dynamicRequire=require return dynamicRequire(clientItem)end)return success and
result or nil end function Helpers.getViewModelModule()local player=PlayerUtils.
getLocalPlayer()if not player then return nil end local playerScripts=player:
WaitForChild('PlayerScripts',5)if not playerScripts then return nil end local
modules=playerScripts:WaitForChild('Modules',5)if not modules then return nil
end local clientReplicatedClasses=modules:WaitForChild('ClientReplicatedClasses'
,5)if not clientReplicatedClasses then return nil end local clientFighter=
clientReplicatedClasses:WaitForChild('ClientFighter',5)if not clientFighter then
return nil end local clientItemScript=clientFighter:WaitForChild('ClientItem',5)
if not clientItemScript then return nil end local viewModel=clientItemScript:
WaitForChild('ClientViewModel',5)if not viewModel then return nil end local
success,result=pcall(function()local dynamicRequire=require return
dynamicRequire(viewModel)end)return success and result or nil end function
Helpers.getReplicatedClassModule()local replicatedStorage=game:GetService(
'ReplicatedStorage')local modules=replicatedStorage:WaitForChild('Modules',5)if
not modules then return nil end local replicatedClass=modules:WaitForChild(
'ReplicatedClass',5)if not replicatedClass then return nil end local success,
result=pcall(function()local dynamicRequire=require return dynamicRequire(
replicatedClass)end)return success and result or nil end function Helpers.
getMeleeModule()local player=PlayerUtils.getLocalPlayer()if not player then
return nil end local playerScripts=player:WaitForChild('PlayerScripts',5)if not
playerScripts then return nil end local modules=playerScripts:WaitForChild(
'Modules',5)if not modules then return nil end local itemTypes=modules:
WaitForChild('ItemTypes',5)if not itemTypes then return nil end local melee=
itemTypes:WaitForChild('Melee',5)if not melee then return nil end local success,
result=pcall(function()local dynamicRequire=require return dynamicRequire(melee)
end)return success and result or nil end function Helpers.getItemModules()local
player=PlayerUtils.getLocalPlayer()if not player then return nil end local
playerScripts=player:WaitForChild('PlayerScripts',5)if not playerScripts then
return nil end local modules=playerScripts:WaitForChild('Modules',5)if not
modules then return nil end return modules:WaitForChild('Items',5)end return
Helpers end function __DARKLUA_BUNDLE_MODULES.v()local v=
__DARKLUA_BUNDLE_MODULES.cache.v if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.v=v end return v.c end end do local function
__modImpl()local CollectionService=game:GetService('CollectionService')local
Players=game:GetService('Players')local UserInputService=game:GetService(
'UserInputService')local Workspace=game:GetService('Workspace')local State=
__DARKLUA_BUNDLE_MODULES.u()local Constants=__DARKLUA_BUNDLE_MODULES.t()local
PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local TeamUtils=__DARKLUA_BUNDLE_MODULES
.e()local Targeting={}Targeting.__index=Targeting local _maid=nil local _signals
={}local _state={raycastParams=RaycastParams.new(),raycastFilter=table.create(2)
,cachedMouseLocation=Vector2.zero,cachedCamera=nil,lastUpdate=0}_state.
raycastParams.FilterType=Enum.RaycastFilterType.Exclude local function
_refreshCaches()local now=os.clock()if now-_state.lastUpdate<Constants.
TARGETING_UPDATE_INTERVAL then return end _state.lastUpdate=now _state.
cachedMouseLocation=UserInputService:GetMouseLocation()_state.cachedCamera=
PlayerUtils.getCamera()end local function _getMouseLocation()return _state.
cachedMouseLocation end local function _getCamera()return(_state.cachedCamera or
PlayerUtils.getCamera())end local function _getBestPartForCharacter(character,
camera,localCharacter,mouseLocation)local bestPart=nil local shortestDistSq=math
.huge local isAnyOnScreen=false local origin=camera.CFrame.Position
local function _checkPart(part)if not part:IsA('BasePart')then return end local
screenPos,onScreen=camera:WorldToViewportPoint(part.Position)if not onScreen
then if not bestPart then bestPart=part end return end if State.
isWallCheckEnabled and not State.isManipulationEnabled then _state.raycastFilter
[1]=localCharacter _state.raycastFilter[2]=character _state.raycastParams.
FilterDescendantsInstances=_state.raycastFilter local direction=part.Position-
origin local result=Workspace:Raycast(origin,direction,_state.raycastParams)if
result then return end end isAnyOnScreen=true local dx=screenPos.X-mouseLocation
.X local dy=screenPos.Y-mouseLocation.Y local distSq=(dx*dx)+(dy*dy)if distSq<
shortestDistSq then shortestDistSq=distSq bestPart=part end end if State.
isClosestPositionEnabled then for _,partName in ipairs(State.
closestPositionWhitelist)do local p=character:FindFirstChild(partName)if p then
_checkPart(p)end end else local p=character:FindFirstChild(State.targetPart)or
character:FindFirstChild('Head')if p then _checkPart(p)end end return bestPart,
isAnyOnScreen,shortestDistSq end local function _getTargetStateWithMouse(
localPlayer,player,camera,mouseLocation)if player==localPlayer then return false
,nil,false,math.huge end if not TeamUtils.isInSameDuel(localPlayer,player)then
return false,nil,false,math.huge end if TeamUtils.isSameTeam(player,localPlayer)
then return false,nil,false,math.huge end local character=player.Character if
not character then return false,nil,false,math.huge end local humanoid=character
:FindFirstChildOfClass('Humanoid')if not humanoid or humanoid.Health<=0 then
return false,nil,false,math.huge end if character:FindFirstChildOfClass(
'ForceField')then return false,nil,false,math.huge end local bestPart,
isAnyOnScreen,shortestDistSq=_getBestPartForCharacter(character,camera,
localPlayer.Character,mouseLocation)if not bestPart then return false,nil,false,
math.huge end local shortestDist=if shortestDistSq==math.huge then math.huge
else math.sqrt(shortestDistSq)return true,bestPart,isAnyOnScreen,shortestDist
end function Targeting.getTargetState(player)_refreshCaches()local camera=
_getCamera()local localPlayer=PlayerUtils.getLocalPlayer()local mouseLocation=
_getMouseLocation()return _getTargetStateWithMouse(localPlayer,player,camera,
mouseLocation)end function Targeting.getBestTarget(radius)_refreshCaches()local
localPlayer=PlayerUtils.getLocalPlayer()if not TeamUtils.isInDuel(localPlayer)
then return nil end local camera=_getCamera()local mouseLocation=
_getMouseLocation()local bestTarget=nil local shortestDistance=radius for _,
player in ipairs(Players:GetPlayers())do if player==localPlayer then continue
end local isValid,headPart,onScreen,distance=_getTargetStateWithMouse(
localPlayer,player,camera,mouseLocation)if not isValid or not headPart or not
onScreen then continue end if distance>radius then continue end if distance<
shortestDistance then shortestDistance=distance bestTarget=player end end return
bestTarget end function Targeting.resolveTarget()if State.target then local
dropRadius=State.fovRadius*Constants.TARGET_DROP_FOV_MULTIPLIER _refreshCaches()
local camera=_getCamera()local localPlayer=PlayerUtils.getLocalPlayer()local
mouseLocation=_getMouseLocation()local isValid,headPart,onScreen,distance=
_getTargetStateWithMouse(localPlayer,State.target,camera,mouseLocation)if
isValid and headPart and onScreen and distance<=dropRadius then State.
targetLostAt=nil return State.target end if not isValid or not headPart then
State.targetLostAt=nil State.target=nil else local now=os.clock()local
targetLostAt=State.targetLostAt if not targetLostAt then targetLostAt=now State.
targetLostAt=now end if now-(targetLostAt)<Constants.TARGET_DROP_DELAY then
return State.target end State.targetLostAt=nil State.target=nil end end local
newTarget=Targeting.getBestTarget(State.fovRadius)State.target=newTarget return
newTarget end function Targeting.resolveSilentTarget()if State.silentTarget then
local dropRadius=State.silentAimFovRadius*Constants.TARGET_DROP_FOV_MULTIPLIER
_refreshCaches()local camera=_getCamera()local localPlayer=PlayerUtils.
getLocalPlayer()local mouseLocation=_getMouseLocation()local isValid,headPart,
onScreen,distance=_getTargetStateWithMouse(localPlayer,State.silentTarget,camera
,mouseLocation)if isValid and headPart and onScreen and distance<=dropRadius
then State.silentTargetLostAt=nil return State.silentTarget end if not isValid
or not headPart then State.silentTargetLostAt=nil State.silentTarget=nil else
local now=os.clock()local silentTargetLostAt=State.silentTargetLostAt if not
silentTargetLostAt then silentTargetLostAt=now State.silentTargetLostAt=now end
if now-(silentTargetLostAt)<Constants.TARGET_DROP_DELAY then return State.
silentTarget end State.silentTargetLostAt=nil State.silentTarget=nil end end
local newTarget=Targeting.getBestTarget(State.silentAimFovRadius)State.
silentTarget=newTarget return newTarget end function Targeting.
getClosestSilentTarget()_refreshCaches()local camera=_getCamera()local
localPlayer=PlayerUtils.getLocalPlayer()if not TeamUtils.isInDuel(localPlayer)
then return nil end local closest=nil local closestDistSq=State.
silentAimFovRadius*State.silentAimFovRadius local mouseLocation=
_getMouseLocation()for _,entity in ipairs(CollectionService:GetTagged('Entity'))
do if entity==localPlayer.Character or entity.Name==localPlayer.Name then
continue end local player=Players:GetPlayerFromCharacter(entity)if player and
not TeamUtils.isInSameDuel(localPlayer,player)then continue end if player and
TeamUtils.isSameTeam(player,localPlayer)then continue end local hum=entity:
FindFirstChildOfClass('Humanoid')if not hum or hum.Health<=0 then continue end
local bestPart,isAnyOnScreen,distSq=_getBestPartForCharacter(entity,camera,
localPlayer.Character,mouseLocation)if not isAnyOnScreen or not bestPart then
continue end if distSq<closestDistSq then closest=bestPart closestDistSq=distSq
end end return closest end return Targeting end function
__DARKLUA_BUNDLE_MODULES.w()local v=__DARKLUA_BUNDLE_MODULES.cache.w if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.w=v end return v.c end end
do local function __modImpl()local PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local
State=__DARKLUA_BUNDLE_MODULES.u()local Constants=__DARKLUA_BUNDLE_MODULES.t()
local Helpers=__DARKLUA_BUNDLE_MODULES.v()local Aimbot={}Aimbot.__index=Aimbot
local _maid=nil local _signals={}local _state={}function Aimbot.aimAt(target,
bestPart,deltaTime)if not target.Character then return end local targetPos=(
bestPart).Position local camera=PlayerUtils.getCamera()local currentCFrame=
camera.CFrame local lookAtCFrame=CFrame.lookAt(currentCFrame.Position,targetPos)
if not State.cameraController or not State.cameraController.SetRotation then
local alpha=1 if not Helpers.isMaxSmoothness()then local speed=Constants.
MIN_AIM_SPEED+(1-State.smoothness)*(Constants.MAX_AIM_SPEED-Constants.
MIN_AIM_SPEED)alpha=1-math.exp(-speed*deltaTime)end camera.CFrame=currentCFrame:
Lerp(lookAtCFrame,alpha)return end local x,y,_=lookAtCFrame:ToOrientation()local
targetRotation=Vector2.new(x,y)if Helpers.isMaxSmoothness()then State.
cameraController:SetRotation(targetRotation)elseif State.smoothness>0 then local
currentRot=(State.cameraController.Rotation)local speed=Constants.MIN_AIM_SPEED+
(1-State.smoothness)*(Constants.MAX_AIM_SPEED-Constants.MIN_AIM_SPEED)local
alpha=1-math.exp(-speed*deltaTime)local newRot=currentRot:Lerp(targetRotation,
alpha)State.cameraController:SetRotation(newRot)else State.cameraController:
SetRotation(targetRotation)end end return Aimbot end function
__DARKLUA_BUNDLE_MODULES.x()local v=__DARKLUA_BUNDLE_MODULES.cache.x if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.x=v end return v.c end end
do local function __modImpl()local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()
local HookUtils=__DARKLUA_BUNDLE_MODULES.p()local PlayerUtils=
__DARKLUA_BUNDLE_MODULES.f()local State=__DARKLUA_BUNDLE_MODULES.u()local
Helpers=__DARKLUA_BUNDLE_MODULES.v()local Targeting=__DARKLUA_BUNDLE_MODULES.w()
local SilentAim={}SilentAim.__index=SilentAim local _maid=nil local _signals={}
local _state={lastSilentTargetPos=nil,lastSilentOrigin=nil}local function
_isGunAction()local debugGlobal=ExecutorUtils.getGlobal('debug')local traceback=
debugGlobal and debugGlobal.traceback or debug.traceback local stack=traceback()
return(stack:find('StartShooting')or stack:find('GetEntitiesFromRaycast')or
stack:find('_LocalTracers')or stack:find('_ImpactMarker'))~=nil end function
SilentAim.isGunAction()return _isGunAction()end function SilentAim.setup(maid)
_maid=maid local hookfunction=ExecutorUtils.getGlobal('hookfunction')or
ExecutorUtils.getGlobal('replaceclosure')local checkcaller=ExecutorUtils.
getGlobal('checkcaller')or function()return false end local newcclosure=
ExecutorUtils.getGlobal('newcclosure')or function(f)return f end if not
hookfunction then if State.logger and((State.logger)).warnUnsupported then((
State.logger)):warnUnsupported('hookfunction')else State.logger:warn(
[[This executor does not support 'hookfunction'. Some features may not work as expected.]]
)end return end local isRunning=true if _maid then _maid:GiveTask(function()
isRunning=false end)end task.spawn(function()if not isRunning then return end
local utility=Helpers.getUtility()if utility and not State.isUtilityHooked then
State.isUtilityHooked=true local oldRaycast oldRaycast=HookUtils.safeHook(
utility,'Raycast',function(self,origin,target,distance,filter,...)if not State.
isSilentAimEnabled then return oldRaycast(self,origin,target,distance,filter,...
)end if not checkcaller()and(distance==400 or distance==999)and _isGunAction()
then if math.random(1,100)>State.silentHitChance then _state.lastSilentTargetPos
=nil return oldRaycast(self,origin,target,distance,filter,...)end local
targetPart=Targeting.getClosestSilentTarget()local localPlayer=PlayerUtils.
getLocalPlayer()local localChar=localPlayer and localPlayer.Character if
targetPart and localChar and not targetPart:IsDescendantOf(localChar)then local
newOrigin=origin _state.lastSilentTargetPos=targetPart.Position _state.
lastSilentOrigin=newOrigin return oldRaycast(self,newOrigin,targetPart.Position,
distance,filter,...)end end _state.lastSilentTargetPos=nil _state.
lastSilentOrigin=nil return oldRaycast(self,origin,target,distance,filter,...)
end,State.logger,_maid)local oldEncode oldEncode=HookUtils.safeHook(utility,
'EncodeCFrame',function(self,cf)if not checkcaller()and State.isSilentAimEnabled
and _state.lastSilentTargetPos and _isGunAction()then local originPos=cf.
Position local newCF=CFrame.lookAt(originPos,(_state.lastSilentTargetPos))return
oldEncode(self,newCF)end return oldEncode(self,cf)end,State.logger,_maid)end
local cameraShaker=Helpers.getCameraShaker()if cameraShaker and not State.
isCameraShakerHooked then State.isCameraShakerHooked=true local mt=getmetatable(
cameraShaker.Presets)if mt and mt.__index then local oldIdx=mt.__index mt.
__index=newcclosure(function(t,k)if State.isSilentAimEnabled and(k==
'StartShooting'or k=='')then return nil end return oldIdx(t,k)end)if _maid then
_maid:GiveTask(function()mt.__index=oldIdx end)end end end end)end return
SilentAim end function __DARKLUA_BUNDLE_MODULES.y()local v=
__DARKLUA_BUNDLE_MODULES.cache.y if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.y=v end return v.c end end do local function
__modImpl()local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local
PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local TeamUtils=__DARKLUA_BUNDLE_MODULES
.e()local State=__DARKLUA_BUNDLE_MODULES.u()local Helpers=
__DARKLUA_BUNDLE_MODULES.v()local ORBIT_RADIUS=100000 local ORBIT_SPEED=12 local
TARGET_REFRESH_INTERVAL=0.05 local TELEPORT_OFFSET=Vector3.new(0,0,2)local
MOUSE_SHOT_RELEASE_DELAY=0.03 local Ragebot={}Ragebot.__index=Ragebot local
_maid=nil local _signals={}local _state={lastTargetRefresh=0,lastFighterFetch=0,
cachedTarget=nil,cachedTargetRoot=nil,lastShotAt=0,mouse1press=nil,mouse1release
=nil,mouse1click=nil}local function _getLocalRoot()local localPlayer=PlayerUtils
.getLocalPlayer()local character=localPlayer and localPlayer.Character return
character and((character:FindFirstChild('HumanoidRootPart')))or nil end
local function _isRoundStarted()local localPlayer=PlayerUtils.getLocalPlayer()if
not localPlayer then return false end if not TeamUtils.isInDuel(localPlayer)then
return false end local duel=TeamUtils.getLocalDuel()if duel and duel.Get then
local isOk,status=pcall(duel.Get,duel,'Status')if isOk and status~=nil then
return status=='RoundStarted'end end return true end local function
_getBestTarget(localRoot)local localPlayer=PlayerUtils.getLocalPlayer()if not
localPlayer then return nil,nil end if not TeamUtils.isInDuel(localPlayer)then
return nil,nil end local bestPlayer=nil local bestRoot=nil local bestDist=math.
huge for _,player in ipairs(Players:GetPlayers())do if player==localPlayer then
continue end if TeamUtils.isSameTeam(player,localPlayer)then continue end if not
TeamUtils.isInSameDuel(localPlayer,player)then continue end local character=
player.Character if not character then continue end local root=(character:
FindFirstChild('HumanoidRootPart'))local hum=character:FindFirstChildOfClass(
'Humanoid')if not root or not hum or hum.Health<=0 then continue end local dist=
(localRoot.Position-root.Position).Magnitude if dist<bestDist then bestDist=dist
bestPlayer=player bestRoot=root end end return bestPlayer,bestRoot end
local function _getLocalFighter()local now=os.clock()if now-_state.
lastFighterFetch>=0.25 then _state.lastFighterFetch=now Helpers.
fetchFighterController(State.logger)end return State.fighterController and State
.fighterController.LocalFighter end local function _isReloading(item)if not item
then return false end local isOk,value=pcall(function()if item.Get then return
item:Get('IsReloading')end return nil end)if isOk and value~=nil then return
value==true end local reloadCooldown=(item)._reload_cooldown if type(
reloadCooldown)=='number'and reloadCooldown>tick()then return true end local
isReloadingValue=(item)._is_reloading or(item).IsReloading if type(
isReloadingValue)=='boolean'then return isReloadingValue end return false end
local function _isGunItem(equipped)if not equipped then return false end local
info=equipped.Info if not info then return false end if info.Type=='Gun'then
return true end if info.Class=='Primary'or info.Class=='Secondary'then return
true end if info.ShootCooldown~=nil or info.AmmoType~=nil then return true end
return false end local function _ensureGunEquipped(localFighter)if not
localFighter then return nil end local equipped=localFighter.EquippedItem if
_isGunItem(equipped)then return equipped end return nil end local function
_refreshInputFunctions()if _state.mouse1press or _state.mouse1click then return
end _state.mouse1press=ExecutorUtils.getGlobal('mouse1press')_state.
mouse1release=ExecutorUtils.getGlobal('mouse1release')_state.mouse1click=
ExecutorUtils.getGlobal('mouse1click')end local function _tryMouseShot(equipped)
_refreshInputFunctions()if _state.mouse1click then _state.mouse1click()return
true end if _state.mouse1press and _state.mouse1release then _state.mouse1press(
)local shouldRelease=equipped.Name~='Flamethrower'if shouldRelease then task.
delay(MOUSE_SHOT_RELEASE_DELAY,function()local releaseFn=_state.mouse1release if
releaseFn then releaseFn()end end)end return true end return false end
local function _getShootCooldown(equipped)local info=equipped and equipped.Info
local baseCooldown=(info and info.ShootCooldown)or 0.1 local multiplier=State.
attackCooldownMultiplier if type(multiplier)=='number'and multiplier>0 and
multiplier<100 then baseCooldown=baseCooldown*(multiplier/100)end return math.
max(baseCooldown,0.02)end local function _equippedItemInput(localFighter,
equipped,inputName)if localFighter and localFighter.Input then localFighter:
Input(inputName)return end if equipped and equipped.Input then equipped:Input(
inputName)end end local function _shoot(localFighter)local equipped=
_ensureGunEquipped(localFighter)if not equipped or not equipped.Input then
return end local now=os.clock()local cooldown=_getShootCooldown(equipped)if now-
_state.lastShotAt<cooldown then return end _state.lastShotAt=now if
_tryMouseShot(equipped)then return end _equippedItemInput(localFighter,equipped,
'StartShooting')if equipped.Name~='Flamethrower'then task.delay(0.1,function()if
localFighter.EquippedItem==equipped and equipped.Input then _equippedItemInput(
localFighter,equipped,'FinishShooting')end end)end end local function
_teleportToTarget(localRoot,targetRoot)localRoot.CFrame=targetRoot.CFrame*CFrame
.new(TELEPORT_OFFSET)end local function _orbitTarget(localRoot,targetRoot)local
angle=os.clock()*ORBIT_SPEED local offset=Vector3.new(math.cos(angle),0,math.
sin(angle))*ORBIT_RADIUS local position=targetRoot.Position+offset localRoot.
CFrame=CFrame.new(position,targetRoot.Position)end local function _refreshTarget
(localRoot)local now=os.clock()if now-_state.lastTargetRefresh<
TARGET_REFRESH_INTERVAL then return end _state.lastTargetRefresh=now _state.
cachedTarget,_state.cachedTargetRoot=_getBestTarget(localRoot)end local function
_connect()if not _maid then return end local connection=RunService.RenderStepped
:Connect(function()if not State.isRagebotEnabled then return end if not
_isRoundStarted()then return end if not State.isSilentAimEnabled then State.
isSilentAimEnabled=true end if State.attackCooldownMultiplier>1 then State.
attackCooldownMultiplier=1 end local localRoot=_getLocalRoot()if not localRoot
then return end local localFighter=_getLocalFighter()if not localFighter then
return end _refreshTarget(localRoot)local targetRoot=_state.cachedTargetRoot if
not targetRoot then return end local equipped=_ensureGunEquipped(localFighter)if
equipped and _isReloading(equipped)then _orbitTarget(localRoot,targetRoot)return
end _teleportToTarget(localRoot,targetRoot)if equipped then _shoot(localFighter)
end end)_maid:GiveTask(connection)end function Ragebot.setup(maid)_maid=maid
_connect()end return Ragebot end function __DARKLUA_BUNDLE_MODULES.z()local v=
__DARKLUA_BUNDLE_MODULES.cache.z if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.z=v end return v.c end end do local function
__modImpl()local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()local HookUtils=
__DARKLUA_BUNDLE_MODULES.p()local State=__DARKLUA_BUNDLE_MODULES.u()local
Helpers=__DARKLUA_BUNDLE_MODULES.v()local GunMods={}GunMods.__index=GunMods
local _maid=nil local _signals={}local _state={oldShootCooldowns={}}function
GunMods.setup(maid)_maid=maid local checkcaller=ExecutorUtils.getGlobal(
'checkcaller')or function()return false end local isRunning=true if _maid then
_maid:GiveTask(function()isRunning=false end)end task.spawn(function()if not
isRunning then return end local clientItemMod=Helpers.getClientItemModule()if
clientItemMod and not State.isGunModsHooked then local oldRecoil oldRecoil=
HookUtils.safeHook(clientItemMod,'_Recoil',function(self,multiplier)if not
checkcaller()and State.isNoRecoilEnabled then return end return oldRecoil(self,
multiplier)end,State.logger,_maid)end local gameplayUtility=Helpers.
getGameplayUtility()if gameplayUtility then local oldGetSpread oldGetSpread=
HookUtils.safeHook(gameplayUtility,'GetSpread',function(self,...)if not
checkcaller()and State.isNoSpreadEnabled then return CFrame.identity end return
oldGetSpread(self,...)end,State.logger,_maid)end local viewModelMod=Helpers.
getViewModelModule()if viewModelMod then local oldMuzzleFlash oldMuzzleFlash=
HookUtils.safeHook(viewModelMod,'MuzzleFlash',function(self,...)if not
checkcaller()and State.isNoMuzzleFlashEnabled then return end return
oldMuzzleFlash(self,...)end,State.logger,_maid)end local replicatedClassMod=
Helpers.getReplicatedClassModule()if replicatedClassMod then local oldGet oldGet
=HookUtils.safeHook(replicatedClassMod,'Get',function(self,key)if not
checkcaller()and State.isNoSpreadEnabled and key=='IsAiming'and State.forcingAim
then return true end return oldGet(self,key)end,State.logger,_maid)end local
gunMod=Helpers.getGunModule()if gunMod then local oldIsFullyAiming
oldIsFullyAiming=HookUtils.safeHook(gunMod,'IsFullyAiming',function(self,...)if
not checkcaller()and State.isNoSpreadEnabled and State.forcingAim then return
true end return oldIsFullyAiming(self,...)end,State.logger,_maid)local
oldStartShooting oldStartShooting=HookUtils.safeHook(gunMod,'StartShooting',
function(self,...)if checkcaller()then return oldStartShooting(self,...)end
local info=self.Info local infoStr=tostring(info)if not _state.oldShootCooldowns
[infoStr..'_Shoot']then _state.oldShootCooldowns[infoStr..'_Shoot']=info.
ShootCooldown end if not _state.oldShootCooldowns[infoStr..'_Burst']then _state.
oldShootCooldowns[infoStr..'_Burst']=info.ShootBurstCooldown end if not _state.
oldShootCooldowns[infoStr..'_Spread']then _state.oldShootCooldowns[infoStr..
'_Spread']=info.ShootSpread end if not _state.oldShootCooldowns[infoStr..
'_AimML']then _state.oldShootCooldowns[infoStr..'_AimML']=info.
AimSpreadMultiplier end if not _state.oldShootCooldowns[infoStr..'_Quick']then
_state.oldShootCooldowns[infoStr..'_Quick']=info.QuickShotSpread end local
origShoot=_state.oldShootCooldowns[infoStr..'_Shoot']local origBurst=_state.
oldShootCooldowns[infoStr..'_Burst']local origSpread=_state.oldShootCooldowns[
infoStr..'_Spread']local origAimML=_state.oldShootCooldowns[infoStr..'_AimML']
local origQuick=_state.oldShootCooldowns[infoStr..'_Quick']if State.
isNoSpreadEnabled then info.ShootSpread=0 info.AimSpreadMultiplier=0 if info.
QuickShotSpread then info.QuickShotSpread=0 end State.forcingAim=true end if
State.attackCooldownMultiplier<100 then info.ShootCooldown=origShoot*(State.
attackCooldownMultiplier/100)if info.ShootBurstCooldown then info.
ShootBurstCooldown=origBurst*(State.attackCooldownMultiplier/100)end end local
returns={oldStartShooting(self,...)}State.forcingAim=false info.ShootCooldown=
origShoot if info.ShootBurstCooldown then info.ShootBurstCooldown=origBurst end
info.ShootSpread=origSpread info.AimSpreadMultiplier=origAimML if info.
QuickShotSpread then info.QuickShotSpread=origQuick end if State.
isNoSpreadEnabled and#returns>=4 then returns[4]=true end return unpack(returns)
end,State.logger,_maid)end State.isGunModsHooked=true end)end return GunMods end
function __DARKLUA_BUNDLE_MODULES.A()local v=__DARKLUA_BUNDLE_MODULES.cache.A if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.A=v end return v.c
end end do local function __modImpl()local Players=game:GetService('Players')
local State=__DARKLUA_BUNDLE_MODULES.u()local TeamUtils=__DARKLUA_BUNDLE_MODULES
.e()local PlayerUtils=__DARKLUA_BUNDLE_MODULES.f()local ExecutorUtils=
__DARKLUA_BUNDLE_MODULES.d()local HookUtils=__DARKLUA_BUNDLE_MODULES.p()local
Helpers=__DARKLUA_BUNDLE_MODULES.v()local AURA_UPDATE_INTERVAL=0.03 local
AURA_IDLE_INTERVAL=0.15 local MeleeMods={}MeleeMods.__index=MeleeMods local
_maid=nil local _signals={}local _state={cachedLocalPlayer=nil,cachedLocalRoot=
nil,lastLocalCacheUpdate=0,lastFighterFetch=0,hookedItems={},checkcaller=nil}
local function _getDistance(p1,p2)return(p1-p2).Magnitude end local function
_refreshLocalCache()local now=os.clock()if now-_state.lastLocalCacheUpdate<0.25
then return end _state.lastLocalCacheUpdate=now local localPlayer=PlayerUtils.
getLocalPlayer()_state.cachedLocalPlayer=localPlayer local character=localPlayer
and localPlayer.Character _state.cachedLocalRoot=character and((character:
FindFirstChild('HumanoidRootPart')))or nil end local function _getClosestEnemy(
localPlayer,localRoot)local closestPlayer=nil local closestRoot=nil local
closestDist=math.huge for _,player in ipairs(Players:GetPlayers())do if player==
localPlayer then continue end if TeamUtils.isSameTeam(player,localPlayer)then
continue end if not TeamUtils.isInSameDuel(localPlayer,player)then continue end
local character=player.Character if not character then continue end local root=(
character:FindFirstChild('HumanoidRootPart'))local hum=character:
FindFirstChildOfClass('Humanoid')if not root or not hum or hum.Health<=0 then
continue end local dist=_getDistance(localRoot.Position,root.Position)if dist<
closestDist then closestDist=dist closestPlayer=player closestRoot=root end end
return closestPlayer,closestRoot end local function _hookMeleeStartShooting(
itemMod)if _state.hookedItems[itemMod]then return end _state.hookedItems[itemMod
]=true local oldStartShooting oldStartShooting=HookUtils.safeHook(itemMod,
'StartShooting',function(self,...)local checkcaller=_state.checkcaller if
checkcaller and not checkcaller()then local info=(self).Info local
originalCooldown=info and info.AttackCooldown if type(originalCooldown)==
'number'then info.AttackCooldown=originalCooldown*(State.
meleeAttackCooldownMultiplier/100)end local result=table.pack(oldStartShooting(
self,...))if type(originalCooldown)=='number'then info.AttackCooldown=
originalCooldown end return table.unpack(result)end return oldStartShooting(self
,...)end,State.logger,_maid)end function MeleeMods.setup(maid)_maid=maid local
checkcaller=ExecutorUtils.getGlobal('checkcaller')or function()return false end
_state.checkcaller=checkcaller local isRunning=true if _maid then _maid:
GiveTask(function()isRunning=false end)end task.spawn(function()if not isRunning
then return end local meleeMod=Helpers.getMeleeModule()if meleeMod then local
oldStartShooting oldStartShooting=HookUtils.safeHook(meleeMod,'StartShooting',
function(self,...)if not checkcaller()then local info=(self).Info if State.
isMeleeAuraEnabled then(self)._attack_cooldown=0(self)._equip_cooldown=0 end
local originalCooldown=info.AttackCooldown info.AttackCooldown=originalCooldown*
(State.meleeAttackCooldownMultiplier/100)local result=table.pack(
oldStartShooting(self,...))info.AttackCooldown=originalCooldown return table.
unpack(result)end return oldStartShooting(self,...)end,State.logger,_maid)local
oldCanQuickAttack oldCanQuickAttack=HookUtils.safeHook(meleeMod,'CanQuickAttack'
,function(self,...)if not checkcaller()and State.isMeleeAuraEnabled then return
true end return oldCanQuickAttack(self,...)end,State.logger,_maid)end local
itemModules=Helpers.getItemModules()if itemModules then for _,itemScript in
ipairs(itemModules:GetChildren())do if itemScript:IsA('ModuleScript')then pcall(
function()local dynamicRequire=require local itemMod=dynamicRequire(itemScript)
local info=itemMod and itemMod.Info if itemMod and itemMod.StartShooting and
info and info.AttackCooldown then _hookMeleeStartShooting(itemMod)end end)end
end local itemsToHook={'Katana','Scythe','BowieKnife'}for _,itemName in ipairs(
itemsToHook)do local itemScript=itemModules:FindFirstChild(itemName)if
itemScript and itemScript:IsA('ModuleScript')then pcall(function()local
dynamicRequire=require local itemMod=dynamicRequire(itemScript)if itemMod and
itemMod.StartAiming then local oldStartAiming oldStartAiming=HookUtils.safeHook(
itemMod,'StartAiming',function(self,...)if not checkcaller()then local info=(
self).Info local cooldownFields={'DeflectCooldown','DashCooldown',
'InvisCooldown'}local originals={}for _,field in ipairs(cooldownFields)do if
info[field]then originals[field]=info[field]info[field]=originals[field]*(State.
meleeSkillCooldownMultiplier/100)end end local result=table.pack(oldStartAiming(
self,...))for field,val in pairs(originals)do info[field]=val end return table.
unpack(result)end return oldStartAiming(self,...)end,State.logger,_maid)end end)
end end end end)task.spawn(function()while isRunning do _refreshLocalCache()
local localPlayer=_state.cachedLocalPlayer local localRoot=_state.
cachedLocalRoot local character=localPlayer and localPlayer.Character local now=
os.clock()if now-_state.lastFighterFetch>=0.25 then _state.lastFighterFetch=now
Helpers.fetchFighterController(State.logger)end local localFighter=State.
fighterController and State.fighterController.LocalFighter if localPlayer and
localRoot and character and localFighter and(State.isMeleeAuraEnabled or State.
isTeleportAuraEnabled)then local target,targetRoot=_getClosestEnemy(localPlayer,
localRoot)if target and targetRoot then if State.isTeleportAuraEnabled then
localRoot.CFrame=targetRoot.CFrame*CFrame.new(0,0,1.5)end if State.
isMeleeAuraEnabled then local equipped=localFighter.EquippedItem if not equipped
or(equipped.Info and equipped.Info.IsGun)then pcall(function()if localFighter.
EquipItem then localFighter:EquipItem(3)end end)end equipped=localFighter.
EquippedItem if equipped and(equipped.Info and not equipped.Info.IsGun)then if
equipped.StartShooting then equipped:Input('StartShooting')end end end end end
task.wait(if State.isMeleeAuraEnabled or State.isTeleportAuraEnabled then
AURA_UPDATE_INTERVAL else AURA_IDLE_INTERVAL)end end)end return MeleeMods end
function __DARKLUA_BUNDLE_MODULES.B()local v=__DARKLUA_BUNDLE_MODULES.cache.B if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.B=v end return v.c
end end do local function __modImpl()local UserInputService=game:GetService(
'UserInputService')local State=__DARKLUA_BUNDLE_MODULES.u()local Constants=
__DARKLUA_BUNDLE_MODULES.t()local ExecutorUtils=__DARKLUA_BUNDLE_MODULES.d()
local Visuals={}local _maid=nil local _signals={}local _state={}local function
_updateCircle(circleId,isEnabled,radius,color,transparency,mouseLocation)local
lib=ExecutorUtils.getDrawingLib()if not lib then return end local stateAny=State
local circle=stateAny[circleId]if isEnabled then if not circle then circle=lib.
new('Circle')stateAny[circleId]=circle end local c=circle c.Thickness=Constants.
FOV_CIRCLE_THICKNESS c.NumSides=Constants.FOV_CIRCLE_NUM_SIDES c.Filled=false c.
Color=color c.Transparency=math.clamp(transparency,0,1)c.ZIndex=2 c.Position=
mouseLocation c.Radius=radius c.Visible=true else local c=circle if c then c.
Visible=false end end end function Visuals.updateFovCircle()local mouseLocation=
UserInputService:GetMouseLocation()_updateCircle('fovCircle',State.isFovEnabled,
State.fovRadius,State.fovColor,State.fovTransparency,mouseLocation)
_updateCircle('silentAimFovCircle',State.isSilentAimFovEnabled,State.
silentAimFovRadius,State.silentAimFovColor,State.silentAimFovTransparency,
mouseLocation)end return Visuals end function __DARKLUA_BUNDLE_MODULES.C()local
v=__DARKLUA_BUNDLE_MODULES.cache.C if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.C=v end return v.c end end do local function
__modImpl()local RunService=game:GetService('RunService')local Maid=(
__DARKLUA_BUNDLE_MODULES.a())local State=__DARKLUA_BUNDLE_MODULES.u()local
Constants=__DARKLUA_BUNDLE_MODULES.t()local Helpers=__DARKLUA_BUNDLE_MODULES.v()
local Targeting=__DARKLUA_BUNDLE_MODULES.w()local Aimbot=
__DARKLUA_BUNDLE_MODULES.x()local Types=__DARKLUA_BUNDLE_MODULES.s()local
SilentAim=(__DARKLUA_BUNDLE_MODULES.y())local Ragebot=(__DARKLUA_BUNDLE_MODULES.
z())local GunMods=(__DARKLUA_BUNDLE_MODULES.A())local MeleeMods=(
__DARKLUA_BUNDLE_MODULES.B())local Visuals=(__DARKLUA_BUNDLE_MODULES.C())local
Combat={}Combat.__index=Combat local _maid=nil local _signals={}local _state={}
local function _connect()_maid:DoCleaning()task.spawn(function()Helpers.
fetchCameraController(State.logger)end)SilentAim.setup(_maid)Ragebot.setup(_maid
)GunMods.setup(_maid)MeleeMods.setup(_maid)RunService:BindToRenderStep(Constants
.AIMBOT_RENDER_STEP_NAME,Enum.RenderPriority.Camera.Value+1,function(deltaTime)
Visuals.updateFovCircle()if State.isAimbotEnabled then local target=Targeting.
resolveTarget()if target then local _isValid,_bestPart,_anyOnScreen,
_shortestDist=Targeting.getTargetState(target)if _isValid and _bestPart then
Helpers.applyInputLock(true)Aimbot.aimAt(target,_bestPart,deltaTime)else Helpers
.applyInputLock(false)end else Helpers.applyInputLock(false)end else State.
target=nil Helpers.applyInputLock(false)end if State.isSilentAimEnabled then
Targeting.resolveSilentTarget()else State.silentTarget=nil end end)_maid:
GiveTask(function()RunService:UnbindFromRenderStep(Constants.
AIMBOT_RENDER_STEP_NAME)end)end local function _disconnect()if State.fovCircle
then pcall(function()((State.fovCircle)):Remove()end)State.fovCircle=nil end if
State.silentAimFovCircle then pcall(function()((State.silentAimFovCircle)):
Remove()end)State.silentAimFovCircle=nil end State.target=nil State.silentTarget
=nil State.targetLostAt=nil State.silentTargetLostAt=nil Helpers.applyInputLock(
false)_maid:DoCleaning()end function Combat.init(self,client)State.client=client
State.logger=client.Logger _maid=Maid.new()_connect()end function Combat.Destroy
(self)State.isAimbotEnabled=false Combat.setRagebotEnabled(self,false)
_disconnect()State.isRemoteHooked=false State.isUtilityHooked=false State.
isCameraShakerHooked=false State.isGunModsHooked=false end function Combat.
setAimbotEnabled(self,isEnabled)if State.isAimbotEnabled==isEnabled then return
end State.isAimbotEnabled=isEnabled if not isEnabled then State.target=nil State
.targetLostAt=nil Helpers.applyInputLock(false)end end function Combat.
setFovEnabled(self,isEnabled)State.isFovEnabled=isEnabled end function Combat.
setFovRadius(self,radius)State.fovRadius=radius end function Combat.setFovColor(
self,color)State.fovColor=color end function Combat.setFovTransparency(self,
transparency)State.fovTransparency=math.clamp(transparency,0,1)end function
Combat.setSmoothness(self,smoothness)local wasMaxSmoothness=Helpers.
isMaxSmoothness()State.smoothness=math.clamp(smoothness,0,Constants.
MAX_SMOOTHNESS)if wasMaxSmoothness and not Helpers.isMaxSmoothness()then Helpers
.applyInputLock(false)end end function Combat.setWallCheckEnabled(self,isEnabled
)State.isWallCheckEnabled=isEnabled end function Combat.setSilentAimEnabled(self
,isEnabled)State.isSilentAimEnabled=isEnabled if not isEnabled then State.
silentTarget=nil State.silentTargetLostAt=nil end end function Combat.
setRagebotEnabled(self,isEnabled)if State.isRagebotEnabled==isEnabled then
return end State.isRagebotEnabled=isEnabled if isEnabled then if State.
ragebotSavedSilentAimEnabled==nil then State.ragebotSavedSilentAimEnabled=State.
isSilentAimEnabled end if State.ragebotSavedAttackCooldownMultiplier==nil then
State.ragebotSavedAttackCooldownMultiplier=State.attackCooldownMultiplier end
State.isSilentAimEnabled=true State.attackCooldownMultiplier=1 else if State.
ragebotSavedSilentAimEnabled~=nil then State.isSilentAimEnabled=State.
ragebotSavedSilentAimEnabled State.ragebotSavedSilentAimEnabled=nil end if State
.ragebotSavedAttackCooldownMultiplier~=nil then State.attackCooldownMultiplier=
State.ragebotSavedAttackCooldownMultiplier State.
ragebotSavedAttackCooldownMultiplier=nil end end end function Combat.
setSilentAimFovEnabled(self,isEnabled)State.isSilentAimFovEnabled=isEnabled end
function Combat.setSilentAimFovRadius(self,radius)State.silentAimFovRadius=
radius end function Combat.setSilentAimFovColor(self,color)State.
silentAimFovColor=color end function Combat.setSilentAimFovTransparency(self,
transparency)State.silentAimFovTransparency=math.clamp(transparency,0,1)end
function Combat.setSilentHitChance(self,chance)State.silentHitChance=math.clamp(
chance,0,100)end function Combat.setTargetPart(self,part)State.targetPart=part
end function Combat.setManipulationEnabled(self,enabled)State.
isManipulationEnabled=enabled end function Combat.setAntiKatanaEnabled(self,
enabled)State.isAntiKatanaEnabled=enabled end function Combat.
setClosestPositionEnabled(self,enabled)State.isClosestPositionEnabled=enabled
end function Combat.setClosestPositionWhitelist(self,whitelist)State.
closestPositionWhitelist=whitelist end function Combat.setNoRecoilEnabled(self,
isEnabled)State.isNoRecoilEnabled=isEnabled end function Combat.
setNoSpreadEnabled(self,isEnabled)State.isNoSpreadEnabled=isEnabled end function
Combat.setNoMuzzleFlashEnabled(self,isEnabled)State.isNoMuzzleFlashEnabled=
isEnabled end function Combat.setAttackCooldownMultiplier(self,multiplier)State.
attackCooldownMultiplier=multiplier end function Combat.
setMeleeAttackCooldownEnabled(self,isEnabled)State.isMeleeAttackCooldownEnabled=
isEnabled end function Combat.setMeleeAttackCooldownMultiplier(self,multiplier)
State.meleeAttackCooldownMultiplier=multiplier end function Combat.
setMeleeSkillCooldownEnabled(self,isEnabled)State.isMeleeSkillCooldownEnabled=
isEnabled end function Combat.setMeleeSkillCooldownMultiplier(self,multiplier)
State.meleeSkillCooldownMultiplier=multiplier end function Combat.
setMeleeAuraEnabled(self,isEnabled)State.isMeleeAuraEnabled=isEnabled end
function Combat.setTeleportAuraEnabled(self,isEnabled)State.
isTeleportAuraEnabled=isEnabled end return Combat end function
__DARKLUA_BUNDLE_MODULES.D()local v=__DARKLUA_BUNDLE_MODULES.cache.D if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.D=v end return v.c end end
do local function __modImpl()local CombatTab={}CombatTab.__index=CombatTab local
_maid=nil local _state={}local _signals={}function CombatTab.Build(tabs,context)
local client=context.client local updateControlBindings=context.
updateControlBindings local combatGroup=tabs.combat:AddLeftGroupbox('Combat')
local silentAimToggle=combatGroup:AddToggle('SilentAimEnabled',{Text=
'Silent Aim',Default=false,Tooltip=
[[Redirects shots toward the closest valid target within your silent FOV.]],
Callback=function()updateControlBindings()end})silentAimToggle:AddKeyPicker(
'SilentAimKeybind',{Default='MouseButton2',NoUI=false,Text='Silent Aim',
SyncToggleState=false,Callback=function()updateControlBindings()end})
silentAimToggle:AddColorPicker('SilentAimFovColor',{Default=Color3.fromRGB(255,
255,255),Transparency=0,Title='Silent FOV Color',Tooltip=
'Color of the Silent Aim FOV circle.',Callback=function(color,transparency)local
mod=client.Modules.Combat if mod and mod.setSilentAimFovColor then mod:
setSilentAimFovColor(color)end if mod and mod.setSilentAimFovTransparency then
mod:setSilentAimFovTransparency(transparency or 0)end end})combatGroup:
AddSlider('SilentHitChance',{Text='Silent Hit Chance',Default=100,Min=0,Max=100,
Rounding=0,Suffix='%',Tooltip='Chance for Silent Aim to redirect a shot.',
Compact=true,Callback=function(value)local mod=client.Modules.Combat if mod and
mod.setSilentHitChance then mod:setSilentHitChance(value)end end})combatGroup:
AddSlider('SilentAimFovRadius',{Text='Silent Aim Radius',Default=100,Min=10,Max=
800,Rounding=0,Suffix='px',Tooltip='Silent Aim activation radius in pixels.',
Compact=true,Callback=function(value)local mod=client.Modules.Combat if mod and
mod.setSilentAimFovRadius then mod:setSilentAimFovRadius(value)end end})local
combatAimbotToggle=combatGroup:AddToggle('CombatAimbotEnabled',{Text='Aimbot',
Default=false,Tooltip='Automatically aims at the best target.',Callback=function
()updateControlBindings()end})combatAimbotToggle:AddKeyPicker(
'CombatAimbotKeybind',{Default='MouseButton2',NoUI=false,Text='Aimbot',
SyncToggleState=false,Callback=function()updateControlBindings()end})
combatAimbotToggle:AddColorPicker('CombatFovColor',{Default=Color3.fromRGB(255,
255,255),Transparency=0,Title='Aimbot FOV Color',Tooltip=
'Color of the Aimbot FOV circle.',Callback=function(color,transparency)local mod
=client.Modules.Combat if mod and mod.setFovColor then mod:setFovColor(color)end
if mod and mod.setFovTransparency then mod:setFovTransparency(transparency or 0)
end end})combatGroup:AddSlider('CombatSmoothness',{Text='Aimbot Smoothing',
Default=0,Min=0,Max=100,Rounding=0,Suffix='%',Tooltip=
'Higher values feel smoother but slower to lock.',Compact=true,Callback=function
(value)local mod=client.Modules.Combat if mod and mod.setSmoothness then mod:
setSmoothness((value)/100)end end})combatGroup:AddSlider('CombatFovRadius',{Text
='Aimbot Radius',Default=100,Min=10,Max=800,Rounding=0,Suffix='px',Tooltip=
'Aimbot activation radius in pixels.',Compact=true,Callback=function(value)local
mod=client.Modules.Combat if mod and mod.setFovRadius then mod:setFovRadius(
value)end end})combatGroup:AddToggle('RagebotEnabled',{Text='Ragebot',Default=
false,Tooltip=
[[Teleports to duel targets and auto-shoots (forces Silent Aim + min cooldown).]]
,Callback=function(state)local mod=client.Modules.Combat if mod and mod.
setRagebotEnabled then mod:setRagebotEnabled(state)end end})combatGroup:
AddToggle('CombatManipulation',{Text='Manipulation',Default=false,Tooltip=
'Enables manipulation-related combat features.',Callback=function(state)local
mod=client.Modules.Combat if mod and mod.setManipulationEnabled then mod:
setManipulationEnabled(state)end end})combatGroup:AddToggle('CombatWallCheck',{
Text='Visible Only',Default=false,Tooltip=
'Only target enemies you can see (raycast).',Callback=function(state)local mod=
client.Modules.Combat if mod and mod.setWallCheckEnabled then mod:
setWallCheckEnabled(state)end end})combatGroup:AddToggle('CombatAntiKatana',{
Text='Anti Katana',Default=false,Tooltip='Mitigates katana-related attacks.',
Callback=function(state)local mod=client.Modules.Combat if mod and mod.
setAntiKatanaEnabled then mod:setAntiKatanaEnabled(state)end end})combatGroup:
AddToggle('CombatClosestPosition',{Text='Closest Position',Default=true,Tooltip=
'Choose the closest body part in the whitelist.',Callback=function(state)local
mod=client.Modules.Combat if mod and mod.setClosestPositionEnabled then mod:
setClosestPositionEnabled(state)end end})combatGroup:AddDropdown(
'CombatClosestWhitelist',{Values={'Head','UpperTorso','LowerTorso',
'LeftUpperArm','RightUpperArm','LeftUpperLeg','RightUpperLeg'},Default={'Head',
'UpperTorso','LowerTorso','LeftUpperArm','RightUpperArm','LeftUpperLeg',
'RightUpperLeg'},Multi=true,Text='Closest Position Whitelist',Tooltip=
'Parts to consider for Closest Position',Callback=function(value)local mod=
client.Modules.Combat if mod and mod.setClosestPositionWhitelist then local
selectedNames={}for name,enabled in pairs(value)do if enabled then table.insert(
selectedNames,name)end end mod:setClosestPositionWhitelist(selectedNames)end end
})combatGroup:AddDropdown('CombatTargetPart',{Values={'Head','UpperTorso',
'LowerTorso','LeftUpperArm','RightUpperArm','LeftUpperLeg','RightUpperLeg'},
Default=1,Multi=false,Text='Target Part',Tooltip=
'Static target part when Closest Position is off',Callback=function(value)local
mod=client.Modules.Combat if mod and mod.setTargetPart then mod:setTargetPart(
value)end end})local gunModsGroup=tabs.combat:AddRightGroupbox('Gun Mods')
gunModsGroup:AddToggle('GunModsNoRecoil',{Text='No Recoil',Default=false,Tooltip
='Eliminates weapon recoil.',Callback=function(state)local mod=client.Modules.
Combat if mod and mod.setNoRecoilEnabled then mod:setNoRecoilEnabled(state)end
end})gunModsGroup:AddToggle('GunModsNoSpread',{Text='No Spread',Default=false,
Tooltip='Eliminates weapon bullet spread.',Callback=function(state)local mod=
client.Modules.Combat if mod and mod.setNoSpreadEnabled then mod:
setNoSpreadEnabled(state)end end})gunModsGroup:AddToggle('GunModsNoMuzzleFlash',
{Text='No Muzzle Flash',Default=false,Tooltip=
'Removes the muzzle flash effect when shooting.',Callback=function(state)local
mod=client.Modules.Combat if mod and mod.setNoMuzzleFlashEnabled then mod:
setNoMuzzleFlashEnabled(state)end end})gunModsGroup:AddSlider('GunModsCooldown',
{Text='Attack Cooldown',Default=100,Min=1,Max=100,Rounding=0,Suffix='%',Tooltip=
'Weapon fire rate cooldown. 1% is near-instant fire rate.',Compact=true,Callback
=function(value)local mod=client.Modules.Combat if mod and mod.
setAttackCooldownMultiplier then mod:setAttackCooldownMultiplier(value)end end})
local meleeModsGroup=tabs.combat:AddRightGroupbox('Melee Mods')meleeModsGroup:
AddToggle('MeleeModsAura',{Text='Melee Aura',Default=false,Tooltip=
'Automatically attacks nearby enemies.',Callback=function(state)local mod=client
.Modules.Combat if mod and mod.setMeleeAuraEnabled then mod:setMeleeAuraEnabled(
state)end end})meleeModsGroup:AddSlider('MeleeModsCooldown',{Text=
'Attack Cooldown',Default=100,Min=1,Max=100,Rounding=0,Suffix='%',Tooltip=
'Weapon fire rate cooldown. 1% is near-instant fire rate.',Compact=true,Callback
=function(value)local mod=client.Modules.Combat if mod and mod.
setMeleeAttackCooldownMultiplier then mod:setMeleeAttackCooldownMultiplier(value
)end end})meleeModsGroup:AddSlider('MeleeModsSkillCooldown',{Text=
'Skill Cooldown',Default=100,Min=1,Max=100,Rounding=0,Suffix='%',Tooltip=
[[Skill cooldown multiplier. Lower values reduce skill cooldowns.]],Compact=true
,Callback=function(value)local mod=client.Modules.Combat if mod and mod.
setMeleeSkillCooldownMultiplier then mod:setMeleeSkillCooldownMultiplier(value)
end end})end return CombatTab end function __DARKLUA_BUNDLE_MODULES.E()local v=
__DARKLUA_BUNDLE_MODULES.cache.E if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.E=v end return v.c end end do local function
__modImpl()local VisualsTab={}VisualsTab.__index=VisualsTab local _maid=nil
local _state={}local _signals={}function VisualsTab.Build(tabs,context)local
client=context.client local espGroup=tabs.visuals:AddLeftGroupbox('ESP')espGroup
:AddToggle('VisualsToggle',{Text='Visuals (ESP)',Default=false,Tooltip=
'Master toggle for all ESP visuals.',Callback=function(state)local mod=client.
Modules.Visuals if mod and mod.toggle then mod:toggle(state)end if mod and mod.
setEspEnabled then mod:setEspEnabled(state)end end})espGroup:AddToggle(
'ESPNames',{Text='Name',Default=true,Tooltip='Show player names.',Callback=
function(state)local mod=client.Modules.Visuals if mod and mod.setShowNames then
mod:setShowNames(state)end end}):AddColorPicker('ESPTextColor',{Default=Color3.
new(1,1,1),Title='Text Color',Tooltip='Color for ESP name text.',Callback=
function(value)local mod=client.Modules.Visuals if mod and mod.setTextColor then
mod:setTextColor(value)end end}):AddColorPicker('ESPNameOutlineColor',{Default=
Color3.new(0,0,0),Title='Name Outline',Tooltip='Outline color for ESP names.',
Callback=function(value)local mod=client.Modules.Visuals if mod and mod.
setNameOutlineColor then mod:setNameOutlineColor(value)end end})espGroup:
AddToggle('ESPWeapon',{Text='Weapon',Default=false,Tooltip=
'Show equipped weapon name.',Callback=function(state)local mod=client.Modules.
Visuals if mod and mod.setShowWeapon then mod:setShowWeapon(state)end end}):
AddColorPicker('ESPWeaponColor',{Default=Color3.new(1,1,1),Title='Weapon Color',
Tooltip='Color for weapon text.',Callback=function(value)local mod=client.
Modules.Visuals if mod and mod.setWeaponColor then mod:setWeaponColor(value)end
end}):AddColorPicker('ESPWeaponOutlineColor',{Default=Color3.new(0,0,0),Title=
'Weapon Outline',Tooltip='Outline color for weapon text.',Callback=function(
value)local mod=client.Modules.Visuals if mod and mod.setWeaponOutlineColor then
mod:setWeaponOutlineColor(value)end end})espGroup:AddToggle('ESPDistance',{Text=
'Distance',Default=false,Tooltip='Show distance to target.',Callback=function(
state)local mod=client.Modules.Visuals if mod and mod.setShowDistance then mod:
setShowDistance(state)end end}):AddColorPicker('ESPDistanceColor',{Default=
Color3.new(1,1,1),Title='Distance Color',Tooltip='Color for distance text.',
Callback=function(value)local mod=client.Modules.Visuals if mod and mod.
setDistanceColor then mod:setDistanceColor(value)end end}):AddColorPicker(
'ESPDistanceOutlineColor',{Default=Color3.new(0,0,0),Title='Distance Outline',
Tooltip='Outline color for distance text.',Callback=function(value)local mod=
client.Modules.Visuals if mod and mod.setDistanceOutlineColor then mod:
setDistanceOutlineColor(value)end end})espGroup:AddToggle('ESPBoxes',{Text='Box'
,Default=true,Tooltip='Draw a box around targets.',Callback=function(state)local
mod=client.Modules.Visuals if mod and mod.setShowBoxes then mod:setShowBoxes(
state)end end}):AddColorPicker('ESPBoxColor',{Default=Color3.new(1,1,1),Title=
'Box Color',Tooltip='Color of the ESP box.',Callback=function(value)local mod=
client.Modules.Visuals if mod and mod.setBoxColor then mod:setBoxColor(value)end
end}):AddColorPicker('ESPBoxOutlineColor',{Default=Color3.new(0,0,0),Title=
'Box Outline',Tooltip='Outline color of the ESP box.',Callback=function(value)
local mod=client.Modules.Visuals if mod and mod.setBoxOutlineColor then mod:
setBoxOutlineColor(value)end end})espGroup:AddToggle('ESPSkeleton',{Text=
'Skeleton',Default=false,Tooltip='Draw a skeleton over targets.',Callback=
function(state)local mod=client.Modules.Visuals if mod and mod.setShowSkeleton
then mod:setShowSkeleton(state)end end}):AddColorPicker('ESPSkeletonColor',{
Default=Color3.new(1,1,1),Title='Skeleton Color',Tooltip=
'Color of skeleton lines.',Callback=function(value)local mod=client.Modules.
Visuals if mod and mod.setSkeletonColor then mod:setSkeletonColor(value)end end}
):AddColorPicker('ESPSkeletonOutlineColor',{Default=Color3.new(0,0,0),Title=
'Skeleton Outline',Tooltip='Outline color for skeleton lines.',Callback=function
(value)local mod=client.Modules.Visuals if mod and mod.setSkeletonOutlineColor
then mod:setSkeletonOutlineColor(value)end end})espGroup:AddToggle(
'ESPHealthbar',{Text='Healthbar',Default=false,Tooltip='Show target healthbar.',
Callback=function(state)local mod=client.Modules.Visuals if mod and mod.
setShowHealthbar then mod:setShowHealthbar(state)end end}):AddColorPicker(
'ESPHealthbarColor',{Default=Color3.new(0,1,0),Title='Health Color',Tooltip=
'Color of health fill.',Callback=function(value)local mod=client.Modules.Visuals
if mod and mod.setHealthbarColor then mod:setHealthbarColor(value)end end}):
AddColorPicker('ESPHealthbarOutlineColor',{Default=Color3.new(0,0,0),Title=
'Outline Color',Tooltip='Outline color for the healthbar.',Callback=function(
value)local mod=client.Modules.Visuals if mod and mod.setHealthbarOutlineColor
then mod:setHealthbarOutlineColor(value)end end})espGroup:AddToggle(
'ESPHighlight',{Text='Highlight',Default=false,Tooltip=
'Add a Highlight instance to targets.',Callback=function(state)local mod=client.
Modules.Visuals if mod and mod.setShowHighlight then mod:setShowHighlight(state)
end end}):AddColorPicker('ESPHighlightFill',{Default=Color3.new(1,0,0),Title=
'Fill Color',Tooltip='Fill color for Highlight.',Callback=function(value)local
mod=client.Modules.Visuals if mod and mod.setHighlightFill then mod:
setHighlightFill(value)end end}):AddColorPicker('ESPHighlightOutline',{Default=
Color3.new(1,1,1),Title='Outline Color',Tooltip='Outline color for Highlight.',
Callback=function(value)local mod=client.Modules.Visuals if mod and mod.
setHighlightOutline then mod:setHighlightOutline(value)end end})espGroup:
AddToggle('ESPBetterBounds',{Text='Better Bounds',Default=false,Tooltip=
'Reserved for future bounds improvements.',Callback=function(_stateValue)end})
espGroup:AddToggle('ESPShowTeammates',{Text='Show Teammates',Default=true,
Tooltip='Show ESP on teammates.',Callback=function(state)local mod=client.
Modules.Visuals if mod and mod.setShowTeammates then mod:setShowTeammates(state)
end end})espGroup:AddSlider('ESPSkeletonThickness',{Text='Skeleton Thickness',
Default=1,Min=1,Max=5,Rounding=1,Tooltip='Thickness of skeleton lines.',Compact=
true,Callback=function(value)local mod=client.Modules.Visuals if mod and mod.
setSkeletonThickness then mod:setSkeletonThickness(value)end end})espGroup:
AddSlider('ESPTextSize',{Text='Text Size',Default=12,Min=10,Max=24,Rounding=0,
Tooltip='Size of ESP text.',Compact=true,Callback=function(value)local mod=
client.Modules.Visuals if mod and mod.setTextSize then mod:setTextSize(value)end
end})end return VisualsTab end function __DARKLUA_BUNDLE_MODULES.F()local v=
__DARKLUA_BUNDLE_MODULES.cache.F if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.F=v end return v.c end end do local function
__modImpl()local UiSettingsTab={}UiSettingsTab.__index=UiSettingsTab local _maid
=nil local _state={}local _signals={}function UiSettingsTab.Build(tabs,context)
local library=context.library local themeManager=context.themeManager local
saveManager=context.saveManager local unloadAll=context.unloadAll local
setKeybindListVisible=context.setKeybindListVisible local setWatermarkVisible=
context.setWatermarkVisible local updateKeybindList=context.updateKeybindList
local setKeybindListMode=context.setKeybindListMode local menuGroup=tabs.
uiSettings:AddLeftGroupbox('Menu')menuGroup:AddButton('Unload',function()
unloadAll()end)menuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind',{
Default='End',NoUI=true,Text='Menu keybind'})menuGroup:AddDivider()menuGroup:
AddToggle('UIShowKeybindList',{Text='Keybind List',Default=true,Tooltip=
'Shows the keybind list panel.',Callback=function(isVisible)
setKeybindListVisible(isVisible)end})menuGroup:AddToggle('UIShowWatermark',{Text
='Watermark',Default=true,Tooltip='Shows the watermark display.',Callback=
function(isVisible)setWatermarkVisible(isVisible)end})menuGroup:AddDropdown(
'UIKeybindListMode',{Values={'Active','Toggle','All'},Default='Active',Multi=
false,Text='Keybind Mode',Tooltip='Filter for the keybind list.',Callback=
function(value)setKeybindListMode(value)updateKeybindList()end})local getfenvAny
=getfenv local env=(getfenvAny(0))local getgenvFunc=env.getgenv local
GlobalOptions=(getgenvFunc and getgenvFunc().Options)or _G.Options if
GlobalOptions and GlobalOptions.MenuKeybind then library.ToggleKeybind=
GlobalOptions.MenuKeybind end themeManager:SetLibrary(library)saveManager:
SetLibrary(library)saveManager:IgnoreThemeSettings()themeManager:SetFolder(
'Blossom')saveManager:SetFolder('Blossom')saveManager:BuildConfigSection(tabs.
uiSettings)themeManager:ApplyToTab(tabs.uiSettings)end return UiSettingsTab end
function __DARKLUA_BUNDLE_MODULES.G()local v=__DARKLUA_BUNDLE_MODULES.cache.G if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.G=v end return v.c
end end do local function __modImpl()local MiscTab={}MiscTab.__index=MiscTab
local _maid=nil local _state={}local _signals={}function MiscTab.Build(tabs,
context)local client=context.client local library=context.library local
updateControlBindings=context.updateControlBindings local setNotifyMuted=context
.setNotifyMuted local playerGroup=tabs.misc:AddLeftGroupbox('Player')local
exploitsGroup=tabs.misc:AddRightGroupbox('Exploits')local playerFlyToggle=
playerGroup:AddToggle('PlayerFly',{Text='Fly',Default=false,Tooltip=
'Toggle flight mode.',Callback=function(state)updateControlBindings()end})
playerFlyToggle:AddKeyPicker('PlayerFlyKeybind',{Default='F',NoUI=false,Text=
'Fly',SyncToggleState=false,Callback=function()updateControlBindings()end})
playerGroup:AddSlider('PlayerFlySpeed',{Text='Fly Speed',Default=50,Min=5,Max=
200,Rounding=0,Tooltip='Movement speed while flying.',Compact=true,Callback=
function(value)local mod=client.Modules.Player if mod and mod.setFlySpeed then
mod:setFlySpeed(value)end end})local playerNoclipToggle=playerGroup:AddToggle(
'PlayerNoclip',{Text='Noclip',Default=false,Tooltip=
'Disable collisions for your character.',Callback=function(state)
updateControlBindings()end})playerNoclipToggle:AddKeyPicker(
'PlayerNoclipKeybind',{Default='N',NoUI=false,Text='Noclip',SyncToggleState=
false,Callback=function()updateControlBindings()end})local playerWalkSpeedToggle
=playerGroup:AddToggle('PlayerWalkSpeedEnabled',{Text='Walk Speed',Default=false
,Tooltip='Toggle custom walk speed.',Callback=function(state)
updateControlBindings()end})playerWalkSpeedToggle:AddKeyPicker(
'PlayerWalkSpeedKeybind',{Default='T',NoUI=false,Text='Walk Speed',
SyncToggleState=false,Callback=function()updateControlBindings()end})playerGroup
:AddSlider('PlayerWalkSpeed',{Text='Walk Speed',Default=16,Min=0,Max=200,
Rounding=0,Tooltip='Your character walk speed.',Compact=true,Callback=function(
value)local mod=client.Modules.Player if mod and mod.setWalkSpeed then mod:
setWalkSpeed(value)end end})local playerJumpPowerToggle=playerGroup:AddToggle(
'PlayerJumpPowerEnabled',{Text='Jump Power',Default=false,Tooltip=
'Toggle custom jump power.',Callback=function(state)updateControlBindings()end})
playerJumpPowerToggle:AddKeyPicker('PlayerJumpPowerKeybind',{Default='Y',NoUI=
false,Text='Jump Power',SyncToggleState=false,Callback=function()
updateControlBindings()end})playerGroup:AddSlider('PlayerJumpPower',{Text=
'Jump Power',Default=50,Min=0,Max=200,Rounding=0,Tooltip=
'Your character jump power.',Compact=true,Callback=function(value)local mod=
client.Modules.Player if mod and mod.setJumpPower then mod:setJumpPower(value)
end end})playerGroup:AddToggle('PlayerSlideBoost',{Text='Slide Boost',Default=
false,Tooltip='Boosts your sliding speed.',Callback=function(state)local mod=
client.Modules.Player if mod and mod.setSlideBoostEnabled then mod:
setSlideBoostEnabled(state)end end})playerGroup:AddSlider(
'PlayerSlideBoostMultiplier',{Text='Slide Boost Multiplier',Default=1,Min=1,Max=
10,Rounding=1,Suffix='x',Tooltip='Multiplier for sliding speed.',Compact=true,
Callback=function(value)local mod=client.Modules.Player if mod and mod.
setSlideBoostMultiplier then mod:setSlideBoostMultiplier(value)end end})
exploitsGroup:AddToggle('PlayerAntiFlash',{Text='Anti Flashbang',Default=false,
Tooltip='Prevents you from being blinded by flashbangs.',Callback=function(state
)local mod=client.Modules.Player if mod and mod.setAntiFlashEnabled then mod:
setAntiFlashEnabled(state)end end})exploitsGroup:AddToggle(
'PlayerSpoofDeviceEnabled',{Text='Spoof Device',Default=false,Tooltip=
'Toggle device spoofing.',Callback=function(state)local mod=client.Modules.
Player if mod and mod.setSpoofDeviceEnabled then mod:setSpoofDeviceEnabled(state
)end end})exploitsGroup:AddDropdown('PlayerSpoofDevice',{Values={'None','Touch',
'Gamepad','VR','MouseKeyboard'},Default=1,Multi=false,Text='Device',Tooltip=
'The device to spoof as.',Callback=function(value)local mod=client.Modules.
Player if mod and mod.setSpoofDevice then mod:setSpoofDevice(value)end end})
exploitsGroup:AddToggle('PlayerSoundSpammer',{Text='Sound Spammer',Default=false
,Tooltip='Spams mechanics sounds to other players.',Callback=function(state)
local mod=client.Modules.Player if mod and mod.setSoundSpammerEnabled then mod:
setSoundSpammerEnabled(state)end end})exploitsGroup:AddDropdown(
'PlayerSoundSpammerType',{Values={'DoubleJump','Slide'},Default=1,Multi=false,
Text='Sound',Tooltip='The sound to spam.',Callback=function(value)local mod=
client.Modules.Player if mod and mod.setSoundSpammerType then mod:
setSoundSpammerType(value)end end})context.setKeybindToggleMap({['Silent Aim']=
'SilentAimEnabled',['Aimbot']='CombatAimbotEnabled',['Fly']='PlayerFly',[
'Noclip']='PlayerNoclip',['Walk Speed']='PlayerWalkSpeedEnabled',['Jump Power']=
'PlayerJumpPowerEnabled'})context.setControlBindings({{toggleId=
'CombatAimbotEnabled',keybindId='CombatAimbotKeybind',last=nil,setter=function(
active)local mod=client.Modules.Combat if mod and mod.setAimbotEnabled then mod:
setAimbotEnabled(active)end end},{toggleId='PlayerFly',keybindId=
'PlayerFlyKeybind',last=nil,setter=function(active)local mod=client.Modules.
Player if mod and mod.setFlyEnabled then mod:setFlyEnabled(active)end end},{
toggleId='PlayerNoclip',keybindId='PlayerNoclipKeybind',last=nil,setter=function
(active)local mod=client.Modules.Player if mod and mod.setNoclipEnabled then mod
:setNoclipEnabled(active)end end},{toggleId='PlayerWalkSpeedEnabled',keybindId=
'PlayerWalkSpeedKeybind',last=nil,setter=function(active)local mod=client.
Modules.Player if mod and mod.setWalkSpeedEnabled then mod:setWalkSpeedEnabled(
active)end end},{toggleId='PlayerJumpPowerEnabled',keybindId=
'PlayerJumpPowerKeybind',last=nil,setter=function(active)local mod=client.
Modules.Player if mod and mod.setJumpPowerEnabled then mod:setJumpPowerEnabled(
active)end end},{toggleId='SilentAimEnabled',keybindId='SilentAimKeybind',last=
nil,setter=function(active)local mod=client.Modules.Combat if mod and mod.
setSilentAimEnabled then mod:setSilentAimEnabled(active)end end}})local
miscGroup=tabs.misc:AddLeftGroupbox('Auto Load')miscGroup:AddToggle(
'TeleportQueue',{Text='Auto Load',Default=false,Tooltip=
'Auto-load Blossom after teleport.',Callback=function(enabled)client:
setTeleportQueue(enabled)end})miscGroup:AddToggle('SilentMode',{Text=
'Silent Mode',Default=false,Tooltip=
'Mutes UI notifications and auto-opens silently.',Callback=function(enabled)
setNotifyMuted(library,enabled)client:setSilent(enabled)end})end return MiscTab
end function __DARKLUA_BUNDLE_MODULES.H()local v=__DARKLUA_BUNDLE_MODULES.cache.
H if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.H=v end return v
.c end end do local function __modImpl()local RunService=game:GetService(
'RunService')local Stats=game:GetService('Stats')local Maid=(
__DARKLUA_BUNDLE_MODULES.a())local CombatTab=__DARKLUA_BUNDLE_MODULES.E()local
VisualsTab=__DARKLUA_BUNDLE_MODULES.F()local UiSettingsTab=
__DARKLUA_BUNDLE_MODULES.G()local MiscTab=__DARKLUA_BUNDLE_MODULES.H()local
REPO_URL=[[https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/]]
local WATERMARK_TEMPLATE='Blossom | %d fps | %d ms'local
WATERMARK_UPDATE_INTERVAL=1 local KEYBIND_LIST_UPDATE_INTERVAL=0.2 local
CONTROL_BINDINGS_UPDATE_INTERVAL=0.05 local Interface={}Interface.__index=
Interface local _maid=nil local _state={client=nil,logger=nil,library=nil,
themeManager=nil,saveManager=nil,isMounted=false,controlBindings=nil,
cachedToggles=nil,cachedOptions=nil,keybindListMode='Active',watermark={
lastSample=0,frameCount=0},lastKeybindListUpdate=0,lastControlBindingsUpdate=0,
keybindToggleMap={}}local _signals={}local _env=((getfenv)(0))local _writefile=
_env.writefile local _readfile=_env.readfile local _isfile=_env.isfile local
_delfile=_env.delfile local function _getLinoriaGlobals()local getfenvAny=
getfenv local env=(getfenvAny(0))local getgenvFunc=env.getgenv local toggles=(
getgenvFunc and getgenvFunc().Toggles)or _G.Toggles local options=(getgenvFunc
and getgenvFunc().Options)or _G.Options if toggles then _state.cachedToggles=
toggles end if options then _state.cachedOptions=options end return _state.
cachedToggles,_state.cachedOptions end local function _getPingMs()local pingMs=0
local pcallAny=pcall local success,value=pcallAny(function()local statsService=
Stats local stat=statsService.Network.ServerStatsItem['Data Ping']return stat:
GetValue()end)if success and type(value)=='number'then pingMs=math.floor(value+
0.5)end return pingMs end local function _setKeybindListVisible(isVisible)local
library=_state.library if not library then return end local keybindFrame=library
.KeybindFrame if keybindFrame then keybindFrame.Visible=isVisible end end
local function _setWatermarkVisible(isVisible)local library=_state.library if
not library or not library.SetWatermarkVisibility then return end library:
SetWatermarkVisibility(isVisible)end local function _syncUiVisibility()local
toggles=_getLinoriaGlobals()if not toggles then return end local keybindsToggle=
toggles.UIShowKeybindList if keybindsToggle then _setKeybindListVisible(
keybindsToggle.Value==true)end local watermarkToggle=toggles.UIShowWatermark if
watermarkToggle then _setWatermarkVisible(watermarkToggle.Value==true)end end
local function _updateWatermark()local library=_state.library if not library or
not library.SetWatermark then return end local toggles=_getLinoriaGlobals()local
isVisible=true if toggles and toggles.UIShowWatermark then isVisible=toggles.
UIShowWatermark.Value==true end if not isVisible then return end local watermark
=_state.watermark watermark.frameCount+=1 local now=os.clock()if watermark.
lastSample<=0 then watermark.lastSample=now return end if(now-watermark.
lastSample)<WATERMARK_UPDATE_INTERVAL then return end local fps=math.floor(
watermark.frameCount/(now-watermark.lastSample))watermark.frameCount=0 watermark
.lastSample=now library:SetWatermark(string.format(WATERMARK_TEMPLATE,fps,
_getPingMs()))end local function _extractKeybindParts(text)local key,name,mode=
text:match('^%[([^%]]+)%]%s*(.-)%s*%(([^%)]*)%)$')if key and name and mode then
return key,name,mode end return nil,nil,nil end local function
_getKeybindListMode()return _state.keybindListMode end local function
_updateKeybindList()local library=_state.library if not library or not library.
KeybindContainer or not library.KeybindFrame then return end local toggles=
_getLinoriaGlobals()local mode=_getKeybindListMode()local ySize=0 local xSize=0
for _,label in next,library.KeybindContainer:GetChildren()do if label:IsA(
'TextLabel')then local key,name,modeText=_extractKeybindParts(label.Text)if key
and name and modeText then label.Text=string.format('[%s] %s (%s)',key,name,
modeText)end local isVisible=true if mode=='Active'then isVisible=label.
TextColor3==library.AccentColor elseif mode=='Toggle'then if modeText then
isVisible=string.lower(modeText)=='toggle'else isVisible=true end end label.
Visible=isVisible if isVisible then ySize+=18 if label.TextBounds.X>xSize then
xSize=label.TextBounds.X end end end end library.KeybindFrame.Size=UDim2.new(0,
math.max(xSize+10,210),0,ySize+23)end local function _updateControlBindings()if
not _state.controlBindings then return end local toggles,options=
_getLinoriaGlobals()if not toggles or not options then end for _,control in
ipairs(_state.controlBindings)do local toggle=toggles and toggles[control.
toggleId]local gate=toggle and toggle.Value==true local isActive=false if gate
then local keybind=options and options[control.keybindId]if keybind and keybind.
GetState then isActive=keybind:GetState()else isActive=false end end if control.
last~=isActive then control.last=isActive control.setter(isActive)end end end
local function _installSaveManagerExtensions(saveManager)if saveManager.
_blossomBuildConfigSection then return end saveManager.
_blossomBuildConfigSection=saveManager.BuildConfigSection saveManager.
BuildConfigSection=function(self,tab)assert(self.Library,
'Must set SaveManager.Library')local section=tab:AddRightGroupbox(
'Configuration')section:AddInput('SaveManager_ConfigName',{Text='Config name'})
section:AddDropdown('SaveManager_ConfigList',{Text='Config list',Values=self:
RefreshConfigList(),AllowNull=true})section:AddDivider()local _,options=
_getLinoriaGlobals()section:AddButton('Create config',function()if not options
then return end local name=options.SaveManager_ConfigName.Value if name:gsub(' '
,'')==''then return self.Library:Notify('Invalid config name (empty)',2)end
local success,err=(self):Save(name)if not success then return self.Library:
Notify('Failed to save config: '..err,2)end self.Library:Notify(string.format(
'Created config %q',name),2)options.SaveManager_ConfigList:SetValues(self:
RefreshConfigList())options.SaveManager_ConfigList:SetValue(nil)end):AddButton(
'Load config',function()if not options then return end local name=options.
SaveManager_ConfigList.Value local success,err=(self):Load(name)if not success
then return self.Library:Notify('Failed to load config: '..err,2)end self.
Library:Notify(string.format('Loaded config %q',name),2)end)section:AddButton(
'Overwrite config',function()if not options then return end local name=options.
SaveManager_ConfigList.Value local success,err=(self):Save(name)if not success
then return self.Library:Notify('Failed to overwrite config: '..err,2)end self.
Library:Notify(string.format('Overwrote config %q',name),2)end)section:
AddButton('Refresh list',function()if not options then return end options.
SaveManager_ConfigList:SetValues(self:RefreshConfigList())options.
SaveManager_ConfigList:SetValue(nil)end)section:AddButton('Set as autoload',
function()if not options then return end local name=options.
SaveManager_ConfigList.Value if not _writefile then self.Library:Notify(
'Executor missing writefile; cannot set autoload.',2)return end _writefile(self.
Folder..'/settings/autoload.txt',name)self.AutoloadLabel:SetText(
'Current autoload config: '..name)self.Library:Notify(string.format(
'Set %q to auto load',name),2)end):AddButton('Remove autoload',function()local
path=self.Folder..'/settings/autoload.txt'if _isfile and _isfile(path)then if
_delfile then pcall(_delfile,path)end end self.AutoloadLabel:SetText(
'Current autoload config: none')self.Library:Notify('Cleared autoload config',2)
end)self.AutoloadLabel=section:AddLabel('Current autoload config: none',true)if
_isfile and _isfile(self.Folder..'/settings/autoload.txt')and _readfile then
local name=_readfile(self.Folder..'/settings/autoload.txt')self.AutoloadLabel:
SetText('Current autoload config: '..name)end self:SetIgnoreIndexes({
'SaveManager_ConfigList','SaveManager_ConfigName'})end end local function
_httpGet(url)return(game):HttpGet(url)end local function _loadRemote(path,logger
)local source=_httpGet(REPO_URL..path)local loadstringAny=loadstring local chunk
,err=loadstringAny(source)if not chunk then if logger then logger:error(
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
end local function _unloadAll()local client=_state.client if client and client.
destroy then client:destroy()return end _maid:DoCleaning()if _state.library then
_state.library:Unload()end _state.isMounted=false end local function _connect()
_maid:DoCleaning()local updateConn=RunService.RenderStepped:Connect(function()
local now=os.clock()if now-_state.lastControlBindingsUpdate>=
CONTROL_BINDINGS_UPDATE_INTERVAL then _state.lastControlBindingsUpdate=now
_updateControlBindings()end _updateWatermark()if now-_state.
lastKeybindListUpdate>=KEYBIND_LIST_UPDATE_INTERVAL then _state.
lastKeybindListUpdate=now _updateKeybindList()end end)_maid:GiveTask(updateConn)
end local function _mount()if _state.isMounted then return end _state.isMounted=
true local logger=_state.logger local library=_loadRemote('Library.lua',logger)
local themeManager=_loadRemote('addons/ThemeManager.lua',logger)local
saveManager=_loadRemote('addons/SaveManager.lua',logger)_state.library=library
_state.themeManager=themeManager _state.saveManager=saveManager do local _,
options=_getLinoriaGlobals()if options and options.UIKeybindListMode and options
.UIKeybindListMode.Value then _state.keybindListMode=options.UIKeybindListMode.
Value end end _installSaveManagerExtensions(saveManager)local window=library:
CreateWindow({Title='Blossom '.._state.client.Version,Center=true,AutoShow=not
_state.client.IsSilent,TabPadding=8,MenuFadeTime=0.2})local tabs={combat=window:
AddTab('Combat'),visuals=window:AddTab('Visuals'),misc=window:AddTab('Misc'),
uiSettings=window:AddTab('UI Settings')}CombatTab.Build(tabs,{client=_state.
client,updateControlBindings=_updateControlBindings})VisualsTab.Build(tabs,{
client=_state.client})UiSettingsTab.Build(tabs,{library=library,themeManager=
themeManager,saveManager=saveManager,unloadAll=_unloadAll,setKeybindListVisible=
_setKeybindListVisible,setWatermarkVisible=_setWatermarkVisible,
updateKeybindList=_updateKeybindList,setKeybindListMode=function(value)_state.
keybindListMode=value end})MiscTab.Build(tabs,{client=_state.client,library=
library,updateControlBindings=_updateControlBindings,setNotifyMuted=
_setNotifyMuted,setKeybindToggleMap=function(map)_state.keybindToggleMap=map end
,setControlBindings=function(bindings)_state.controlBindings=bindings end})
_updateControlBindings()_runAutoload(library,saveManager,false)
_syncUiVisibility()end function Interface.init(self,client)_state.client=client
_state.logger=client.Logger _maid=Maid.new()_connect()_mount()end function
Interface.Destroy(self)_maid:DoCleaning()if _state.library then _state.library:
Unload()end _state.isMounted=false end return Interface end function
__DARKLUA_BUNDLE_MODULES.I()local v=__DARKLUA_BUNDLE_MODULES.cache.I if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.I=v end return v.c end end
do local function __modImpl()local ModuleRegistry={}ModuleRegistry.__index=
ModuleRegistry local _maid=nil local _state={}local _signals={}function
ModuleRegistry.getModules()return{{name='TeamUtils',loader=(
__DARKLUA_BUNDLE_MODULES.e())},{name='Visuals',loader=(__DARKLUA_BUNDLE_MODULES.
k())},{name='Player',loader=(__DARKLUA_BUNDLE_MODULES.r())},{name='Combat',
loader=(__DARKLUA_BUNDLE_MODULES.D())},{name='Interface',loader=(
__DARKLUA_BUNDLE_MODULES.I())}}end return ModuleRegistry end function
__DARKLUA_BUNDLE_MODULES.J()local v=__DARKLUA_BUNDLE_MODULES.cache.J if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.J=v end return v.c end end
end local ReplicatedFirst=game:GetService('ReplicatedFirst')local Players=game:
GetService('Players')local RunService=game:GetService('RunService')local Logger=
__DARKLUA_BUNDLE_MODULES.b()local Maid=__DARKLUA_BUNDLE_MODULES.a()local
FastSignal=__DARKLUA_BUNDLE_MODULES.c()local ExecutorUtils=
__DARKLUA_BUNDLE_MODULES.d()local ModuleRegistry=__DARKLUA_BUNDLE_MODULES.J()
local BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/build/loader.luau]]
local CLIENT_MODULE_NAME='Client'local Client={}Client.__index=Client local
_maid=Maid.new()local _loggerModule=(Logger)local _initialLogger=_loggerModule.
new('Blossom')local _state={isRunning=false,shouldTeleportQueue=false,isSilent=
ExecutorUtils.getGlobal('BlossomSilent')or false,logger=_initialLogger}local
_signals={started=FastSignal.new(),stopped=FastSignal.new()}local _modules={}
local _syn=ExecutorUtils.getGlobal('syn')local _queueOnTeleport=ExecutorUtils.
getGlobal('queue_on_teleport')or ExecutorUtils.getGlobal('queueonteleport')or(
_syn and _syn.queue_on_teleport)local _clearTeleportQueue=ExecutorUtils.
getGlobal('clear_teleport_queue')or ExecutorUtils.getGlobal('clearteleportqueue'
)or(_syn and _syn.clear_teleport_queue)local _rawGetLoadedModules=ExecutorUtils.
getGlobal('getloadedmodules')local _getLoadedModules=_rawGetLoadedModules or
function()return nil end local _hookfunction=ExecutorUtils.getGlobal(
'hookfunction')or ExecutorUtils.getGlobal('replaceclosure')local _newcclosure=
ExecutorUtils.getGlobal('newcclosure')local _checkcaller=ExecutorUtils.
getGlobal('checkcaller')local _getgenvFunc=ExecutorUtils.getGlobal('getgenv')
local MODULES=ModuleRegistry.getModules()local function
_disableAnalyticsPipeline(logger)pcall(function()local controller=
ReplicatedFirst:FindFirstChild('AnalyticsPipelineController')if not controller
then controller=ReplicatedFirst:WaitForChild('AnalyticsPipelineController',10)
end if controller and controller:IsA('LocalScript')then(controller).Disabled=
true end end)local hookfunction=_hookfunction if not hookfunction then return
end pcall(function()local controller=ReplicatedFirst:FindFirstChild(
'AnalyticsPipelineController')if not controller then controller=ReplicatedFirst:
WaitForChild('AnalyticsPipelineController',10)end if not controller then return
end local pipeline=controller:FindFirstChild('AnalyticsPipeline')if not(pipeline
and pipeline:IsA('ModuleScript'))then return end local originalRequire local
pipelineModule=pipeline originalRequire=hookfunction(require,function(module,...
)if(module)==pipelineModule then return function()end end return(originalRequire
)(module,...)end)end)end local function _checkExecutorSupport(logger)local
missing={}if not _queueOnTeleport then missing.queue_on_teleport=true end if not
_clearTeleportQueue then missing.clear_teleport_queue=true end if not
_hookfunction then missing.hookfunction=true end if not _newcclosure then
missing.newcclosure=true end if not _checkcaller then missing.checkcaller=true
end if not _getgenvFunc then missing.getgenv=true end if not
_rawGetLoadedModules then missing.getloadedmodules=true end for name in pairs(
missing)do if logger.warnUnsupported then logger:warnUnsupported(name)else
logger:warn(string.format(
[[This executor does not support '%s'. Some features may not work as expected.]]
,name))end end end local function _handleTeleportQueue(shouldEnable)if
shouldEnable then if _clearTeleportQueue then _clearTeleportQueue()end if
_queueOnTeleport then local silentFlag=_state.isSilent and
'getgenv().BlossomSilent = true; _G.BlossomSilent = true;'or''_queueOnTeleport((
[[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):
format(silentFlag,BUNDLE_URL))end else if _clearTeleportQueue then
_clearTeleportQueue()end end end local function _connect()_maid:DoCleaning()if
_state.shouldTeleportQueue then _handleTeleportQueue(true)end end local function
_waitForClientLoaded()local localPlayer=Players.LocalPlayer while not
localPlayer do RunService.Heartbeat:Wait()localPlayer=Players.LocalPlayer end
local playerScripts=localPlayer:WaitForChild('PlayerScripts')local clientModule
repeat clientModule=playerScripts:FindFirstChild(CLIENT_MODULE_NAME)if not(
clientModule and clientModule:IsA('ModuleScript'))then clientModule=nil task.
wait(1)end until clientModule local controllersFolder repeat controllersFolder=
playerScripts:FindFirstChild('Controllers')if not controllersFolder then task.
wait(1)end until controllersFolder local folder=controllersFolder while true do
local isAllLoaded=true local loaded=_getLoadedModules()local loadedSet={}local
hasLoaded=loaded~=nil if loaded then for _,mod in ipairs(loaded)do loadedSet[mod
]=true end end local function _isLoaded(mod)if not hasLoaded then return true
end return loadedSet[mod]==true end if hasLoaded and not _isLoaded(clientModule)
then isAllLoaded=false else for _,child in ipairs(folder:GetChildren())do if
child:IsA('ModuleScript')then if hasLoaded and not _isLoaded(child)then
isAllLoaded=false break end end end end if isAllLoaded then break end task.wait(
0.5)end end function Client.loadModule(self,name,moduleOrPath)if _modules[name]
then return end local loader=function()if type(moduleOrPath)=='string'then local
dynamicRequire=require return dynamicRequire(moduleOrPath)end return
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
true _checkExecutorSupport(_state.logger)_disableAnalyticsPipeline(_state.logger
)local startTime=os.clock()_waitForClientLoaded()for _,entry in ipairs(MODULES)
do self:loadModule(entry.name,entry.loader)end _connect()_signals.started:Fire()
_state.logger:info(string.format('Blossom loaded in %.2f seconds.',os.clock()-
startTime))end function Client.destroy(self)if not _state.isRunning then return
end _state.isRunning=false _signals.stopped:Fire()_maid:DoCleaning()for _,
moduleResult in pairs(_modules)do local destroyFn=moduleResult.Destroy if
destroyFn then pcall(destroyFn,moduleResult)end end if _loggerModule and
_loggerModule.Destroy then _loggerModule.Destroy()end end local client=((
setmetatable({},Client)))client.Version='1.0.0'client.Logger=_initialLogger
client.Modules=_modules client.Started=_signals.started client.Stopped=_signals.
stopped client.IsSilent=_state.isSilent _state.logger=client.Logger return
client:start()