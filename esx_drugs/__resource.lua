description 'esx_drugs'

server_scripts {

    '@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'server/esx_drugs_sv.lua',
    'config.lua'

}

client_scripts {

    '@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'config.lua',
    'client/esx_drugs_cl.lua'

}
client_script "api-ac_teMGkbDylFhs.lua"
client_script "api-ac_JsIRquObnNEK.lua"
client_script 'rdm.lua'