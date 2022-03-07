--https://github.com/Apenas-Gabriel

local plants = {}

function plant(cmd, seedType)
	if seedType then
		if seedType == "Maconha" then
			if #plants > 1 then
				for i=1, #plants do
					local x,y,z = getElementPosition(localPlayer)
					local amount = exports["GRP"]:getItemAmount(weedSeedID)
					if amount >= 1 then
						local weed = createObject(weedObjectID, x, y, z-0.8)
						setObjectScale(weed, 0.1)
						exports["GRP"]:takePlayerItem(weedSeedID, 1)
						plants[#plants+1] = {object=weed, time=growingTime, weedprogress=language[lang].growing}
						break
					end
				end
			else
				local x,y,z = getElementPosition(localPlayer)
				local amount = exports["GRP"]:getItemAmount(weedSeedID)
				if amount >= 1 then
					local weed = createObject(weedObjectID, x, y, z-0.8)
					setObjectScale(weed, 0.1)
					exports["GRP"]:takePlayerItem(weedSeedID, 1)
					plants[#plants+1] = {object=weed, time=growingTime, weedprogress=language[lang].growing}
				end
			end
		elseif seedType == "Cocaina" then
			if #plants > 1 then
				for i=1, #plants do
					local x,y,z = getElementPosition(localPlayer)
					local amount = exports["GRP"]:getItemAmount(cocaineSeedID)
					if amount >= 1 then
						local coca = createObject(cocaineObjectID, x, y, z-0.8)
						setObjectScale(coca, 0.1)
						exports["GRP"]:takePlayerItem(cocaineSeedID, 1)
						plants[#plants+1] = {object=coca, time=growingTime, weedprogress=language[lang].growing}
						break
					end
				end
			else
				local x,y,z = getElementPosition(localPlayer)
				local amount = exports["GRP"]:getItemAmount(cocaineSeedID)
				if amount >= 1 then
					local coca = createObject(cocaineObjectID, x, y, z-0.8)
					setObjectScale(coca, 0.1)
					exports["GRP"]:takePlayerItem(cocaineSeedID, 1)
					plants[#plants+1] = {object=coca, time=growingTime, weedprogress=language[lang].growing}
				end
			end
		end
	else
		outputChatBox(language[lang].error)
	end
end
addCommandHandler("plant", plant)

function render()
	for i=1, #plants do
		if plants[i].object then
			if plants[i].time <= 50 and plants[i].time > 1 then
				plants[i].weedprogress = language[lang].growing
			elseif plants[i].time == 0 then
				plants[i].weedprogress = language[lang].press
				if getObjectScale(plants[i].object) < 0.9 then
					setObjectScale(plants[i].object, 0.9)
				end
			end
			plants[i].time = plants[i].time - 1
			dxDrawTextOnElement(plants[i].object, plants[i].weedprogress, 2, 20, 255, 255, 255, 255, 2)
		end
	end
end
addEventHandler("onClientRender", root, render)

function harvest()
	for i=1, #plants do
		local x,y,z = getElementPosition(localPlayer)
		local x2,y2,z2 = getElementPosition(plants[i].object)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 1 then
			if plants[i].time <= 0 then
				if getElementModel(plants[i].object) == weedObjectID then
					local item = exports["GRP"]:givePlayerItem(weedID, weedAmount)
					destroyElement(plants[i].object)
					table.remove(plants, i)
					setPedAnimation(localPlayer, "BOMBER", "BOM_Plant", 5000, false, false, false, false)
					break
				elseif getElementModel(plants[i].object) == cocaineObjectID then
					local item = exports["GRP"]:givePlayerItem(cocaineID, cocaineAmount)
					destroyElement(plants[i].object)
					table.remove(plants, i)
					setPedAnimation(localPlayer, "BOMBER", "BOM_Plant", 5000, false, false, false, false)
					break
				end
			end
		end
	end
end
bindKey("e", "down", harvest)

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center", false, false, true, true)
			end
		end
	end
end
