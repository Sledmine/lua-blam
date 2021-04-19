-- UI
-- Example of how to get and modify data from ui widgets using lua-blam

clua_version = 2.056

local blam = require "blam"
-- Provide global and short syntax for multiple tag classes references
tagClasses = blam.tagClasses

function OnMapLoad()
    -- Get widget table properties
    local pauseMenu = blam.uiWidgetDefinition("ui\\shell\\multiplayer_game\\pause_game\\1p_pause_game")
    if (pauseMenu) then
        -- Getting widget properties
        console_out(pauseMenu.name)
        console_out(pauseMenu.width)
        console_out(pauseMenu.height)
        console_out(pauseMenu.boundsX)
        console_out(pauseMenu.boundsY)
        -- Iterating through all the child widgets
        for _, childWidgetTagId in pairs(pauseMenu.childWidgetsList) do
            -- Getting child widget properties
            local widget = blam.uiWidgetDefinition(childWidgetTagId)
            if (widget) then
                console_out(widget.name)
            end
        end
        -- Getting background bitmap data as a tag from this widget
        local backgroundBitmapTag = blam.getTag(pauseMenu.backgroundBitmap)
        if (backgroundBitmapTag) then
            console_out(backgroundBitmapTag.path)
        end
        -- Change background bitmap by the loading background bitmap
        -- Get bitmap data as a tag
        local loadingBitmapTag = blam.getTag("ui\\shell\\bitmaps\\background", tagClasses.bitmap)
        if (loadingBitmapTag) then
            pauseMenu.backgroundBitmap = loadingBitmapTag.id
        end
    else
        console_out("Widget tag was not found on this map!")
    end
end

function OnTick()
    -- Get local player biped data
    local playerBiped = blam.biped(get_dynamic_player())
    if (playerBiped) then
        if (playerBiped.flashlightKey) then
            -- Open ui widget when the player uses the flashlightKey
            local widgetLoaded = load_ui_widget("ui\\shell\\multiplayer_game\\pause_game\\1p_pause_game")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    else
        console_out("Player does not have a biped alive or assigned!")
    end
end

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")

-- Allow fast reload of this script on local/development mode
-- My recommendation is to remove this on release due to triggering the same function twice
if (server_type == "local") then
    OnMapLoad()
end