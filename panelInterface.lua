local root = uiHelper
local l = root:propagate( root, "Interface_panel")





----------------------------------------------------------------------------------------------------------------------------------------#################################

function l:createS1Unit( pFrame , evt)
    local default_evt = { 
        unitClosed = function( s1) end,
    }
    if evt == nil then evt = default_evt else setmetatable(evt, { __index = default_evt}) end

    local s1 = CreateFrame( "Frame", nil, pFrame)
    s1:SetBackdrop(GameTooltip:GetBackdrop())
    s1:SetBackdropColor( 1, 1 ,1 ,0.7)
    s1:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    s1:SetHeight(130)

    function s1:reset()
        self.i1:reset()
        self.img0:reset()
        self.ddm1:reset()
    end

    function s1:RegisterStorage( st)
        local res = true
        if st == nil then
            st = {}
            res = false
        end
        self.storage = st

        return res
    end

    function s1:load()
        self.i1:load()
        self.img0:load()
        self.ddm1:load()
    end
    function s1:save()
        self.i1:save()
        self.img0:save()
        self.ddm1:save()
    end

    function s1:SetType( type)
        if self.curType == type then return end
        print("rr1")
        if type == "buffs" then 
            print("rr2")
            self.s2:showMe()          
            s1:SetHeight(130)

        elseif type == "coldowns" then 
            print("rr3")
            self.s2:hideMe()          
            s1:SetHeight( 95)

        else
            print("rr4")
            print( "invalid type inserted into s1")
            return 
        end
        print("rr5")
        self.curType = type
    end


    local s1_exit = CreateFrame( "Button", nil, s1)
    s1_exit.s1 = s1
    s1_exit:SetPoint( "CENTER", s1, "TOPRIGHT", -9, -9)
    s1_exit:SetSize( 25, 25)
    s1_exit.tex = s1_exit:CreateTexture( nil, "BACKGROUND", -8, -8)
    s1_exit.tex:SetAllPoints(s1_exit)
    s1_exit.tex:SetTexture( root.paths.images .. "exit_cross.blp")
    s1_exit.ealpha = 0.6 
    s1_exit.ealpha = 1
    s1_exit:SetAlpha( s1_exit.ealpha)
    s1_exit:SetScript("OnClick", function( self) evt.unitClosed(self.s1)  end)
    s1_exit:SetScript( "OnEnter", function( self) self:SetAlpha( s1_exit.ealpha)  end)
    s1_exit:SetScript( "OnLeave", function( self) self:SetAlpha( s1_exit.lalpha)  end)
    s1.s1_exit = s1_exit

    local img0 = CreateFrame( "Frame", nil , s1)
    img0:SetSize( 64, 64)
    --img0:SetPoint( "TOPRIGHT", s1, "TOPRIGHT", -25, -16)
    img0:SetPoint( "TOP", s1, "TOP", 0, -16)
    img0:SetPoint( "RIGHT", s1_exit, "LEFT", -7, 0)
    local noImg = root.paths.images .. "noImg.blp"
    img0.texture = img0:CreateTexture( nil, "BACKGROUND")
    img0.texture:SetTexture( noImg) --Interface\AddOns\UiHelpers\image\yoloface.blp
    img0.texture:SetAllPoints( img0)
    s1.img0 = img0
    function img0:reset()
        self.texture:SetTexture( noImg)
    end

    function img0:load_data( data)
        self.texture:SetTexture( data)
    end
    function img0:save_data()
        return self.texture:GetTexture()
    end
    function img0:load()
        if s1.storage.img0 == nil then return  end
        self:load_data( s1.storage.img0)
    end
    function img0:save()
        s1.storage.img0 = self:save_data()
    end

    local i1 = root.ui:createInput( s1, "img Path")
    i1:SetPoint("TOPLEFT", s1, "TOPLEFT", 15, -7)
    i1:SetPoint("RIGHT", img0, "LEFT", -10, 0)
    i1:SetHeight( 35)
    s1.i1 = i1
    i1.input:SetText( "[example] \"Interface\\AddOns\\UiHelpers\\image\\yoloface.blp\"")
    i1.input:SetScript( "OnEnterPressed", function(self) 
        self:ClearFocus()
    end)
    i1.input:SetScript("OnEditFocusGained", function()
        i1.input.state = 0
    end) 
    i1.input:SetScript("OnEditFocusLost", function() 
        if i1.input.state == 0 then
            i1.input.state = i1.input.state  + 1

            local text = i1.input:GetText()
            if img0.texture:SetTexture( text) == 1 then
                img0.texture:SetAllPoints( img0)
            else
                img0.texture:SetTexture( noImg)
                img0.texture:SetAllPoints( img0)
            end
        end
    end)
    function i1:reset()
        self.input:SetText( "[example] \"Interface\\AddOns\\UiHelpers\\image\\yoloface.blp\"")
    end

    function i1:load_data( data)
        self.input:SetText( data)
    end
    function i1:save_data()
        return self.input:GetText() 
    end
    function i1:load()
        if s1.storage.i1 == nil then return end
        self:load_data( s1.storage.i1)
    end
    function i1:save()
        s1.storage.i1 = self:save_data()
    end


    local s2 = CreateFrame( "Frame", nil, s1)
    s2:SetPoint( "TOPLEFT", i1, "BOTTOMLEFT", 0, -10)
    s2:SetPoint( "TOPRIGHT", i1, "BOTTOMRIGHT", 0 , -10)
    s2:SetBackdrop(GameTooltip:GetBackdrop())
    s2:SetBackdropColor( 1, 1 ,1 ,0.7)
    s2:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    s1.s2 = s2

    function s2:showMe()
        self:Show()

    end
    function s2:hideMe()
        self:Hide()
    end
    local ddm1 = root.ui:createDropDownMenu( s2, "type: ", {"One Every Stack", "One for all Stacks"}, {OnClose = function( child)  end}, {border = 0})
    ddm1:SetPoint( "CENTER", s2, "CENTER")
    ddm1:SetPoint( "LEFT", s2, "LEFT", 20, 0)
    ddm1:SetWidth(200)
    s1.ddm1 = ddm1

    function ddm1:load_data( data)
        self.f:chooseOption( data)
    end
    function ddm1:save_data()
        return self.f:getChooseOption()
    end
    function ddm1:load()
        if s1.storage.ddm1 == nil then return end
        self:load_data( s1.storage.ddm1)
    end
    function ddm1:save()
        s1.storage.ddm1 = self:save_data()
    end


    s2:SetHeight( ddm1:GetHeight() + 20)
    local interval = root.ui:createIntreval( s2, "Stacks Interval:",  "to", {
        leaveFocus0 = function( self) 
           
        end,
        leaveFocus1 = function( self) 
            local n1 =self.f.e0:GetNumber()
            
        end,
    }, { border = 10, height = 22, iWidth0 = 25, iWidth1 = 25})
    interval.e0:SetNumeric()
    interval:SetPoint( "CENTER", s2, "CENTER")
    interval:SetPoint( "LEFT", ddm1, "RIGHT", 20, 0)
    s1.interval = interval

    function interval:load_data( data1, data2)
        self.e0:SetText( data1)
        self.e1:SetText( data2)
    end
    function interval:save_data()
        return { e0 = self.e0:GetText(), e1 = self.e1:GetText()}
    end
    function interval:load()
        if s1.storage.int_e0 == nil or s1.storage.int_e1 == nil then return end
        self:load_data( s1.storage.int_e0, s1.storage.int_e1)
        
    end
    function interval:save()
        local d = self:load_data()
        s1.storage.int_e0 = d.e0
        s1.storage.int_e1 = d.e1
    end
    
    return s1
