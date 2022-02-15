ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(5000, CountCops)

end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsCoke)
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarveztCoke')
AddEventHandler('esx_drugs:startHarveztCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

RegisterServerEvent('esx_drugs:stupHarvestCoke')
AddEventHandler('esx_drugs:stupHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsCoke)
		return
	end

	SetTimeout(10000, function()

		if PlayersTransformingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 100 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif cokeQuantity < 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 5)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransfornCoke')
AddEventHandler('esx_drugs:startTransfornCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransfornCoke')
AddEventHandler('esx_drugs:stopTransfornCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

local function SellCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsCoke)
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)
				if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 198)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 258)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 308)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 358)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 396)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                elseif CopsConnected >= 5 then
                    xPlayer.addAccountMoney('black_money', 428)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
                end
				
				SellCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSollCoke')
AddEventHandler('esx_drugs:startSollCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopSmollCoke')
AddEventHandler('esx_drugs:stopSmollCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = false

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsMeth)
		return
	end
	
	SetTimeout(5000, function()

		if PlayersHarvestingMeth[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestMet')
AddEventHandler('esx_drugs:startHarvestMet', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

RegisterServerEvent('esx_drugs:stupHarvestMeth')
AddEventHandler('esx_drugs:stupHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsMeth)
		return
	end

	SetTimeout(12000, function()

		if PlayersTransformingMeth[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 100 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif methQuantity < 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 4)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransfurmMeth')
AddEventHandler('esx_drugs:startTransfurmMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformNeth')
AddEventHandler('esx_drugs:stopTransformNeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

local function SellMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsMeth)
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingMeth[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('meth_pooch', 1)
				if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 276)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 374)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 474)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 552)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 616)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected == 5 then
                    xPlayer.addAccountMoney('black_money', 654)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                elseif CopsConnected >= 6 then
                    xPlayer.addAccountMoney('black_money', 686)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
                end
				
				SellMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSoollMeth')
AddEventHandler('esx_drugs:startSoollMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellMeth(_source)

end)

RegisterServerEvent('esx_drugs:stapSellMeth')
AddEventHandler('esx_drugs:stapSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = false

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsWeed)
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingWeed[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:stcsartHarvestWeed')
AddEventHandler('esx_drugs:stcsartHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvesdtWeed')
AddEventHandler('esx_drugs:stopHarvesdtWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsWeed)
		return
	end

	SetTimeout(7500, function()

		if PlayersTransformingWeed[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 100 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 10)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransfodfrmWeed')
AddEventHandler('esx_drugs:startTransfodfrmWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformWeded')
AddEventHandler('esx_drugs:stopTransformWeded', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

local function SellWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx_weedjob:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsWeed)
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingWeed[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('weed_pooch', 1)
                if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 108)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 128)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 152)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 165)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
                elseif CopsConnected >= 4 then
                    xPlayer.addAccountMoney('black_money', 180)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
                end
				
				SellWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellWddeed')
AddEventHandler('esx_drugs:startSellWddeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopSdellWeed')
AddEventHandler('esx_drugs:stopSdellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = false

end)


--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsOpium)
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingOpium[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLpium')
AddEventHandler('esx_drugs:startHarvestLpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

RegisterServerEvent('esx_drugs:startpHarvestOpium')
AddEventHandler('esx_drugs:startpHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsOpium)
		return
	end

	SetTimeout(10000, function()

		if PlayersTransformingOpium[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 100 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif opiumQuantity < 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 5)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLOpium')
AddEventHandler('esx_drugs:startTransformLOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLOpium')
AddEventHandler('esx_drugs:stopTransformLOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsOpium)
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingOpium[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('opium_pooch', 1)
				if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 300)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 500)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 700)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 800)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 900)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                elseif CopsConnected >= 5 then
                    xPlayer.addAccountMoney('black_money', 1000)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
                end
				
				SellOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSelFOpium')
AddEventHandler('esx_drugs:startSelFOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopSelldddOpium')
AddEventHandler('esx_drugs:stopSelldddOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = false

end)


-- RETURN INVENTORY TO CLIENT
RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_drugs:ReturnInventory', 
    	_source, 
    	xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.job.name, 
		currentZone
    )
end)

-- Register Usable Item
ESX.RegisterUsableItem('weed', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_drugs:onPot', _source)
    TriggerClientEvent('esx:showNotification', _source, _U('used_one_weed'))

end)
