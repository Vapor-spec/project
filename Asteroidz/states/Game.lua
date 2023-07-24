require "globals"

local love = require "love"

local Text = require "../components/Text"
local Asteroids = require "../objects/Asteroids"

function Game()
    return {
        level = 1,
        state = {
            menu = true, 
            paused = false,
            running = false,
            ended = false
        },
		screen_text = {},
		game_over_showing = false,
		
        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
			
			if self.state.ended then
				self:gameOver()
			end
        end,
		
		gameOver = function(self)
			self.screen_text = {
				Text{
					"GAME OVER",
					0,
					love.graphics.getHeight() * 0.4,
					"h1",
					true,
					true,
					love.graphics.getWidth(),
					"center"
				}
			}
			self.game_over_showing = true
		end,
        draw = function (self, faded)
            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            end
			for index, text in pairs(self.screen_text) do
				if self.game_over_showing then
					self.game_over_showing = text:draw(self.screen_text,
					index)
					if not self.game_over_showing then 
						self:changeGameState("menu")
					end
					else
						text:draw(self.screen_text, index)
					end
					
				end
        end,

        startNewGame = function (self, player)
            self:changeGameState("running")
			local num_asteroids = 0
            asteroids = {}	
			self.screen_text = {
				Text{
					"Level " .. self.level,
					0,
					love.graphics.getHeight * 0.25,
					"h1",
					true,
					true,
					love.graphics.getWidth(),
					"center"
				}
			}
        
            local as_x = math.floor(math.random(love.graphics.getWidth()))
            local as_y = math.floor(math.random(love.graphics.getHeight()))
    
            table.insert(asteroids, 1, Asteroids(as_x, as_y, 100, self.level, true))
        end
    }
end

return Game