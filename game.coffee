tile_size = 16
world_size = [20, 20]

make_grid = (size_x, size_y, value=null) ->
    ((value for y in [1..size_y]) for x in [1..size_x])

make_bush = (x, y) ->
    bush = Crafty.e("2D, Canvas, bush1, Mouse")
        .attr(x: x * tile_size, y: y * tile_size, z: 2)
    bush.bind("Click", (e) ->
        world[x][y] = 0
        bush.destroy()
    )

make_start = (x, y) ->
    Crafty.e("2D, Canvas, player")
        .attr(x: x * tile_size, y: y * tile_size, z: 2)

make_end = (x, y) ->
    Crafty.e("2D, Canvas, flower")
        .attr(x: x * tile_size, y: y * tile_size, z: 2)

make_grass = (x, y) ->
    grass = Crafty.e("2D, Canvas, grass1, Mouse, Tint")
        .attr(x: x * tile_size, y: y * tile_size, z: 1)
        .bind("MouseOver", (e) ->
            if e.mouseButton == Crafty.mouseButtons.RIGHT
                world[x][y] = 1
                make_bush(x, y))
        .bind("Click", () ->
            world[x][y] = 1
            make_bush(x, y))
        .tint("#000000", 0)
    grasses[x][y] = grass

setup_tile = (x, y) ->
    make_grass(x, y)

    if world[x][y] == 1
        make_bush(x, y)

generate_world = () ->
    for x in [0..world_size[0] - 1]
        for y in [0..world_size[1] - 1]
            setup_tile(x, y)

    make_start(start[0], start[1])
    make_end(end[0], end[1])

show_path = () ->
    path = AStar.get_path(world, start, end,
        (pos) -> grasses[pos.x][pos.y].tint("#FF0000", .9),
        (pos) -> grasses[pos.x][pos.y].tint("#0000FF", .9),
    )
    for pos in path
        grasses[pos.x][pos.y].tint("#FFFFFF", .8)

world = make_grid(world_size[0], world_size[1], 0)
grasses = make_grid(world_size[0], world_size[1])
start = [5,5]
end = [10,10]

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

    $("#path").click(show_path)

