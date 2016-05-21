local _M = {}

require "gui/support/class"

local awindow = require "gui/awindow"
local imagelist = require "gui/imagelist"

_M.Pointer = class(awindow.AWindow)

function _M.Pointer:setImage(fileName, r, g, b, a, idx, blendSrc, blendDst)
	self:_setImage(self._rootProp, self._IMAGE_INDEX, self.IMAGES, fileName, r, g, b, a, idx, blendSrc, blendDst)
	self:_setCurrImages(self._IMAGE_INDEX, self.IMAGES)
end

function _M.Pointer:getImage(idx)
	return self._imageList:getImage(self.IMAGES, idx)
end

function _M.Pointer:clearImages()
	self._imageList:clearAllImages()
	self:_setCurrImages(self._IMAGE_INDEX, self.IMAGES)
end
function _M.Pointer:init(gui)
	awindow.AWindow.init(self, gui)

	self._type = "Pointer"

	self._IMAGE_INDEX = self._WIDGET_SPECIFIC_OBJECTS_INDEX
	self.IMAGES = self._WIDGET_SPECIFIC_IMAGES

	self._imageList = imagelist.ImageList()
end

return _M