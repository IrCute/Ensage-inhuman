--<<Auto feed enemy | Version: 1.2>>
--[[
	------------------------------------------
	? Script : Auto Feed enemy
	? Version: 1.2
	? Made By: Lucastx
	-------------------------------------------
	Description:
	------------
		Auto feed your enemy!
		Todolist:
			» Add a function to say a message for everyone feed
			» Add a courier fuction to buy courier and delivery it to enemy?
	Change log:
	-----------
	    » Version 1.2 Logs:
		    - Added auto buy items
		    - Changed the function Move, to AttackMove (Now you gonna clear the line until you get the enemy position
		» Version 1.1 Logs:
		    - Code clear
		    - Optimized the code
		    - Added a HOTKEY function
		    - Added the time for feed 150 Sec = 2 minuts and 30 seconds (You can change that, 1000 = 1 Second)
		» Version 1.0 : Initial release
]]--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Libs Necessarias
require("libs.Utils")
require("libs.ScriptConfig")

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Hotkeys
config = ScriptConfig.new()
config:SetParameter("ativo", "D", config.TYPE_HOTKEY)
config:Load()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Algumas variaveis

feed_route_radiant = {Vector(4961,4434,262) }
feed_route_dire = {Vector(-5390,-4926,264) }
local AlternarKey    = config.ativo
local ativo      = false
local registered    = false
local ItemsIniciais = {11, 29, 16, 16 ,16} -- Queeling, Boots, branches

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Local para escrever na tela
local x,y = 220,45
local monitor = client.screenSize.x/1600
local font = drawMgr:CreateFont("font","Verdana",12,300)  --CreateFont(name, fontname, tall, weight)
local statusText = drawMgr:CreateText(x*monitor,y*monitor,0x5DF5F5FF,"(" .. string.char(AlternarKey) .. ") Feed time: Waiting for you be trash player",font) statusText.visible = false

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Carregar script
function onLoad()

    if not client.connected or client.loading or client.console then
        script:Disable()
    else

        registered = true
        statusText.visible = true
        script:RegisterEvent(EVENT_TICK, Main)
        script:RegisterEvent(EVENT_KEY, Key)
        script:UnregisterEvent(onLoad)
    end

end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
-- HOTKEY Alternancia
function Key(msg, code)

    if client.chat or client.console or client.loading then return end -- Se estiver com o chat aberto ou console ou game ainda carregando desativa


    if IsKeyDown(AlternarKey) then -- Verifica a alternancia da HOTKEY
        ativo = not ativo

        if ativo  then
            statusText.text = "(" ..string.char(AlternarKey) .. ") Feed Time: Ativado"
            ativo = true
        else
            statusText.text = "(" ..string.char(AlternarKey) .. ") Feed Time: Desativado"
            ativo = false
        end

    end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- Funcao principal
function Main(tick)

    if not SleepCheck() then return end
    local me = entityList:GetMyHero() -- Pega informacoes do meu heroi
    if not me then return end -- Se o heroi nao for eu a funcao acaba aqui.


    if ativo then

        if me.alive and me.team == LuaEntity.TEAM_RADIANT then
            me:AttackMove(feed_route_radiant[1])
            Sleep(150000)
            return
        end

        if me.alive and me.team == LuaEntity.TEAM_DIRE then
            me:AttackMove(feed_route_dire[1])
            Sleep(150000)
            return
        end
    end



end



function StartBuy()

    if client.gameTime >= -80.101578 and client.gameTime <= 30.332870 then
        for i, itemID in ipairs(ItemsIniciais) do
            entityList:GetMyPlayer():BuyItem(itemID)
        end
    end


end

StartBuy(); -- call the function

-- Jogo finalizado
function onClose()

    collectgarbage("collect")
    if registered then
        statusText.Visible = false
        script:UnregisterEvent(Main)
        script:UnregisterEvent(Key)
        script:RegisterEvent(EVENT_TICK,onLoad)
        registered = false

    end

end


script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)