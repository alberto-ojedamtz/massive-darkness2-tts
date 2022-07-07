HERO_CLASSES = { }
HERO_BAGS = {}
CLASS_COMPONENTS = {}
PLAYERS_PROPERTIES = {}
TEXT_OBJECTS = {}

CHARACTER_ZONE_GUID = "d88dbe"
CHARACTER_MENU_START_INDEX = 4

MENU_Z_SPACING = 5
MENU_STARTING_Z_VALUE = 0
MENU_NUMBER_OF_PLAYERS = 4
CLASS_DEFAULT_TEXT = "Choose a class"

function createCharacterSelectMenu ()
    initializePlayerMenus()

    initializeCharacterBags()
    initializeClassComponentsBags()
end

function spawnCycleClassButtonsObject(zPos)
    local fixedZPos = zPos - 0.5

    local previousClassButton = {
        click_function = "cyclePreviousClass",
        label = "<",
        font_size = 500,
        font_color = "Black",
        width = 500,
        height = 500
    }

    local nextClassButton = {
        click_function = "cycleNextClass",
        position = { x = 9, y = 2, z = 0 },
        label = ">",
        font_size = 500,
        font_color = "Black",
        width = 500,
        height = 500
    }

    return spawnHiddenObjectWithButtons(3.5, fixedZPos, previousClassButton, nextClassButton)
end

function initializePlayerMenus() 
    local zPos = MENU_STARTING_Z_VALUE

    for i = 1, MENU_NUMBER_OF_PLAYERS, 1 do
        spawnPlayerNumberText(i, zPos)
        local selectedClassTextObj = spawnChooseClassText(zPos)
        local cycleClassBtnsObj = spawnCycleClassButtonsObject(zPos)

        zPos = zPos - MENU_Z_SPACING
        PLAYERS_PROPERTIES[i] = createPlayerMenuProperties(i, selectedClassTextObj, cycleClassBtnsObj)
    end
end

function spawnChooseClassText(zPos)
    local position = { x = 8, y = 1, z = zPos }
    local text = CLASS_DEFAULT_TEXT

    return spawn3DText(position, text)
end

function spawnPlayerNumberText(playerNumber, zPos)
    local position = { x = 0, y = 1, z = zPos }
    local text = "Player " .. playerNumber

    return spawn3DText(position, text)
end

function spawn3DText(position, text)
    local object = spawnObject({
        position = position,
        rotation = { x = 90, y = 0, z = 0 },
        type = "3DText"
    })

    object.TextTool.setValue(text)

    table.insert(TEXT_OBJECTS, object)

    return object
end

function createPlayerMenuProperties(playerNumber, selectedClassTextObj, btnsObj)
    return {
        number = playerNumber,
        selectedClassTextObj = selectedClassTextObj,
        buttonsObj = btnsObj,
        selectedClassText = "",
        selectedClassId = 0,
        selectedCharacterText = "",
        selectedCharacterId = 0,
        selectedCharacterCard = nil,
        selectedConsumable = nil,
        selectedWeapon = nil,
    }
end

function initializeCharacterBags()
    local zone = getObjectFromGUID(CHARACTER_ZONE_GUID)
    local heroBags = zone.getObjects()

    for _, bag in pairs(heroBags) do
        HERO_BAGS[bag.getName()] = bag
        table.insert(HERO_CLASSES, bag.getName())
    end
end

function initializeClassComponentsBags()
    local zone = getObjectFromGUID("26ce87")
    local componentBags = zone.getObjects()

    for _, bag in pairs(componentBags) do
        CLASS_COMPONENTS[bag.getName()] = bag
    end
end

function createCharacterMenu(playerProperties)
    -- Menu already exists
    if characterMenuExists(playerProperties) then
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

    local nextCharacterButton = {
        click_function = "cycleNextCharacter",
        label = ">",
        position = { x = 19, y = 1, z = 0 },
        font_size = fontSize,
        font_color = "Black",
        width = 500,
        height = 500
    }

    playerProperties.buttonsObj.createButton(previousCharacterButton)
    playerProperties.buttonsObj.createButton(nextCharacterButton)
end

function destroyCharacterMenu(playerProperties) 
    if not characterMenuExists(playerProperties) then
        return
    end

    destroySelectedCharacterObjects(playerProperties)
    for i = CHARACTER_MENU_START_INDEX, #playerProperties.buttonsObj.getButtons() - 1, 1 do
        playerProperties.buttonsObj.removeButton(i)
    end
end

