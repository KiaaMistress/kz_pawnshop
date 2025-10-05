Config = {}

Config.NotifySystem = 'ox_lib'  -- Change this to 'ox_lib' or 'lation_ui' as needed

-- Pawn Shop locations
Config.PawnLocation = {
    [1] = {
        coords = vec3(-779.6689, -611.1604, 30.2791),
        length = 1.5,
        width = 1.8,
        heading = 275.9,
        debugPoly = false,
        -- Optional overrides:
        -- minZ = 29.0,
        -- maxZ = 32.0,
        -- distance = 2.0
    }
}

-- Money handling
Config.BankMoney = false -- true = deposit into bank, false = cash

-- Opening hours
Config.UseTimes = false  -- false = open 24/7
Config.TimeOpen = 7
Config.TimeClosed = 17

-- qb-target usage
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

-- Items that can be pawned
Config.PawnItems = {
    { item = 'goldchain',        label = 'Golden Chain',     price = math.random(50,100) },
    { item = 'diamond_ring',     label = 'Diamond Ring',     price = math.random(50,100) },
    { item = 'rolex',            label = 'Golden Watch',     price = math.random(50,100) },
    { item = '10kgoldchain',     label = '10k Gold Chain',   price = math.random(50,100) },
    { item = 'tablet',           label = 'Tablet',           price = math.random(50,100) },
    -- { item = 'iphone',           label = 'iPhone',           price = math.random(50,100) },
    -- { item = 'samsungphone',     label = 'Samsung',          price = math.random(50,100) },
    -- { item = 'laptop',           label = 'Laptop',           price = math.random(50,100) },
    -- { item = 'fitbit',           label = 'Fitbit',           price = math.random(50,100) },
}


