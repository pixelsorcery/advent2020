import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

enum Dirs: Int {
    case ne = 0
    case e
    case se
    case sw
    case w
    case nw
}

enum Color {
    case white
    case black
}

var dirs:[(x:Int, y:Int)] = [(x:1, y:-1),
                      (x:1, y:0),
                      (x:0, y:1),
                      (x:-1, y:1),
                      (x:-1,y:0),
                      (x:0,y:-1)]

var tiles:[[Int]: Color] = [:]

for line in lines {
    var loc:(x:Int, y:Int) = (x: 0, y: 0)

    let charArray = Array(line) 

    var i = 0
    while i < charArray.count {
        if charArray[i] == "e" {
            loc.x += dirs[Dirs.e.rawValue].x
            loc.y += dirs[Dirs.e.rawValue].y
        } else if charArray[i] == "w" {
            loc.x += dirs[Dirs.w.rawValue].x
            loc.y += dirs[Dirs.w.rawValue].y            
        } else if charArray[i] == "n" {
            i += 1
            if charArray[i] == "e" {
                loc.x += dirs[Dirs.ne.rawValue].x
                loc.y += dirs[Dirs.ne.rawValue].y
            }
            else {
                loc.x += dirs[Dirs.nw.rawValue].x
                loc.y += dirs[Dirs.nw.rawValue].y
            }
        } else if charArray[i] == "s" {
            i += 1
            if charArray[i] == "e" {
                loc.x += dirs[Dirs.se.rawValue].x
                loc.y += dirs[Dirs.se.rawValue].y
            }
            else {
                loc.x += dirs[Dirs.sw.rawValue].x
                loc.y += dirs[Dirs.sw.rawValue].y
            }
        }
        i += 1
    }

    let location:[Int] = [loc.x, loc.y]
    if tiles[location] != nil {
        if tiles[location] == Color.white {
            tiles[location] = Color.black
        } else {
            tiles[location] = Color.white
        }
    }
    else {
        tiles[location] = Color.black
    }
}

var part1 = 0
for key in tiles.keys {
    if tiles[key] == Color.black {
        part1 += 1
    }
}

print ("part 1: \(part1)")

var tileDics:[[[Int]: Color]] = [tiles, [:]]
var idx = 0

let start = -200
let range = abs(start) * 2

for _ in 0..<100 {
    let nextTileIdx = (idx + 1) % 2
    tileDics[nextTileIdx] = [:]
    var whiteTiles:Set<[Int]> = []
    for key in tileDics[idx].keys{
        var blackTiles = 0
        for dir in dirs {
            if tileDics[idx][[key[0] + dir.x, key[1] + dir.y]] == Color.black {
                blackTiles += 1
            } else if tileDics[idx][[key[0] + dir.x, key[1] + dir.y]] == nil {
                whiteTiles.insert([key[0] + dir.x, key[1] + dir.y])
            }
        }
        // Any white tile with exactly 2 black tiles immediately
        // adjacent to it is flipped to black.
        if tileDics[idx][key] == Color.white {
            if blackTiles == 2 {
                tileDics[nextTileIdx][key] = Color.black
            } else {
                tileDics[nextTileIdx][key] = tileDics[idx][key]
            }
        // Any black tile with zero or more than 2 black tiles
        // immediately adjacent to it is flipped to white.
        } else if tileDics[idx][key] == Color.black {
            if blackTiles == 0 || blackTiles > 2 {
                tileDics[nextTileIdx][key] = Color.white
            } else {
                tileDics[nextTileIdx][key] = tileDics[idx][key]
            }
        }
    }

    for tileLoc in whiteTiles {
        var blackTiles = 0
        for dir in dirs {
            assert(tileDics[nextTileIdx][tileLoc] == nil)
            if tileDics[idx][[tileLoc[0] + dir.x, tileLoc[1] + dir.y]] == Color.black {
                blackTiles += 1
            }
        }

        // Any white tile with exactly 2 black tiles immediately
        // adjacent to it is flipped to black.
        if blackTiles == 2 {
            tileDics[nextTileIdx][tileLoc] = Color.black
        }
    }

    var tiles = 0
    for key in tileDics[nextTileIdx].keys {
        if tileDics[nextTileIdx][key] == Color.black {
            tiles += 1
        }
    }
    idx = nextTileIdx
}

var part2 = 0
for key in tileDics[idx].keys {
    if tileDics[idx][key] == Color.black {
        part2 += 1
    }
}

print ("part 2: \(part2)")