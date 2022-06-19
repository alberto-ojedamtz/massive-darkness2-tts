HERO_CLASSES = { }
HERO_BAGS = {}
CLASS_COMPONENTS = {}
PLAYER_MENUS = {}

PLAYER_1_GUID = "d78c56"
PLAYER_2_GUID = "c6d1b9"
PLAYER_3_GUID = "4b1371"
PLAYER_4_GUID = "65b0de"
PLAYER_5_GUID = "2c0bbc"
SELECTED_CLASS_BUTTON_INDEX = 2
SELECTED_CHARACTER_BUTTON_INDEX = 5

CHARACTER_ZONE_GUID = "d88dbe"
CHARACTER_MENU_START_INDEX = 4
CLASS_DEFAULT_TEXT = "Pick a class"


function createCharacterSelectMenu ()
    initializeHeroClasses()
    initializePlayerMenus()
    initializeClassComponents()
    hidePlayerMenuCheckers()

    for _, pm in pairs(PLAYER_MENUS) do
        createMenuForPlayer(pm)
    end
end

function initializeHeroClasses()
    local zone = getObjectFromGUID(CHARACTER_ZONE_GUID)
    local heroBags = zone.getObjects()

    for _, bag in pairs(heroBags) do
        HERO_BAGS[bag.getName()] = bag
        table.insert(HERO_CLASSES, bag.getName())
    end
end

function initializeClassComponents()
    local zone = getObjectFromGUID("26ce87")
    local componentBags = zone.getObjects()

    for _, bag in pairs(componentBags) do
        CLASS_COMPONENTS[bag.getName()] = bag
    end
end

function initializePlayerMenus() 
    PLAYER_MENUS[PLAYER_1_GUID] = createPlayerMenuProperties(PLAYER_1_GUID, 1, "06a5de")
    PLAYER_MENUS[PLAYER_2_GUID] = createPlayerMenuProperties(PLAYER_2_GUID, 2, "1cf3e3")
    PLAYER_MENUS[PLAYER_3_GUID] = createPlayerMenuProperties(PLAYER_3_GUID, 3, "df9bba")
    PLAYER_MENUS[PLAYER_4_GUID] = createPlayerMenuProperties(PLAYER_4_GUID, 4, "1c5601")
    PLAYER_MENUS[PLAYER_5_GUID] = createPlayerMenuProperties(PLAYER_5_GUID, 5, "29b6cd")
end

function createPlayerMenuProperties(guid, number, cardZoneGuid)
    return {
        obj = getObjectFromGUID(guid),
        number = number,
        selectedClassText = "",
        selectedClassId = 0,
        selectedCharacterText = "",
        selectedCharacterId = 0,
        selectedCharacterCard = nil,
        selectedCharacterFigurine = nil,
        cardZoneGuid = cardZoneGuid
    }
end

-- Menus are created from a checker object that is hidden
function hidePlayerMenuCheckers()
    for _, pm in pairs(PLAYER_MENUS) do
        local startZ = (pm.number - 1) * 5 * -1

        pm.obj.setLock(true)
        pm.obj.setPosition({ x = 0, y = 0, z = startZ })
    end
end

