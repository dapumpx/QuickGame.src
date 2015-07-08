local MapScene = class("MapScene", function()
    return display.newScene("MapScene")
end)

function MapScene:ctor()
    local background = display.newSprite("image/map_background.png", display.cx, display.cy)
    self:addChild(background)
    
    local imgRoleLevel = display.newSprite("image/map_user_level_bg.png", display.cx, display.cy)
        :align(display.LEFT_BOTTOM, 0, 0)
    self:addChild(imgRoleLevel)
    
    display.addSpriteFrames("ani/btn_collect/1.plist", "ani/btn_collect/1.png") --添加帧缓存

    self.btnCollect = display.newSprite("#sp_btn_collect0000")
    self:addChild(self.btnCollect)
    display.align(self.btnCollect, display.BOTTOM_RIGHT, display.right, -25)
    
    local aniFrames = display.newFrames("sp_btn_collect00%02d", 0, 32)
    local btnCollectAni = display.newAnimation(aniFrames, 1.0/32.0)
    display.setAnimationCache("btnCollectAni", btnCollectAni)
    
    self.btnCollect:setTouchEnabled(true)
    self.btnCollect:addNodeEventListener(
    	cc.NODE_TOUCH_EVENT, 
    	handler(self, self.onTouchBtnClickHandler))
end

function MapScene:onTouchBtnClickHandler(event)
	printf("sprite: %s x,y: %0.2f, %0.2f",
           event.name, event.x, event.y)
	
	self.btnCollect:playAnimationOnce(display.getAnimationCache("btnCollectAni"), false)
end

function MapScene:onEnter()
end

function MapScene:onExit()
end

return MapScene