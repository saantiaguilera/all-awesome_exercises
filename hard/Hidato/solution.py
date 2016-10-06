# Credits to adrian17 !! -> www.reddit.com/user/adrian17

data = [line.split() for line in open("input.txt")]
map = {(x, y): e for y, row in enumerate(data) for x, e in enumerate(row)}
checkpoint_coords = {coord: int(e) for coord, e in map.items() if e.isdigit()}
checkpoints = {n: coord for coord, n in checkpoint_coords.items()}
legal = {coord for coord, e in map.items() if e != 'x'}

curr = 1
if curr in checkpoints:
    paths = {(checkpoints[curr],)}
else:
    paths = {(coord,) for coord in legal}

while paths:
    if curr == len(legal):
        break
    curr += 1
    newpaths = set()
    for path in paths:
        x, y = path[-1]
        for dy, dx in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]:
            newpos = (x+dx, y+dy)
            if newpos not in legal:
                continue
            if newpos in checkpoint_coords and checkpoint_coords[newpos] != curr:
                continue
            if curr in checkpoints and checkpoints[curr] != newpos:
                continue
            if newpos in path:
                continue
            newpaths.add(path + (newpos,))
    paths = newpaths

if paths:
    print("Found")
    path = list(paths)[0]
    for i, (x, y) in enumerate(path):
        data[y][x] = i+1
    for line in data:
        print(''.join('{:<3}'.format(e) for e in line))