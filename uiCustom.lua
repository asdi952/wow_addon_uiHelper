local root = uiHelper
local l = root:propagate( root, "ui")


  

function l:createInput( pFrame, label, style)
    print( "created intput 1")
    print( style) 
    --print( style.leaveColor) 
    local default_style  = { enterColor = { 0.7, 0.7 ,0.7 ,0.7}, leaveColor = { 1, 1 ,1 ,0.7}, el_joint_space = 0}
    if style == nil then style = default_style else setmetatable( style, { __index = default_style}) end
    print( "created intput 2")
    print( style.leaveColor) 


    local i0 = CreateFrame("Frame", nil, pFrame)
    print( "created intput 3")
   
    i0:SetBackdrop(GameTooltip:GetBackdrop())
    i0:SetBackdropColor( 1, 1 ,1 ,0.7)
    i0:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])

    i0:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    print( "created intput 4")

    local i0_l = i0:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    i0_l:SetPoint("TOPLEFT", i0, "TOPLEFT", 20, 0)
    i0_l:SetPoint("BOTTOMLEFT", i0, "BOTTOMLEFT", 20, 0)
    i0_l:SetText(label)
    i0_l:SetWidth(i0_l:GetStringWidth() + 20)
    print( "created intput 5")


    local i0_m = CreateFrame("EditBox", nil, i0)
    i0_m:ClearAllPoints()
    i0_m:SetPoint( "TOPLEFT", i0_l, "TOPRIGHT", style.el_joint_space, 0)
    i0_m:SetPoint( "BOTTOMLEFT", i0_l, "BOTTOMRIGHT", style.el_joint_space, 0)
    i0_m:SetPoint( "BOTTOMRIGHT", i0, "BOTTOMRIGHT", -10, 0)
    i0_m:SetPoint( "TOPRIGHT", i0, "TOPRIGHT",-10, 0)
    i0_m:SetScript( "OnEscapePressed", function( self) self:ClearFocus() end)
    i0_m:SetFontObject(GameFontNormal)
    i0_m:EnableKeyboard(true)
    i0_m:SetAutoFocus(false)
    i0_m:ClearFocus(self)
    i0_m:SetScript("OnEnter", function (self) i0:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    i0_m:SetScript("OnLeave", function (self) i0:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)
    print( "created intput 6")

    i0:EnableMouse(true)
    i0:SetScript("OnMouseDown", function (self, button)  i0_m:SetFocus() end)
    i0:SetScript("OnEnter", function (self) i0:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    i0:SetScript("OnLeave", function (self) i0:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)

    print( "created intput 7")

    local input = i0
    input.label = i0_l
    input.input = i0_m

    i0_m.i0 = i0

    return input
end

function l:createDropDownMenu( pFrame, label, nameList, evt, style)

    local style_default = { border = 10}
    if style == nil then 
        style = style_default 
    else
        setmetatable( style, { __index = style_default})
    end

    local m = root.std:createObjArray()
    local lf = nil
    local tHeight = 0
    local h = 0

    local mf = CreateFrame( "Frame", nil, pFrame)
    mf.text = mf:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    mf.text:SetPoint( "TOPLEFT", mf, "TOPLEFT", 10, 0)
    mf.text:SetPoint( "BOTTOMLEFT", mf, "BOTTOMLEFT", 10, 0)
    mf.text:SetText( label)
    mf.text:SetWidth( mf.text:GetStringWidth() )

    mf.evt = evt
    mf.style = style

    local f = CreateFrame( "Frame", nil, mf)
    f:SetPoint( "TOPLEFT", mf.text, "TOPRIGHT", 10, -style.border)
    f:SetPoint( "TOPRIGHT", mf, "TOPRIGHT",-10, -style.border)
    f:SetFrameStrata("HIGH")
    f:SetBackdrop(GameTooltip:GetBackdrop())
    f:SetBackdropColor( 1, 1 ,1 ,0)
    f:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)
    f.state = 0
    mf.f = f


    function f:swap( child)
        local t = f.vchilds:get(1)
        if t == child then
            return
        end

        local text = t.text:GetText()
        t.text:SetText( child.text:GetText())
        child.text:SetText( text)
    end
    function f:close( child)
        if child ~= nil then
            f:swap( child)
        end
        if f.evt.OnClose ~= nil then
            f.evt.OnClose( mf, f.vchilds:get(1).text:GetText())
        end
        
        for i, k in ipairs(f.vchilds:get_array()) do
            if i ~= 1 then
                k:Hide()
            end
        end
        f:SetHeight( h )
        f.state = 1
        f.cf:EnableMouse(false)

    end
    function f:open( )
        for i, k in ipairs(f.vchilds:get_array()) do
            if i ~= 1 then
                k:Show()
            end
        end
        f:SetHeight( tHeight)
        f.state = 0
        f.cf:EnableMouse(true)
    end
    function f:action( child)
        local s = self
        if  s.state == 0 then
            s:close( child)
        elseif s.state == 1 then
            s:open()
        end
    end

    function f:chooseOption( opt)
        for i, k in ipars( f.vchilds:get_array()) do
            local text = k.text:GetText()
            if text == opt then
                self:swap( k)
                break
            end
        end
    end
    function f:getChooseOption()
        return self.vchilds:get(1).text:GetText()
    end

    for i, k in ipairs( nameList) do
        local hf = CreateFrame( "Frame", nil, f)
        --hf.name = k    
        hf.parent = f
        if lf == nil then
            hf:SetPoint( "TOPLEFT", f, "TOPLEFT", 0 ,0)    
            hf:SetPoint( "TOPRIGHT", f, "TOPRIGHT", 0 ,0)    
        else
            hf:SetPoint( "TOPLEFT", lf, "BOTTOMLEFT", 0 , 10)
            hf:SetPoint( "TOPRIGHT", lf, "BOTTOMRIGHT", 0 , 10)
        end
        f.clickColor = { 0.1, 0.1, 0.1, 0.7}
        f.enterColor = { 0.6, 0.6, 0.6, 0.7}
        f.leaveColor = { 0.3, 0.3, 0.3, 0.7}
        hf:SetBackdrop(GameTooltip:GetBackdrop())
        hf:SetBackdropColor( f.leaveColor[1], f.leaveColor[2], f.leaveColor[3], f.leaveColor[4])
        hf:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
        hf:EnableMouse(true)

        hf.text = hf:CreateFontString( nil, "OVERLAY", "GameTooltipText")
        hf.text:SetPoint("CENTER", hf, "CENTER", 0, 0)
        hf.text:SetText( k)
        h = hf.text:GetStringHeight() + 20
        
        hf:SetHeight( h)

        tHeight = tHeight + h
        if i ~= 1 then
            local borderH = 10
            tHeight = tHeight - borderH
        end

        hf:SetScript("OnMouseDown", function(self, but) 
            local p = self.parent
            if but == "LeftButton" then
                hf:SetBackdropColor( p.clickColor[1], p.clickColor[2], p.clickColor[3], p.clickColor[4])
            end
        end)

        hf:SetScript("OnMouseUp", function(self, but) 
            local p = self.parent
            if but == "LeftButton" then
                hf:SetBackdropColor( p.leaveColor[1], p.leaveColor[2], p.leaveColor[3], p.leaveColor[4])
                p:action( self)
            end
        end)
        hf:SetScript("OnEnter", function(self, arg1) 
            local p = self.parent
            hf:SetBackdropColor( p.enterColor[1], p.enterColor[2], p.enterColor[3], p.enterColor[4])
        end)
        hf:SetScript("OnLeave", function(self, arg1) 
            local p = self.parent
            hf:SetBackdropColor( p.leaveColor[1], p.leaveColor[2], p.leaveColor[3], p.leaveColor[4])
        end)

        m:add( hf)
        lf = hf
    end
    mf:SetHeight( h + style.border*2)

    local cf = CreateFrame( "Frame", nil, UIParent)
    cf.parent = f
    
    cf:SetAllPoints( UIParent)
    cf:SetScript("OnEnter", function(self) self.parent:close() end)
    cf:SetFrameLevel(lf:GetFrameLevel() - 1)

    f:SetScript("OnLeave", function( self) 
        close() 
    end)
    f.vchilds = m
    f.evt = evt
    f.cf = cf
    f:close()

    function mf:reset()
        for i, k in ipairs(f.vchilds:get_array()) do
            k.text:SetText(nameList[i])
        end
    end

    return mf
end


function l:createIntreval(pFrame, label, midText, evt, style)
    local style_default = { border = 9, height = 20, iWidth0 = 35, iWidth1 = 35, enterColor = { 0.7, 0.7 ,0.7 ,0.7}, leaveColor = { 0.3, 0.3 ,0.3 ,0.7}}
    local evt_default = { leaveFocus0 = function(self ) end, leaveFocus1 = function() end}
    if style == nil then style = style_default else setmetatable(style, { __index = style_default}) end
    if evt == nil then evt = evt_default else setmetatable(evt, { __index = evt_default}) end

    local f = CreateFrame("Frame", nil, pFrame)

    f:SetHeight( style.height + style.border*2)

    f.label = f:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    f.label:SetPoint( "TOPLEFT", f, "TOPLEFT", style.border, -style.border)
    f.label:SetPoint( "BOTTOMLEFT", f, "BOTTOMLEFT", style.border, style.border)
    f.label:SetText( label)
    f.label:SetWidth( f.label:GetStringWidth() + 5)

    local e0s = CreateFrame( "Frame", nil, f)
    e0s.base = f
    e0s:SetPoint("TOPLEFT", f.label, "TOPRIGHT", 2, 5)
    e0s:SetPoint("BOTTOMLEFT", f.label, "BOTTOMRIGHT", 2, -5)
    e0s:SetWidth( style.iWidth0 + 20)
    e0s:SetBackdrop(GameTooltip:GetBackdrop())
    e0s:SetBackdropColor( 0.3, 0.3 ,0.3 ,0.7)
    e0s:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0.2)
    e0s:EnableMouse( true)
    e0s:SetScript( "OnMouseDown", function( self, but) self.base.e0:SetFocus() end)
    e0s:SetScript("OnEnter", function (self) e0s:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    e0s:SetScript("OnLeave", function (self) e0s:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)

    local e0 = CreateFrame( "EditBox", nil, e0s)
    e0.base = f
    e0:SetPoint("CENTER", e0s, "CENTER", 0, 0)
    e0:SetSize(style.iWidth0, style.height)
    e0:EnableKeyboard(true)
    e0:SetAutoFocus(false)
    e0:ClearFocus(self)
    e0:SetFontObject(GameFontNormal)
    e0:SetScript( "OnEscapePressed", function( self) self:ClearFocus() end)
    e0:SetScript( "OnEnterPressed", function( self)  self.base.e1:SetFocus() end)
    e0:SetScript("OnEditFocusLost", function (self) evt.leaveFocus0( self) end)
    e0:SetScript("OnEnter", function (self) e0s:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    e0:SetScript("OnLeave", function (self) e0s:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)
    
    f.midText = f:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    f.midText:SetPoint( "TOPLEFT", e0s, "TOPRIGHT", 5, -5)
    f.midText:SetPoint( "BOTTOMLEFT", e0s, "BOTTOMRIGHT", 5, 5)
    f.midText:SetText( midText)
    f.midText:SetWidth( f.midText:GetStringWidth() + 5)

    local e1s = CreateFrame( "Frame", nil, f)
    e1s.base = f
    e1s:SetPoint("TOPLEFT", f.midText, "TOPRIGHT", 2, 5)
    e1s:SetPoint("BOTTOMLEFT", f.midText, "BOTTOMRIGHT", 2, -5)
    e1s:SetWidth( style.iWidth1 + 20)
    e1s:SetBackdrop(GameTooltip:GetBackdrop())
    e1s:SetBackdropColor( 0.3, 0.3 ,0.3 ,0.7)
    e1s:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0.2)
    e1s:EnableMouse( true)
    e1s:SetScript( "OnMouseDown", function( self, but) self.base.e1:SetFocus() end)
    e1s:SetScript("OnEnter", function (self) e1s:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    e1s:SetScript("OnLeave", function (self) e1s:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)

    local e1 = CreateFrame( "EditBox", nil, e1s)
    e1.base = f
    e1:SetPoint("CENTER", e1s, "CENTER", 0, 0)
    e1:SetSize(style.iWidth1, style.height)
    e1:EnableKeyboard(true)
    e1:SetAutoFocus(false)
    e1:ClearFocus(self)
    e1:SetFontObject(GameFontNormal)
    e1:SetScript( "OnEscapePressed", function( self) self:ClearFocus() end)
    e1:SetScript( "OnEnterPressed", function( self)  self:ClearFocus() end)
    e1:SetScript("OnEditFocusLost", function (self) evt.leaveFocus1( self) end)
    e1:SetScript("OnEnter", function (self) e1s:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    e1:SetScript("OnLeave", function (self) e1s:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)
    
    
    f.e0 = e0
    f.e1 = e1

    function f:chDescription( label, midText)
        self.label:SetText( label)
        self.label:SetWidth( self.label:GetStringWidth() + 5)
        self.midText:SetText( midText)
        self.midText:SetWidth( self.midText:GetStringWidth() + 5)
    end


    return f
end

function l:createCheckBox( pFrame, label, evt, style)
    local style_default = { border = 9, height = 20, enterColor = { 0.7, 0.7 ,0.7 ,0.7}, leaveColor = { 0.2, 0.2,0.2 ,0.8}, boxSize = 65}
    if style == nil then style = style_default else  setmetatable(style, { __index = style_default}) end

    local f = CreateFrame( "Frame", nil, pFrame)
    f:SetHeight(style.height + style.border * 2)
    f.label = f:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    f.label:SetPoint( "TOPLEFT", f, "TOPLEFT", style.border, -style.border)
    f.label:SetPoint( "BOTTOMLEFT", f, "BOTTOMLEFT", style.border, style.border)
    f.label:SetText( label)
    f.label:SetWidth( f.label:GetStringWidth() + 5)

    f.button = CreateFrame("Button", nil, f)
    f.button:SetPoint("LEFT", f.label, "RIGHT", 5, 0)
    f.button:SetPoint("CENTER", f.label, "CENTER", 0, 0)
    f.button:SetWidth( style.boxSize)
    f.button:SetHeight( style.boxSize)
    f.button:SetBackdrop(GameTooltip:GetBackdrop())
    f.button:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])
    f.button:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0.2)
    f.button:SetScript("OnEnter", function (self) f.button:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4]) end)
    f.button:SetScript("OnLeave", function (self) f.button:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) end)
    f:SetWidth( f.label:GetWidth() + f.button:GetWidth() + 2*style.border + 5)

    f.button.f = f
    f.button.state = 0
    f.button:SetScript("OnClick", function( self, but) 
        self.f:changeState()
    end)

    function f:setState( state)
        if state == 1 then
            f.img:SetAlpha( 1)
            self.button.state = 1
        else
            f.img:SetAlpha( 0)
            self.button.state = 0
        end
    end

    function f:changeState()
        if self.button.state == 1 then
            self:setState( 0)    
        else
            self:setState( 1)    
        end
    end

    f.img = f.button:CreateTexture(nil, "BACKGROUND")
    f.img:SetAllPoints( f.button)
    f.img:SetTexture( root.paths.images .. "check_cross.blp")
    f.img:SetAlpha( 0)

    function f:getState()
        return self.button.state
    end

    function f:reset()
        self:setState( 0)
    end

    return f
