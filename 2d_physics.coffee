Crafty.c("SunflowerPhysics", 
    {
        _position: []
        _velocity: []
        _acceleration: []
        _last_time: -1

        init: () ->
            this.bind("EnterFrame", () ->
                current_time = (new Date()).getTime()
                if this._last_time < 0
                    this._last_time = current_time
                    return

                dt = current_time - this._last_time
                this._last_time = current_time

                this._from_engine()

                num_dimensions = this._position.length
                for dimension in [0..(num_dimensions-1)]
                    this._position[dimension] += this._calculate_delta_position(this._velocity[dimension], this._acceleration[dimension], dt)

                for dimension in [0..(num_dimensions-1)]
                    this._velocity[dimension] += this._calculate_delta_velocity(this._acceleration[dimension], dt)

                this._to_engine()
            )

        _calculate_delta_position: (v, a, dt) ->
            return (v * dt) - ((a * dt * dt) / 2)

        _calculate_delta_velocity: (a, dt) ->
            return a * dt

        _from_engine: () ->
            this._position[0] = this.x
            this._position[1] = this.y
            if(this._velocity.length < 2)
                this._velocity = [0,0]
            if(this._acceleration.length < 2)
                this._acceleration = [0,0]

        _to_engine: () ->
            this.x = this._position[0]
            this.y = this._position[1]

        set_position: (vector) ->
            this._position = vector.slice()
            return this

        get_position: () -> this._position.slice()

        set_velocity: (vector) ->
            this._velocity = vector.slice()
            return this

        get_velocity: (dim) -> this._velocity.slice()

        set_acceleration: (vector) ->
            this._acceleration = vector.slice()
            return this

        get_acceleration: () -> this._acceleration.slice()
    })
