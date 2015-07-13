local SnakeCandy = class("SnakeCandy", function()
    return display.newSprite()
end)

function SnakeCandy:setCandyType( candyType )
	self.candyType = candyType

	if self.candyType == SNAKE_CANDY_TYPE.TYPE_APPLE then
		self:setDisplayFrame(display.newSpriteFrame("snake/SNAKE_APPLE.png"))
	end

end

return SnakeCandy