function getPlayerPropertiesFromButtonObj(btnObj)
    for _, v in pairs(PLAYERS_PROPERTIES) do 
        if (v.buttonsObj.getGUID() == btnObj.getGUID()) then 
            return v
        end
    end
end

function cyclePreviousClass(obj)
    local playerProperties = getPlayerPropertiesFromButtonObj(obj)
    local previousClassId = playerProperties.selectedClassId - 1

    if previousClassId < 0 then 
        previousClassId = #HERO_CLASSES
    end

    cycleClass(obj, playerProperties, previousClassId)
end

function cycleNextClass(obj)
    local playerProperties = getPlayerPropertiesFromButtonObj(obj)
    local nextClassId = playerProperties.selectedClassId + 1

    if not HERO_CLASSES[nextClassId] then 
        nextClassId = 0 
    end

    cycleClass(obj, playerProperties, nextClassId)
end

function cycleClass(obj, playerProperties, classId)
    local selectedClass = HERO_CLASSES[classId] or CLASS_DEFAULT_TEXT
    playerProperties.selectedClassText = HERO_CLASSES[classId]
    playerProperties.selectedClassId = classId
    playerProperties.selectedClassTextObj.TextTool.setValue(selectedClass)

    -- sets to 0 so next characterId is 1
    playerProperties.selectedCharacterId = 0
    cycleNextCharacter(obj)
end

function cyclePreviousCharacter(obj)
    local playerProperties = getPlayerPropertiesFromButtonObj(obj)
    local previousCharacterId = playerProperties.selectedCharacterId - 1

    cycleCharacter(playerProperties, previousCharacterId, false)
end

function cycleNextCharacter(obj)
    local playerProperties = getPlayerPropertiesFromButtonObj(obj)
    local nextCharacterId = playerProperties.selectedCharacterId + 1

    cycleCharacter(playerProperties, nextCharacterId, true)
end

function cycleCharacter(playerProperties, characterId, isDefaultAtBeginning)
    if (playerProperties.selectedClassId == 0) then 
        destroyCharacterMenu(playerProperties)
        return
    end

    createCharacterMenu(playerProperties)

    local zPos = playerProperties.buttonsObj.getPosition().z
    local bag = HERO_BAGS[playerProperties.selectedClassText]
    local characters = HERO_BAGS[playerProperties.selectedClassText].getObjects()
    local characterBag = findCharacterBag(characters, characterId)

    if not characterBag then 
        characterId = isDefaultAtBeginning and 1 or #characters
        characterBag = findCharacterBag(characters, characterId)
    end

    playerProperties.selectedCharacterId = characterId
    playerProperties.selectedCharacterText = characterBag.name

    placeObjectsOnCharacterZone(bag, playerProperties, zPos)
end

function placeObjectsOnCharacterZone(bag, playerProperties, zPos)
    destroySelectedCharacterObjects(playerProperties)

    local helperBag = bag.clone({ position = { x = 0, y = 1, z = 0 }})
    helperBag.interactable = false
    helperBag.setLock(true)
    helperBag.setPosition({ x = bag.getPosition().x, y = 1, z = 0 })

    local characterBag = helperBag.takeObject({ 
        index = playerProperties.selectedCharacterId - 1, 
        position = { x = 23, y = -1, z = zPos },
        smooth = false
    })

    local characterCard = characterBag.takeObject({
        position = { x = 16, y = 0.9, z = zPos },
        smooth = false
    })

    local yRotation = characterCard.getDescription() ~= "" and characterCard.getDescription() or 0
    characterCard.setRotation({ x = 0, y = yRotation, z = 0 })
    characterCard.interactable = false

    local characterFigurine = characterBag.takeObject({
        position = { x = 20, y = 0.9, z = zPos },
        smooth = false
    })
    characterFigurine.interactable = false

    playerProperties.selectedCharacterCard = characterCard
    playerProperties.selectedCharacterFigurine = characterFigurine

    helperBag.destruct()
    characterBag.destruct()
end

function destroySelectedCharacterObjects(playerProperties)
    if playerProperties.selectedCharacterCard ~= nil then 
        playerProperties.selectedCharacterCard.destruct()
        playerProperties.selectedCharacterFigurine.destruct()
    end
end

function findCharacterBag(bag, characterId) 
    for i, v in ipairs(bag) do
        if i == characterId then 
            return v
        end
    end
end

function characterMenuExists(playerProperties)
    return #playerProperties.buttonsObj.getButtons() > CHARACTER_MENU_START_INDEX
end

function destroyPlayerMenuButtons()
    destroyAllHiddenObjects()
    for _, v in pairs(TEXT_OBJECTS) do
        v.destruct()
    end
end