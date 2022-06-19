require("character-select")
require("custom-objects")
require("player-area")

function setUp() 
    createCharacterSelectMenu()

    local checkerSetup = getObjectFromGUID("8eb6d6")
    checkerSetup.setLock(true)
    checkerSetup.setPosition({ x = 8, y = 0, z = 3})
    checkerSetup.createButton({
        click_function = "startGame",
        position = { x = 0, y = 1, z = 0 },
        label = "Start",
        font_size = 500,
        width = 2000,
        height = 500
    })
end

function startGame()
    log("START")
    setUpPlayerAreas()   
end