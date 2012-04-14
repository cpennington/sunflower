window.onload = () ->
    # start crafty
    Crafty.init(400, 336)

    # the loading screen that will display while our assets load
    Crafty.scene("loading", () ->
        # black background with some loading text
        Crafty.background("#000")
        Crafty.e("2D, DOM, Text").attr({ w: 100, h: 20, x: 150, y: 120 })
                .text("Loading")
                .css({ "text-align": "center" })
    )

    # automatically play the loading scene
    Crafty.scene("loading")
