Crafty.c("2DPhysics", 
    {
        _vx: 0
        _vy: 0
        _ax: 0
        _ay: 0
        _last_time: -1

        init: () ->
            this.requires("2D")
            this.bind("EnterFrame", () ->
                current_time = (new Date()).getTime()
                if this._last_time < 0
                    this._last_time = current_time
                    return

                dt = current_time - this._last_time
                this._last_time = current_time

                this.x += this._calculate_position(this._vx, this._ax, dt)
                this.y += this._calculate_position(this._vy, this._ay, dt)

                this._vx += this._calculate_velocity(this._ax, dt)
                this._vy += this._calculate_velocity(this._ay, dt)
            )

        _calculate_position: (v, a, dt) ->
            return (v * dt) - ((a * dt * dt) / 2)

        _calculate_velocity: (a, dt) ->
            return a * dt

        set_position: (x, y) ->
            this.x = x
            this.y = y
            return this

        set_velocity: (vx, vy) ->
            this._vx = vx
            this._vy = vy
            return this

        get_velocity: () ->
            return [this._vx, this._vy]

        set_acceleration: (ax, ay) ->
            this._ax = ax
            this._ay = ay
            return this
    })