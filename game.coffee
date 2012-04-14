tile_size = 16
world_size = [20, 20]

world = ((0 for y in [1..world_size[1]]) for x in [1..world_size[1]])

window.onload = () ->
    # start crafty
    Crafty.init(world_size[0]*tile_size, world_size[0]*tile_size)

    # the loading screen that will display while our assets load
    Crafty.scene("loading", () ->
        Crafty.load(["sprite.png"], () -> Crafty.scene("main"))

        # black background with some loading text
        Crafty.background("#000")
        Crafty.e("2D, DOM, Text").attr({ w: 100, h: 20, x: 150, y: 120 })
                .text("Loading")
                .css({ "text-align": "center" })
    )

    Crafty.sprite(tile_size, "sprite.png",
        grass1: [0, 0],
        grass2: [1, 0],
        grass3: [2, 0],
        grass4: [3, 0],
        flower: [0, 1],
        bush1: [0, 2],
        bush2: [1, 2],
        player: [0, 3],
        enemy: [0, 3],
        banana: [4, 0],
        empty: [4, 0],
    )

    Crafty.scene("main", () ->

        for i in [0..world_size[0]]
            for j in [0..world_size[1]]
                Crafty.e("2D, DOM, grass1").attr(x: i * tile_size, y: j * tile_size, z: 1)
    )

    # automatically play the loading scene
    Crafty.scene("loading")

