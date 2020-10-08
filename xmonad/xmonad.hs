import XMonad
import System.IO (hPutStrLn, Handle)

import Data.List
import Data.Monoid
import Data.Maybe
import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, isDialog)

import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Simplest
import XMonad.Layout.Renamed
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.Master
import XMonad.Layout.SimplestFloat
import qualified XMonad.Layout.BoringWindows as BW

import XMonad.Layout.Roledex

import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops

-- Used programs
myTerminal = "konsole"
myScreenshotTool = "maim -s -u | xclip -selection clipboard -t image/png -i"

-- Font

myFont = "xft:Source Code Pro:regular:pixelsize=16"
mySmallFont = "xft:Source Code Pro:size=9:bold:antialias=true" 

-- All used colors

colorWhite = "#ffffff"
colorBlack = "#000000"
colorGray = "#d0d0d0"
colorDark = "#212026"
colorLightDark = "#5d4d71"
colorLight = "#cdadda"
colorLightLight = "#ddbdea"

-- Helper Functions

quoteStr :: [Char] -> [Char]
quoteStr str = "\'" ++ str ++ "\'" 

quoteInt :: Int -> [Char]
quoteInt int = quoteStr $ show int 

myLayout = avoidStruts $ windowNavigation $ BW.boringWindows $ -- Global layout modificators
	(
	addTabs shrinkText myTabConfig $ subLayout [0] (Simplest) $ -- In reality it is Tab 
	tall ||| mirTall ||| grid
	) 
	||| tab ||| simplestFloat -- If layout is tabbed disable sublayout 
	where 
		defSpace = spacing 1
		tall = renamed [ Replace "Def. Tall" ] $ defSpace $ ResizableTall 1 (3/100) (1/2) []
		mirTall = renamed [ Replace "Rot. Tall" ] $ Mirror $ defSpace $ ResizableTall 1 (3/100) (1/2) []
		grid = renamed [ Replace "Grid" ] $ defSpace $ Grid
		tab = renamed [ Replace "Tabbed" ] $ noBorders $ tabbed shrinkText myTabConfig
		myTabConfig = def { 
				fontName            = mySmallFont
			      , activeColor         = colorLight
			      , inactiveColor       = colorLightDark
			      , activeBorderColor   = colorLightDark
			      , inactiveBorderColor = colorDark
			      , activeTextColor     = colorWhite
			      , inactiveTextColor   = colorGray
			      }

dmenuCommand :: [Char]
dmenuCommand = "dmenu_run -fn " ++ 
	 	quoteStr myFont ++ 
	 	" -nb " ++ 
	 	quoteStr colorDark ++ 
	 	" -nf " ++ 
	 	quoteStr colorLight ++ 
	 	" -sb " ++ 
	 	quoteStr colorLightLight ++ 
	 	" -sf " ++
		quoteStr colorBlack


newKeys :: [([Char], X())] 
newKeys = 
     [
         ("M-s", spawn dmenuCommand),
	 ("M-<Tab>", sendMessage (NextLayout)),

	 ("<Print>", spawn myScreenshotTool),
	 
	 ("M-C-h", sendMessage $ pullGroup L),
	 ("M-C-l", sendMessage $ pullGroup R),
	 ("M-C-k", sendMessage $ pullGroup U),
	 ("M-C-j", sendMessage $ pullGroup D),
	 ("M-C-b", withFocused $ sendMessage . UnMergeAll),
	 ("M-C-n", withFocused $ sendMessage . UnMerge),
	 ("M-C-m", withFocused $ sendMessage . MergeAll)
       ] 

removedKeys :: [String]
removedKeys = [ "M-S-q", "M-S-p", "M-p", "M-<space>" ]

myManageHook = composeAll . concat $
     [ 
       [ className =? cls --> doFloat | cls <- floatingClasses ],
       [ title     =? ttl --> doFloat | ttl <- floatingApps ],
       [ isDialog --> doFloat ]
       -- [ isFullscreen --> doFullFloat ]
     ]
     where floatingApps = [  ] -- By title
     	   floatingClasses = [ "Steam", "megasync", "MEGAsync", "Pavucontrol", "matplotlib" ] -- By class

myStartup :: X ()
myStartup = mapM_ spawnOnce 
	[ 
	"nitrogen --restore", 
	"megasync",
    "xscreensaver",
	"stalonetray --geometry 3x1+1300+0"
	-- "stalonetray --geometry 3x1-700+0" 
	]

createbar :: MonadIO m => Int -> m Handle
createbar id = spawnPipe $ "xmobar -x " ++ quoteInt id ++ " -B " ++ quoteStr colorDark ++ " -F " ++ quoteStr colorLight ++ " -f " ++ quoteStr myFont

main :: IO ()
main = do
	bar0 <- createbar 0
	bar1 <- createbar 1
	xmonad $ ewmh $ desktopConfig
		{ terminal    = myTerminal
		, modMask     = mod4Mask
		, borderWidth = 2
		, normalBorderColor = colorDark
		, focusedBorderColor= colorLight
		, manageHook = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks 
		, layoutHook = myLayout 
		, startupHook = myStartup
		, logHook = dynamicLogWithPP xmobarPP
				{ ppOutput = \x -> hPutStrLn bar0 x >> hPutStrLn bar1 x 
				, ppCurrent = xmobarColor "#c3e88d" "" . wrap "<" ">" -- Current workspace in xmobar
				, ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
				, ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
				, ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
				, ppTitle = xmobarColor "#d0d0d0" "" . shorten 50     -- Title of active window in xmobar
				, ppSep =  " | "                                      -- Separators in xmobar
				, ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
				, ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
				}
		} 
		`additionalKeysP` newKeys
		`removeKeysP` removedKeys

		
