
print("addon started")
*/
local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

f:SetScript("OnEvent", function(self, event, ...) 
    print(event)

end)

local buff = CreateFrame("Frame")

buff:RegisterEvent("UNIT_AURA")

buff:SetScript( "OnEvent", function ( self, evt, unit) 
    if( unit == "player") then
        print( "player")

        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId 
        = UnitAura( unit, GetNumBuffs())
        print( name)
    end

end)

function GetNumBuffs()
    local a=0; while UnitBuff("player", a+1) do a=a+1 end
    return a;
end


local ipanel = CreateFrame("Frame")
ipanel.name = ""



local f = CreateFrame("Frame",nil,UIParent)
f:SetFrameStrata("BACKGROUND")
f:SetWidth(64) -- Set these to whatever height/width is needed 
f:SetHeight(64) -- for your Texture

local t = f:CreateTexture(nil,"BACKGROUND")
t:SetTexture("Interface\\AddOns\\UiHelpers\\image\\yoloface.blp")
print(t:GetSize())
t:SetAlpha( 0.5)
t:SetAllPoints(f)
f.texture = t

f:SetResizable( true)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)

function f:OnStopDrag( self)
    f:StopMovingOrSizing()
    f.resize:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, 0)
end
f:SetScript("OnDragStop", f.OnStopDrag)
f:SetScript("OnHide", f.StopMovingOrSizing)

local function OnMovingStop(self)
    print( self)
    self:StopMovingOrSizing()
   
   local x1, y1 = f.resize:GetLeft(), f.resize:GetTop()
   local x0, y0 = f:GetLeft(), f:GetTop()

   if (x1 - x0 )< 20 then
        x1 = x0 + 20
        f.resize:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, 0)
   end

   if ( y0 - y1 )< 20 then
        y0 = y1 + 20
        f.resize:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, 0)
   end


   f:SetSize( x1 - x0 , y0 - y1)
end

f:SetPoint("CENTER",0,0)
f.resize = CreateFrame("Frame", nil, f)
f.resize:SetSize(25, 25)
f.resize:SetBackdrop(GameTooltip:GetBackdrop())
f.resize:SetBackdropColor(0, 0, 0, 0.8)
f.resize:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
f.resize:SetMovable(true)
f.resize:EnableMouse(true)
f.resize:RegisterForDrag("LeftButton")

f.resize:SetScript("OnDragStart", f.resize.StartMoving)
f.resize:SetScript("OnDragStop", OnMovingStop)
f.resize:SetScript("OnHide", f.resize.StopMovingOrSizing)

f.resize:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, 0)

f.resize:Show()
f:Show()

local texManager = {}
texManager.count = 0
texManager.holder = {}



local imgUiClass = {}

function imgUi:new() end
function imgUi:setWidth() end
function imgUi:setTexture() end
function imgUi:editable( enable) end




html = CreateFrame('SimpleHTML', nil, UIParent);

html:SetText('<html><body><h1>html</h1></body></html>')
html:SetWidth(200) -- Set these to whatever height/width is needed 
html:SetHeight(200) -- for your Texture
html:SetPoint("CENTER",100,100)
html:SetFont('Fonts\\FRIZQT__.TTF', 11)
html:Show()

local w = CreateFrame("Frame", "Wish List", UIParent)
w:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
w:SetWidth(400)
w:SetHeight(50)
w:EnableKeyboard(true)
w:SetBackdrop(GameTooltip:GetBackdrop())
w:SetBackdropColor(0, 0, 0, 0.8)
w:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)

w:SetMovable(true)
w:EnableMouse(true)

w:RegisterForDrag("LeftButton")
w:SetScript("OnDragStart", w.StartMoving)
w:SetScript("OnDragStop", w.StopMovingOrSizing)
w:SetScript("OnHide", w.StopMovingOrSizing)

w.enter = CreateFrame("EditBox",nil,w)
w.enter:SetScript( "OnEscapePressed", function( self) print( self:ClearFocus()) end)

w.enter:SetWidth(160)
w.enter:SetHeight(24)
w.enter:SetFontObject(GameFontNormal)
w.enter:SetBackdrop(GameTooltip:GetBackdrop())
w.enter:SetBackdropColor(0, 0, 0, 0.8)
w.enter:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
w.enter:SetPoint("CENTER",theFrame,"CENTER",0,40)
w.enter:ClearFocus(self)
w.enter:SetAutoFocus(false)
w.enter:SetText("try 3") 

--w.enter:Show()
--w:Show()
--w.enter:Show()