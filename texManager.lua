local root = uiHelper
local l = root:propagate( root, "texManager")



function l:init()
    self.holder = {}
    self.size = 0
end

function l:add( name, tex)
    self.holder[ name] = tex
    self.size = self.size + 1 
end

function l:addDefaultColors( )
    local tex = CreateTexture( nil, "BACKGROUND")
    tex:SetBackdropColor(1, 0, 0)
    self:add( "red", tex)

    local tex = CreateTexture( nil, "BACKGROUND")
    tex:SetBackdropColor(0, 1, 0)
    self:add( "green", tex)

    local tex = CreateTexture( nil, "BACKGROUND")
    tex:SetBackdropColor(0, 0, 1)
    self:add( "green", tex)
end

function l:addColor( name, r, g, b, a)
    local tex = CreateTexture( nil, "BACKGROUND")
    tex:SetBackdropColor( r, g, b)
    self:add( name, tex)
end



function l:get( path)
    local tex =  self.holder[ path]

    if tex == nil then
        tex = CreateTexture( nil, "BACKGROUND")
        tex:SetTexture( path)
        self:add( path, tex)
    end

    return tex;
end


l:init()
l:addDefaultColors()

