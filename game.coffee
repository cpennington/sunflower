tile_size = 16
world_size = [20, 20]

world = ((0 for y in [1..world_size[1]]) for x in [1..world_size[1]])
world[5][7] = 1
console.log(world)

make_bush = (x, y) ->
    bush = Crafty.e("2D, Canvas, bush1, Mouse")
        .attr(x: x * tile_size, y: y * tile_size, z: 2)
    bush.bind("Click", () ->
        world[x][y] = 0
        bush.destroy()
    )


place_tile = (x, y) -> 
    Crafty.e("2D, Canvas, grass1, Mouse")
        .attr(x: x * tile_size, y: y * tile_size, z: 1)
        .bind("Click", () ->
            world[x][y] = 1
            make_bush(x, y)
        )

    if world[x][y] == 1
        make_bush(x, y)

generate_world = () ->
    for x in [0..world_size[0] - 1]
        for y in [0..world_size[1] - 1]
            place_tile(x, y)


window.onload = () ->
    # start crafty
    Crafty.init(world_size[0]*tile_size, world_size[0]*tile_size)

    # the loading screen that will display while our assets load
    Crafty.scene("loading", () ->
        Crafty.load(["sprite.png"], () -> Crafty.scene("main"))

        # black background with some loading text
        Crafty.background("#000")
        Crafty.e("2D, Canvas, Text")
            .attr({ w: 100, h: 20, x: 150, y: 120 })
            .text("Loading")
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
        generate_world()
    )

    # automatically play the loading scene
    Crafty.scene("loading")

