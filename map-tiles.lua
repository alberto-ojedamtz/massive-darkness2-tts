CORE_MAP_1A = "324b6a"
CORE_MAP_1B = "968ed8"
CORE_MAP_2A = "cddc3d"
CORE_MAP_2B = "b847f3"
CORE_MAP_3A = "c7ec29"
CORE_MAP_3B = "31ec26"
CORE_MAP_4A = "08f575"
CORE_MAP_4B = "ee96a3"
CORE_MAP_5A = "9cb48f"
CORE_MAP_5B = "3992d6"
CORE_MAP_6A = "a3f628"
CORE_MAP_7A = "641c1b"
CORE_MAP_7B = "b99ecd"
CORE_MAP_6B = "d3ad82"
CORE_MAP_8A = "0c0e03"
CORE_MAP_8B = "cd8169"

MAP_TILES_BAG = "e0fe74"

MAP_GRID_X = { -40, -24.3, -8.6, 7.1 }
MAP_GRID_Z = { 29, 13.3, -2.4, -18.1 }

MAP_TILE_OFFSET = 15.7

--[[
    guid: Map tile guid
    x: Index from MAP_GRID_X for position.x
    z: Index from MAP_GRID_Z for position.z
    rotations: Number of times tile should be rotated to the right by 90°
]]
function createTilePlacement(guid, xPos, zPos, yRotation)
    local result = {
        guid = guid,
        position = { x = xPos, y = 2, z = zPos },
        rotation = { x = 0, y = yRotation or 0, z = 0 }
    }

    return result
end

CORE_QUEST_1 = {
    name = "Tutorial",
    page = 36,
    tiles = { 
        createTilePlacement(CORE_MAP_1A, -24.3, -18.1),
        createTilePlacement(CORE_MAP_4A, -8.6, -18.1)
    },
}

CORE_QUEST_2 = {
    name = "Highway to Hellscape",
    page = 37,
    tiles = {
        createTilePlacement(CORE_MAP_1A, -30.94, -18.1, 270),
        createTilePlacement(CORE_MAP_3A, -15.24, -18.1),
        createTilePlacement(CORE_MAP_5A, 0.46, -18.1)
    },
}

QUEST_CATALOG = {
    CORE_QUEST_1,
    CORE_QUEST_2,
}
