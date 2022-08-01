
local root = uiHelper
local l = root:get_ext("it_units")

local m = {}
l.unitMethods = m

function m:init( pFrame, evt)
    self.evt = evt

    self.frame = CreateFrame("Frame", nil, parent);
    local f = self.frame
    f:SetScript("OnHide", f.StopMovingOrSizing)
    local tex = root.texManager:get("red")
    if( text == nil) then print("tex is nil") end

    tex:SetAlpha( 0.3)
    tex:SetAllPoints(self.frame)
    f.texture = tex
    f:SetResizable( true)

    self.botUnit = nil
    self.topUnit = nil

end



function m:setSize()
    self.frame:SetHeight(100)
end


function m:anchor()
    self.frame:SetPoint("BOTTOMLEFT", self.topUnit.frame, "TOPLEFT", 0, 0)
    self.frame:SetPoint("BOTTOMRIGHT", self.topUnit.frame, "TOPRIGHT", 0, 0)
end

function m:getHolderId()
    return self.holderId
end

function m:setHolderId( id)
    self.holderId = id
end

function m:show()
    self.frame:Show()
end

function m:hide( )
    self.frame:Hide()
end

function m:reset( )
    self.topUnit = nil
    self.botUnit = nil
end

function m:joinTopBot( )
    local s = self
    if s.topUnit ~= nil then
        s.topUnit.botUnit = s.botUnit
    end
    if s.botUnit ~= nil then
        s.botUnit.topUnit = s.topUnit
    end

end




