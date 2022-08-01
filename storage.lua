local root = uiHelper
local l = root:propagate( root, "storage")


local storage = CreateFrame("Frame"); -- Need a frame to respond to events
storage:RegisterEvent("ADDON_LOADED")

storage:SetScript("OnEvent", function( self, event, arg1) 
    if arg1 == root.name then
        print(event, arg1)

        if UiHelpers_saved == nil then 
            UiHelpers_saved = root:createStorage()
        else
            if root:registerStorage( UiHelpers_saved) then
                root:load(UiHelpers_saved)
            end
        end
    end
end)

