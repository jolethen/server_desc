-- your_mod/server_desc.lua
local desc_file = minetest.get_worldpath() .. "/server_description.txt"

-- Load saved description
local function load_description()
    local f = io.open(desc_file, "r")
    if f then
        local text = f:read("*all")
        f:close()
        return text
    end
    return ""
end

-- Save description
local function save_description(text)
    local f = io.open(desc_file, "w")
    if f then
        f:write(text)
        f:close()
    end
end

-- Apply description to server
local function apply_description(text)
    minetest.settings:set("server_description", text)
    minetest.log("action", "[server_desc] Server description changed to: " .. text)
end

-- Privilege for description editing
minetest.register_privilege("setdesc", {
    description = "Can change server description",
    give_to_singleplayer = false,
})

-- Command to set server description
minetest.register_chatcommand("setdesc", {
    params = "<description>",
    description = "Change the server description",
    privs = {setdesc = true},
    func = function(name, param)
        if param == "" then
            return false, "Usage: /setdesc <new description>"
        end
        save_description(param)
        apply_description(param)
        minetest.chat_send_all("[Server] " .. name .. " changed the server description.")
        return true, "Server description updated!"
    end,
})

-- Command to get current description
minetest.register_chatcommand("getdesc", {
    description = "Show current server description",
    func = function()
        return true, "Current server description: " .. load_description()
    end,
})

-- Apply saved description at startup
minetest.register_on_mods_loaded(function()
    local desc = load_description()
    if desc ~= "" then
        apply_description(desc)
    end
end)
