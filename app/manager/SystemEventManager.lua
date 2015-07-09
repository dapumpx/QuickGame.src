local SystemEventManager = class("SystemEventManager", function ()
	return display.newNode()
end)

function SystemEventManager:ctor()
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

-- function SystemEventManager:getInstance()
-- 	if self.eventManager == nil then
-- 		self.eventManager = SystemEventManager.new()
-- 	end

-- 	return self.eventManager
-- end

return SystemEventManager