end

function l:createLineButtons( pFrame, nameList, style) --namList k.name k.click 
    local style_default = { border = 9, height = 20, enterColor = { 0.7, 0.7 ,0.7 ,0.7}, leaveColor = { 0.2, 0.2,0.2 ,0.8}, }
    if style == nil then style = style_default else  setmetatable(style, { __index = style_default}) end

    local f = CreateFrame("Frame", nil, pFrame)
    f:SetHeight( style.height + 2* style.border)

    f.butts = root.std:createVector()
    local width = 0
    for i, k in ipairs( nameList) do
        local b = CreateFrame("Button", nil, f)
        f.butts.push( b)

        if i == 1 then
            b:SetPoint( "TOPLEFT", f, "TOPLEFT", style.border, -style.border)
            b:SetPoint( "BOTTOMLEFT", f, "BOTTOMLEFT", style.border, style.border)
        else
            local lFrame = f.butts.getLast()
            b:SetPoint( "TOPLEFT", lFrame, "TOPLEFT")
            b:SetPoint( "BOTTOMLEFT", lFrame, "BOTTOMLEFT")
        end

        b.text = b:CreateFontString( nil, "OVERLAY", "GameTooltipText")
        b.text:SetPoint("TOPLEFT", b, "TOPLEFT")
        b.text:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT")
        b.text:SetText( k.name)
        b.text.SetWidth( b.text:GetStringWidth() + 5)
        b.SetWidth( b.text:GetStringWidth() + 5)
        b:SetBackdrop(GameTooltip:GetBackdrop())
        b:SetBackdropColor( f.leaveColor[1], f.leaveColor[2], f.leaveColor[3], f.leaveColor[4])
        b:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
        b:SetScript("OnEnter", function( self) b:SetBackdropColor( f.enterColor[1], f.enterColor[2], f.enterColor[3], f.enterColor[4]) end)
        b:SetScript("OnLeave", function( self) b:SetBackdropColor( f.leaveColor[1], f.leaveColor[2], f.leaveColor[3], f.leaveColor[4]) end)
        b:SetScript("OnClick", function( self, but) k.click( self) end)


        width = width + b:GetWidth()

    end

    f:SetWidth( width + style.border)