end
----------------------------------------------------------------------------------------------------------------------------------------#################################
function l:createS0Unit( pFrame, evt)
    local default_evt = { 
        unitClosed = function( s0) end,
    }
    if evt == nil then evt = default_evt else setmetatable(evt, { __index = default_evt}) end

    local s0 = CreateFrame("Frame", nil, pFrame)
    s0.pFrame = pFrame
    s0:SetBackdrop(GameTooltip:GetBackdrop())
    s0:SetBackdropColor( 0, 0 , 1, 1)
    s0:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)

    function s0:refreshHeight()
        local size = { 
            self.s1_units:getHeight() + 0,
            80
        }
        table.sort( size)
        self:SetHeight( size[#size] + 200)
    end
    function s0:reset()
        self.ddm0:reset_plus()
        self.checkBox:reset()
        self.s1_units:reset()
    end

    function s0:registerStorage( st)
        local res = true
        if st == nil then
            st = {}
            res = false
        end
        self.storage = st
        return res 
    end
    function s0:load( )
        self.i0:load()
        self.ddm0:load()
        self.checkBox:load() 
        self.s1_units:load()
    end
    function s0:save( )
        self.i0:save()
        self.ddm0:save()
        self.checkBox:save() 
        self.s1_units:save()
    end

    local side0 = CreateFrame( "Frame", nil,  s0)
    side0:SetPoint( "TOPRIGHT", s0, "TOPRIGHT", -15, -20)
    side0:SetWidth( 210)
    side0:SetHeight(210)
    side0:SetBackdrop(GameTooltip:GetBackdrop())
    side0:SetBackdropColor(  1, 1 ,1 ,0.4)
    side0:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    s0.side0 = side0

    local s0_exit = CreateFrame( "Button", nil, s0)
    s0_exit.s0 = s0
    s0_exit:SetPoint( "TOPRIGHT", s0, "TOPRIGHT", -10, -10)
    s0_exit:SetSize( 30, 30)
    s0_exit.tex = s0_exit:CreateTexture( nil, "BACKGROUND")
    s0_exit.tex:SetAllPoints(s0_exit)
    s0_exit.tex:SetTexture( root.paths.images .. "exit_cross.blp")
    s0_exit.ealpha = 0.6 
    s0_exit.ealpha = 1
    s0_exit:SetAlpha( s0_exit.ealpha)
    s0_exit:SetScript("OnClick", function( self) evt.unitClosed(self.s0)  end)
    s0_exit:SetScript( "OnEnter", function( self) self:SetAlpha( s0_exit.ealpha)  end)
    s0_exit:SetScript( "OnLeave", function( self) self:SetAlpha( s0_exit.lalpha)  end)
    s0.s0_exit = s0_exit


    local ddm0 = root.ui:createDropDownMenu( side0, "Target: ", {"My buffs", "My Target buffs", "My Coldowns"}, 
    {
        OnClose = function(self, child) 
         
            local lp = self.evt.lparent
    
            if lp.s1_units == nil then 
                lp.curType = "buffs"
                print("equal to nil")
                return 
            end
            lp.curType = self:processChange( child)
            print(lp.curType)
            lp.s1_units:changeType( lp.curType)
        end, 
        lparent = s0
    }, nil)
    --ddm0:SetPoint( "RIGHT", s0_exit, "LEFT", -10 , 0)
    --ddm0:SetPoint( "TOP", s0, "TOP", 0, -20)
    ddm0:SetPoint( "TOPLEFT", side0, "TOPLEFT", 16,-16)
    ddm0:SetWidth(189)
    ddm0:SetBackdrop(GameTooltip:GetBackdrop())
    ddm0:SetBackdropColor( 1, 1 ,1 ,0.7)
    ddm0:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    s0.ddm0 = ddm0
    
    function ddm0:reset_plus()
        self:reset()
        --s0.curType = self:processChange( self.f:getChooseOption())
    end

    function ddm0:processChange( child)
        local res 
        if child == "My buffs" then 
            res = "buffs"
        elseif child == "My Target buffs" then
            res = "buffs"
        elseif child == "My Coldowns" then
            res = "coldowns"
        end
        return res
    end
    function ddm0:load_data( data)
        self.f:chooseOption( data)
    end
    function ddm0:save_data()
        return self.f:getChooseOption()
    end
    function ddm0:save()
        s0.storage.ddm0 = self:save_data()
    end
    function ddm0:load()
        if s0.storage.ddm0 == nil then return end
        self:load_data( s0.storage.ddm0)
    end

    local checkBox = root.ui:createCheckBox( side0, "Select to Edit: ", nil, { height = 30, border = 15, boxSize = 45})
    checkBox:SetPoint( "TOPLEFT", ddm0, "BOTTOMLEFT", 0, -13)
    checkBox:SetBackdrop(GameTooltip:GetBackdrop())
    checkBox:SetBackdropColor( 1, 1 ,1 ,0.7)
    checkBox:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
    s0.checkBox = checkBox

    function checkBox:reset_color()
        checkBox:SetBackdropColor( 1, 1 ,1 ,0.7)
    end
    function checkBox:reset()
        self:setState( 0)
    end
    function checkBox:load_data( data)
        self:setState( data)
    end
    function checkBox:save_data()
        return self:getState()
    end

    function checkBox:load()
        if s0.storage.checkBox == nil then return end
        self:load_data( s0.storage.checkBox )
    end
    function checkBox:save()
        s0.storage.checkBox = self:save_data()
    end
    local sBut = root.ui:createButton( side0, "Save Parcel", {
        click = function( self)
            self.input:showMe()
            print( "clicked")
        end
    }, {height = 30, border = 15, enterColor = {0.8, 0, 0, 0.8}, leaveColor = { 1, 0, 0, 1}})
    sBut:SetPoint( "TOPLEFT", checkBox, "BOTTOMLEFT", 4, -13)
    sBut.s0 = s0

    function sBut:reset()
        self.input:hideMe()
    end


    local sBut_input_panel = CreateFrame( "Frame", nil, UIParent)
    sBut_input_panel:SetAllPoints( UIParent)
    sBut_input_panel:SetScript( "OnMouseDown", function( self, but ) print("panel") self.input:hideMe()  end)
    sBut_input_panel:EnableMouse(false)
    sBut_input_panel:SetFrameStrata( "HIGH")

    local sBut_input  = root.ui:createInput( sBut_input_panel, "Name: ")-- { enterColor = { 1, 0, 0 ,0.7}}
    sBut_input:SetPoint( "TOPLEFT", checkBox, "BOTTOMLEFT", 4, -13)
    sBut_input:SetSize( sBut:GetWidth() + 60, sBut:GetHeight() )

    function sBut_input:process( text)
        print( "processe - ", text)
        
        local aText = string.match( text, "^ *(%w+) *")
        if aText == nil then
            print( "invalid word")
            return false
        end

        if self.lastText ~= aText then
            self.lastText = aText
            print( "text difrente")
            -- todo check if exist in storage
            self:hideMe()
        else
            print( "text equal")

        end
        return true
    end

    sBut_input.input.parent = sBut_input
    sBut_input.input:SetScript( "OnEnterPressed", function(self) print(self:GetText(), "--") self.parent:process( self:GetText()) self.parent:hideMe() print( "end")end)
    --sBut_input.input:SetScript( "OnEditFocusLost", function(self) print(self:GetText(), "--") self:process( self:GetText()) end)
    sBut_input.panel = sBut_input_panel
    sBut_input.but = sBut
    sBut.input = sBut_input
    sBut_input_panel.input = sBut_input    
    function sBut_input:showMe()
        self.input:SetText( "")
        self.panel:EnableMouse( true)
        self.but:Hide()
        self:Show()
        self.input:SetFocus()
    end
    function sBut_input:hideMe()
        self.panel:EnableMouse( false)
        self.but:Show()
        self:Hide()
    end
    --sBut_input:showMe()
    sBut_input:hideMe()

    --[[local msg = self.s0.pFrame.f.logMsg
    print( msg)
    msg:addText( "sfdgdfgdfgfdgdhsfgjh sgfh sdfsd sd fsd f sdfd fgs dsdfag dfg adf gadf gdaf fsdf ")
    msg:setAnchor( self, "BOTTOMRIGHT", self, "TOPLEFT", -10, 10)--]]




    local i0 = root.ui:createInput( s0, "Buff Name")  -------------------------INPUT ABILITY NAME
    i0:SetPoint( "LEFT", s0, "LEFT", 20, 0)
    i0:SetPoint( "TOPRIGHT", side0, "TOPLEFT", -13, -15)
    i0:SetHeight( 35)
    i0.input:SetScript( "OnEnterPressed", function(self) 
        self:ClearFocus()
    end)
    s0.i0 = i0

    function i0:reset()
        self.input:SetText("")
    end

    function i0:load_data( text)
        return self.input:SetText( text)
    end
    function i0:save_data()
        return self.input:GetText()
    end

    function i0:save()
        s0.storage.i0 = self:save_data()
    end
    function i0:load()
        if s0.storage.i0 == nil then return end
        self:load_data( s0.storage.i0)
    end




   

    local s1_ps = CreateFrame( "Button", nil, s0)
    s1_ps.width = 120
    s1_ps.height = 50
    s1_ps:SetWidth( s1_ps.width)
    s1_ps:SetHeight( s1_ps.height)
    s1_ps:SetBackdrop(GameTooltip:GetBackdrop())
    s1_ps:SetBackdropColor( 1, 0.8, 0, 1)
    s1_ps:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)
    s1_ps.img = s1_ps:CreateTexture( nil, "OVERLAY ")
    s1_ps.img:SetPoint( "CENTER", s1_ps, "CENTER")
    s1_ps.img:SetSize( s1_ps.height-13, s1_ps.height-16)
    s1_ps.img:SetTexture( root.paths.images .. "s1_plus_sign.blp")
    s1_ps:SetFrameStrata("HIGH")
    s1_ps:SetScript( "OnClick", function( self, but)
        self.s1_units:createS1Unit()
    end)
    s0.s1_ps = s1_ps

    local s1_units = {
        height = 0,
    }

    s0.s1_units = s1_units
    s1_ps.s1_units = s1_units

    s1_units.holder = root.std:createFrameUnitsManager({
        s0 = s0,
        s1_units = s1_units,
        create = function( self)  
            return root.Interface_panel:createS1Unit( s0, {
                unitClosed = function(unit) s1_units:removeS1Unit( unit) end,
            })
        end,
        enable = function( self, frame) 
            if self.enabled.count == 0 then
                frame:SetPoint( "TOPLEFT", s0.i0, "BOTTOMLEFT", 50, -7)
                frame:SetPoint( "TOPRIGHT", s0.i0, "BOTTOMRIGHT", 0, -7)
            else
                local lFrame = self.enabled.endMod:getData() 
                frame:SetPoint( "TOPLEFT", lFrame, "BOTTOMLEFT", 0, -10)
                frame:SetPoint( "TOPRIGHT", lFrame, "BOTTOMRIGHT", 0, -10)
            end
            frame:reset()
            frame:SetType( s0.curType)

            frame:Show()

            s1_units.height = s1_units.height + frame:GetHeight() + 10
            s0:refreshHeight()
        end,
        disable = function( self, frame) 
            --local sides = self:getSideFrames( frame)
            frame:ClearAllPoints()
            frame:Hide()

            local nf = frame.unitId.next
            if nf ~= nil then
                s1_units:reAnchor( nf:getData(), s0)
            end

            s1_units.height = s1_units.height - frame:GetHeight() - 10
            s0:refreshHeight()
        end
    })

    function s1_units:reAnchor( frame, s0_b)
        local mod = frame.unitId -- from enable frames list
        local prev = mod.prev

        frame:ClearAllPoints()
        if prev == nil then
            frame:SetPoint( "TOPLEFT", s0_b.i0, "BOTTOMLEFT", 50, -7)
            frame:SetPoint( "TOPRIGHT", s0_b.i0, "BOTTOMRIGHT", 0, -7)
        else
            frame:SetPoint( "TOPLEFT", prev:getData(), "BOTTOMLEFT", 0, -10)
            frame:SetPoint( "TOPRIGHT", prev:getData(), "BOTTOMRIGHT", 0, -10)
        end
        prev = mod
        mod = mod.next

        while mod ~= nil do
            local nf = mod:getData()
            local prev_nf = prev:getData()

            nf:ClearAllPoints()
            nf:SetPoint( "TOPLEFT", prev_nf, "BOTTOMLEFT", 0, -10)
            nf:SetPoint( "TOPRIGHT", prev_nf, "BOTTOMRIGHT", 0, -10)

            prev = mod
            mod = mod.next
        end

    end
        
    function s1_units:getHeight()
        return self.height
    end

    function s1_units:getLastFrame()
        local a = self.holder.enabled.endMod
        if a == nil then return nil else return a:getData() end
    end

    function s1_ps:reAnchor()
        self:ClearAllPoints()
        local lFrame = s1_units:getLastFrame()
        if lFrame ~= nil then
            self:SetPoint( "BOTTOMRIGHT", lFrame, "BOTTOMRIGHT", -120, -27)
            --lFrame:SetFrameLevel( lFrame:GetFrameLevel() - 1)
            print("frame level ", lFrame:GetFrameLevel())
            self:SetParent(lFrame)
            --self.SetFrameStrata("HIGH")
        else
            --self:SetFrameLevel(s0:GetFrameLevel() - 1)
            self:SetParent( s0)
            --self.SetFrameStrata("HIGH")
            self:SetPoint( "TOPRIGHT", s0.i0, "BOTTOMRIGHT", -150, -10)
        end

        s1_ps:SetBackdrop(GameTooltip:GetBackdrop())
        s1_ps:SetBackdropColor( 1, 0.8, 0, 1)
        s1_ps:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)
    end

    function s1_units:reset()
        print("c 1")
        self.holder:clear_raw()
        print("c 2")
    end


    function s1_units:createS1Unit()
        local frame = self.holder:createUnit()
        s1_ps:reAnchor()

        --s0:SetHeight(s0_height:GetHeight() + 25)
        return frame
    end
    function s1_units:removeS1Unit( frame)
        self.holder:removeUnit( frame)
        s1_ps:reAnchor()

        --s0:SetHeight(s0_height:GetHeight() + 25)
    end


    function s1_units:load_data( ss1)
        for i, k in ipairs( ss1) do
            local frame = self:createS1Unit()
            if frame:registerStorage() ~= nil then
                frame:load()
            end
        end
    end
    function s1_units:save_data()
        local res = root.std:createStack()

        local mod = self.holder.enabled.startMod
        while mod ~= nil do
            local ss1 = mod:getData()

            res.push( ss1:save())

            mod = mod.next
        end
        
        return res
    end
    function s1_units:load()
        if s0.storage.s1_units == nil then return end
        self:load_data( s0.storage.s1_units)
    end
    function s1_units:save()
        s0.storage.s1_units = self:save_data()
    end

    function s1_units:changeType( type)
        local mod = self.holder.enabled.startMod
        while mod ~= nil do
            local ss1 = mod:getData()

            print( ss1.SetType)
            ss1:SetType( type)

            mod = mod.next
        end
    end

    s1_ps:reAnchor()
    s0:refreshHeight()
    return s0
