CLOSED = 0
OPEN = 1

DEBUG = 0

class PathPoint2
    constructor: (@x, @y) ->
        this.state = null
        this.parent = null
        this.score = 0
        this.heuristic = 0
        this.total_score = 0

    set_score: (new_score) ->
        this.score = new_score
        this.total_score = this.heuristic + new_score

    set_heuristic: (new_heuristic) ->
        this.heuristic = new_heuristic
        this.total_score = this.score + new_heuristic

get_neighbors = (map, point) ->
    neighbors = []
    max_x = map.length
    max_y = map[0].length
    for diff in [[-1,0],[0,1],[1,0],[0,-1]]
        new_x = point.x + diff[0]
        new_y = point.y + diff[1]
        if ((new_x < max_x) && (new_x >= 0) && (new_y < max_y) && (new_y >= 0) && map[new_x][new_y] == 0)
            neighbors.push([new_x, new_y])
    return neighbors

calculate_heuristic = (start, end) ->
    return Math.abs(end.x - start.x) + Math.abs(end.y - start.y)

reconstruct_path = (endPoint) ->
    path = []
    point = endPoint
    while point?
        path.push(point)
        point = point.parent
    return path

make_grid = (size_x, size_y, value=null) ->
    ((value for y in [1..size_y]) for x in [1..size_x])

root = exports ? this
root.AStar = 
    get_path: (map, start, goal, on_frontier=null, on_expand=null) ->
        open_set = new MinHeap(null, (a, b) ->
            if a == b
                0
            else if a.total_score < b.total_score
                -1
            else
                1
        )
        all_points = make_grid(map.length, map[0].length)

        startPoint = new PathPoint2(start[0], start[1])
        all_points[start[0]][start[1]] = startPoint

        endPoint = new PathPoint2(goal[0], goal[1])

        startPoint.set_heuristic(calculate_heuristic(startPoint, endPoint))
        open_set.push(startPoint, startPoint.total_score)

        while open_set.size() > 0
            current = open_set.pop()
            on_expand(current)
            if current.x == endPoint.x && current.y == endPoint.y
                return reconstruct_path(current)

            current.state = CLOSED
            for neighbor in get_neighbors(map, current)
                point = all_points[neighbor[0]][neighbor[1]]

                tentative_score = current.score + 1
                if not point?
                    point = new PathPoint2(neighbor[0], neighbor[1])
                    point.set_score(tentative_score)
                    point.set_heuristic(calculate_heuristic(point, endPoint))
                    all_points[point.x][point.y] = point

                if point.state == CLOSED
                    continue

                if point.state == null
                    point.parent = current
                    point.state = OPEN
                    open_set.push(point)
                    on_frontier(point)
                else if tentative_score < point.score
                    point.parent = current
                    point.set_score(tentative_score)
                    open_set.heapify()
