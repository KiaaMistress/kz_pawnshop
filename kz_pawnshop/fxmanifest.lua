fx_version 'cerulean'
game 'gta5'

author 'KiaaMistress'
description 'KZ Pawnshop for QBCore'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@qb-core/import.lua'
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'ox_inventory',
    'qb-core',
    'qb-target',
}

