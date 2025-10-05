local QBCore = exports['qb-core']:GetCoreObject()

-- Exploit detection (distance check)
local function exploitBan(src, reason)
    DropPlayer(src, 'Exploiting pawnshop detected: ' .. reason)
end

-- Sell pawn items
RegisterNetEvent('pawnshop:server:sellPawnItems', function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Distance check
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local inZone = false
    for _, v in pairs(Config.PawnLocation) do
        if #(playerCoords - v.coords) < 5.0 then
            inZone = true
            break
        end
    end
    if not inZone then
        exploitBan(src, 'Selling pawn items outside of zone')
        return
    end

    -- Attempt to remove item
    if exports.ox_inventory:RemoveItem(src, itemName, tonumber(itemAmount)) then
        -- Give money
        local totalPrice = tonumber(itemAmount) * tonumber(itemPrice)
        if Config.BankMoney then
            Player.Functions.AddMoney('bank', totalPrice, 'pawnshop-sell')
        else
            Player.Functions.AddMoney('cash', totalPrice, 'pawnshop-sell')
        end

        -- Trigger client success event only (client handles notification)
        TriggerClientEvent('pawnshop:client:sellSuccess', src, itemName, itemAmount, itemPrice)
    else
        -- Error notification if item removal fails
        local description = "You don't have that item."
        if Config.NotifySystem == 'lation_ui' then
            TriggerClientEvent('lation_ui:notify', src, {
                title = 'Pawn Shop',
                message = description,
                type = 'error',
                position = 'top-right'
            })
        else
            -- 'lib' or 'ox_lib'
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Pawn Shop',
                description = description,
                type = 'error'
            })
        end
    end
end)

-- Callback to get player inventory for menu
lib.callback.register('pawnshop:server:getInventory', function(source)
    local items = exports.ox_inventory:GetInventoryItems(source)
    return items
end)








