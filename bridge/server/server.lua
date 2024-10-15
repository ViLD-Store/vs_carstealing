Core = {
    Debug = function(o)
        if type(o) == 'table' then
            local s = '{ '
            for k,v in pairs(o) do
               if type(k) ~= 'number' then k = '"'..k..'"' end
               s = s .. '['..k..'] = ' .. Core.Debug(v) .. ','
            end
            return s .. '} '
         else
            return tostring(o)
         end
    end,
    ReplaceString = function(main_text, replace, replaceto)
        return string.gsub(main_text, replace, replaceto)
    end,
    Notification = function(source, message, type)
        if not type then type = 'success' end 
        TriggerClientEvent('custom_notification', source, message, type)
    end
}

function GetLib()
	return Core
end