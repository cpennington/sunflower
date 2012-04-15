Crafty.c("Easing", 
    {
        _start_x: 0
        _start_y: 0
        _delta_x: 0
        _delta_y: 0
        _duration: 0
        _frames: 0
        _active: false

        _linear: (t, init, dx, dt) ->
            return (dx / dt)*t + init

        _easeInQuad: (t, init, dx, dt) ->
            return dx*(t/=dt)*t + init

        init: () ->
            this.requires("2D")

        _on_enter_frame: () ->
            this._frames += 1
            this.x = this._ease(this._frames, this._start_x, this._delta_x, this._duration)
            this.y = this._ease(this._frames, this._start_y, this._delta_y, this._duration)

            if this._frames >= this._duration
                this.unbind("EnterFrame", this._on_enter_frame)
                this._active = false

        _setup: (target_x, target_y, duration, easing_function) ->
            if isNaN(target_x) or isNaN(target_y) or isNaN(duration) then return

            this._start_x = this.x
            this._start_y = this.y
            this._delta_x = target_x - this._start_x
            this._delta_y = target_y - this._start_y
            this._duration = duration
            this._frames = 0
            this._ease = easing_function

            if not this._active
                this._active = true
                this.bind("EnterFrame", this._on_enter_frame)

        easeLinear: (target_x, target_y, duration) ->
            this._setup(target_x, target_y, duration, this._linear)

        easeInQuad: (target_x, target_y, duration) ->
            this._setup(target_x, target_y, duration, this._easeInQuad)
    })