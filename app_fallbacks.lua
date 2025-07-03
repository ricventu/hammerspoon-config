local M = {}

function M.activateAppWithWindowFallback(appName, fallbackKeystroke)
    hs.application.launchOrFocus(appName)

    hs.timer.waitUntil(
        function()
            local app = hs.application.get(appName)
            return app and app:isFrontmost()
        end,
        function()
            local app = hs.application.get(appName)
            if app and #app:allWindows() == 0 then
                hs.eventtap.keyStroke(fallbackKeystroke.mods, fallbackKeystroke.key, 0, app)
            end
        end,
        0.01,  -- intervallo di polling (10ms)
        2      -- timeout massimo (2s)
    )
end

return M
