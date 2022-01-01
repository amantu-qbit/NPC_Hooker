local QBCore = exports['qb-core']:GetCoreObject()

local idle = true
local StreetPed
local StreetPedExists = false
local PreviousStreetPed
local PlayerPed
local InVehicle
local PlayerVehicle
local Timer


IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

RegisterNetEvent('actionHandler')
AddEventHandler('actionHandler', function(action)
	local service = action
	local currentCash = QBCore.Functions.GetPlayerData().money['cash']
	
	if service == 'bj' then
		TriggerServerEvent('npc_pickup:pay', 'bj', Config.BJPrice, currentCash)		
	else
		TriggerServerEvent('npc_pickup:pay', 'sex', Config.SexPrice, currentCash)
		
	end	
end )

RegisterNetEvent('getin')
AddEventHandler('getin', function()	

	if(InVehicle) and (IsCar(PlayerVehicle)) and GetPedInVehicleSeat(PlayerVehicle, -1) == PlayerPed and IsVehicleSeatFree(PlayerVehicle, 0) and IsVehicleStopped(PlayerVehicle) and StreetPedExists == false then
		
		StreetPed = GetClosestPed()
			
		local StreetPedHash = GetEntityModel(StreetPed)		
		
		Timer = Config.TextOverHeadTimer

		if StreetPed ~= 0 and not StreetPedExists then		
			Citizen.CreateThread(function()
				while true do
					Citizen.Wait(0)
					
					local StreetPedCoords = GetEntityCoords(StreetPed)
					
					if IsPedInVehicle(StreetPed, PlayerVehicle, false) or IsPedFatallyInjured(StreetPed) or Timer < 1 then
						break
					else
						DrawText3Ds(StreetPedCoords.x, StreetPedCoords.y, StreetPedCoords.z + 1.0, Config.TextOverHead)
					end
				end
			end)
			
			Citizen.CreateThread(function()
				while true do
					Citizen.Wait(0)
					if Timer > 0 then 
						Timer = Timer - 1
						Citizen.Wait(1000) 
					end 
				end 
			end)
			
			AddRelationship(StreetPed)
			TaskEnterVehicle(StreetPed, PlayerVehicle, -1, 0, 1.0, 1, 0)				
			
			StreetPedExists = true
			Citizen.Wait(1000)
			-- TriggerEvent('chat:addMessage', '','^7' .. Config.ChatMsgGetIn .. '^7.')

		end		
	end
	
end )

RegisterNetEvent('getout')
AddEventHandler('getout', function(noMoney)
	currentCash = QBCore.Functions.GetPlayerData().money['cash']
	
	if (StreetPedExists) and (idle) then
	
		if currentCash >= Config.BJPrice or currentCash >= Config.SexPrice then
			PlayAmbientSpeech1(StreetPed, "Hooker_Had_Enough", "Speech_Params_Force_Shouted_Clear")	
			-- TriggerEvent('chat:addMessage', '', {255, 255, 255}, '^7' .. Config.ChatMsgNoMoney .. '^7.')
			QBCore.Functions.Notify("".. Config.ChatMsgNoMoney .."","error")
		else
			PlayAmbientSpeech1(StreetPed, "Hooker_Leaves_Angry", "Speech_Params_Force_Shouted_Clear")				
		end
				
		TaskLeaveVehicle(StreetPed, PlayerVehicle, 1)
		TaskWanderStandard(StreetPed, 10.0, 10)
		RemovePedFromGroup(StreetPed)
		
		Citizen.Wait(5000)
		SetEntityAsNoLongerNeeded(StreetPed)
		PreviousStreetPed = StreetPed
		StreetPedExists = false
    end
	
end )

RegisterNetEvent('bj')
AddEventHandler('bj', function()
	
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	
		if IsPedInAnyVehicle(PlayerPed) and not IsVehicleSeatFree(PlayerVehicle, -1) and not IsVehicleSeatFree(PlayerVehicle, 0) 
		   and IsVehicleStopped(PlayerVehicle) and idle then
		   		
				local ped = GetPedInVehicleSeat(PlayerVehicle, 0)
				idle = false
							
				playNetworkedAnim("BJ", PlayerPed, "oddjobs@towing", "m_blow_job_loop", ped, "oddjobs@towing", "f_blow_job_loop")

				Citizen.Wait(2000)
				PlayAmbientSpeech1(ped, "Sex_Oral", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Oral", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Oral", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Oral_Fem", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Oral_Fem", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Finished", "Speech_Params_Force_Shouted_Clear")
				ClearPedTasks(PlayerPed)
				ClearPedTasks(ped)
				Citizen.Wait(3000)
				PlayAmbientSpeech1(ped, "Hooker_Offer_Again", "Speech_Params_Force_Shouted_Clear")
				TriggerServerEvent('hud:server:RelieveStress', math.random(1, 5))	
				
				idle = true
				break
			end
		break
		
	end
	end)
end)

