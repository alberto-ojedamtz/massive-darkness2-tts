HIDDEN_OBJECTS = {}

function spawnHiddenObject(xPos, zPos)
    local spawnedObject = spawnObject({
        type = "Checker_black",
        position = { x = xPos, y = -1, z = zPos },
        rotation = { x = 0, y = 180, z = 0 },
        callback_function = makeObjectUninteractable
    })

    table.insert(HIDDEN_OBJECTS, spawnedObject)

    return spawnedObject
end

function destroyAllHiddenObjects()
    for _, obj in pairs(HIDDEN_OBJECTS) do
        obj.destruct()
    end
end

function makeObjectUninteractable(obj)
    obj.setLock(true)
    obj.interactable = false
end