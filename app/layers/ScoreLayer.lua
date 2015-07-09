

local ScoreLayer = class("ScoreLayer", function(color, width, height) 
    return cc.LayerColor:create(color, width, height)
end)
--local ScoreLayer = class("ScoreLayer", cc.LayerColor)
--function ScoreLayer:create(dtype, text, callbackfunc) 
--    local layer = ScoreLayer.new() 
--    return layer 
--end

function ScoreLayer:ctor(color, width, height)
    self:createMsgBox()
    self:setColor(color)
    self:changeWidthAndHeight(width, height)
    self:setAnchorPoint(0.5, 0.5)
    self:setPosition(display.cx - self:getContentSize().width * 0.5, display.cy)   
    self.SystemEventManager = require("app.manager.SystemEventManager").new()
end

function ScoreLayer:createMsgBox()
    local label = cc.ui.UILabel.new({
        UILabelType = cc.ui.UILabel.LABEL_TYPE_TTF,
        text = "REPLAY",
        font = "Verdana-Bold",
        size = 40,
        color = cc.c4f(0,0,0,100)
    })
    label:pos(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    label:setAnchorPoint(0.5, 0.5)
    
    self:addChild(label)

    label:setTouchEnabled(true)
    label:addNodeEventListener(
        cc.NODE_TOUCH_EVENT, 
        handler(self, self.onTouchBtnClickHandler))
end

function ScoreLayer:onTouchBtnClickHandler(event)
    local event = cc.EventCustom:new("HelloTest001")
    eventManager:dispatchEvent(event)
end

return ScoreLayer