end
----------------------------------------------------------------------------------------------------------------------------------------################################# FFFFFFFFFFFFFFFFFFF


local f = CreateFrame( "Frame", nil, UIParent)
l.frame = f
f:SetSize( GetScreenWidth() * 0.8, GetScreenHeight() * 0.6)
f:SetPoint("CENTER")
f:SetBackdrop(GameTooltip:GetBackdrop())
f:SetBackdropColor( 1, 1 ,1 ,0.7)
f:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)
f.escape = CreateFrame("Frame")
f.escape:SetScript("OnKeyDown", function(self, arg1, arg2) print(self, arg1, arg2) end)

f.logMsg = root.ui:createMessage( f, {}, { width = 200})


function f:registerStorage( st)
    local res = true
    if st.mainInterface == nil then
        st.mainInterface = {}
        res = false
    end
    self.storage = st.mainInterface

    return res
end

function f:load()    
    self.s0_units:load()
end

function f:save()
    self.s0_units:save()
end


local f_exit = CreateFrame( "Button", nil, f)
f_exit.f = f
f_exit:SetPoint( "TOPRIGHT", f, "TOPRIGHT", -10, -10)
f_exit:SetSize( 30, 30)
f_exit.tex = f_exit:CreateTexture( nil, "BACKGROUND")
f_exit.tex:SetAllPoints(f_exit)
f_exit.tex:SetTexture( root.paths.images .. "exit_cross.blp")
f_exit.ealpha = 0.6 
f_exit.ealpha = 1
f_exit:SetAlpha( f_exit.ealpha)
f_exit:SetScript("OnClick", function( self) self.f:Hide()  end)
f_exit:SetScript( "OnEnter", function( self) self:SetAlpha( f_exit.ealpha)  end)
f_exit:SetScript( "OnLeave", function( self) self:SetAlpha( f_exit.lalpha)  end)
f.f_exit = f_exit


