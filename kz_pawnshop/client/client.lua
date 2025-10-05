local QBCore = exports['qb-core']:GetCoreObject()

-- Configurable notification system: 'lib', 'ox_lib', 'lation_ui'
Config.NotifySystem = Config.NotifySystem or 'lib'

-- Helper function for notifications
local function Notify(title, description, type)
    if Config.NotifySystem == 'lation_ui' then
        exports.lation_ui:notify({
            title = title,
            message = description,
            type = type or 'info',
            position = 'top-right'
        })
    else
        -- For 'lib' or 'ox_lib', both use lib.notify
        lib.notify({
            title = title,
            description = description,
            type = type or 'inform'
        })
    end
end

-- Create pawnshop target zones
CreateThread(function()
    for key, value in pairs(Config.PawnLocation) do
        local minZ = value.minZ or (value.coords.z - 1.0)
        local maxZ = value.maxZ or (value.coords.z + 2.0)

        exports['qb-target']:AddBoxZone(
            'PawnShop'..key,
            value.coords,
            value.length,
            value.width,
            {
                name = 'PawnShop'..key,
                heading = value.heading,
                debugPoly = value.debugPoly,
                minZ = minZ,
                maxZ = maxZ
            },
            {
                options = {
                    {
                        type = 'client',
                        event = 'pawnshop:client:openMenu',
                        icon = 'fa-solid fa-coins',
                        label = 'Open Pawn Shop'
                    }
                },
                distance = value.distance or 2.5
            }
        )
    end
end)

-- Main pawnshop menu
RegisterNetEvent('pawnshop:client:openMenu', function()
    if Config.UseTimes then
        local hour = GetClockHours()
        if hour < Config.TimeOpen or hour > Config.TimeClosed then
            Notify('Pawn Shop', ('We are closed. Open %s:00 to %s:00'):format(Config.TimeOpen, Config.TimeClosed), 'error')
            return
        end
    end

    local menu = {
        { title = 'Pawn Shop', icon = 'store', disabled = true },
        {
            title = 'Sell Items',
            description = 'View pawnable items',
            icon = 'coins',
            event = 'pawnshop:client:openSellMenu'
        },
        {
            title = 'Close',
            icon = 'xmark',
            event = 'pawnshop:client:closeMenu'
        }
    }

    lib.registerContext({
        id = 'pawnshop_main',
        title = 'Pawn Shop',
        options = menu
    })

    lib.showContext('pawnshop_main')
end)

-- Close menu handler
RegisterNetEvent('pawnshop:client:closeMenu', function()
    lib.hideContext()
end)

-- Open Sell Menu
RegisterNetEvent('pawnshop:client:openSellMenu', function()
    lib.callback('pawnshop:server:getInventory', false, function(inv)
        local options = {
            { title = 'Sellable Items', icon = 'list', disabled = true }
        }

        for _, v in pairs(Config.PawnItems) do
            local amount = 0
            for _, item in pairs(inv) do
                if item.name == v.item then
                    amount = item.count
                    break
                end
            end

            local label = v.label or (QBCore.Shared.Items[v.item] and QBCore.Shared.Items[v.item].label) or v.item

            if amount > 0 then
                options[#options+1] = {
                    title = label,
                    description = ('Sell for $%s each (You have %s)'):format(v.price, amount),
                    icon = 'gem',
                    event = 'pawnshop:client:sellItem',
                    args = { name = v.item, label = label, price = v.price, amount = amount }
                }
            else
                options[#options+1] = {
                    title = label,
                    description = ('Sell for $%s each - You don\'t have any'):format(v.price),
                    icon = 'ban',
                    disabled = true
                }
            end
        end

        options[#options+1] = {
            title = '⬅ Back',
            icon = 'arrow-left',
            event = 'pawnshop:client:openMenu'
        }

        lib.registerContext({
            id = 'pawnshop_sellmenu',
            title = 'Pawn Shop',
            options = options
        })
        lib.showContext('pawnshop_sellmenu')
    end)
end)

-- Sell item input
RegisterNetEvent('pawnshop:client:sellItem', function(data)
    local input = lib.inputDialog('Sell ' .. data.label, {
        { type = 'number', label = ('Amount (max %s)'):format(data.amount), min = 1, max = data.amount, default = 1 }
    })

    if not input or not input[1] then return end

    local amount = tonumber(input[1])
    if amount and amount > 0 and amount <= data.amount then
        TriggerServerEvent('pawnshop:server:sellPawnItems', data.name, amount, data.price)
    else
        Notify('Pawn Shop', 'Invalid amount.', 'error')
    end
end)

-- Success notification after selling items
RegisterNetEvent('pawnshop:client:sellSuccess', function(itemName, amount, price)
    -- Lookup the label in QBCore or Config
    local label = nil
    if QBCore.Shared.Items[itemName] then
        label = QBCore.Shared.Items[itemName].label
    else
        for _, v in pairs(Config.PawnItems) do
            if v.item == itemName then
                label = v.label
                break
            end
        end
    end
    label = label or itemName

    local total = amount * price
    Notify('Pawn Shop', ('You sold %sx %s for $%s'):format(amount, label, total), 'success')

    -- Close sell menu automatically
    lib.hideContext()
end)









