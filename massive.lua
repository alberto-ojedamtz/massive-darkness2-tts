require("character-select")
require("player-area")
require("map-tiles")
require("quest-select")
require("utils")

mainButtonObject = nil

function setUp() 
    createCharacterSelectMenu()

    mainButtonObject = getObjectFromGUID("8eb6d6")
    mainButtonObject.setLock(true)
    mainButtonObject.setPosition({ x = 8, y = 0, z = 3})
    mainButtonObject.createButton({
        click_function = "questSelection",
        position = { x = 0, y = 1, z = 0 },
        label = "Confirm",
        font_size = 500,
        width = 2000,
        height = 500
    })
end