--- edit load save
local topBar = CreateFrame( "Frame", nil, f)
topBar:SetPoint( "TOPLEFT", f, "TOPLEFT", 10, -10)
topBar:SetPoint( "TOPRIGHT", f, "TOPRIGHT", -10, -10)
topBar:SetHeight( 40)
f.topBar = topBar

local set_but = root.ui:createButton( topBar, "    Settings    ", { 
click = function(self) 
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory( root.name)
end
},{ 
    height = topBar:GetHeight(), 
    border = 10 ,
    enterColor = { 0.6, 0.4, 0, 8},
    leaveColor = { 1, 1, 1, 1},
})
set_but:SetPoint( "CENTER", topBar, "CENTER")
set_but:SetPoint( "LEFT", topBar, "LEFT", 30, 0)
set_but:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
f.set_but = set_but

local edit_but = root.ui:createButton( topBar, "    Edit    ", { 
click = function(self) 
    print("edited")
end,
OnEnter = function(self) 
    local mod = self.f.sf.cf.s0_units.units.enabled.startMod
    while mod ~= nil do
        local s0 = mod:getData()
        s0.checkBox:SetBackdropColor( self.style.enterColor[1], self.style.enterColor[2], self.style.enterColor[3], self.style.enterColor[4])
        mod = mod.next
    end
end,
OnLeave = function(self) 
    local mod = self.f.sf.cf.s0_units.units.enabled.startMod
    while mod ~= nil do
        local s0 = mod:getData()
        s0.checkBox:reset_color()
        mod = mod.next
    end
end,
},{ 
    height = topBar:GetHeight(), 
    border = 10 ,
    enterColor = { 0.6, 0.4, 0, 0.8},
    leaveColor = { 1, 0.7, 0, 1},
})
edit_but:SetPoint( "CENTER", topBar, "CENTER")
edit_but:SetPoint( "RIGHT", topBar, "RIGHT", -170, 0)
edit_but:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
edit_but.f = f
f.edit_but = edit_but