end

function l:createButton( pFrame, name, evt, style)
    local style_default = { border = 9, height = 40, enterColor = { 0.7, 0.7 ,0.7 ,0.7}, leaveColor = { 0.2, 0.2,0.2 ,0.8}, }
    local evt_default = { click = function(self ) end, OnLeave = function(self) end, OnEnter = function(self) end }
    if style == nil then style = style_default else  setmetatable(style, { __index = style_default}) end
    if evt == nil then evt = evt_default else setmetatable(evt, { __index = evt_default}) end


    local but = CreateFrame("Button", nil, pFrame)
    but:SetHeight(  style.height + style.border)
    but.style = style
    but.evt = evt
   
    but.text = but:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    but.text:SetText( name)
    but.text:SetWidth(  but.text:GetStringWidth() + 5)
    but.text:SetPoint( "CENTER", but, "CENTER")
    --but.text:SetPoint( "BOTTOMLEFT", but, "BOTTOMLEFT", style.border, style.border)

    but:SetWidth(  but.text:GetStringWidth() + 5 + 2*style.border)


    but:SetBackdrop(GameTooltip:GetBackdrop())
    but:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])
    but:SetBackdropBorderColor( 0.8, 0.8, 0.8, 0.8)
    but:SetScript("OnClick", function( self, tbut) 
        if tbut == "LeftButton" then
            evt.click( self)
        end
    end)
    but:SetScript("OnEnter", function( self) 
        self:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4])
        evt.OnEnter( self)
    end)
    but:SetScript("OnLeave", function( self) 
        self:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4]) 
        evt.OnLeave( self)
    end)

    return but
