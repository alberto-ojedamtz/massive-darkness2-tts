require("character-select")
require("custom-objects")
require("player-area")
require("map-tiles")
require("quest-select")
require("utils")

checkerQuestSelect = nil

function setUp() 
    createCharacterSelectMenu()

    checkerQuestSelect = getObjectFromGUID("8eb6d6")
    checkerQuestSelect.setLock(true)
    checkerQuestSelect.setPosition({ x = 8, y = 0, z = 3})
    checkerQuestSelect.createButton({
        click_function = "questSelection",
        position = { x = 0, y = 1, z = 0 },
        label = "Confirm",
        font_size = 500,
        width = 2000,
        height = 500
    })
end
