-- Position subtitle a little bit above osd on pause
-- to prevent osd from covering subtitle

local paused = nil

mp.observe_property("pause", "bool",
    function(name, value)
        paused = value
    end
)

function position_subtitle()
    if paused then
        mp.commandv('set', 'sub-pos', '97')
    else
        mp.commandv('set', 'sub-pos', '100')
    end
end

mp.observe_property('pause', 'bool', position_subtitle)
