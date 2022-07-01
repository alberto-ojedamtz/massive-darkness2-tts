QUEST_MENU_OBJECTS = {
    leftArrow = nil,
    rightArrow = nil,
    questName = nil
}

RULEBOOK_GUID = "a22a3f"
RULEBOOK = nil

SELECTED_QUEST_INDEX = 1
TAKEN_MAP_TILE_INDEX = 1

function questSelection(obj)
    setUpPlayerAreas()
    destroyPlayerMenuButtons()

    checkerQuestSelect.editButton({ index = 0, label = "Start", click_function = "placeQuestTile" })

    Wait.frames(
        function() placeRulebook() end
    , 5)

    Wait.frames(
        function() createQuestSelectionMenu() end
    , 10)
end

function placeRulebook()
    RULEBOOK = getObjectFromGUID(RULEBOOK_GUID).clone({position = {x = 22, y = 1, z = -3}})
    RULEBOOK.setLock(true)
    RULEBOOK.interactable = false
end

function createQuestSelectionMenu() 
    QUEST_MENU_OBJECTS.leftArrow = spawnHiddenObject(0, 0)
    QUEST_MENU_OBJECTS.questName = spawnHiddenObject(7, 0)
    QUEST_MENU_OBJECTS.rightArrow = spawnHiddenObject(14, 0)

    QUEST_MENU_OBJECTS.leftArrow.createButton({
        click_function = "previousQuest",
        label = "<",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 500,
        height = 500
    })

    QUEST_MENU_OBJECTS.questName.createButton({
        click_function = "asd",
        label = QUEST_CATALOG[SELECTED_QUEST_INDEX].name, 
        font_color = "White",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 0,
        height = 0
    })

    QUEST_MENU_OBJECTS.rightArrow.createButton({
        click_function = "nextQuest",
        label = ">",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 500,
        height = 500
    })

    updateSelectedQuest()
end

function previousQuest()
    if (SELECTED_QUEST_INDEX == 1) then
        SELECTED_QUEST_INDEX = #QUEST_CATALOG
    else
        SELECTED_QUEST_INDEX = SELECTED_QUEST_INDEX - 1
    end
    
    updateSelectedQuest()
end

function nextQuest()
    if (SELECTED_QUEST_INDEX == #QUEST_CATALOG) then 
        SELECTED_QUEST_INDEX = 1
    else
        SELECTED_QUEST_INDEX = SELECTED_QUEST_INDEX + 1
    end

    updateSelectedQuest()
end

function updateSelectedQuest()
    QUEST_MENU_OBJECTS.questName.editButton({
        index = 0,
        label = QUEST_CATALOG[SELECTED_QUEST_INDEX].name
    })
    RULEBOOK.Book.setPage(QUEST_CATALOG[SELECTED_QUEST_INDEX].page)
end

function placeQuestTile()
    if (TAKEN_MAP_TILE_INDEX > #QUEST_CATALOG[SELECTED_QUEST_INDEX].tilesPlacement) then
        destroyAllHiddenObjects()
        return
    end

    local bag = getObjectFromGUID(MAP_TILES_BAG)
    local tile = QUEST_CATALOG[SELECTED_QUEST_INDEX].tilesPlacement[TAKEN_MAP_TILE_INDEX]
    TAKEN_MAP_TILE_INDEX = TAKEN_MAP_TILE_INDEX + 1

    bag.takeObject({
        guid = tile.guid,
        position = tile.position,
        rotation = tile.rotation,
        callback_function = placeQuestTile
    })
end