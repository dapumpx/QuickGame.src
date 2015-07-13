local ScoreLayer = require("app.layers.ScoreLayer")
local SnakeScene = class("SnakeScene", function()
    return display.newScene("SnakeScene")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

FLAG_UP = 1;
FLAG_DOWN = 2;
FLAG_LEFT = 3;
FLAG_RIGHT = 4;

local snakeSchedule

function SnakeScene:ctor()
    self.flagDirection = FLAG_LEFT
    self.currDirection = FLAG_LEFT

    self.background = cc.LayerColor:create(cc.c4f(255,255,255,255), display.size.width, display.size.height)
    self:addChild(self.background)
    
    self.background1 = cc.LayerColor:create(cc.c4f(0,0,0,255), display.size.width - 20, display.size.height - 50)
    self.background1:setPosition(10,0)
    self:addChild(self.background1)
    
    local btnLeft = {
        normal = "snake/SNAKE_BTN_LEFT_1.png",
    --pressed = "snake/SNAKE_BTN_LEFT_1.png",
    --disabled = "snake/SNAKE_BTN_LEFT_1.png",
    }
    self.leftBtn = cc.ui.UIPushButton.new(btnLeft)
        :onButtonClicked(function(event) self:onPlayButtonClickHandler(event) end)
        :align(display.BOTTOM_CENTER, display.cx - 230, display.bottom + 100)
        :addTo(self)
    self.leftBtn:setAnchorPoint(0.5, 0.5)

    local btnRight = {
        normal = "snake/SNAKE_BTN_RIGHT_1.png"
    }
    
    
    self.rightBtn = cc.ui.UIPushButton.new(btnRight)
        :onButtonClicked(function(event) self:onPlayButtonClickHandler(event) end)
        :align(display.BOTTOM_CENTER, display.cx + 230, display.bottom + 100)
        :addTo(self)
    self.rightBtn:setAnchorPoint(0.5, 0.5)

    local btnUp = {
        normal = "snake/SNAKE_BTN_UP_1.png"
    }

    self.upBtn = cc.ui.UIPushButton.new(btnUp)
        :onButtonClicked(function(event) self:onPlayButtonClickHandler(event) end)
        :align(display.BOTTOM_CENTER, display.cx, display.bottom + 155)
        :addTo(self)
    self.upBtn:setAnchorPoint(0.5, 0.5)

    local btnDown = {
        normal = "snake/SNAKE_BTN_DOWN_1.png"
    }

    self.downBtn = cc.ui.UIPushButton.new(btnDown)
        :onButtonClicked(function(event) self:onPlayButtonClickHandler(event) end)
        :align(display.BOTTOM_CENTER, display.cx, display.bottom + 50)
        :addTo(self)
    self.downBtn:setAnchorPoint(0.5, 0.5)

    self.txtScore = cc.ui.UILabel.new({
        UILabelType = cc.ui.UILabel.LABEL_TYPE_TTF,
        text = "Score: 0",
        font = "Verdana-Bold",
        size = 30,
        color = cc.c4f(0,0,0,255)
    })
    self.txtScore:align(display.LEFT_TOP, display.left + 10, display.top - 10)
    self:addChild(self.txtScore)

    self.tblSnake = {}
    self.tblSnakePos = {}
    self.tblApple = {}

    self:addSnakeBody()

    snakeSchedule = scheduler.scheduleGlobal(handler(self, self.MoveBody), 0.3)

    local customListenerBg = cc.EventListenerCustom:create("HelloTest001",
                                handler(self, self.callback))
    eventManager:addEventListenerWithFixedPriority(customListenerBg, 1)
    -- eventManager:addEventListener("helloThere", handler(self, self.callback))
    -- eventManager:dispatchEvent({name="helloThere"})
end

function SnakeScene:callback()
    print("done!!!!!!!!!!!!!!!")
end

function SnakeScene:randomApple()
--    if table.getn(self.tblApple) > 10 then return end
    if math.random() < 0.7 then return end
    
    local apple = display.newSprite("snake/SNAKE_APPLE.png")
    apple:setAnchorPoint(0.5, 0.5)
    local obj = {["apple"]=apple, x=math.random(-15,15), y=math.random(-9, 23)}
    
    for i, v in ipairs(self.tblSnake) do
        if self.tblSnakePos[v][1] == obj.x and self.tblSnakePos[v][2] == obj.y then
            apple = nil
            obj = nil
            break
        end
    end

    if apple ~= nil then
        for i, v in ipairs(self.tblApple) do
            if v.x == obj.x and v.y == obj.y then
                apple = nil
                obj = nil
                break
            end
        end
    end
    
    if apple == nil then 
        return 
    end
    
    table.insert(self.tblApple, obj) 
    apple:setPosition(display.cx + obj.x * 20,display.cy + obj.y*20)
    self:addChild(apple)
end

function SnakeScene:onPlayButtonClickHandler(event)
    -- print_lua_table(event)
    if self.isGameOver then return end
    if event.target == self.leftBtn and self.currDirection ~= FLAG_RIGHT then
        self.flagDirection = FLAG_LEFT
    elseif event.target == self.rightBtn and self.currDirection ~= FLAG_LEFT then
        self.flagDirection = FLAG_RIGHT
    elseif event.target == self.upBtn and self.currDirection ~= FLAG_DOWN then
        self.flagDirection = FLAG_UP
    elseif event.target == self.downBtn and self.currDirection ~= FLAG_UP then
        self.flagDirection = FLAG_DOWN
    end
    
    self:MoveBody()
    scheduler.unscheduleGlobal(snakeSchedule)
    snakeSchedule = scheduler.scheduleGlobal(handler(self, self.MoveBody), 0.3)
end

function SnakeScene:checkApple()
    for i, v in ipairs(self.tblApple) do
        if self.tblSnakePos[self.tblSnake[1]][1] == v.x
           and  self.tblSnakePos[self.tblSnake[1]][2] == v.y
        then
            self:removeChild(v.apple)
            self:addSnakeBody()
            table.remove(self.tblApple,i)
            break
        end
    end
end

function SnakeScene:addSnakeBody()
--    if table.getn(self.tblSnake) >= 10 then
--        return
--    end
    local sBody = display.newSprite("snake/SNAKE_BODY.png")
    self:addChild(sBody)
    if table.getn(self.tblSnake) == 0 then
        self.tblSnakePos[sBody] = {0, 0}
        sBody:setPosition(display.cx, display.cy)
        sBody:setAnchorPoint(0.5, 0.5)
    else
        self.tblSnakePos[sBody] = self.lastPoint
        sBody:setPosition(self.lastPos.x, self.lastPos.y)
        sBody:setAnchorPoint(0.5, 0.5)
    end

    table.insert(self.tblSnake, sBody)
end

function SnakeScene:MoveBody()
    local tLen = table.getn(self.tblSnake)
    if tLen == 0 then
        return
    end
    
    self.lastPos = {x=self.tblSnake[tLen]:getPositionX(), y=self.tblSnake[tLen]:getPositionY()}
    self.lastPoint = self.tblSnakePos[self.tblSnake[tLen]]
    
    self.currDirection = self.flagDirection
    
    local oldLastPos = {x=self.tblSnake[tLen]:getPositionX(), y=self.tblSnake[tLen]:getPositionY()}
    local oldLastPoint = self.tblSnakePos[self.tblSnake[tLen]]

    for i = tLen, 2, -1 do
        self.tblSnake[i]:setPosition(self.tblSnake[i-1]:getPositionX(), self.tblSnake[i-1]:getPositionY())
        self.tblSnakePos[self.tblSnake[i]] = self.tblSnakePos[self.tblSnake[i - 1]]
    end
    if self.flagDirection == FLAG_LEFT then
        self.tblSnake[1]:setPositionX(self.tblSnake[1]:getPositionX() - 20)
        self.tblSnakePos[self.tblSnake[1]] = {self.tblSnakePos[self.tblSnake[1]][1] - 1, self.tblSnakePos[self.tblSnake[1]][2]}
    elseif self.flagDirection == FLAG_RIGHT then
        self.tblSnake[1]:setPositionX(self.tblSnake[1]:getPositionX() + 20)
        self.tblSnakePos[self.tblSnake[1]] = {self.tblSnakePos[self.tblSnake[1]][1] + 1, self.tblSnakePos[self.tblSnake[1]][2]}
    elseif self.flagDirection == FLAG_UP then
        self.tblSnake[1]:setPositionY(self.tblSnake[1]:getPositionY() + 20)
        self.tblSnakePos[self.tblSnake[1]] = {self.tblSnakePos[self.tblSnake[1]][1], self.tblSnakePos[self.tblSnake[1]][2] + 1}
    elseif self.flagDirection == FLAG_DOWN then
        self.tblSnake[1]:setPositionY(self.tblSnake[1]:getPositionY() - 20)
        self.tblSnakePos[self.tblSnake[1]] = {self.tblSnakePos[self.tblSnake[1]][1], self.tblSnakePos[self.tblSnake[1]][2] - 1}
    end

    self.isGameOver = false

    if self.tblSnakePos[self.tblSnake[1]][1] < -15
        or self.tblSnakePos[self.tblSnake[1]][1] > 15
        or self.tblSnakePos[self.tblSnake[1]][2] > 21
        or self.tblSnakePos[self.tblSnake[1]][2] < -13
    then
        self.isGameOver = true
    end

    if self.isGameOver ~= true then
        for i, j in pairs(self.tblSnakePos) do
            for m, n in pairs(self.tblSnakePos) do
                if i ~= m and j[1] == n[1] and j[2] == n[2] then
                    self.isGameOver = true;
                    break;
                end
            end
            if self.isGameOver then break end
        end
    end
    
    if self.isGameOver then
        if snakeSchedule ~= nil then
            scheduler.unscheduleGlobal(snakeSchedule)
            snakeSchedule = nil
        end
        self:GameOver()

        for i = 1, tLen - 1, 1 do
            self.tblSnake[i]:setPosition(self.tblSnake[i+1]:getPositionX(), self.tblSnake[i+1]:getPositionY())
            self.tblSnakePos[self.tblSnake[i]] = self.tblSnakePos[self.tblSnake[i + 1]]
        end
        self.tblSnake[tLen]:setPosition(oldLastPos.x, oldLastPos.y)
        self.tblSnakePos[self.tblSnake[tLen]] = oldLastPoint
        return
    end
    
    self:randomApple()
    self:checkApple()
end

function SnakeScene:GameOver()
    print("Game Over!!!")
    
    local scoreLayer = ScoreLayer.new(cc.c4f(255,255,0,255), 200, 100)
    self:addChild(scoreLayer)
end

return SnakeScene

