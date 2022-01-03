fx_version 'adamant'

game 'gta5'


ui_page 'nui/nui.html'

files {
    'nui/*.css',
    'nui/nui.html',
    'nui/app.js',
    'nui/loader.js',

    'nui/lib/*.js',

    'sounds/**/*.ogg',
    'video/*.webm',
}


shared_scripts {
    "config/*.lua",
}

client_scripts {
    "client/module/handler/module_handler.lua",
	"client/module/modules/*.lua",
    "client/module/module/ui_native_pages/*.lua",
}

server_scripts {
    "server/modules/*.lua",
}

dependency 'vein'