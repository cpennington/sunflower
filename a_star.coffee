class PathPoint2
    constructor: (@x, @y, @score) ->
        this.closed = false

    set_heuristic_score: (end) ->
        x_diff = end.x - this.x
        y_diff = end.y - this.y
        this.heuristic = (x_diff*x_diff) + (y_diff*y_diff)

    get_total_score: () ->
        return this.score + (this.heuristic ? 0)

    is_same_position: (other) ->
        return other.x == this.x && other.y == this.y

get_neighbors = (map, point, goal) ->
    neighbors = []
    max_x = map.length
    max_y = map[0].length
    for diff in [[-1,0],[0,1],[1,0],[0,-1]]
        new_x = point.x + diff[0]
        new_y = point.y + diff[1]
        if ((new_x < max_x) && (new_x >= 0) && (new_y < max_y) && (new_y >= 0) && map[new_x][new_y] == 0)
            neighbors.push([new_x, new_y])
    return neighbors

reconstruct_path = (endPoint) ->
    path = []
    point = endPoint
    while point?
        path.push(endPoint)
        point = endPoint.parent
    return path

make_grid = (size_x, size_y, value=null) ->
    ((value for y in [1..size_y]) for x in [1..size_x])

root = exports ? this
root.AStar = 
    get_path: (map, start, goal, on_frontier=null, on_expand=null) ->
        open_set = new PriorityQueue({low:true})
        all_points = make_grid(map.length, map[0].length)

        startPoint = new PathPoint2(start[0], start[1], 0)
        all_points[start[0]][start[1]] = startPoint

        endPoint = new PathPoint2(goal[0], goal[1], -1)
        all_points[goal[0]][goal[1]] = endPoint

        startPoint.set_heuristic_score(endPoint)
        open_set.push(startPoint, startPoint.get_total_score())

        while open_set.top()?
            current = open_set.pop()
            on_expand(current)
            Crafty.timer.step()
            console.log("expanding point (" + current.x + "," + current.y + ") with total score " + current.get_total_score())
            if current.is_same_position(endPoint)
                reconstruct_path(current)

            current.closed = true
            for neighbor in get_neighbors(map, current, goal)
                point = all_points[neighbor[0]][neighbor[1]]
                if not point?
                    point = new PathPoint2(neighbor[0], neighbor[1], current.score + 1)
                    point.set_heuristic_score(endPoint)
                    all_points[point.x][point.y] = point

                if point.closed
                    continue

                tentative_score = current.score + 1

                should_move_to_point = false
                console.log("evaluating point (" + point.x + "," + point.y + ") with score " + point.score + " and heuristic score " + point.heuristic)
                if not open_set.includes(point)
                    open_set.push(point, point.get_total_score())
                    on_frontier(point)
                    Crafty.timer.step()
                    console.log("adding frontier point (" + point.x + "," + point.y + ") with total score " + point.get_total_score())
                    point.parent = current
                else if tentative_score < point.score
                    point.parent = current
                    point.score = tentative_score
                    open_set.update(point, point.get_total_score())
