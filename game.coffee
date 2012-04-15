tile_size = 16
world_size = [30, 20]

make_grid = (size_x, size_y, value=null) ->
    ((value for y in [1..size_y]) for x in [1..size_x])

make_bush = (x, y) ->
    bush = Crafty.e("2D, Canvas, bush1, Mouse")
        .attr(x: x * tile_size, y: y * tile_size, z: 2)
    bush.bind("Click", (e) ->
        world[x][y] = 0
        bush.destroy()
    )

NEAR_DIST = 10
FAR_DIST = 20
VELOCITY = 0.2
ACCELERATION = 0.001

get_vector_magnitude = (x, y) ->
    return Math.sqrt(x * x + y * y)

get_vector_from_magnitude_direction = (m, vx, vy) ->
    vec = []
    mag = get_vector_magnitude(vx, vy)
    vec.push(vx * (m/mag))
    vec.push(vy * (m/mag))
    return vec

v_dot = (a, b) -> a[0] * b[0] + a[1] * b[1]
v_scale = (s, v) -> [s * v[0], s * v[1]]
v_project = (a, b) -> v_scale(v_dot(a, b) / v_dot(b, b), b)
v_reject = (a, b) -> a - v_project(a, b)
v_add = (a, b) -> [a[0] + b[0], a[1] + b[1]]
v_sub = (a, b) -> [a[0] - b[0], a[1] - b[1]]
v_length = (v) -> Math.sqrt(v_dot(v, v))
v_norm = (v) -> v_scale(1/v_length(v), v)
v_cap = (max, v) ->
    len = v_length(v)
    if len > max
        v_scale(max/len, v)
    else
        v


TIME_TO_TARGET = 50
PROJECT_ACCEL = .0001
MAX_ACCEL = .005
REJECT_ACCEL = -.01

debug_vector = (start, vec, color) ->
    end = v_add(start, vec)
    ctx = Crafty.canvas.context
    ctx.strokeStyle = color
    ctx.beginPath()
    ctx.moveTo(start[0], start[1])
    ctx.lineTo(end[0], end[1])
    ctx.stroke()

make_start = (x, y) ->
    player = Crafty.e("2D, Canvas, 2DPhysics, Controls, player")
        .attr(x: x * tile_size, y: y * tile_size, z: 2, _frameCount: 0)
        .bind("EnterFrame", (e) ->
            target_x = Crafty.mousePos.x
            target_y = Crafty.mousePos.y
            diff_x = target_x - this.x
            diff_y = target_y - this.y
            if not isNaN(diff_x) and not isNaN(diff_y)
                delta = [diff_x, diff_y]
                target_velocity = v_scale(1 / TIME_TO_TARGET, delta)
                vgood = v_project(this.get_velocity(), target_velocity)
                vbad = v_sub(this.get_velocity(), vgood)
                agood = v_cap(MAX_ACCEL, v_sub(target_velocity, vgood))
                abad = v_scale(REJECT_ACCEL, vbad)
                accel = v_add(agood, abad)
                #debug_vector(this.get_position(), v_scale(20, target_velocity), "rgba(0,255,0,1)")
                #console.log(v_dot(vgood, target_velocity))
                #if v_dot(agood, target_velocity) > 0
                #    debug_vector(v_add(v_add(this.get_position(), v_scale(20, target_velocity)), [-5, -5]), v_scale(100000, agood), "rgba(0,0,255,1)")
                #else
                #    debug_vector(v_add(v_add(this.get_position(), v_scale(20, target_velocity)), [-5, -5]), v_scale(100000, agood), "rgba(255,0,0,1)")

                #debug_vector(this.get_position(), v_scale(1000, abad), "rgba(255,0,0,1)")
                #debug_vector(this.get_position(), v_scale(1000, this.get_velocity()), "rgba(0,0,255,1)")
                this.set_acceleration(accel[0], accel[1])
        )

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
        .bind("Click", ->
            world[x][y] = 1
            make_bush(x, y))
        .tint("#000000", 0)
    grasses[x][y] = grass

setup_tile = (x, y) ->
    make_grass(x, y)

    if world[x][y] == 1
        make_bush(x, y)

generate_world = ->
    for x in [0..world_size[0] - 1]
        for y in [0..world_size[1] - 1]
            setup_tile(x, y)

    make_start(start[0], start[1])
    make_end(end[0], end[1])

show_path = ->
    path = AStar.get_path(world, start, end,
        (pos) -> grasses[pos.x][pos.y].tint("#FF0000", .9),
        (pos) -> grasses[pos.x][pos.y].tint("#0000FF", .9),
    )
    for pos in path
        grasses[pos.x][pos.y].tint("#FFFFFF", .8)


world = make_grid(world_size[0], world_size[1], 0)
grasses = make_grid(world_size[0], world_size[1])
start = [5,5]
end = [19,8]

window.onload = ->
    # start crafty
    Crafty.init(world_size[0]*tile_size, world_size[1]*tile_size)

    # the loading screen that will display while our assets load
    Crafty.scene("loading", ->
        Crafty.load(["sprite.png"], -> Crafty.scene("main"))

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

    Crafty.scene("main", ->
        generate_world()
    )

    # automatically play the loading scene
    Crafty.scene("loading")

    $("#pause").click(-> Crafty.pause())

