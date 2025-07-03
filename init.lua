-- Carica script con funzioni personalizzate
local appFallbacks = require("app_fallbacks")

-- Mappa applicazioni che vuoi forzare a mostrare finestre
local forceNewWindow = {
    ["Notes"] = function()
        appFallbacks.activateAppWithWindowFallback("Notes", { mods = {"cmd"}, key = "0" })
    end,
    ["Mail"] = function()
        appFallbacks.activateAppWithWindowFallback("Mail", { mods = {"cmd"}, key = "1" })
    end,
    ["Terminale"] = function()
        appFallbacks.activateAppWithWindowFallback("Terminale", { mods = {"cmd"}, key = "n" })
    end,
    ["TablePlus"] = function()
        appFallbacks.activateAppWithWindowFallback("TablePlus", { mods = {"cmd"}, key = "n" })
    end,
    ["Finder"] = function()
        appFallbacks.activateAppWithWindowFallback("Finder", { mods = {"cmd"}, key = "n" })
    end,
    ["Safari"] = function()
        appFallbacks.activateAppWithWindowFallback("Safari", { mods = {"cmd"}, key = "n" })
    end
}

-- Evento quando cambi app con Cmd+Tab o clic Dock
local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated and forceNewWindow[appName] then
        forceNewWindow[appName]()
    end
end)

appWatcher:start()

hs.alert.show("Hammerspoon configurato ✅")
