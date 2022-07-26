function dualsubs()
    local i = 0
    local tracks_count = mp.get_property_number("track-list/count")

    if tracks_count < 2 then
        return
    end

    while i < tracks_count do
        local track_type = mp.get_property(string.format("track-list/%d/type", i))
        local track_lang = mp.get_property(string.format("track-list/%d/lang", i))
        local track_id = mp.get_property(string.format("track-list/%d/id", i))

        if track_type == "sub" then
            if track_lang == nil then
                mp.set_property_number("sid", track_id)
                goto continue
            end
            if track_lang == "ru" or track_lang == "rus" then
                mp.set_property_number("sid", track_id)
            end
            if string.match(track_lang, "en") then
                mp.set_property_number("secondary-sid", track_id)
            end
        end

        ::continue::
        i = i + 1
    end
end

mp.register_event("file-loaded", dualsubs)
