-- ⚙️ Lista di app che devono forzare apertura di nuova finestra
local forceNewWindow = {
    ["Finder"] = function()
        hs.osascript.applescript([[
            tell application "Finder"
                make new Finder window
                activate
            end tell
        ]])
    end,
    ["Terminal"] = function()
        hs.osascript.applescript([[
            tell application "Terminal"
                do script ""
                activate
            end tell
        ]])
    end,
    ["Safari"] = function()
        hs.osascript.applescript([[
            tell application "Safari"
                if (count of windows) = 0 then
                    make new document
                end if
                activate
            end tell
        ]])
    end,
    ["Google Chrome"] = function()
        hs.osascript.applescript([[
            tell application "Google Chrome"
                if (count of windows) = 0 then
                    make new window
                end if
                activate
            end tell
        ]])
    end,
    ["Visual Studio Code"] = function()
        hs.osascript.applescript([[
            tell application "Visual Studio Code"
                activate
                tell application "System Events"
                    keystroke "n" using command down
                end tell
            end tell
        ]])
    end,
    ["Note"] = function()
        hs.application.launchOrFocus("Notes")
    
        hs.timer.waitUntil(
            function()
                local app = hs.application.get("Notes")
                return app and app:isFrontmost()
            end,
            function()
                local app = hs.application.get("Notes")
                if app and #app:allWindows() == 0 then
                    hs.eventtap.keyStroke({"cmd"}, "0", 0, app)
                end
            end,
            0.01,  -- check every 10ms
            1      -- timeout after 1s (in caso Notes non si attivi)
        )
    end
}

local function fallbackAppAction(appName)
    if forceNewWindow[appName] then
        forceNewWindow[appName]()
    else
        hs.application.launchOrFocus(appName)
    end
end

hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
        hs.timer.doAfter(0.2, function()
            local app = hs.application.get(appName)
            if not app then return end

            local win = app:mainWindow()
            if not win then
                local windows = app:allWindows()
                if #windows > 0 then win = windows[1] end
            end

            if win then
                win:unminimize()
                win:focus()
            else
                fallbackAppAction(appName)
            end
        end)
    end
end):start()
