class PathPoint2
    constructor: (@x, @y, @score, @from_point) ->

    set_heuristic_score = (end) ->
        x_diff = end.x - this.x
        y_diff = end.y - this.y
        this.heuristic = Math.sqrt((x_diff*x_diff) - (y_diff*y_diff))

    get_total_score = () ->
        return this.score + (this.heuristic ? 0)

    is_same = (other) ->
        return other.x == this.x && other.y == this.y

get_neighbors = (map, point, goal) ->
    neighbors = []
    max_x = map.length
    max_y = map[0].length
    for dx in [-1, 0 , 1]
        for dy in [-1, 0, 1]
            if (dx == 0 && dy == 0)
                continue

            new_x = point.x + dx
            new_y = point.y + dy
            if ((new_x < max_x) && (new_x >= 0) && (new_y < max_y) && (new_y >= 0))
                new_score = point.score + dx + dy
                new_point = new PathPoint2(new_x, new_y, new_score, point)
                new_point.set_heuristic_score(goal)
                neighbors.push(new_point)
                
    return neighbors

get_path = (map, start, goal) ->
    open_set = new PriorityQueue({low:true})

    startPoint = new PathPoint2(start[0], start[1], 0, null)
    endPoint = new PathPoint2(end[0], end[1], -1, null)

    startPoint.set_heuristic_score(endPoint)
    open_set.push(startPoint, startPoint.get_total_score())

    while open_set.top()?
        current = open_set.pop()
        if current.is_same(endPoint)
            alert("done!")

        current.closed = true