end

function l:createScrollFrame( pFrame, evt, style)
    local default_style = { optionHeight = 42, width = 135, height = 220, enterColor = {0.3, 0.3, 0.3, 0.9,}, leaveColor = { 1, 1, 1, 1,}}
    if style == nil then style = default_style else setmetatable( style, { __index = default_style})end
    local default_evt = { OnClick = function( self, but) end, OnCreated = function( self, elm)  end, OnRemoved = function( self, elm)  end, }
    if evt == nil then evt = default_evt else setmetatable( evt, { __index = default_evt})end

    local ml = CreateFrame( "Frame", nil, UIParent)
    ml:SetAllPoints(UIParent)
    ml:SetScript( "OnMouseDown", function(self) self.sf:hideMe() end)
    ml:SetFrameStrata("HIGH")
    local uniqueWord = "createScrollFrame" .. root.std:createUniqueNum()

    local sf = CreateFrame( "ScrollFrame", uniqueWord , pFrame, "UIPanelScrollFrameTemplate")
--    local sf = CreateFrame( "ScrollFrame", "$parent_ScrollFrame" , pFrame, "UIPanelScrollFrameTemplate")
    sf:SetSize( style.width, style.height)
    sf:SetBackdrop(GameTooltip:GetBackdrop())
    sf:SetBackdropColor( 1, 0, 0, 1)
    sf:SetBackdropBorderColor( 1, 0.8, 0, 1)
    sf:SetAlpha( 1)
    sf:SetFrameStrata("HIGH")
    ml.sf = sf
    sf.ml = ml
    sf.sb = _G[ sf:GetName() .. "ScrollBar"];
    sf.sb:ClearAllPoints()
    sf.sb:SetPoint("TOPRIGHT", sf, "TOPRIGHT", -5 , -25)
    sf.sb:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", 5, 25)
    sf.sb:EnableMouse( true)
    sf.options = root.std:createVector()
    sf.height = 0

    function sf:replaceOptions( opt) --opt is a vector



    end

    function sf:refresh()
        local h = self.cf:GetHeight() + 10
        if h > style.height then
            h = style.height
            self.sb:Show()
        else
            self.sb:Hide()
        end
        self:SetHeight( h)
    end
    function sf:showMe()
        self:Show()
        self.ml:EnableMouse(true)
    end
    function sf:hideMe()
        self:Hide()
        self.ml:EnableMouse( false)
    end

    local cf = CreateFrame("Frame",  uniqueWord, sf)
    cf:SetSize(sf:GetWidth() - 23, sf:GetHeight())
    cf:SetPoint( "TOPLEFT", sf, "TOPLEFT")
    sf:SetScrollChild(cf)
    
    --[[cf:SetBackdrop(GameTooltip:GetBackdrop())
    cf:SetBackdropColor( 1, 0, 0, 1)
    cf:SetBackdropBorderColor( 1, 0.8, 0, 0)--]]
    sf.cf = cf

    function cf:refresh()
        cf:SetHeight( sf.height)
    end

    function sf:btClicked( but)
        --print( "button :", but.text:GetText())
        evt.OnClick( self, but)
    end

    function sf:createOption( data)
        local o = CreateFrame( "Button", nil, cf)
        o:SetBackdrop(GameTooltip:GetBackdrop())
        o:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])
        o:SetBackdropBorderColor( 0.8, 0.8, 0.8, 0)
        o.data = data
        o.text = o:CreateFontString( nil, "OVERLAY", "GameTooltipText")
        o.text:SetText( data.label) 
        o.text:SetWidth( o.text:GetStringWidth() + 5)
        o.text:SetPoint( "CENTER", o, "CENTER")

        local lOpt = self.options:getLast()
        if lOpt == nil then
            o:SetPoint( "TOPLEFT", cf, "TOPLEFT", 0, 0)
            o:SetPoint( "TOPRIGHT", cf, "TOPRIGHT", 0, 0)
        else
            o:SetPoint( "TOPLEFT", lOpt, "BOTTOMLEFT" ,0 , 10)
            o:SetPoint( "TOPRIGHT", lOpt, "BOTTOMRIGHT", 0 , 10)
        end

        o:SetHeight( style.optionHeight )
        self.height = self.height + o:GetHeight() -10

        o:SetScript( "OnClick", function(self) 
            sf:btClicked( self)
        end)
        o:SetScript( "OnEnter", function(self) 
            self:SetBackdropColor( style.enterColor[1], style.enterColor[2], style.enterColor[3], style.enterColor[4])
        end)
        o:SetScript( "OnLeave", function(self) 
            self:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])
        end)

        self.options:push( o)
        cf:refresh()
        self:refresh()

        return o
    end

   

    function sf:load_many( list)
        for i, k in ipairs( list)do
            sf:createOption( k)
        end
    end

  

    return sf
