HIDDEN_OBJECTS = {}

function spawnHiddenObjectWithButtons(xPos, zPos, ...)
    local spawnedObject = spawnObject({
        type = "Checker_black",
        position = { x = xPos, y = -1, z = zPos },
        rotation = { x = 0, y = 180, z = 0 },
        sound = false,
        callback_function = makeObjectUninteractable
    })

    local buttonsParams = { ... }
    for _, params in ipairs(buttonsParams) do
        params.position = params.position or { x = 0, y = 2, z = 0 }
        spawnedObject.createButton(params)
    end

    table.insert(HIDDEN_OBJECTS, spawnedObject)

    return spawnedObject
end

function destroyAllHiddenObjects()
    while #HIDDEN_OBJECTS > 0 do
        table.remove(HIDDEN_OBJECTS, 1).destruct()
    end
end

function makeObjectUninteractable(obj)
    obj.setLock(true)
    obj.interactable = false
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

function destroyMenu()
    destroyAllHiddenObjects()
    for _, v in pairs(TEXT_OBJECTS) do
        v.destruct()
    end
end