fx_version 'cerulean'
game 'gta5'

author 'KiaaMistress'
description 'Pawn Shop Script'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@lation_ui/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- keep only if your qb-core uses it
    'server/server.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'qb-core'
}