end

function l:createMessage( pFrame, evt, style)
    local default_style = { border = 10, width = 100, height = 100, enterColor = { 0.8, 0, 0, 0.8}, leaveColor = { 1, 0 ,0 ,1} }
    if style == nil then style = default_style else setmetatable( style, { __index = default_style}) end

    local bf = CreateFrame( "Frame", nil, pFrame)
    bf:SetAllPoints( UIParent)
    bf:SetFrameStrata("DIALOG")
    bf:SetScript( "OnMouseDown", function( self) self.sf:hideMe() end)

    local sf = CreateFrame( "ScrollFrame", "createMessage", pFrame, "UIPanelScrollFrameTemplate")
    sf:SetSize( style.width, style.height)
    sf:SetBackdrop(GameTooltip:GetBackdrop())
    sf:SetBackdropColor( style.leaveColor[1], style.leaveColor[2], style.leaveColor[3], style.leaveColor[4])
    sf:SetBackdropBorderColor( 0.8, 0.8, 0.8, 0)
    sf:SetFrameStrata("DIALOG")
    bf.sf = sf
    sf.bf = bf

    sf.sb = _G[ sf:GetName() .. "ScrollBar"];
    sf.sb:ClearAllPoints()
    sf.sb:SetPoint("TOPRIGHT", sf, "TOPRIGHT", -5 , -25)
    sf.sb:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", 5, 25)
    sf.sb:EnableMouse( true)

    local cf = CreateFrame("Frame",  "createMessage", sf)
    cf:SetSize(sf:GetWidth() - 23, sf:GetHeight())
    cf:SetPoint( "TOPLEFT", sf, "TOPLEFT")
    sf:SetScrollChild(cf)
    cf.height = 0
    sf.cf = cf


    cf.text = cf:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    cf.text:SetText("")
    cf.text:SetPoint( "TOPLEFT", cf, "TOPLEFT", style.border, -style.border)
    cf.text:SetPoint( "TOPRIGHT", cf, "TOPRIGHT", -style.border, -style.border)

    function sf:showMe()
        self:Show()
        self.bf:EnableMouse(true)
    end

    function sf:hideMe()
        self:Hide()
        self.bf:EnableMouse( false)
    end

    function sf:refresh()
        local h = self.cf:GetHeight()
        if h > style.height then
            h = style.height
            self.sb:Show()
        else
            self.sb:Hide()
        end
        self:SetHeight( h + 2*style.border)
    end

    function cf:refresh()
        self:SetHeight( 100 + style.border )
    end

    function sf:addText( text)
        print( "asd")
        self.cf.text:SetText( text, 0.5, 0.5, 0.5,  0.75, true)
        --self.cf.text:SetWidth(0)
        print( self.cf.text:GetStringHeight() )
        print( self.cf.text:GetWidth() /  self.cf.text:GetStringWidth())
        print( self.cf.text:GetHeight())
        self.cf.text:SetHeight( (self.cf.text:GetWidth() /  (self.cf.text:GetStringWidth() )) * (self.cf.text:GetStringHeight())) 
        self.cf.text:Show()
        self.cf:refresh()
        self:refresh()
        self:showMe()
    end

    function sf:setAnchor( pFrame, pointName, ref, pointNameRef, p0, p1)
        print("setAnchor")
        --self:SetParent( pFrame)
        sf:ClearAllPoints()
        sf:SetPoint( pointName, ref, pointNameRef, p0, p1)
    end
    sf:hideMe()


    return sf

