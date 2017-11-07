--[[
* The MIT License
* Copyright (C) 2014 Bacioiu "Zapa" Ciprian (bacioiu.ciprian@gmail.com).  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom th be Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--function print( )

--end
KEY_W = 119
KEY_A = 97
KEY_D = 100
KEY_S = 115
KEY_Q = 113
KEY_E = 101
KEY_F = 102
KEY_P = 112
KEY_UP = 294
KEY_DOWN = 296
KEY_LEFT = 293
KEY_RIGHT =  295
KEY_ENTER = 269
KEY_SPACE = 32
KEY_I = 105
KEY_O = 111
KEY_L = 108
KEY_T = 116
KEY_V = 118
KEY_ESC = 283
KEY_QUESTION = 47
KEY_BRACKET_NEXT = 46
KEY_NOTHING = 90000
KEY_PLUS = 61
KEY_M = 109

KEY_2 = 50

KEY_PGN_UP = 289
KEY_PGN_DOWN = 290

scale = false

resX = MOAIEnvironment.horizontalResolution -- ? da hell
resY = MOAIEnvironment.verticalResolution
MOAILogMgr.setLogLevel (MOAILogMgr.LOG_NONE)
--io.stdout:setvbuf("no")

units_x = 960
units_y = 720

--MOAISim.enterFullscreenMode ()

SCREEN_X_OFFSET = 0
SCREEN_Y_OFFSET = 0

if scale == false then
	THEME_NAME = "basetheme.lua"
else
	THEME_NAME = "basetheme.lua"
end

GLOBAL_UNITS_X = units_x

if  MOAIEnvironment.osBrand ~= "Android"  then
	pathToWrite = ""
	_gAndroidOffset = 0
else
	pathToWrite = MOAIEnvironment.documentDirectory.."//"
	_gAndroidOffset = -10
end

local multiplier = 1
--10
if scale == false then
	
	resX =  960
	resY =  720
	--resX = 960
	--resY = 640
	div = resX / units_x * multiplier
	div2 = resY / units_y * multiplier
else
	resX = MOAIEnvironment.horizontalResolution or 960
	resY = MOAIEnvironment.verticalResolution or 720
	div = resX / units_x * multiplier
	div2 = resY / units_y *multiplier 
	
end
local DEVICE_WIDTH = resX
local DEVICE_HEIGHT = resY
local SCREEN_WIDTH = units_x
local SCREEN_HEIGHT = units_y
local SCREEN_UNITS_Y = units_y
local SCREEN_UNITS_X = units_x

local gameAspect = SCREEN_UNITS_Y / SCREEN_UNITS_X
local realAspect = DEVICE_HEIGHT / DEVICE_WIDTH

if realAspect > gameAspect then
    SCREEN_WIDTH = resX
    SCREEN_HEIGHT = resY
else
    SCREEN_WIDTH = resX
    SCREEN_HEIGHT = resY
end
 
if SCREEN_WIDTH < resX then
    SCREEN_X_OFFSET = 0
end
 
if SCREEN_HEIGHT < resY then
    SCREEN_Y_OFFSET = 0
end

local DEVICE_WIDTH = resX
local DEVICE_HEIGHT = resY
 if realAspect > gameAspect then
    SCREEN_WIDTH = DEVICE_WIDTH
    SCREEN_HEIGHT = DEVICE_WIDTH * gameAspect
 else
    SCREEN_WIDTH = DEVICE_HEIGHT / gameAspect
    SCREEN_HEIGHT = DEVICE_HEIGHT
 end

 if SCREEN_WIDTH < DEVICE_WIDTH then
    SCREEN_X_OFFSET = ( DEVICE_WIDTH - SCREEN_WIDTH ) * 0.5
 end

 if SCREEN_HEIGHT < DEVICE_HEIGHT then
    SCREEN_Y_OFFSET = ( DEVICE_HEIGHT - SCREEN_HEIGHT ) * 0.5
 end
--viewport:setSize ( SCREEN_X_OFFSET, SCREEN_Y_OFFSET, SCREEN_X_OFFSET + SCREEN_WIDTH, SCREEN_Y_OFFSET + SCREEN_HEIGHT )
--[[
SCREEN_X_OFFSET, SCREEN_Y_OFFSET, SCREEN_X_OFFSET + SCREEN_WIDTH, SCREEN_Y_OFFSET + SCREEN_HEIGHT

]]
vpx1 = SCREEN_X_OFFSET
vpy1 = SCREEN_Y_OFFSET

vpx2 = SCREEN_X_OFFSET + SCREEN_WIDTH
vpy2 = SCREEN_Y_OFFSET + SCREEN_HEIGHT
--if resX == nil then resX = 960 end
--if resY == nil then resY = 640 end




g_ActionPhaseLayer = 1
g_ActionPhase_UI_Layer = 2
g_BackgroundLayer = 3
g_GroundLayer = 4
g_RangeLayer = 5
g_Ui_Layer = 6
g_Text_Layer = 7
-----------------------------------------
----- USER INTERFACE ----------------------
---------------------------------------------
require "gui/support/class"

gui = require "gui/gui"
resources = require "gui/support/resources"
filesystem = require "gui/support/filesystem"
inputconstants = require "gui/support/inputconstants"

--------------------------------------------
----------------------------------------------
--------------------------------------------
require "additional.moses"
require "additional.csvData"

require "core.core"
require "core.image"
require "core.camera"
require "core.StateMachine"
require "core.input"
require "core.renderer"
require "core.math"
require "core.grid"
require "core.animation"
require "core.keyboard"
require "core.font"
require "core.effects"
require "core.sound"
require "core.networking"
require "core.3dbasic"
require "core.meshAnimation"
require "Game.game" -- THE ACTUAL MAIN FILE! MAIN LUA is AREA 51, front for area 52 :D
require "core.importCollada"
useCollada = true


sound:init( )

app_name = "Ebony Spire: Heresy"


layermgr = require "layermgr"



core:init( )
core:seWindow(resX, resY, scale)
core:setViewPort(1, ViewPort1, vpx1, vpy1, vpx2, vpy2, 1)

--partition = MOAIPartition.new ()


core:newLayer(Layer1, 1)
-- don't feel like tweaking 'round' my layer wrapper! Gonna do it some other way

core:newLayer(Layer2, 1)
core:newLayer(Layer3, 1)
core:newLayer(Layer4, 1)
core:newLayer(Layer5, 1)
core:setViewPort(6, ViewPort2, resX, resY, 1)
core:newLayer(Layer6, 2)
core:newLayer(Layer7, 1)
core:newLayer(Layer8, 1)


--core:layerSetPartition(1, partition)
--core:layerSetPartition(2, partition)

MOAISim.setStep ( 1 / 60 )
MOAISim.clearLoopFlags ()
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
--MOAISim.setLoopFlags ( MOAISim.LOOP_FLAGS_FIXED)
MOAISim.setBoostThreshold ( 0 )


--MOAIGfxDevice.setPenColor ( 1, 1, 1, 1 )
function setClearColor( r, g, b )
        local fb = MOAIGfxDevice:getFrameBuffer()
        fb:setClearColor( r, g, b )
end
setClearColor(0.137, 0, 0.137 , 1)
--setClearColor(0,0,0, 1)

layermgr.addLayer("ActionPhase",4,core:returnLayer(1))
layermgr.addLayer("ActionPhase_hb",5,core:returnLayer(2)) -- main game layer! TODO: Separate draw layers for diff states
layermgr.addLayer("BackgroundLayer",0,core:returnLayer(3))
layermgr.addLayer("GroundLayer",1,core:returnLayer(4))
layermgr.addLayer("RangeLayer",3,core:returnLayer(5))
layermgr.addLayer("UiLayer", 6, core:returnLayer(6))
layermgr.addLayer("TextLayer", 7, core:returnLayer(7))
layermgr.addLayer("ScenaryLayer", 8, core:returnLayer(8))

CAM_GL = nil



--core:_debugRenderLayer(1) -- Still playing around with this.

--mm_Heavy Fabric_0.ogg



g = gui.GUI( units_x, units_y, vpx1, vpy1, vpx2, vpy2, units_x, units_y)
layermgr.addLayer("gui", 99999, g:layer())
--core:setViewPort(
core:addGuiViewPort(g:viewport(), vpx1, vpy1, vpx2, vpy2, 1)


MOAIGfxDevice.setListener(MOAIGfxDevice.EVENT_RESIZE, OnScreenResize )

--MOAIGfxDevice.setListener(MOAIGfxDevice.EVENT_RESIZE, OnScreenResize )
Game:init( )

--function print( )

--end

function GameLoop( )
	while true do
        local FRAME = MOAISim.getPerformance ()
        local DrawCalls = MOAIRenderMgr.getPerformanceDrawCount() 

     	--print("FPS: "..FRAME.."")
      --	print("DRAW: "..DrawCalls.."")
        Game:loop( )
        coroutine.yield()
    end
end

mainThread = MOAICoroutine.new()
mainThread:run(GameLoop)


