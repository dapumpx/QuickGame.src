
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    local background = display.newSprite("image/welcome_background.jpg", display.cx, display.cy)
    self:addChild(background)
    
    self.PUSH_BUTTON_IMAGES = {
        normal = "ui/button/btn_play_1.png",
        pressed = "ui/button/btn_play_3.png",
        disabled = "ui/button/btn_play_4.png",
    }
    
    pushBtn = cc.ui.UIPushButton.new(self.PUSH_BUTTON_IMAGES)
        :onButtonClicked(self.onPlayButtonClickHandler)
        :align(display.BOTTOM_CENTER, display.cx, display.bottom + 60)
        :addTo(self)
    pushBtn:setAnchorPoint(0.5, 0.5)
    local scaleTo = cc.ScaleTo:create(0.15, 1.2)
    local scaleTo1 = cc.ScaleTo:create(0.1, 0.8)
    local scaleTo2 = cc.ScaleTo:create(0.05, 1)
    local sequence = cc.Sequence:create(scaleTo, scaleTo1, scaleTo2)
    pushBtn:runAction(sequence)
end


---------------------------
--@param
--@return
function MainScene:onPlayButtonClickHandler(event)
    print("pushButton click")
    audio.playSound("sound/btn_click.mp3",false)
    app:enterScene("SnakeScene")
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