RegisterNetEvent('sex')
AddEventHandler('sex', function()
	
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	
		if IsPedInAnyVehicle(PlayerPed) and not IsVehicleSeatFree(PlayerVehicle, -1) and not IsVehicleSeatFree(PlayerVehicle, 0) 
		   and IsVehicleStopped(PlayerVehicle) and idle then
		   		
				local ped = GetPedInVehicleSeat(PlayerVehicle, 0)
				idle = false
												
				playNetworkedAnim("SEX", PlayerPed,"mini@prostitutes@sexlow_veh", "low_car_sex_loop_player", ped, "mini@prostitutes@sexlow_veh", "low_car_sex_loop_female")

				Citizen.Wait(2000)
				PlayAmbientSpeech1(ped, "Sex_Generic", "Speech_Params_Force_Normal_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Generic", "Speech_Params_Force_Normal_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Generic", "Speech_Params_Force_Normal_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Generic_Fem", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Generic_Fem", "Speech_Params_Force_Shouted_Clear")
				Citizen.Wait(5000)
				PlayAmbientSpeech1(ped, "Sex_Finished", "Speech_Params_Force_Shouted_Clear")
				ClearPedTasks(PlayerPed)
				ClearPedTasks(ped)
				Citizen.Wait(3000)
				PlayAmbientSpeech1(Hooker, "Hooker_Offer_Again", "Speech_Params_Force_Shouted_Clear")
				TriggerServerEvent('hud:server:RelieveStress', math.random(1, 10))
						
				idle = true
				break
			end
		break
		
	end
	end)
end)

Citizen.CreateThread(function()
    while true do
        PlayerPed = PlayerPedId()
        InVehicle = IsPedInAnyVehicle(PlayerPed, false)		
		if (InVehicle) then
			PlayerVehicle = GetVehiclePedIsIn(PlayerPed,false)
		end
        Citizen.Wait(500)
    end
end)

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetClosestPed()
    local closestPed = 0
  
    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
		local pedHash = GetEntityModel(ped)
        if distanceCheck <= 10.0 and ped ~= PlayerPedId() and table.contains(Config.AllowedModels, pedHash) 
			and (not IsPedFatallyInjured(ped)) and PreviousStreetPed ~= ped then
            
			closestPed = ped
            break
        end
    end
	
    return closestPed
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function AddRelationship(ped)

	SetEntityAsMissionEntity(ped)
	
	SetPedAsGroupMember(ped, GetPedGroupIndex(PlayerPed))
	
	SetPedFleeAttributes(ped, 0, 0)
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function playNetworkedAnim(action, player, playerAnimDictionary, playerAnimationName, npc, npcAnimDictionary, npcAnimationName)

	if DoesEntityExist(player) and DoesEntityExist(npc) and (not IsEntityDead(player)) and (not IsEntityDead(npc)) then
		
		local playerRotation = GetEntityRotation(player, 2)	
		
		local driverSeatPos = GetWorldPositionOfEntityBone(PlayerVehicle, GetEntityBoneIndexByName(PlayerVehicle, "seat_dside_f"))
		local passengerSeatPos = GetWorldPositionOfEntityBone(PlayerVehicle, GetEntityBoneIndexByName(PlayerVehicle, "seat_pside_f"))
		
		loadAnimDict(playerAnimDictionary)
		loadAnimDict(npcAnimDictionary)
		
		if action == "BJ" then
		
			local playerScene = NetworkCreateSynchronisedScene(driverSeatPos, playerRotation, 2, false, true, 1065353216, 0, 1.3)
			NetworkAddPedToSynchronisedScene(player, playerScene, playerAnimDictionary, playerAnimationName, 1.0, -4.0, 1, 16, 1148846080, 0)
			
			local npcScene = NetworkCreateSynchronisedScene(passengerSeatPos, playerRotation, 2, false, true, 1065353216, 0, 1.3)
			NetworkAddPedToSynchronisedScene(npc, npcScene, npcAnimDictionary, npcAnimationName, 1.0, -4.0, 1, 16, 1148846080, 0)

			NetworkStartSynchronisedScene(playerScene)	
			NetworkStartSynchronisedScene(npcScene)				
		
		else
				
			local bothScene = NetworkCreateSynchronisedScene(driverSeatPos, playerRotation, 2, false, true, 1065353216, 0, 1.3)
			NetworkAddPedToSynchronisedScene(player, bothScene, playerAnimDictionary, playerAnimationName, 1.0, -4.0, 1, 16, 1148846080, 0)
			NetworkAddPedToSynchronisedScene(npc, bothScene, npcAnimDictionary, npcAnimationName, 1.0, -4.0, 1, 16, 1148846080, 0)

			NetworkStartSynchronisedScene(bothScene)		
		
		end
		
	end

end