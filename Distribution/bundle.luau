type ScriptSignal__DARKLUA_TYPE_a<T...> ={IsActive:(self:
ScriptSignal__DARKLUA_TYPE_a<T...>)->boolean,Fire:(self:
ScriptSignal__DARKLUA_TYPE_a<T...>,T...)->(),Connect:(self:
ScriptSignal__DARKLUA_TYPE_a<T...>,callback:(T...)->())->
ScriptConnection__DARKLUA_TYPE_b,Once:(self:ScriptSignal__DARKLUA_TYPE_a<T...>,
callback:(T...)->())->ScriptConnection__DARKLUA_TYPE_b,DisconnectAll:(self:
ScriptSignal__DARKLUA_TYPE_a<T...>)->(),Destroy:(self:
ScriptSignal__DARKLUA_TYPE_a<T...>)->(),Wait:(self:ScriptSignal__DARKLUA_TYPE_a<
T...>)->T...}type ScriptConnection__DARKLUA_TYPE_b={Disconnect:(self:
ScriptConnection__DARKLUA_TYPE_b)->(),Connected:boolean}type
Class__DARKLUA_TYPE_c=ScriptSignal__DARKLUA_TYPE_a<...any>type
Fusion__DARKLUA_TYPE_d=Types.Fusion type Animatable__DARKLUA_TYPE_e=Types.
Animatable type UsedAs__DARKLUA_TYPE_f<T> =Types.UsedAs<T>type
Child__DARKLUA_TYPE_g=Types.Child type Computed__DARKLUA_TYPE_h<T> =Types.
Computed<T>type Contextual__DARKLUA_TYPE_i<T> =Types.Contextual<T>type
GraphObject__DARKLUA_TYPE_j=Types.GraphObject type For__DARKLUA_TYPE_k<KO,VO> =
Types.For<KO,VO>type Observer__DARKLUA_TYPE_l=Types.Observer type
PropertyTable__DARKLUA_TYPE_m=Types.PropertyTable type Scope__DARKLUA_TYPE_n<
Constructors=Fusion__DARKLUA_TYPE_d> =Types.Scope<Constructors>type
ScopedObject__DARKLUA_TYPE_o=Types.ScopedObject type SpecialKey__DARKLUA_TYPE_p=
Types.SpecialKey type Spring__DARKLUA_TYPE_q<T> =Types.Spring<T>type
StateObject__DARKLUA_TYPE_r<T> =Types.StateObject<T>type Task__DARKLUA_TYPE_s=
Types.Task type Tween__DARKLUA_TYPE_t<T> =Types.Tween<T>type Use__DARKLUA_TYPE_u
=Types.Use type Value__DARKLUA_TYPE_v<T,S=T> =Types.Value<T,S>type
Version__DARKLUA_TYPE_w=Types.Version local a={cache={}::any}do do
local function __modImpl()local b={}b.__index=b function b.new(c:string)return
setmetatable({Source=c or'System'},b)end function b.Info(c,...)print(string.
format('[\27[34m%s\27[0m] ',c.Source),...)end function b.Warn(c,...)warn(string.
format('[%s] ',c.Source),...)end function b.Error(c,...)error(string.format(
'[%s] ',c.Source).. ...,0)end return b end function a.a():typeof(__modImpl())
local b=a.cache.a if not b then b={c=__modImpl()}a.cache.a=b end return b.c end
end do local function __modImpl()local b:boolean do b=false local c=Instance.new
'BindableEvent'local d=false c.Event:Connect(function()d=true end)c:Fire()c:
Destroy()if d==false then b=true end end local c:typeof(require(script.Docs))=b
and require(script.Deferred)or require(script.Immediate)return c end function a.
b():typeof(__modImpl())local b=a.cache.b if not b then b={c=__modImpl()}a.cache.
b=b end return b.c end end do local function __modImpl()local b={Enabled=false,
Connections={}}function b.Init(c,d)c.Client=d c.Logger=d.Logger c.Logger:Info
'Movement loaded'end function b.Toggle(c,d:boolean)c.Enabled=d if d then c.
Logger:Info'Movement Enabled'else c.Logger:Info'Movement Disabled'end end
function b.Cleanup(c)c:Toggle(false)end return b end function a.c():typeof(
__modImpl())local b=a.cache.c if not b then b={c=__modImpl()}a.cache.c=b end
return b.c end end do local function __modImpl()local b=game:GetService
'RunService'local c={Enabled=false,Connections={}}function c.Init(d,e)d.Client=e
d.Logger=e.Logger d.Logger:Info'Visuals loaded'end function c.Toggle(d,e:boolean
)d.Enabled=e if e then d:Enable()else d:Disable()end end function c.Enable(d)d.
Logger:Info'ESP Enabled'table.insert(d.Connections,b.RenderStepped:Connect(
function()end))end function c.Disable(d)d.Logger:Info'ESP Disabled'for e,f in
ipairs(d.Connections)do f:Disconnect()end d.Connections={}end function c.Cleanup
(d)d:Disable()end return c end function a.d():typeof(__modImpl())local b=a.cache
.d if not b then b={c=__modImpl()}a.cache.d=b end return b.c end end do
local function __modImpl()local b=require(script.Types)local c=require(script.
External)do local d=require(script.RobloxExternal)c.setExternalProvider(d)end
local d:Fusion__DARKLUA_TYPE_d=table.freeze{version={major=0,minor=3,isRelease=
true},Contextual=require(script.Utility.Contextual),Safe=require(script.Utility.
Safe),cleanup=require(script.Memory.legacyCleanup),deriveScope=require(script.
Memory.deriveScope),doCleanup=require(script.Memory.doCleanup),innerScope=
require(script.Memory.innerScope),scoped=require(script.Memory.scoped),Observer=
require(script.Graph.Observer),Computed=require(script.State.Computed),ForKeys=
require(script.State.ForKeys)::b.ForKeysConstructor,ForPairs=require(script.
State.ForPairs)::b.ForPairsConstructor,ForValues=require(script.State.ForValues)
::b.ForValuesConstructor,peek=require(script.State.peek),Value=require(script.
State.Value),Attribute=require(script.Instances.Attribute),AttributeChange=
require(script.Instances.AttributeChange),AttributeOut=require(script.Instances.
AttributeOut),Child=require(script.Instances.Child),Children=require(script.
Instances.Children),Hydrate=require(script.Instances.Hydrate),New=require(script
.Instances.New),OnChange=require(script.Instances.OnChange),OnEvent=require(
script.Instances.OnEvent),Out=require(script.Instances.Out),Tween=require(script
.Animation.Tween),Spring=require(script.Animation.Spring)}return d end function
a.e():typeof(__modImpl())local b=a.cache.e if not b then b={c=__modImpl()}a.
cache.e=b end return b.c end end do local function __modImpl()local b={
Background=Color3.fromRGB(25,25,35),Header=Color3.fromRGB(30,30,45),Accent=
Color3.fromRGB(100,150,255),Text=Color3.fromRGB(240,240,240),TextDim=Color3.
fromRGB(150,150,150),Border=Color3.fromRGB(50,50,60),ElementBackground=Color3.
fromRGB(35,35,45),ElementHover=Color3.fromRGB(45,45,55)}function b.GetColor(c,d)
return c[d]or Color3.new(1,0,1)end return b end function a.f():typeof(__modImpl(
))local b=a.cache.f if not b then b={c=__modImpl()}a.cache.f=b end return b.c
end end do local function __modImpl()local b=game:GetService'UserInputService'
local c=a.e()local d=a.f()local e=c.New local f=c.Children local g=c.OnEvent
local h=c.Value local function Window(i)local j=h(UDim2.new(0.5,-250,0.5,-175))
local k=false local l=Vector2.new(0,0)local m=UDim2.new(0,0,0,0)local function
InputBegan(n)if n.UserInputType==Enum.UserInputType.MouseButton1 then k=true l=n
.Position m=j:get()end end b.InputChanged:Connect(function(n)if k and n.
UserInputType==Enum.UserInputType.MouseMovement then local o=n.Position-l local
p=UDim2.new(m.X.Scale,m.X.Offset+o.X,m.Y.Scale,m.Y.Offset+o.Y)j:set(p)end end)b.
InputEnded:Connect(function(n)if n.UserInputType==Enum.UserInputType.
MouseButton1 then k=false end end)return e'Frame'{Name='MainWindow',Size=i.Size
or UDim2.new(0,500,0,350),Position=j,BackgroundColor3=d.Background,
BorderSizePixel=0,[f]={e'UICorner'{CornerRadius=UDim.new(0,8)},e'UIStroke'{Color
=d.Border,Thickness=1},e'Frame'{Name='Header',Size=UDim2.new(1,0,0,40),
BackgroundColor3=d.Header,[g'InputBegan']=InputBegan,[f]={e'UICorner'{
CornerRadius=UDim.new(0,8)},e'Frame'{Size=UDim2.new(1,0,0,10),Position=UDim2.
new(0,0,1,-10),BackgroundColor3=d.Header,BorderSizePixel=0},e'TextLabel'{Size=
UDim2.new(1,-20,1,0),Position=UDim2.new(0,20,0,0),BackgroundTransparency=1,Text=
i.Title,TextColor3=d.Text,Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=
Enum.TextXAlignment.Left}}},e'ScrollingFrame'{Size=UDim2.new(1,-20,1,-50),
Position=UDim2.new(0,10,0,45),BackgroundTransparency=1,ScrollBarThickness=2,
ScrollBarImageColor3=d.Accent,AutomaticCanvasSize=Enum.AutomaticSize.Y,
CanvasSize=UDim2.new(0,0,0,0),BorderSizePixel=0,[f]={e'UIListLayout'{Padding=
UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},i[f]}}}}end return Window
end function a.g():typeof(__modImpl())local b=a.cache.g if not b then b={c=
__modImpl()}a.cache.g=b end return b.c end end do local function __modImpl()
local b=a.e()local c=a.f()local d=b.New local e=b.Children local f=b.OnEvent
local g=b.Value local h=b.Spring local i=b.Computed local function Toggle(j)
local k=j.State or g(false)local l=j.Callback or function()end local m=h(i(
function()return k:get()and 1 or 0 end),25,0.8)return d'TextButton'{Size=UDim2.
new(1,0,0,32),BackgroundColor3=c.ElementBackground,Text='',AutoButtonColor=false
,[f'MouseButton1Click']=function()local n=not k:get()k:set(n)task.spawn(l,n)end,
[e]={d'UICorner'{CornerRadius=UDim.new(0,6)},d'TextLabel'{Size=UDim2.new(1,-50,1
,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,TextColor3=c.Text,
TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=14,
Text=j.Title},d'Frame'{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,
0.5,0),Size=UDim2.new(0,40,0,20),BackgroundColor3=i(function()return k:get()and
c.Accent or c.ElementHover end),[e]={d'UICorner'{CornerRadius=UDim.new(1,0)},d
'Frame'{AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0,16,0,16),Position=i(
function()local n=m:get()return UDim2.new(0,2+(20*n),0.5,0)end),BackgroundColor3
=c.Text,[e]={d'UICorner'{CornerRadius=UDim.new(1,0)}}}}}}}end return Toggle end
function a.h():typeof(__modImpl())local b=a.cache.h if not b then b={c=
__modImpl()}a.cache.h=b end return b.c end end do local function __modImpl()game
:GetService'RunService'local b=a.e()local c=a.g()local d=a.h()local e=b.New
local f=b.Children local g={}function g.Init(h,i)h.Client=i h.Logger=i.Logger
local j,k=pcall(function()return game:GetService'CoreGui'end)if not j then k=
game:GetService'Players'.LocalPlayer:WaitForChild'PlayerGui'end h.Target=k h:
Mount()end function g.Mount(h)if h.Target:FindFirstChild'BlossomUI'then h.Target
.BlossomUI:Destroy()end local i=e'ScreenGui'{Name='BlossomUI',Parent=h.Target,
ResetOnSpawn=false,DisplayOrder=100,[f]={c{Title='Blossom '..h.Client.Version,[f
]={d{Title='Movement Assist',Callback=function(i)local j=h.Client.Modules.
Movement if j and j.Toggle then j:Toggle(i)end end},d{Title='Visuals (ESP)',
Callback=function(i)local j=h.Client.Modules.Visuals if j and j.Toggle then j:
Toggle(i)end end}}}}}h.Instance=i h.Logger:Info'UI mounted successfully'end
function g.Cleanup(h)if h.Instance then h.Instance:Destroy()end end return g end
function a.i():typeof(__modImpl())local b=a.cache.i if not b then b={c=
__modImpl()}a.cache.i=b end return b.c end end end local b={Players=game:
GetService'Players',RunService=game:GetService'RunService',UserInputService=game
:GetService'UserInputService'}local c=a.a()local d=a.b()type BlossomClient={
Version:string,Logger:any,Events:{[string]:any},Modules:{[string]:any},IsRunning
:boolean,LoadModule:(self:BlossomClient,name:string,moduleOrPath:any)->(),Start:
(self:BlossomClient)->(),Stop:(self:BlossomClient)->()}local e:BlossomClient={
Version='1.0.0',Logger=c.new'Blossom',Events={Started=d.new(),Stopped=d.new()},
Modules={},IsRunning=false}function e.LoadModule(f,g,h)local i=function()if
type(h)=='string'then return require(h)end return h end local j,k=pcall(i)if j
then f.Modules[g]=k if k.Init then task.spawn(function()k:Init(f)end)end f.
Logger:Info('Loaded module:',g)else f.Logger:Warn('Failed to load module:',g,k)
end end function e.Start(f)if f.IsRunning then return end f.IsRunning=true f.
Logger:Info'Client initializing...'f:LoadModule('Movement',a.c())f:LoadModule(
'Visuals',a.d())f:LoadModule('Interface',a.i())f.Events.Started:Fire()end
function e.Stop(f)f.IsRunning=false f.Events.Stopped:Fire()for g,h in pairs(f.
Modules)do if h.Cleanup then pcall(h.Cleanup,h)end end f.Logger:Info
'Client stopped.'end return e:Start()