local SnakeBody = class("SnakeBody", function()
    return display.newSprite("snake/SNAKE_BODY.png")
end)

function SnakeBody:ctor()
	self.frontSnakeBody = nil
	self.behindSnakeBody = nil
end

function SnakeBody:setPoint(x, y)
	self.pointX = x
	self.pointY = y
end

function SnakeBody:getPoint()
	return self.pointX, self.pointY
end

function SnakeBody:checkIsOut()
	if self.pointX  < -15
		or self.pointX > 15
		or self.pointY > 21
		or self.pointY < -13
	then
		return true
	else
		return false
	end
end

function SnakeBody:setFrontBody(frontSnakeBody)
	self.frontSnakeBody = frontSnakeBody
end

function SnakeBody:setBehindBody(behindSnakeBody)
	self.behindSnakeBody = behindSnakeBody
end

function SnakeBody:move(isMoveForward)
	if isMoveForward then
		self:setPosition(self.frontSnakeBody:getPositionX(), self.frontSnakeBody:getPositionY())
		self:setPoint(self.frontSnakeBody:getPoint())
	else
		self:setPosition(self.behindSnakeBody:getPositionX(), self.behindSnakeBody:getPositionY())
		self:setPoint(self.behindSnakeBody:getPoint())
	end
end


return SnakeBody