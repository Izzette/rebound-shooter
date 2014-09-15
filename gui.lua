EN = require 'enemies'
PA = require 'player'
LV = require 'levels'
BU = require 'bullets'

function mainmenu()
  canPlay = 0
  loveframes.SetState("mainmenu")
  
  local frame = loveframes.Create("frame")
	frame:SetName("Rebound Shooter")
  frame:SetDraggable(false)
  frame:ShowCloseButton(false)
  frame:SetSize(800, 600)
  frame:Center()
  frame:SetState("mainmenu")
         
  local levelSelection = loveframes.Create("multichoice", frame)
  levelSelection:SetPos(300, 350)   
  for level, data in pairs(levels) do
    levelSelection:AddChoice(level)
  end
  levelSelection.OnChoiceSelected = function(object, choice)
    for level, data in pairs(levels) do
      if choice == level then
        enemiesSpawn = data
        canPlay = canPlay + 1
      end
    end
  end
  local shipSelection = loveframes.Create("multichoice", frame)
  shipSelection:SetPos(300, 300)   
  for i,typeP in ipairs(shipTypes) do
    shipSelection:AddChoice(typeP)
  end
  shipSelection.OnChoiceSelected = function(object, choice)
    typeP = choice
    canPlay = canPlay + 1
  end
  local panel1 = loveframes.Create("panel", frame)
  panel1:SetSize(200, 50)
  panel1:SetPos(300, 400)
  
	local playButton = loveframes.Create("button", panel1)
	playButton:SetWidth(200)
	playButton:SetText("Play")
	playButton:Center()
	playButton.OnClick = function(object, x, y)
    if canPlay >= 2 then
      play = true
      loveframes.SetState("none")
      loadPlayer()
      loadEnemies()
      loadBullets()
      sTime = love.timer.getTime()
      cTime = sTime
    else
      object:SetText("Please Select a Level and a Ship")
    end
	end
  local panel2 = loveframes.Create("panel", frame)
  panel2:SetSize(200, 50)
  panel2:SetPos(300, 450)
  
  local builderButton = loveframes.Create("button", panel2)
	builderButton:SetWidth(200)
	builderButton:SetText("Level Builder")
	builderButton:Center()
	builderButton.OnClick = function(object, x, y)
    object:SetText("Level Builder Not Yet Integrated")
	end
  local panel3 = loveframes.Create("panel", frame)
  panel3:SetSize(200, 50)
  panel3:SetPos(300, 500)
  
  local exitButton = loveframes.Create("button", panel3)
	exitButton:SetWidth(200)
	exitButton:SetText("Exit")
	exitButton:Center()
	exitButton.OnClick = function(object, x, y)
    love.event.quit()
	end
end
function pausemenu()
  play = false
  loveframes.SetState("pausemenu")
 
  local frame = loveframes.Create("frame")
	frame:SetName("Paused")
  frame:SetSize(120, 150)
  frame:SetDraggable(false)
  frame:Center()
  frame:SetState("pausemenu")
  frame.OnClose = function(object)
    uTime = love.timer.getTime()
    loveframes.SetState("none")
    timePaused = timePaused + (uTime - pTime)
    play = true
  end
	local playButton = loveframes.Create("button", frame)
	playButton:SetSize(100, 30)
	playButton:SetText("Resume")
	playButton:SetPos(10, 40)
	playButton.OnClick = function(object, x, y)
    uTime = love.timer.getTime()
    loveframes.SetState("none")
    timePaused = timePaused + (uTime - pTime)
    play = true
	end
  local exitButton = loveframes.Create("button", frame)
	exitButton:SetSize(100, 30)
	exitButton:SetText("Exit to Menu")
	exitButton:SetPos(10, 90)
	exitButton.OnClick = function(object, x, y)
    enemies = {}
    bullets = {}
    ship.shots = {}
    powerUps = {}
    for k,v in pairs(levels) do
      for ie,ve in ipairs(v) do
        ve.c = true
      end
    end
    loveframes.SetState("mainmenu")
	end
end