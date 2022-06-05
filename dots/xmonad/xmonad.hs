import XMonad
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spacing

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers

import qualified XMonad.StackSet as W

colBackground   = "#282a36"
colCurLine      = "#44475a"
colSelection    = "#44475a"
colForeground   = "#f8f8f2"
colComment      = "#6272a4"
colCyan         = "#8be9fd"
colGreen        = "#50fa7b"
colOrange       = "#ffb86c"
colPink         = "#ff79c6"
colPurple       = "#bd93f9"
colRed          = "#ff5555"
colYellow       = "#f1fa8c"

myConfig = desktopConfig
    { terminal = "alacritty"
    , modMask = mod4Mask
    , borderWidth = 2
    , normalBorderColor = colBackground
    , focusedBorderColor = colPurple
    , focusFollowsMouse = True
    , layoutHook = myLayout
    }

myKeys = 
    [ ((mod4Mask, xK_d), spawn "rofi -show combi")
    , ((mod4Mask, xK_Return), spawn "alacritty")
    , ((mod4Mask, xK_n), spawn "alacritty --command neomutt")
    , ((mod4Mask, xK_p), spawn "flameshot gui")
    , ((mod4Mask, xK_h), windows W.focusDown)
    , ((mod4Mask, xK_l), windows W.focusUp)
    , ((mod4Mask, xK_j), sendMessage Shrink)
    , ((mod4Mask, xK_k), sendMessage Expand)
    , ((mod4Mask, xK_w), kill)
    , ((mod4Mask, xK_s), windows W.swapMaster)
    , ((mod4Mask, xK_minus), spawn "pamixer -d 5")
    , ((mod4Mask, xK_equal), spawn "pamixer -i 5")
    ]

myLayout = spacingRaw False (Border 3 3 3 3) True (Border 3 3 3 3) True $
           layoutHook def

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent = active . wrap "[" "]"
    , ppHidden = visible . wrap " " " "
    , ppHiddenNoWindows = empty . wrap " " " "
    , ppWsSep = ""
    , ppTitle = active . wrap " " " " . shorten 40
    , ppLayout = layout . wrap " λ " " "
    , ppSep = empty "|"
    }
    where
        active = xmobarColor colPink colBackground 
        visible = xmobarColor colForeground colBackground 
        empty = xmobarColor colComment colBackground 
        layout = xmobarColor colPurple colBackground 

main = xmonad
     . ewmhFullscreen
     . ewmh 
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig `additionalKeys` myKeys
