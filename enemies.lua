function loadEnemies()
  EI = require 'enemyinfo'  -- load (and run) enemyinfo.lua
  enemies = {}  -- holds all on screen enemies
  deleteTimeE = 7
 end
function updateEnemies(dt)  -- main update function
  for i,v in ipairs(enemies) do
    if v.hp <= 0 then
      v:onDeath(i)  -- call on-death method
    end
    v.move = v.movement[1].move
    v:move(dt)  -- call move method
    v.x, v.y = v.shape[1]:center() --same as above, but for our test enemies
    if v.y > 600 then  -- if outside room
      table.remove(enemies, i)  -- delete enemy
    end
    if v.nextMove <= cTime then  -- if it's time for the next movement
      table.insert(v.movement, v.movement[1])  -- add the current to the end of list
      table.remove(v.movement, 1)  -- remove it from the begining, now a new movement is movement[1]
      v.nextMove = v.nextMove + v.movement[1].switch  -- next move set
      v.movement[1].onSwitch(v, i)  -- call the on-switch method
    end
    if v.nextShot <= cTime then  -- if it's time for the next shot
      if v.bullets[1].typeB ~= "noshoot" then
      createBullet(v.x, v.y, v.bullets[1].typeB)  -- shoot function will be called, bullet added to bullets dictonary
      end
      table.insert(v.bullets, v.bullets[1])  -- cycle bullets
      table.remove(v.bullets, 1)
      v.nextShot = v.nextShot + v.bullets[1].rate
    end
  end
  if deleteTimeE >= cTime then
    for i,v in ipairs(enemies) do
      if v.y > 800 then
        table.remove(ememies, i)
      end
    end
    deleteTimeE = deleteTimeE + 5
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and cTime >= v.t then  -- if the enemy hasn't spawned yet, and it's time
      local ref = refEnemy(v.typeE, v.x, v.y)  -- reference info about this type of enemy
      ref.nextMove = v.t + ref.movement[1].switch  -- next movement change
      ref.nextShot = v.t + ref.bullets[1].rate  -- next bullet to fire
      table.insert(enemies, ref)  -- actually create enemy
      enemies[#enemies]:onSpawn()  -- call on spawn method
      v.c = false  -- mark as spawned
    end 
  end
end
function drawEnemies(dt)
  for i,v in ipairs(enemies) do
    v:draw()  -- call enemy draw method
  end
end