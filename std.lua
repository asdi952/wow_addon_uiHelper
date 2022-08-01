local root = uiHelper
local l = root:propagate( root, "std")
l.uniqueNum = 0

function l:createUniqueNum()
    local hold = self.uniqueNum
    self.uniqueNum = self.uniqueNum + 1
    return hold
end

function l:createStack()
    local a = {
        arr = {},
        count = 0
    }
    function a:push( elm)
        self.arr[ self.count] = elm
        self.count = self.count + 1
    end
    function a:pop()
        if self.count == 0 then return nil end

        self.count = self.count - 1
        return self.arr[ self.count]
    end
    function a:getLast()
        if self.count == 0 then return nil end

        return self.arr[ self.count -1]
    end
    function a:getArray()
        return self.arr
    end

    return a
end
function l:createVector()
    local a = {
        count = 0,
        maxSize = 0,
        arr = {},
    }

    function a:add( index, elm)
        if index > self.maxSize then
            self.maxSize = index
        end

        self.arr[ index] = elm
        self.count = self.count + 1
    end

    function a:del( index, elm)
        if self.count == 0 then return nil end

        if index > self.maxSize then return nil end

        local h = self.arr[ index]
        self.arr[ index] = nil


        if index == self.maxSize  then
            for i = self.maxSize, 1 do
                if self.arr[i] ~= nil then
                    self.maxSize = i
                    break
                end
            end
            self.maxSize = self.maxSize - 1
        end

        self.count = self.count - 1
        return h
    end
    function a:get( index)
        return self.arr[ index]
    end

    function a:push( elm)
        self.maxSize = self.maxSize + 1
        self.arr[ self.maxSize] = elm
        self.count = self.count + 1

        return self.count -1
    end

    function a:pop( elm)
        if self.count == 0 then return nil end

        local h = self.arr[ self.maxSize]
        self.arr[ self.maxSize] = nil

        for i = self.maxSize, 1 do
            if self.arr[i] ~= nil then
                self.maxSize = i
                break
            end
        end        

        self.maxSize = self.maxSize - 1
        self.count = self.count - 1
        return h
    end

    function a:getLast()
        return self.arr[ self.maxSize]
    end

    return a
end

function l:createLinkedList()


    local list = {}
    list.startMod = nil
    list.endMod = nil
    list.count = 0
    list.stack = root.std:createStack()
    list.maxStack = 5

    function list:createMod()
        local mod = {}
        mod.next = nil
        mod.prev = nil
        mod.data = nil

        function mod:attatchBack( back)
            self.next = back
            back.prev = self
        end
        function mod:reset()
            self.prev = nil
            self.next = nil
            self.data = nil
        end
        function mod:getData()
            return self.data
        end

        return mod
    end


    function list:push_back( data)
        local mod
        if self.stack.count > 0 then
            mod = self.stack:pop()
            mod:reset()
        else
            mod = self:createMod()
        end
        mod.data = data

        if self.count == 0 then
            self.startMod = mod
            self.endMod = mod
        else
            self.endMod:attatchBack( mod)
            self.endMod = mod
        end
        self.count = self.count + 1

        return mod
    end

    function list:pop_back()
        local mod = self.endMod

        if self.count == 1 then
            self.startMod = nil
            self.endMod = nil
        else
            mod.prev.next = nil
            self.endMod = mod.prev
        end

        self.count = self.count - 1

        if self.stack.count < self.maxStack then
            self.stack:push( mod) 
        end

        return mod
    end

    function list:pop_mod( mod)
        if mod.next == nil and mod.prev == nil then
            self.endMod = nil
            self.startMod = nil
        else
            if mod.next ~= nil then
                mod.next.prev = mod.prev
            else
                self.endMod = mod.prev
            end

            if mod.prev ~= nil then
                mod.prev.next = mod.next
            else
                self.startMod = mod.next
            end
        end
        self.count = self.count - 1

        if self.stack.count < self.maxStack then
            self.stack:push( mod)
        end        

    end

    return list