local load_build = root.ui:createButton( topBar, "  Load Build  ", { 
click = function(self) 
    self.f.builds_w:showMe()
    
end,

},{ 
    height = topBar:GetHeight(), 
    border = 10 ,
    enterColor = { 1, 0.2, 0, 0.8},
    leaveColor = { 1, 0, 0, 1},
})
load_build:SetPoint( "CENTER", set_but, "CENTER")
load_build:SetPoint( "LEFT", set_but, "RIGHT", 20, 0)
load_build:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
load_build.f = f
f.load_build = load_build

local builds_w = root.ui:createScrollFrame( topBar, {

    OnClick = function(self, but)
        but.data.func( but.data) 
        self:hideMe()
    end
}, {})
builds_w:SetPoint( "TOPLEFT", load_build, "BOTTOMLEFT", 0, -5)
builds_w:SetFrameStrata("HIGH")
f.builds_w = builds_w

builds_w:load_many({
    {label = "asda", coco = "coconut", func = function( self) print( self.coco) end }, 
    {label = "hihi", coco = "hihicoco", func = function() print( "coco") end },
})


builds_w:hideMe()

--[[function builds_w:save_data()
    local res = root.std:createStack()

    for i=1,self.options.maxSize do 
        res.push( self.options.arr[i])
    end
    return res
end
function builds_w:load_data( stack)
    for i=1,(stack.count -1) do
        self:createOption( stack.arr[i])
    end
end
function builds_w:save()
    f.storage.builds_w = self:save_data()
end
function builds_w:load()
    self:load_data( f.storage.builds_w)
end--]]

