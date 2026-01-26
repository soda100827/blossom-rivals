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
end local Logger=__DARKLUA_BUNDLE_MODULES.a()local Signal=
__DARKLUA_BUNDLE_MODULES.b()local BUNDLE_URL=
[[https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau]]
local Client={Version='1.0.0',Logger=Logger.new('Blossom'),Events={Started=
Signal.new(),Stopped=Signal.new()},Modules={},IsRunning=false,_TeleportQueueConn
=nil}local MODULES={{Name='Movement',Path='src/features/Movement'},{Name=
'Visuals',Path='src/features/Visuals'},{Name='Interface',Path='src/ui/Interface'
}}function Client:LoadModule(name,moduleOrPath)if self.Modules[name]then self.
Logger:Warn('Module already loaded:',name)return end local loader=function()if
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
TeleportState.Started then queueOnTeleport(('loadstring(game:HttpGet("%s"))()'):
format(BUNDLE_URL))end end)end function Client:Start()if self.IsRunning then
return end self.IsRunning=true self.Logger:Info('Client initializing...')for _,
entry in ipairs(MODULES)do self:LoadModule(entry.Name,entry.Path)end self.Events
.Started:Fire()end function Client:Stop()self.IsRunning=false self.Events.
Stopped:Fire()for name,module in pairs(self.Modules)do if module.Cleanup then
pcall(module.Cleanup,module)end end self.Logger:Info('Client stopped.')end
return Client:Start()