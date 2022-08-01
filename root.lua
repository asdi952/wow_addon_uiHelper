
print( "root started")

uiHelper = {}

local l = uiHelper

l.name = "UiHelpers"
l.parent = nil
l.extension = {}
l.size_ext = 0
l.dev = true
l.paths = {
    images = "Interface\\AddOns\\UiHelpers\\image\\"
}

function l:add_ext( name, obj)
    self.extension[ name] = obj
    self.size_ext = self.size_ext + 1
end

function l:buildName( obj)
    local res = ""

    while obj ~= nil do
        res = obj.name .. "/ "..res
        obj = obj.parent
    end
    return res
end

function l:get_ext( name)
    return self.extension[ name]
end

function l:propagate( parent, name)

    if self.extension[ name] ~= nil then
        print(  ext_name .. " already was load, duplicated names")
        return nil;
    end
    
    local m = {}
    m.parent = parent
    m.name = name

    self:add_ext( name, m)
    parent[ name] = m

    if self.dev == true then
        print( "Loadded - " .. self:buildName( m))
    end

    return m
end

function l:load( )
    if self.Interface_panel.frame:registerStorage( self.storage) then
        self.Interface_panel.frame:load()
    end
    if self.defaultBuilds:registerStorage( self.storage) then
        self.Interface_panel:load()
    end
end

function l:createStorage( )
    local st = {}
    return st
end

function l:registerStorage( st)
    local res = true

    if st.root == nil then
        st.root = {}
        res = false
    end
    self.storage = st.root

    return res
end