end

function l:createButInput( pFrame, info, evt)
    local default_info = {
        input_label = "name",
        input_enterColor = { 0.7, 0.7 ,0.7 ,0.7},
        input_leaveColor = { 1, 1, 1, 0.8},
        button_label = "button",
        button_enterColor = { 0.7, 0.7 ,0.7 ,0.7},
        button_leaveColor = { 0.2, 0.2,0.2 ,0.8},

    }
    local default_evt = {
        OnSubmit = function( self, text) end
    }
    if info == nil then info = default_info else setmetatable( info, { __index = default_info}) end
    if evt == nil then evt = default_evt else setmetatable( evt, { __index, default_evt}) end

    local body = CreateFrame("Frame", nil, pFrame)

    local iBlock = CreateFrame("Frame", nil, UIParent)
    iBlock:SetAllPoints( UIParent)
    iBlock:EnableMouse(false)
    iBlock:SetScript("OnMouseDown", function( self) self.input.input:SetText( "") self.body:buttonMe() end)
    iBlock:SetFrameStrata( "HIGH")

    local input = l:createInput( iBlock, info.input_label, { el_joint_space = -13})
    input:SetPoint("TOPLEFT", body, "TOPLEFT")
    input:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT")
    input.input:SetScript("OnEnterPressed", function( self)  evt.OnSubmit( self.i0.body, self:GetText() ) self:SetText( "") self.i0.body:buttonMe() end)

    local button = CreateFrame( "Button", nil, body)
    button:SetPoint("TOPLEFT", body, "TOPLEFT")
    button:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT")

    button:SetBackdrop(GameTooltip:GetBackdrop())
    button:SetBackdropColor( info.button_leaveColor[1], info.button_leaveColor[2], info.button_leaveColor[3], info.button_leaveColor[4])
    button:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)

    button:SetScript("OnClick", function(self, but) self.body:inputMe() end)
    button:SetScript("OnEnter", function(self) button:SetBackdropColor( info.button_enterColor[1], info.button_enterColor[2], info.button_enterColor[3], info.button_enterColor[4]) end)
    button:SetScript("OnLeave", function(self) button:SetBackdropColor( info.button_leaveColor[1], info.button_leaveColor[2], info.button_leaveColor[3], info.button_leaveColor[4]) end)

    button.label = button:CreateFontString( nil, "OVERLAY", "GameTooltipText")
    button.label:SetPoint( "CENTER", button, "CENTER")
    button.label:SetText( info.button_label)


    button.body = body
    input.body = body
    iBlock.body = body
    iBlock.input = input

    body.input = input
    body.button = button
    body.iBlock = iBlock

    function body:buttonMe()
        self.input:Hide()
        self.button:Show()
        self.iBlock:EnableMouse( false)
    end
    function body:inputMe()
        self.input:Show()
        self.button:Hide()
        self.iBlock:EnableMouse( true)
        self.input.input:SetFocus()
    end
    
    body:buttonMe()    

    return body

end