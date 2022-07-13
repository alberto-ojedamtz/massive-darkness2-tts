QUEST_MENU_OBJECTS = {
    leftArrow = nil,
    rightArrow = nil,
    questName = nil
}

RULEBOOK_GUID = "a22a3f"
RULEBOOK = nil

SELECTED_QUEST_INDEX = 1
TAKEN_MAP_TILE_INDEX = 1

function questSelection()
    setUpPlayerAreas()
    destroyMenu()

    mainButtonObject.editButton({ 
        index = 0, label = "Start", 
        click_function = "setUpQuest" 
    })

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
    local leftArrowButtonParams = {
        click_function = "previousQuest",
        label = "<",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 500,
        height = 500
    }
    QUEST_MENU_OBJECTS.leftArrow = spawnHiddenObjectWithButtons(0, 0, leftArrowButtonParams)

    local questNameButtonParams = {
        click_function = "asd",
        label = QUEST_CATALOG[SELECTED_QUEST_INDEX].name, 
        font_color = "White",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 0,
        height = 0
    }
    QUEST_MENU_OBJECTS.questName = spawnHiddenObjectWithButtons(7, 0, questNameButtonParams)

    local rightArrowButtonParams = {
        click_function = "nextQuest",
        label = ">",
        font_size = 500,
        position = { x = 0, y = 2, z = 0 },
        width = 500,
        height = 500
    }
    QUEST_MENU_OBJECTS.rightArrow = spawnHiddenObjectWithButtons(14, 0, rightArrowButtonParams)

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

function setUpQuest()
    destroyAllHiddenObjects()
    placeMapTiles()
end

function placeMapTiles() 
    local bag = getObjectFromGUID(MAP_TILES_BAG)

    for k, tile in ipairs(QUEST_CATALOG[SELECTED_QUEST_INDEX].tiles) do
        Wait.frames(
            function() 
                bag.takeObject({
                    guid = tile.guid,
                    position = tile.position,
                    rotation = tile.rotation,
                })
            end
            , k * 25)
    end
end