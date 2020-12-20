import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

struct Tile {
    var tileData:[String]
    var tileDataNoBorder:[String]
    var sides:[String] = []
    var matchingTiles:Set<Int> = []
    //var matchingTiles:[Int] = []
    var rotate = 0
    var mirrorH = false
    var mirrorV = false
    var top = 0
    var bottom = 0
    var left = 0
    var right = 0

    mutating func flipV() {
        for i in 0..<tileData[0].count/2 {
            let tmp = tileData[i]
            tileData[i] = tileData[tileData.count - i - 1]
            tileData[tileData.count - i - 1] = tmp
        }
        reInit()
    }

    mutating func flipH() {
        for i in 0..<tileData[0].count {
            tileData[i] = String(tileData[i].reversed())
        }   
        reInit()     
    }

    mutating func setSides() {
        sides = []
        sides.append(tileData[0])
        sides.append(tileData[tileData.count-1])
        var l = ""
        var r = ""
        for i in 0..<tileData.count {
            l += tileData[i].prefix(1)
            r += tileData[i].suffix(1)
        }
        sides.append(String(l))
        sides.append(String(r))
    }

    mutating func setBorders() {
        tileDataNoBorder = []
        for idx in 1..<tileData[0].count-1 {
            tileDataNoBorder.append(String(tileData[idx].prefix(tileData[idx].count-1).suffix(tileData[idx].count-2)))
        }
    }

    mutating func reInit() {
        setSides()
        setBorders()
    }

    // clockwise
    mutating func rotateTile() {
        var newTileData:[String] = Array(repeating: "", count: tileData[0].count)
        for i in 0..<tileData[0].count {
            for j in 0..<tileData[0].count {
                newTileData[j] += String(tileData[tileData[0].count - i - 1].prefix(j+1).suffix(1))
            }
        }
        tileData = newTileData
        reInit()
    }
}

enum Side: Int {
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
}

var tileDic:[Int:Tile] = [:]

var tileId = 0
var lineData:[String] = []
for line in lines {
    if line.contains("Tile") {
        tileId = Int(line.split(separator:" ")[1].replacingOccurrences(of:":", with: ""))!
        lineData = []
    } else if line.contains(".") {
        lineData.append(line)
    } else if line == "" {
        var sides:[String] = []
        sides.append(lineData[0])
        sides.append(lineData[lineData.count-1])
        var l = ""
        var r = ""
        for i in 0..<lineData.count {
            l += lineData[i].prefix(1)
            r += lineData[i].suffix(1)
        }
        sides.append(String(l))
        sides.append(String(r))

        var tileDataNoBorder:[String] = []
        for idx in 1..<lineData[0].count-1 {
            tileDataNoBorder.append(String(lineData[idx].prefix(lineData[idx].count-1).suffix(lineData[idx].count-2)))
        }
        let t = Tile(tileData: lineData,
                     tileDataNoBorder: tileDataNoBorder,
                     sides: sides,
                     matchingTiles:[],
                     rotate:0,
                     mirrorH: false,
                     mirrorV: false,
                     top:0,
                     bottom:0,
                     left:0,
                     right:0)
        tileDic[tileId] = t
    }
}

var part1 = 1

// find 4 corner tiles
var corners:[Int] = []

for key in tileDic.keys {
    var sideMatch = 0
    for s1 in 0..<4 {
        for key2 in tileDic.keys {
            if key == key2 { continue }
            for s2 in 0..<4 {
                let side1 = tileDic[key]!.sides[s1]
                let side2 = tileDic[key2]!.sides[s2]
                if side1 == side2 {
                    sideMatch += 1
                    tileDic[key]!.matchingTiles.insert(key2)
                    tileDic[key2]!.matchingTiles.insert(key)
                }
                if side1 == String(side2.reversed()) {
                    sideMatch += 1
                    tileDic[key]!.matchingTiles.insert(key2)
                    tileDic[key2]!.matchingTiles.insert(key)
                }
            }
        }     
    }
    if sideMatch == 2 {
        part1 *= key
        corners.append(key)
    }
}

print ("part 1: \(part1)") //18411576553343

let sideLength = Int(sqrt(Double(tileDic.count)))

let monster = """
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
"""

var tileOrder:[Int] = [corners[0]]

var processed:Set<Int> = [corners[0]]
var q:[Int] = [corners[0]]

while q.count > 0 {
    let curTile = q.removeLast()
    // find next tile in every direction
    for match in tileDic[curTile]!.matchingTiles {
        if processed.contains(match) { continue }
        var oriented = false
        for i in 0..<4 {
            for side in 0..<4 {
                var tile = tileDic[match]!
                let cur = tileDic[curTile]!
                var matched = false
                if tile.sides[i] == cur.sides[side] {
                    matched = true
                } else if String(tile.sides[i].reversed()) == cur.sides[side] {
                    matched = true
                }

                if matched {
                    // look for orientation of tile that matches current tile's orientationn
                    for _ in 0...2 {
                        tile.flipH()
                        for _ in 0...2 {
                            tile.flipV()
                            for _ in 0...3 {
                                tile.rotateTile()
                                switch side {
                                    case Side.top.rawValue:
                                        if tile.sides[Side.bottom.rawValue] == cur.sides[Side.top.rawValue] {
                                            oriented = true
                                            break
                                        }
                                    case Side.bottom.rawValue:
                                        if tile.sides[Side.top.rawValue] == cur.sides[Side.bottom.rawValue] {
                                            oriented = true
                                            break
                                        }
                                    case Side.right.rawValue:
                                        if tile.sides[Side.left.rawValue] == cur.sides[Side.right.rawValue] {
                                            oriented = true
                                            break
                                        }
                                    case Side.left.rawValue:
                                        if tile.sides[Side.right.rawValue] == cur.sides[Side.left.rawValue] {
                                            oriented = true
                                            break
                                        }
                                    default:
                                        assert(false)
                                        break
                                } // switch
                            }
                            if oriented == true { break }
                        }
                        if oriented == true { break }
                    }
                    assert(oriented == true)
                }
                if oriented == true { break }
            }
            if oriented == true { break }
        }

        q.append(match)
        processed.insert(match)
    }
}

// find and start at top left corner