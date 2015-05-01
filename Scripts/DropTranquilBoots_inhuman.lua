--<<Original by DarkPower, modified by hmxxhmzx>>

--===================--
--     LIBRARIES     --
--===================--
require("libs.Utils")
require("libs.ScriptConfig")
--===================--
--      CONFIG       --
--===================--
local config = ScriptConfig.new()
config:SetParameter("DOWNKEY", "57", config.TYPE_HOTKEY)
config:SetParameter("turnflag", false)
config:Load()

function DropItems(im)
	for i,v in ipairs(im.items) do	
		local bonusArmor = v:GetSpecialData("bonus_armor")
		local bonusMS = v:GetSpecialData("bonus_movement_speed")
		if bonusArmor and bonusMS then
			entityList:GetMyPlayer():DropItem(v,im.position,config.turnflag)
		end		
	end
end

function UpItems(im)
	local DownItems = entityList:FindEntities({type=LuaEntity.TYPE_ITEM_PHYSICAL})
	for i,v in ipairs(DownItems) do
		entityList:GetMyPlayer():TakeItem(v,config.turnflag)
	end
end
		
function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	if IsKeyDown(config.DOWNKEY) then
		local me = entityList:GetMyHero()
		DropItems(me)
		UpItems(me)
	end
end

script:RegisterEvent(EVENT_KEY,Key)
