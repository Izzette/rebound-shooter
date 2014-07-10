function loadEnemies()
  EI = require 'enemyinfo'  -- load (and run) enemyinfo.lua
  enemies = {}  -- holds all on screen enemies
 end
function updateEnemies(dt)  -- main update function
  for i,v in ipairs(enemies) do
    v.x, v.y = v.shape:center() --same as above, but for our test enemies
    if v.hp <= 0 then
      v.onDeath(i, v.x, v.y)  -- call on-death method
    end
    local move = v.movement[1]  -- copy movement data to local move for convinence
    move.move(i, v.x, v.y, dt)  -- call move method
    if v.y > 600 or v.y < 0 or v.x > 800 or v.x < 0 then  -- if outside room
      table.remove(enemies, i)  -- delete enemy
    end
    if v.nextShot <= cTime then  -- if it's time for the next shot
      createBullet(v.x, v.y, move.bullet[1].typeB)  -- shoot function will be called
      table.insert(move.bullet, move.bullet[1])  -- cylce bullets
      table.remove(move.bullet, 1)
      v.nextShot = v.nextShot + move.bullet[1].rate
    end
    if v.nextMove <= cTime then  -- if it's time for the next movement
      table.insert(v,movement, move)  -- add the current to the end of list
      table.remove(v.movement, 1)  -- remove it from the begining, now a new movement is movement[1]
      v.movement[1].onSwitch(i, v.x, v.y)  -- call the on-switch method
      v.nextMove = v.nextMove + v.movement[1].switch  -- next move set
    end
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and cTime >= v.t then  -- if the enemy hasn't spawned yet, and it's time
      local ref = refEnemey(v.typeE)  -- reference info about this type of enemy
      ref.x = v.x  -- position
      ref.y = v.y
      ref.nextMove = v.t + ref.movement[1].switch  -- next movement change
      ref.nextShot = v.t + ref.movement[1].bullet[1].rate  -- next bullet to fire
      table.insert(enemies, ref)  -- actually create enemy
      enemies[#enemies].onSpawn(#enemies, v.x, v.y)  -- call on spawn method
      v.c = false  -- mark as spawned
    end 
  end
end
function drawEnemies(dt)
    for i,v in ipairs(enemies) do
      v.movement[1].shape(i, v.x, v.y)  -- call enemy draw method
    end
  end