local save_build = root.ui:createButInput( topBar, { 
    button_label =  "Save Build",
    button_enterColor = { 1, 0.2 ,0.2 ,0.7},
    button_leaveColor = { 0.9, 0.5, 0 ,0.8},
}, { 
    OnSubmit = function(self, text) print("sub ", text) end
})
save_build:SetSize( 120, topBar:GetHeight() + 10)
save_build:SetPoint( "CENTER", load_build, "CENTER")
save_build:SetPoint( "LEFT", load_build, "RIGHT", 20, 0)
print("save build end")

--------------------------------------------------------------------------

--[[local load_parcel = root.ui:createButton( topBar, "  Load Parcel  ", { 
click = function(self) 
    self.f.parcels_w:showMe()
    
end,

},{ 
    height = topBar:GetHeight(), 
    border = 10 ,
    enterColor = { 1, 0.2, 0, 0.8},
    leaveColor = { 1, 0, 0, 1},
})
load_parcel:SetPoint( "CENTER", load_build, "CENTER")
load_parcel:SetPoint( "LEFT", load_build, "RIGHT", 20, 0)
load_parcel:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)
load_parcel.f = f
f.load_parcel = load_parcel

local parcels_w = root.ui:createScrollFrame( topBar, {

    OnClick = function(self, but)
        print( "clicked on: ", but.text:GetText()) 
         self:hideMe()
    end
}, {})
parcels_w:SetPoint( "TOPLEFT", load_parcel, "BOTTOMLEFT", 0, -5)
parcels_w:SetFrameStrata("HIGH")
f.parcels_w = parcels_w

parcels_w:load_many({
    "asda","asdas"
})
parcels_w:hideMe()


function parcels_w:save_data()
    local res = root.std:createStack()

    for i=1,self.options.maxSize do 
        res.push( self.options.arr[i])
    end
    return res
end
function parcels_w:load_data( stack)
    for i=1,(stack.count -1) do
        self:createOption( stack.arr[i])
    end
end
function parcels_w:save()
    f.storage.parcels_w = self:save_data()
end
function parcels_w:load()
    self:load_data( f.storage.parcels_w)
end--]]
--[[
--]]
----------------------------------------------------------------------------------------------------------------------------------------#################################

