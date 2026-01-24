local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
Logger={}Logger.__index=Logger function Logger.new(source)return setmetatable({
Source=source or'System'},Logger)end local function formatMessage(level,source,
...)local parts={...}for i,value in ipairs(parts)do parts[i]=tostring(value)end
local message=table.concat(parts,' ')return string.format('[\u{1f338}] %s',
message)end function Logger:Info(...)print(formatMessage('INFO',self.Source,...)
)end function Logger:Warn(...)warn(formatMessage('WARN',self.Source,...))end
function Logger:Error(...)error(formatMessage('ERROR',self.Source,...),0)end
return Logger end function __DARKLUA_BUNDLE_MODULES.a()local v=
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
__modImpl()local RunService=game:GetService('RunService')local Visuals={Enabled=
false,Connections={}}function Visuals:Init(Client)self.Client=Client self.Logger
=Client.Logger end function Visuals:Toggle(state)self.Enabled=state if state
then self:Enable()else self:Disable()end end function Visuals:Enable()table.
insert(self.Connections,RunService.RenderStepped:Connect(function()end))end
function Visuals:Disable()for _,conn in ipairs(self.Connections)do conn:
Disconnect()end self.Connections={}end function Visuals:Cleanup()self:Disable()
end return Visuals end function __DARKLUA_BUNDLE_MODULES.d()local v=
__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function
__modImpl()local repo=
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
MenuFadeTime=0.2})local tabs={Main=window:AddTab('Main'),Misc=window:AddTab(
'Misc'),['UI Settings']=window:AddTab('UI Settings')}local mainGroup=tabs.Main:
AddLeftGroupbox('Main')mainGroup:AddToggle('MovementToggle',{Text=
'Movement Assist',Default=false,Callback=function(state)local mod=self.Client.
Modules.Movement if mod and mod.Toggle then mod:Toggle(state)end end})mainGroup:
AddToggle('VisualsToggle',{Text='Visuals (ESP)',Default=false,Callback=function(
state)local mod=self.Client.Modules.Visuals if mod and mod.Toggle then mod:
Toggle(state)end end})local menuGroup=tabs['UI Settings']:AddLeftGroupbox('Menu'
)menuGroup:AddButton('Unload',function()Library:Unload()end)menuGroup:AddLabel(
'Menu bind'):AddKeyPicker('MenuKeybind',{Default='End',NoUI=true,Text=
'Menu keybind'})Library.ToggleKeybind=Options.MenuKeybind ThemeManager:
SetLibrary(Library)SaveManager:SetLibrary(Library)SaveManager:
IgnoreThemeSettings()ThemeManager:SetFolder('Blossom')SaveManager:SetFolder(
'Blossom')SaveManager:BuildConfigSection(tabs['UI Settings'])ThemeManager:
ApplyToTab(tabs['UI Settings'])local miscGroup=tabs.Misc:AddLeftGroupbox(
'Auto Load')miscGroup:AddToggle('AutoLoad',{Text='Auto Load',Default=false,
Callback=function(enabled)self.Client:SetTeleportQueue(enabled)if enabled then
local silent=Toggles.SilentMode and Toggles.SilentMode.Value or false
runAutoload(Library,SaveManager,silent)end end})miscGroup:AddToggle('SilentMode'
,{Text='Silent Mode',Default=false,Callback=function(enabled)if enabled then
setNotifyMuted(Library,true)else setNotifyMuted(Library,false)end end})self.
Logger:Info('UI mounted successfully')end function Interface:Cleanup()if self.
Library then self.Library:Unload()end end return Interface end function
__DARKLUA_BUNDLE_MODULES.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end
end local Services={Players=game:GetService('Players'),RunService=game:
GetService('RunService'),UserInputService=game:GetService('UserInputService')}
local Logger=__DARKLUA_BUNDLE_MODULES.a()local Signal=__DARKLUA_BUNDLE_MODULES.
b()local Client={Version='1.0.0',Logger=Logger.new('Blossom'),Events={Started=
Signal.new(),Stopped=Signal.new()},Modules={},IsRunning=false,_TeleportQueueConn
=nil}function Client:LoadModule(name,moduleOrPath)local loader=function()if
type(moduleOrPath)=='string'then return require(moduleOrPath)end return
moduleOrPath end local success,result=pcall(loader)if success then self.Modules[
name]=result if result.Init then task.spawn(function()result:Init(self)end)end
self.Logger:Info('Loaded module:',name)else self.Logger:Warn(
'Failed to load module:',name,result)end end function Client:SetTeleportQueue(
enabled)if self._TeleportQueueConn then self._TeleportQueueConn:Disconnect()self
._TeleportQueueConn=nil end if not enabled then return end local queueOnTeleport
=queue_on_teleport or queueonteleport or(syn and syn.queue_on_teleport)if not
queueOnTeleport then self.Logger:Warn('queue_on_teleport not available.')return
end local success,player=pcall(function()return game:GetService('Players').
LocalPlayer end)if not success or not player then self.Logger:Warn(
'LocalPlayer not available for teleport queue.')return end self.
_TeleportQueueConn=player.OnTeleport:Connect(function(state)if state==Enum.
TeleportState.Started then queueOnTeleport(
[[loadstring(game:HttpGet("https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau"))()
]]
)end end)end function Client:Start()if self.IsRunning then return end self.
IsRunning=true self.Logger:Info('Client initializing...')self:LoadModule(
'Movement',__DARKLUA_BUNDLE_MODULES.c())self:LoadModule('Visuals',
__DARKLUA_BUNDLE_MODULES.d())self:LoadModule('Interface',
__DARKLUA_BUNDLE_MODULES.e())self.Events.Started:Fire()end function Client:Stop(
)self.IsRunning=false self.Events.Stopped:Fire()for name,module in pairs(self.
Modules)do if module.Cleanup then pcall(module.Cleanup,module)end end self.
Logger:Info('Client stopped.')end return Client:Start()