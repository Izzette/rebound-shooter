function refEnemy(typeE, x, y)
  local ref = {}  -- define local ref
  ref.x = x  -- position
  ref.y = y
  ref.typeE = typeE  -- type of enemy
  if typeE == "square" then  -- if "square" enemies ...
    ref.hp = 50  -- hp not variable on movement, equal to 50pts
    ref.onDeath = function(self, i)  -- on-death method
      local chance = math.random()
      if chance >= 0.8 then
        spawnPowerUp(self.x, self.y, "health")
      end
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end  -- no on-spawn method
    ref.shape = {{}}
    ref.shape[1] = collider:addRectangle(x, y, 25, 25)
    ref.draw = function(self)  -- shape method
      love.graphics.setColor(255, 0, 0)  -- red
      self.shape[1]:draw("fill")  -- "square" shape
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 100
      table.remove(enemies, i)  -- instead of onDeath, no chance of powerUp spawning
    end
    ref.bullets = {{typeB = "basic", rate = 0.25},{typeB = "basic", rate = 0.25},{typeB = "basic", rate = 0.5}} -- bullet shooting pattern
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape[1]:move(-20 * dt, 40 * dt)  -- down, left, px/sec
    end
    ref.movement[1].switch = 1
    ref.movement[1].onSwitch = function(self, i) end  -- no on switch action
    ref.movement[2].move = function(self, dt)  -- move method for movement[2]
      self.shape[1]:move(20 * dt, 40 * dt)
    end
    ref.movement[2].switch = 1 -- time until movement[i+1]
    ref.movement[2].onSwitch = function(self, i) end  -- no on switch action
  end
  if typeE == "mine" then  -- if it's a mine
    ref.hp = 1  -- hp not variable on movement, instant kills
    ref.onDeath = function(self, i)  -- on-death method
      local chance = math.random()
      if chance >= 0.5 then
        spawnPowerUp(self.x, self.y, "charge")
      end
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end  -- no on spawn method
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.shape = {{}}
    ref.shape[1] = collider:addCircle(x, y, 10)
    ref.draw = function (self)  -- shape method
      love.graphics.setColor(255, 150, 0)  -- orange enemy
      self.shape[1]:draw("fill")  -- "mine" shape, it's a samll circle
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 175
      table.remove(enemies, i)
    end
    ref.bullets = {{typeB = "noshoot", rate = 0}}  -- doesn't shoot
    ref.movement = {{}}
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape[1]:move(0, 25 * dt)  -- scrolling speed
    end
    ref.movement[1].switch = 1  -- movement[1] switch after one second
    ref.movement[1].onSwitch = function(self, i) end  -- no method on-switch
  end
  if typeE == "mach" then  -- if it's a "mach"
    ref.hp = 25
    ref.onDeath = function(self, i)  -- on-death method
      local chance = math.random()
      if chance >= 0.9 then
        spawnPowerUp(self.x + 1, self.y + 8, "health")
        spawnPowerUp(self.x - 4, self.y - 8, "charge")
      elseif chance >= 0.7 then
        spawnPowerUp(self.x, self.y, "health")
      elseif chance >= 0.5 then
        spawnPowerUp(self.x, self.y, "charge")
      end
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end
    ref.shape = {{}}
    ref.shape[1] = collider:addPolygon(x, y, x + 7, y - 20, x - 7, y - 20)
    ref.draw = function(self)  -- shape method
      love.graphics.setColor(50, 255, 10) -- lime green
      self.shape[1]:draw("fill")  -- "mach" shape
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 75
      table.remove(enemies, i)
    end
    ref.bullets = {{typeB = "basic", rate = 0.15}}  -- long delay after every 6th bullet, short on the 3rd
    ref.movement = {{},{},{},{},{}}
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape[1]:move(0, 50 * dt)
    end
    ref.movement[1].switch = 0.75
    ref.movement[1].onSwitch = function(self, i) end
    ref.movement[2].move = function(self, dt)  -- move method for movement[2]
      self.shape[1]:move(-25 * dt, 35 * dt)
    end
    ref.movement[2].switch = 0.8
    ref.movement[2].onSwitch = function(self, i)  -- change bullet pattern
      enemies[i].bullets = {{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.4}}
    end
    ref.movement[3].move = function(self, dt)
      self.shape[1]:move(25 * dt, 35 * dt)
    end
    ref.movement[3].switch = 1.6
    ref.movement[3].onSwitch = function(self, i)
      enemies[i].bullets = {{typeB = "unblock", rate = (1.6 / 6)}}
    end
    ref.movement[4].move = function(self, dt)  -- move method for movement[2]
      self.shape[1]:move(-25 * dt, 35 * dt)
    end
    ref.movement[4].switch = 0.8
    ref.movement[4].onSwitch = function(self, i)  -- change bullet pattern
      enemies[i].bullets = {{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.4}}
    end
    ref.movement[5].move = function(self, dt)
      self.shape[1]:move(0, 35 * dt)
    end
    ref.movement[5].switch = 0.5
    ref.movement[5].onSwitch = function(self, i) 
      self.movement[2].onSwitch = function(self, i)
        self.movement = {{}}
        self.movement[1].move = function(self, dt)
          self.shape[1]:move(0, 50 * dt)
        end
        self.movement[1].switch = 1
        self.movement[1].onSwitch = function(self, i) end
        enemies[i].bullets = {{typeB = "basic", rate = 0.15}}
      end
    end
  elseif typeE == "bomber" then
    ref.hp = 50  -- hp not variable on movement, instant kills
    ref.stage = 1
    ref.onDeath = function(self, i)  -- on-death method
      self.hp = 100
      self.bullets = {{typeB = "noshoot", rate = 1}}
      repeat
        table.insert(self.shape, {})
      until #self.shape == 3
      self.shape[2] = collider:addRectangle(self.x - 20, self.y - 7, 40, 14)
      self.shape[3] = collider:addRectangle(self.x - 7, self.y - 20, 14, 40)
      table.insert(self.movement, {})  -- new movement index
      self.movement[1].onSwitch = function(self, i) end  -- no method on-switch
      self.movement[2].move = function(self, dt) end  -- doesn't move
      self.movement[2].switch = 0.5
      self.movement[2].onSwitch = function(self, i) end
      self.draw = function(self)
        love.graphics.setColor(255, 0, 0)
        self.shape[2]:draw("fill")
        self.shape[3]:draw("fill")
        love.graphics.setColor(255, 255, 0)
        self.shape[1]:draw("fill")
      end
      self.onDeath = function(self, i)
        local chance = math.random()
        if chance >= 0.5 then
          spawnPowerUp(self.x, self.y, "charge")
        else
          spawnPowerUp(self.x, self.y, "health")
        end
        table.remove(enemies, i)
      end
    end
    ref.onSpawn = function(self) end  -- no on spawn method
    ref.shape = {{}}
    ref.shape[1] = collider:addCircle(x, y, 15)
    ref.draw = function (self)  -- shape method
      love.graphics.setColor(255, 255, 0)
      self.shape[1]:draw("fill")  -- "mine" shape, it's a samll circle
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 300
      table.remove(enemies, i)
    end
    ref.bullets = {{typeB = "basic", rate = 1}}
    ref.movement = {{}}  -- movement directory for all variable data
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.movement[1].move = function(self, dt)  -- move method for movement[1]
        for i,v in ipairs(self.shape) do
          v:move(0, 40 * dt)
        end
      end
    end
    ref.movement[1].switch = 1  -- movement[1] switch after one second
    ref.movement[1].onSwitch = function(self, i) end  -- no method on-switch
  end
  return ref  -- return the generated reference information
end