PLAYER_BOARDS_POSITIONS = { 
    { x = -52, y = 1, z = -44 },
    { x = 21, y = 1, z = -44 }
}

LEVEL_BOARD_RELATIVE_POSITIONS = {
    x = 4.98,
    y = 0.12,
    z = -1.6
}

CHARACTER_CARD_RELATIVE_POSITIONS = {
    x = -1.24, 
    y = 0.12, 
    z = 1.82
}

function setUpPlayerAreas()
    for _, playerMenu in pairs(PLAYER_MENUS) do
        if (playerMenu.selectedClassId > 0 and playerMenu.selectedCharacterId > 0) then
            placePlayerBoard(playerMenu)
            placeLevelBoard(playerMenu)
        end
    end
end

function placePlayerBoard(playerMenu) 
    local boardPosition = PLAYER_BOARDS_POSITIONS[playerMenu.number]

    local playerBoard = spawnObject({ 
        type = "Custom_Token",
        position = boardPosition
    })

    playerBoard.setCustomObject({ image = PLAYER_BOARD_URL })
    playerBoard.setScale({ x = 2.6, y = 1, z = 2.6 })
    playerBoard.setRotation({ x = 0, y = 180, z = 0 })
    playerBoard.setLock(true)
end

function placeLevelBoard(playerMenu)
    local playerBoardPosition = PLAYER_BOARDS_POSITIONS[playerMenu.number]
    local xPos = playerBoardPosition.x + LEVEL_BOARD_RELATIVE_POSITIONS.x
    local yPos = playerBoardPosition.y + LEVEL_BOARD_RELATIVE_POSITIONS.y
    local zPos = playerBoardPosition.z + LEVEL_BOARD_RELATIVE_POSITIONS.z

    local levelBoard = spawnObject({
        type = "Custom_Token",
        position = { x = xPos, y = yPos, z = zPos }
    })

    levelBoard.setCustomObject({ 
        image = LEVEL_BOARD_URL, 
        thickness = 0.1 
    })
    levelBoard.setScale({ x = 0.74, y = 1, z = 0.75 })
    levelBoard.setRotation({ x = 0, y = 180, z = 0 })
    levelBoard.setLock(true)
end