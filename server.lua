QBCore = exports['qb-core']:GetCoreObject()


RegisterCommand("getin", function(source, args, raw)
	
	TriggerClientEvent('getin', source)

end)

RegisterCommand("getout", function(source, args, raw)
	
	TriggerClientEvent('getout', source, false)

end)

RegisterCommand("bj", function(source, args, raw)
	
	TriggerClientEvent('actionHandler', source, 'bj')

end)

RegisterCommand("sex", function(source, args, raw)

	TriggerClientEvent('actionHandler', source, 'sex')
	
end)

RegisterServerEvent('npc_pickup:pay')
AddEventHandler('npc_pickup:pay', function(action, charge, cash)

	local src = source
	local cash = cash
	local service = action
	local price = charge
	local xPlayer = QBCore.Functions.GetPlayer(source)
	
	if cash >= charge then
		if action == 'bj' then
			TriggerClientEvent('bj', source)
			xPlayer.Functions.RemoveMoney("cash",charge)
		else
			TriggerClientEvent('sex', source)	
			xPlayer.Functions.RemoveMoney("cash",charge)
		end
	else
		TriggerClientEvent('getout', source, true)
	end
end)