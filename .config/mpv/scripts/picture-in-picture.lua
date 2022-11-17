local state = {
    fullscreen = false,
    border = false
}

mp.observe_property("fullscreen", "bool",
function(name, val)
    state.fullscreen = val
end
)

mp.observe_property("border", "bool",
function(name, val)
    state.border = val
end
)

local picture_in_picture_mode = false
local was_ontop = false
local window_was_fullscreen = state.fullscreen
local window_had_borders = state.border
local pip_autofit = "30%"
local standard_autofit = "70%"


-- toggle Picture-In-Picture
function toggle_picture_in_picture()
    if picture_in_picture_mode then -- disable
        if window_was_fullscreen then
            mp.commandv('set', 'fullscreen', 'yes')
        else
            mp.commandv('set', 'autofit', standard_autofit)
        end
        if window_had_borders then
            mp.commandv('set', 'border', 'yes')
        end
        mp.set_property_bool("ontop", false)
        picture_in_picture_mode = false
    else -- enable
        window_was_fullscreen = state.fullscreen
        window_had_borders = state.border
        mp.commandv('set', 'fullscreen', 'no')
        mp.commandv('set', 'border', 'no')
        mp.commandv('set', 'autofit', pip_autofit)
        mp.set_property_bool("ontop", true)
        picture_in_picture_mode = true
    end
end

mp.add_key_binding("t", "ontop", toggle_picture_in_picture)
