         

         

         

        MYM = {}

         

        PNG_EXTENSION = ".png"

        BG_SUFFIX = ""

        ASSET_SUFFIX = ""

        GFX_SCALE_X, GFX_SCALE_Y = 1, 1

        GLOBAL_SCALE_X, GLOBAL_SCALE_Y = 1, 1

         

        local testScreenScale = false

        local simulateAndroidDevice = false

         

        local osBranch = MOAIEnvironment.osBrand

        local osVersion = MOAIEnvironment.osVersion

         

        local defaultW, defaultH = 1024, 768 --1136, 640

        local screenW, screenH

        local viewW, viewH

        local scaleX, scaleY

        local viewportScaleX, viewportScaleY

         

         

        -- Return the view size.

        -- We support all iOS resolutions, but not Android's.

        -- We need to scale for most of Android devices.

        -- This function returns the view size that we supported,

        -- Hanappe's Application will do the scale automatically.

        local function calcViewSize()

               

                -- test Android screen size

                if ((testScreenScale or simulateAndroidDevice) and not MYM.isMobile()) then

                        MOAIEnvironment.horizontalResolution = 2048

                        MOAIEnvironment.verticalResolution = 1536

                end

               

                screenW = MOAIEnvironment.horizontalResolution or defaultW

                screenH = MOAIEnvironment.verticalResolution or defaultH

                if (MYM.isAndroid() or testScreenScale) then

                        --&#91;&#91;if (screenW >= 1920) then

                                viewW, viewH = 2560, 1440

                        elseif (screenW == 1280) then

                                viewW, viewH = 1280, 720

                        elseif (screenH >= 720) then

                                viewW, viewH = 1024, 768

                        elseif (screenH <= 320) then

                                viewW, viewH = 480, 320

                        else

                                viewW, viewH = 1280, 720

                        end&#93;&#93;

                        viewW, viewH = 1024, 768--2048, 1536

                else

                        if (screenW < screenH) then

                                viewW, viewH = screenH, screenW

                                screenW, screenH = viewW, viewH

                        else

                                viewW, viewH = screenW, screenH

                        end

                        if (not is4xGfx()) then

                                viewW, viewH = 1024, 768

                        end

                end

               

                -- scale down the screen size for easier to test on desktop

                if (testScreenScale) then

                        if (viewH >= 720) then

                                if (viewW / viewH >= 1.7) then

                                        MOAIEnvironment.horizontalResolution = 1152

                                        MOAIEnvironment.verticalResolution = 648

                                elseif (viewW / viewH == 1.6) then

                                        MOAIEnvironment.horizontalResolution = 1152

                                        MOAIEnvironment.verticalResolution = 720

                                elseif (viewW / viewH >= 1.3) then

                                        MOAIEnvironment.horizontalResolution = 1024

                                        MOAIEnvironment.verticalResolution = 768

                                end

                               

                                screenW = MOAIEnvironment.horizontalResolution

                                screenH = MOAIEnvironment.verticalResolution

                        end

                end

               

                scaleX = viewW / screenW

                scaleY = viewH / screenH

               

                if (isGfxiPadRetina()

                        or isGfxiPhoneRetina()

                        or isGfx_16_9_1440()) then

                        viewportScaleX = viewW / 2

                        viewportScaleY = viewH / 2

                        GLOBAL_SCALE_X = 0.5

                        GLOBAL_SCALE_Y = 0.5

                else

                        viewportScaleX = viewW

                        viewportScaleY = viewH

                end

               

                return viewW, viewH

        end

         

        function isGfx_3_2_320()

                return (MYM.getViewWidth() == 480 and MYM.getViewHeight() == 320)

        end

         

        function isGfx_3_2_640()

                return (MYM.getViewWidth() == 960 and MYM.getViewHeight() == 640)

        end

         

        function isGfx_16_9_640()

                return (MYM.getViewWidth() == 1136 and MYM.getViewHeight() == 640)

        end

         

        function isGfx_4_3_768()

                return (MYM.getViewWidth() == 1024 and MYM.getViewHeight() == 768)

        end

         

        function isGfx_4_3_1536()

                return (MYM.getViewWidth() == 2048 and MYM.getViewHeight() == 1536)

        end

         

        function isGfxiPhoneRetina()

                return (isGfx_3_2_640() or isGfx_16_9_640())

        end

         

        function isGfxiPadRetina()

                return isGfx_4_3_1536()

        end

         

        function isGfxiOSRetina()

                return (isGfxiPhoneRetina() or isGfxiPadRetina())

        end

         

        function isGfx_16_9_720()

                return (MYM.getViewWidth() == 1280 and MYM.getViewHeight() == 720)

        end

         

        function isGfx_16_9_1440()

                return (MYM.getViewWidth() == 2560 and MYM.getViewHeight() == 1440)

        end

         

        function is2xGfx()

                return (isGfxiPhoneRetina()

                                or isGfx_4_3_768()

                                or isGfx_16_9_720())

        end

         

        function is4xGfx()

                return (isGfxiPadRetina()

                                or isGfx_16_9_1440())

        end

         

         

         

        -- init assets config

        local function initAssetsConfig()

                if (isGfx_4_3_768()) then

                        BG_SUFFIX = "-1024x768"

                        ASSET_SUFFIX = "@2x"

                elseif (isGfx_4_3_1536()) then

                        BG_SUFFIX = "-2048x1536"

                        ASSET_SUFFIX = "@4x"

                elseif (isGfx_3_2_640()) then

                        BG_SUFFIX = "-960x640"

                        ASSET_SUFFIX = "@2x"

                elseif (isGfx_16_9_640()) then

                        BG_SUFFIX = "-1136x640"

                        ASSET_SUFFIX = "@2x"

                elseif (isGfx_16_9_1440()) then

                        BG_SUFFIX = "-2560x1440"

                        ASSET_SUFFIX = "@4x"

                elseif (isGfx_16_9_720()) then

                        BG_SUFFIX = "-1280x720"

                        ASSET_SUFFIX = "@2x"

                else

                        BG_SUFFIX = "-480x320"

                        ASSET_SUFFIX = "@1x"

                end

        end

         

         

         

        -- init the MYM config

        function MYM.init()

                calcViewSize()

                initAssetsConfig()

        end

         

        function MYM.isLandscape()

                return true

        end

         

        -- return TRUE if the current device is iOS

        function MYM.isiOS()

                return (osBranch == "iOS")

        end

         

        -- return TRUE if the current device is Android

        function MYM.isAndroid()

                return (osBranch == "Android")

        end

         

        function MYM.isSimulateAndroid()

                return simulateAndroidDevice or false

        end

         

        -- return TRUE if the current device is mobile

        function MYM.isMobile()

                return (MYM.isiOS() or MYM.isAndroid())

        end

         

        -- return the device's OS version

        function MYM.getDeviceVersion()

                return osVersion

        end

         

        -- Return device's view width

        function MYM.getViewWidth()

                return viewW

        end

         

        -- Return device's view height

        function MYM.getViewHeight()

                return viewH

        end

         

        -- Return device's screen width

        function MYM.getScreenWidth()

                return screenW

        end

         

        -- Return device's screen height

        function MYM.getScreenHeight()

                return screenH

        end

         

        -- Return device's scale x

        function MYM.getScaleX()

                return scaleX

        end

         

        -- Return device's scale y

        function MYM.getScaleY()

                return scaleY

        end

         

        -- Return the value for viewport scale x

        function MYM.getValueForViewportScaleX()

                return viewportScaleX

        end

         

        -- Return the value for viewport scale y

        function MYM.getValueForViewportScaleY()

                return viewportScaleY

        end

         

        -- Returns the audio format for music, Android only plays 'ogg'. iOS is

        -- optimised for 'mp3'

        function MYM.getMusicFormat()

                --if (MYM.isAndroid()) then

                --      return '.ogg'

                --else

                        return '.mp3'

                --end

        end

         

        function MYM.getSfxFormat()

                if (MYM.isAndroid()) then

                        return '.ogg'

                else

                        return '.wav'

                end

        end

         