function createMenuForPlayer(playerMenu)
    local fontSize = 500

    local playerText = {
        click_function = "nil",
        label = "Player " .. playerMenu.number,
        position = { x = 0, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "White",
        width = 0,
        height = 0
    }

    local previousClassButton = {
        click_function = "cyclePreviousClass",
        label = "<",
        position = { x = 3, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "Black",
        width = 500,
        height = 500
    }

    local selectedClassText = {
        click_function = "nil",
        label = CLASS_DEFAULT_TEXT,
        position = { x = 6.5, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "White",
        width = 0,
        height = 0
    }

    local nextClassButton = {
        click_function = "cycleNextClass",
        label = ">",
        position = { x = 10, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "Black",
        width = 500,
        height = 500
    }

    playerMenu.obj.createButton(playerText)
    playerMenu.obj.createButton(previousClassButton)
    playerMenu.obj.createButton(selectedClassText)
    playerMenu.obj.createButton(nextClassButton)
end

function createCharacterMenu(playerMenu)
    -- Menu already exists
    if characterMenuExists(playerMenu) then
        return
    end

    local fontSize = 500
    local previousCharacterButton = {
        click_function = "cyclePreviousCharacter",
        label = "<",
        position = { x = 13, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "Black",
        width = 500,
        height = 500
    }

    local selectedCharacterText = {
        click_function = "nil",
        label = "",
        position = { x = 16, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "White",
        width = 0,
        height = 0
    }

    local nextCharacterButton = {
        click_function = "cycleNextCharacter",
        label = ">",
        position = { x = 19, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "Black",
        width = 500,
        height = 500
    }

    playerMenu.obj.createButton(previousCharacterButton)
    playerMenu.obj.createButton(selectedCharacterText)
    playerMenu.obj.createButton(nextCharacterButton)
end

function destroyCharacterMenu(playerMenu) 
    if not characterMenuExists(playerMenu) then
        return
    end

    removeObjectsFromCharacterZone(playerMenu)
    for i = CHARACTER_MENU_START_INDEX, #playerMenu.obj.getButtons() - 1, 1 do
        playerMenu.obj.removeButton(i)
    end
end

function cyclePreviousClass(obj)
    local playerMenu = PLAYER_MENUS[obj.getGUID()]
    local previousClassId = playerMenu.selectedClassId - 1

    if previousClassId < 0 then 
        previousClassId = #HERO_CLASSES
    end

    cycleClass(obj, playerMenu, previousClassId)
end

function cycleNextClass(obj)
    local playerMenu = PLAYER_MENUS[obj.getGUID()]
    local nextClassId = playerMenu.selectedClassId + 1

    if not HERO_CLASSES[nextClassId] then 
        nextClassId = 0 
    end

    cycleClass(obj, playerMenu, nextClassId)
end

function cycleClass(obj, playerMenu, classId)
    local selectedClass = HERO_CLASSES[classId] or CLASS_DEFAULT_TEXT
    playerMenu.selectedClassText = HERO_CLASSES[classId]
    playerMenu.selectedClassId = classId
    playerMenu.obj.editButton({ index = SELECTED_CLASS_BUTTON_INDEX, label = selectedClass })

    -- sets to 0 so next characterId is 1
    playerMenu.selectedCharacterId = 0
    cycleNextCharacter(obj)
end

function cyclePreviousCharacter(obj)
    local playerMenu = PLAYER_MENUS[obj.getGUID()]
    local previousCharacterId = playerMenu.selectedCharacterId - 1

    cycleCharacter(playerMenu, previousCharacterId, false)
end

function cycleNextCharacter(obj)
    local playerMenu = PLAYER_MENUS[obj.getGUID()]
    local nextCharacterId = playerMenu.selectedCharacterId + 1

    cycleCharacter(playerMenu, nextCharacterId, true)
end

function cycleCharacter(playerMenu, characterId, isDefaultAtBeginning)
    if (playerMenu.selectedClassId == 0) then 
        destroyCharacterMenu(playerMenu)
        return
    end

    createCharacterMenu(playerMenu)

    local zPos = playerMenu.obj.getPosition().z
    local bag = HERO_BAGS[playerMenu.selectedClassText]
    local characters = HERO_BAGS[playerMenu.selectedClassText].getObjects()
    local characterBag = findCharacterBag(characters, characterId)

    if not characterBag then 
        characterId = isDefaultAtBeginning and 1 or #characters
        characterBag = findCharacterBag(characters, characterId)
    end

    playerMenu.selectedCharacterId = characterId
    playerMenu.selectedCharacterText = characterBag.name
    playerMenu.obj.editButton({ index = SELECTED_CHARACTER_BUTTON_INDEX, label = characterBag.name })

    placeObjectsOnCharacterZone(bag, playerMenu, zPos)
end

function placeObjectsOnCharacterZone(bag, playerMenu, zPos)
    removeObjectsFromCharacterZone(playerMenu)

    local helperBag = bag.clone({ position = { x = 0, y = 1, z = 0 }})
    helperBag.interactable = false
    helperBag.setLock(true)
    helperBag.setPosition({ x = bag.getPosition().x, y = 1, z = 0 })

    local characterBag = helperBag.takeObject({ 
        index = playerMenu.selectedCharacterId - 1, 
        position = { x = 23, y = -1, z = zPos },
        smooth = false
    })

    local characterCard = characterBag.takeObject({
        position = { x = 23, y = 0.9, z = zPos },
        smooth = false
    })

    local yRotation = characterCard.getDescription() ~= "" and characterCard.getDescription() or 0
    characterCard.setRotation({ x = 0, y = yRotation, z = 0 })
    characterCard.interactable = false

    local figurine = characterBag.takeObject({
        position = { x = 27, y = 0.9, z = zPos },
        smooth = false
    })
    figurine.interactable = false

    playerMenu.selectedCharacterCard = characterCard
    playerMenu.selectedCharacterFigurine = figurine

    helperBag.destruct()
    characterBag.destruct()
end

function removeObjectsFromCharacterZone(playerMenu)
    local objects = getObjectsFromCharacterZone(playerMenu)
    for _, obj in pairs(objects) do 
        obj.destruct()
    end
end

function getObjectsFromCharacterZone(playerMenu)
    local objectsInZone = getObjectFromGUID(playerMenu.cardZoneGuid).getObjects()
    local objects = {}
    for _, c in pairs(objectsInZone) do
        if (c.getGUID() ~= "c86088") then 
            table.insert(objects, c)
        end
    end
    return objects;
end

function findCharacterBag(bag, characterId) 
    for i, v in ipairs(bag) do
        if i == characterId then 
            return v
        end
    end
end

function characterMenuExists(playerMenu)
    return #playerMenu.obj.getButtons() > CHARACTER_MENU_START_INDEX
end