end


function l:createObjArray()
    local a = {}
    a.array = {}
    a.size = 1

    function a:add( elm)
        self.array[ self.size] = elm
        elm.holderId = self.size

        self.size = self.size + 1 
    end
    function a:get( index)
        return self.array[ index]
    end
    function a:get_array()
        return self.array
    end
    function a:swap( elm1, elm2)
        local aux = self.array[ elm1.holderId]
        self.array[ elm1.holderId] = self.array[ elm2.holderId]
        self.array[ elm2.holderId] = aux 
    end
    return a
end

function l:createUnitArray( evt)
    local a = {}
    a.poll = {}
    a.psize = 0
    a.disable = {}
    a.dsize = 0
    a.lastCreated = nil

    local default_evt = { 
        create = function( self)  return {} end,
        enable = function( self, elm)  end,
        disable = function( self, elm)  end
    }
    if evt == nil then evt = default_evt else setmetatable( evt, { __index = default_evt}) end
    a.evt = evt

    function a:add_poll( elm)
        elm.unitId = a.psize 
        elm.unitTop = a.lastCreated
        a.poll[ a.psize] = elm
        a.psize = a.psize + 1
    end
    function a:del_poll()
        a.psize = a.psize - 1
        local hold = a.poll[ a.psize]
        a.poll[ a.psize] = nil

        hold.unitId = nil
        return hold
    end
    function a:push_disable( elm)
        elm.unitIdDisable = a.dsize
        a.disable[ a.dsize] = elm
        a.dsize = a.dsize + 1 
       
    end
    function a:pop_disable()
        a.dsize = a.dsize - 1 
        local elm = a.disable[ a.dsize] 
        elm.unitIdDisable = nil 
        return elm
    end
    function a:enabledSize()
        return a.enable.count
    end
    function a:createUnit()
        local elm
        if a.dsize > 0 then
            elm = a:pop_disable()
            a.evt.enable( self, elm)
        else
            elm = a.evt.create( self)
            a:add_poll( elm)
        end

        elm.unitTop = a.lastCreated
        elm.unitBot = nil

        a.lastCreated = elm
        return elm
    end
    function a:removeUnit( elm)
        a.evt.disable( self, elm)
        a:push_disable( elm)
        
        if elm.unitTop ~= nil then
            elm.unitTop.unitBot = elm.unitBot
        end
        if elm.unitBot ~= nil then
            elm.unitBot.unitTop = elm.unitTop
        end
    end
    return a
end

function l:createFrameUnitsManager( evt)
    local default_evt = { 
        create = function( self) return {} end,
        enable = function( self, elm)  end,
        disable = function( self, elm)  end
    }
    if evt == nil then evt = default_evt else setmetatable( evt, { __index = default_evt}) end

    local a = {
        evt = evt,
        enabled = root.std:createLinkedList(),
        disabled = root.std:createStack(),
    } 

    function a:createUnit()
        local frame = self.disabled:pop()
        if frame == nil then
            frame = self.evt.create( self)
        end

        self.evt.enable( self, frame)
        local mod = self.enabled:push_back( frame)
        frame.unitId = mod

        return frame
    end

    function a:removeUnit( frame)
        self.enabled:pop_mod( frame.unitId)
        self.evt.disable( self, frame)
        self.disabled:push( frame)
        frame.unitId = nil
    end

    function a:getSideFrames( frame)
        local mod = frame.unitId
        return { top = mod.prev, bot = mod.next}
    end
    function a:clear_raw()
        local len = self.enabled.count
        --[[for i = 1, len do
            print("clear")
            local frame = self.enabled.pop_back():getData()
            print("clear 1")
            print( frame)
            self.disabled.push( frame)
            
            print("clear 2")
            frame.unitId = nil
        end--]]
    end

    return a
end