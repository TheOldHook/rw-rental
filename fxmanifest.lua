fx_version 'cerulean'
game 'gta5'

description 'RW-Rental'
version '1.0.0'
lua54 'yes'


client_script {
    'client/client.lua',
}

server_script {
    'server/server.lua'
}


shared_script 'config.lua'
ui_page 'html/index.html'


files {
    'html/index.html',
    'html/styles.css',
    'html/ui.js',
    'html/reset.css',
    'html/img/*.jpg',
}