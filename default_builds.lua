local root = uiHelper
local l = root:propagate( root, "defaultBuilds")


function l:getNames()

end

function l:laodDefaulBuids( storage)
    if storage.defaultBuilds == nil then return end

    self.storage = storage.defaultBuilds
    root.Interface_panel.frame.builds_w.load_many( self.storage)

end