local sf = CreateFrame("ScrollFrame", "$parent_ScrollFrame", f, "UIPanelScrollFrameTemplate")
--sf:SetAllPoints(f)
sf:SetPoint( "TOPLEFT", topBar, "BOTTOMLEFT")
sf:SetPoint( "LEFT", f, "LEFT")
sf:SetPoint( "BOTTOm", f, "BOTTOM", 0, 10)
f.sf = sf
--sf:SetPoint( "BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 10)
--sf:SetSize( f:GetWidth() , )
--sf:SetClipsChildren(true)
f.scrollbar = _G[sf:GetName() .. "ScrollBar"];
f.scrollbar:ClearAllPoints()
f.scrollbar:SetPoint("TOPRIGHT", sf, "TOPRIGHT", -6 , -23)
f.scrollbar:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", -6, 23)




local cf = CreateFrame( "Frame", "$parent_ScrollChild", sf)
cf:SetWidth( sf:GetWidth() - f.scrollbar:GetWidth() -7- 2)
cf:SetPoint( "TOPLEFT", sf, "TOPLEFT")
cf.f = f

sf:SetScrollChild(cf)
sf.cf = cf

--[[cf:SetBackdrop(GameTooltip:GetBackdrop())
cf:SetBackdropColor( 0, 1 ,0 ,0.7)
cf:SetBackdropBorderColor( 0.6, 0.6, 0.6, 0)--]]

function cf:refreshHeight()
    --[[local size = { 
        self.s0_units:getHeight() + 0,
        0
    }
    table.sort( size)--]]
    self:SetHeight( self.s0_units:getHeight() + 10)
end


local s0_ps = CreateFrame( "Button", nil, cf)
s0_ps.width = 120
s0_ps.height = 50
s0_ps:SetWidth( s0_ps.width)
s0_ps:SetHeight( s0_ps.height)
s0_ps:SetBackdrop(GameTooltip:GetBackdrop())
s0_ps:SetBackdropColor( 0.2, 1, 0, 1)
s0_ps:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)
s0_ps.img = s0_ps:CreateTexture( nil, "OVERLAY ")
s0_ps.img:SetPoint( "CENTER", s0_ps, "CENTER")
s0_ps.img:SetSize( s0_ps.height-13, s0_ps.height-16)
s0_ps.img:SetTexture( root.paths.images .. "s1_plus_sign.blp")
s0_ps:SetScript( "OnClick", function( self, but)
    self.s0_units:createS0Unit()
end)
cf.s0_ps = s0_ps

local s0_units = {
    height = 0,
}
cf.s0_units = s0_units
s0_ps.s0_units = s0_units

