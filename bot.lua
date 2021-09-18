-- CompIT-Bot - A Discord bot written in Lua with the Discordia library.

-- Our first course, but let's not be greedy.

local coro = require("coro-http")
local discordia = require("discordia")
local json = require("json")
local spawn = require('coro-spawn')
local parse = require('url').parse
local client = discordia.Client()


-- Require some additional Discordia standard libraries.

discordia.extensions()


-- Some definitions.

local connections = {}

local commands = {
    {Command = "Moderator Commands", Description = ""},
    {Command = " !kick [user]", Description = "Kick a user"},
    {Command = " !ban [user]", Description = "Ban a user"},
    {Command = " !unban [user]", Description = "Unban a user"}
}

local perms = {
    kick = 0x00000002,
    ban = 0x00000004
}


-- Output any errors to the server.

function err()
    message:reply("Something's not quite right...")
end


-- Basic functionality.

client:on("messageCreate", function(message)

    local content = message.content
    local member = message.author
    local memberid = message.author.id
    
    if message.author == client.user then return end
    if not message.guild then return end
    if message.author.bot then return end
    
    local args = message.content:split('%s+')
    local cmd = table.remove(args, 1)
    
    if cmd == "!ping" then
        message:reply("pong")
    end    
    
    if cmd == "!help" then
        local c = member:getPrivateChannel()
        local list = ""
        for _, v in pairs(commands) do
            list = list.."   "..v.Command..": "..v.Description.."\n"
        end
        c:send('```'..list..'```')
    end
    
    if cmd == "!ban" then
        local target = message.mentionedUsers
        if member:hasPermission(0x00000004) then
            if #target == 1 then
                message:reply("<@!"..target[1][1].."> has been banned.")
                member.guild:banUser(target[1][1],_,_)
            elseif #target == 0 then
                message:reply("Syntax error in ban command.")
                
            elseif #target >= 1 then
                message:reply("Sorry, that operation isn't supported yet.")
            end
        else
            message:reply("You do not have permission to run that command.")
        end
    end
    
    if cmd == "!unban" then
        local target = message.mentionedUsers
        if member:hasPermission(0x00000004) then
            if #target <= 1 then
                message:reply("<@!"..target[1][1].."> has been unbanned.")
                member.guild:unbanUser(target[1][1],_)
            elseif #target >= 1 then
                message:reply("Sorry, that operation isn't supported yet.")
            end
        else
            message:reply("You do not have permission to run that command.")
        end
    end
    
    if cmd == "!kick" then
        local target = message.mentionedUsers
        if member:hasPermission(0x00000002) then
            if #target <= 2 then
                message:reply("<@!"..target[1][1].."> has been kicked for ")
                member.guild:kickUser(target[1][1],_)
            elseif #target == 0 then
                message:reply("Syntax error in kick command.")
            elseif #target >= 2 then
                message:reply("Sorry, that operation isn't supported yet.")
            end
        else
            message:reply("You do not have permission to run that command.")
        end
    end
end)


-- Finally we get to make our connection proper.

client:run("Bot "..os.getenv("DISCORD_BOT_TOKEN"))