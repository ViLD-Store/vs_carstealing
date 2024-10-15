fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Vild Store'
description 'Car Robbery'
version '0.0.5'

shared_script 'config.lua'

client_scripts {
    'bridge/client/*.lua',
    'bridge/client/libs/*.lua',
    'client/*.lua'
}

server_scripts {
    'bridge/server/*.lua',
    'bridge/server/libs/*.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/js/*.js',
}

escrow_ignore {
    'config.lua'
}