s0_units.units = root.std:createFrameUnitsManager({
    s0_units = s0_units,
    cf = cf,
    create = function( self)  
        print("created")
        return root.Interface_panel:createS0Unit( cf, {
            unitClosed = function(unit)print("close1") s0_units:removeS0Unit( unit) print( "close2")end,
        })
    end,
    enable = function( self, frame) 
        print("enabled")

        if self.enabled.count == 0 then
            frame:SetPoint( "TOPLEFT", cf, "TOPLEFT", 0, -7)
            frame:SetPoint( "TOPRIGHT", cf, "TOPRIGHT", 0, -7)
        else
            local lFrame = self.enabled.endMod:getData() 
            frame:SetPoint( "TOPLEFT", lFrame, "BOTTOMLEFT", 0, -10)
            frame:SetPoint( "TOPRIGHT", lFrame, "BOTTOMRIGHT", 0, -10)
        end
        frame:reset()
        frame:Show()
        print("enabled h1")
        s0_units.height = s0_units.height + frame:GetHeight() + 10
        print("enabled h2")
        cf:refreshHeight()
        print("enabled end")
    end,
    disable = function( self, frame) 
        --local sides = self:getSideFrames( frame)
        frame:ClearAllPoints()
        frame:Hide()

        local nf = frame.unitId.next
        if nf ~= nil then
            s0_units:reAnchor( nf:getData(), cf)
        end

        s0_units.height = s0_units.height - frame:GetHeight() - 10
        cf:refreshHeight()
    end
}) 
function s0_units:getHeight()
    print( "get height s0:units", self.height)
    return self.height
end
function s0_units:reAnchor( frame, cf_b)
    local mod = frame.unitId -- from enable frames list
    local prev = mod.prev

    frame:ClearAllPoints()
    if prev == nil then
        frame:SetPoint( "TOPLEFT", cf_b, "TOPLEFT", 0, -7)
        frame:SetPoint( "TOPRIGHT", cf_b, "TOPRIGHT", 0, -7)
    else
        frame:SetPoint( "TOPLEFT", prev:getData(), "BOTTOMLEFT", 0, -10)
        frame:SetPoint( "TOPRIGHT", prev:getData(), "BOTTOMRIGHT", 0, -10)
    end
    prev = mod
    mod = mod.next

    while mod ~= nil do
        local nf = mod:getData()
        local prev_nf = prev:getData()

        nf:ClearAllPoints()
        nf:SetPoint( "TOPLEFT", prev_nf, "BOTTOMLEFT", 0, -10)
        nf:SetPoint( "TOPRIGHT", prev_nf, "BOTTOMRIGHT", 0, -10)

        prev = mod
        mod = mod.next
    end

end

function s0_units:getLastFrame()
    local a = self.units.enabled.endMod
    if a == nil then return nil else return a:getData() end
end

function s0_ps:reAnchor()
    self:ClearAllPoints()

    local lFrame = s0_units:getLastFrame()
    if lFrame ~= nil then
        self:SetPoint( "BOTTOMLEFT", lFrame, "BOTTOMLEFT", 120, -27)
        --lFrame:SetFrameLevel( lFrame:GetFrameLevel() - 1)
        self:SetParent(lFrame)
    else
        self:SetParent( cf)
        self:SetFrameLevel( cf:GetFrameLevel() + 1)
        self:SetPoint( "TOPLEFT", cf, "TOPLEFT", 210, -30)
    end
    --[[s0_ps:SetBackdrop(GameTooltip:GetBackdrop())
    s0_ps:SetBackdropColor( 1, 0.8, 0, 1)
    s0_ps:SetBackdropBorderColor( 0.6, 0.6, 0.6, 1)--]]
end

function s0_units:createS0Unit()
    local frame = self.units:createUnit()
    s0_ps:reAnchor()
    return frame 
end

function s0_units:removeS0Unit( frame)
    print("1")
    self.units:removeUnit( frame)
    print("2")
    s0_ps:reAnchor()
    print("3")
end


function s0_units:registerStorage( storage)
    self.storage = storage
end

function s0_units:save_data()
    local res = root.std:createStack()

    local mod = self.units.enabled.startMod
    while mod ~= nil do
        local ss0 = mod:getData()

        res.push( ss0.save())

        mod = mod.next
    end

    return res
end
function s0_units:load_data( ss0)

    for i, k in ipairs( ss0) do 
        local frame = self.createS0Unit()
        if frame:registerStorage( k) then
            frame:load()
        end
    end
end
function s0_units:save()
    f.storage.s0_units = self:save_data()
end

function s0_units:load()
    self:load_data( f.storage.s0_units)
end



s0_ps:reAnchor()
cf:refreshHeight()
s0_units:createS0Unit()

local interface = CreateFrame( "Frame")
interface.name = root.name
InterfaceOptions_AddCategory(interface)
local b = root.ui:createButton( interface, "Menu", { 
    click = function( self) 
        InterfaceOptionsFrame_Show()
        self.f:Show() 
    end
}, { height= 15, border= 20, leaveColor = {1, 0.1, 0.1, 1}, enterColor = {0.6, 0.1, 0.1, 1} })
b.f = f
b:SetAlpha( 1)
b:SetPoint( "TOPLEFT", interface, "TOPLEFT", 100, -100)

--[[
local s0 = l:createS0Unit( cf)
s0:SetPoint("TOPLEFT", cf, "TOPLEFT")
s0:SetPoint("TOPRIGHT", cf, "TOPRIGHT")
--]]

l.baseFrame = f
l.scrollframe = sf
l.scrollChildFrame = cf


