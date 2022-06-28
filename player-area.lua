PLAYER_BOARD_GUIDS = {
    "e0e32e",
    "6af186",
    "fdd3b2",
    "5038c2"
}

LEVEL_BOARD_RELATIVE_POSITIONS = { x = 4.98, y = 0.12, z = -1.6 }

CHARACTER_CARD_RELATIVE_POSITION = { x = -1.24, y = 0.12, z = 1.82 }

FIGURINE_RELATIVE_POSITION = { x = -4.24, y = 0, z = 5.82 }

COMPONENTS_BAG_RELATIVE_POSITION = { x = 0, y = 0, z = 5.82 }

function setUpPlayerAreas()
    for _, playerMenu in pairs(PLAYER_MENUS) do
        if (playerMenu.selectedClassId > 0 and playerMenu.selectedCharacterId > 0) then
            placeCharacterCardOnPlayerArea(playerMenu)
            placeFigurineOnPlayerArea(playerMenu)
            placeClassComponentsOnPlayerArea(playerMenu)
        end
    end
end

function placeObjectRelativeToPlayerBoard(playerMenu, object, relativeValues, lock)
    local position = getObjectFromGUID(PLAYER_BOARD_GUIDS[playerMenu.number]).getPosition()

    local xPos = position.x + relativeValues.x
    local yPos = position.y + relativeValues.y
    local zPos = position.z + relativeValues.z

    if (playerMenu.number > 2) then
        object.rotate({x = 0, y = 180, z = 0})
        xPos = xPos - (relativeValues.x * 2)
        zPos = zPos - (relativeValues.z * 2)
    end

    object.setPositionSmooth({ x = xPos, y = yPos, z = zPos })
    object.interactable = true
    object.setLock(lock)
end

function placeCharacterCardOnPlayerArea(playerMenu)
    local characterCard = playerMenu.selectedCharacterCard
    placeObjectRelativeToPlayerBoard(playerMenu, characterCard, CHARACTER_CARD_RELATIVE_POSITION, true)
end

function placeFigurineOnPlayerArea(playerMenu)
    local figurine = playerMenu.selectedCharacterFigurine
    placeObjectRelativeToPlayerBoard(playerMenu, figurine, FIGURINE_RELATIVE_POSITION, false)
end

function placeClassComponentsOnPlayerArea(playerMenu)
    local componentsBag = CLASS_COMPONENTS[playerMenu.selectedClassText]
    placeObjectRelativeToPlayerBoard(playerMenu, componentsBag, COMPONENTS_BAG_RELATIVE_POSITION, false)
end