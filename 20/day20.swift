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

    func printTile() {
        for line in tileData {
            print (line)
        }
        print ("\n")
    }

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
var tileIds:[Int] = []
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
        tileIds.append(tileId)
    }
}

var part1 = 1

// find 4 corner tiles
var corners:[Int] = []
var threes = 0
var fours = 0
for key in tileIds {
    var sideMatch = 0
    for s1 in 0..<4 {
        for key2 in tileIds {
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

    if sideMatch == 3 {
        threes += 1
    }

    if sideMatch == 4 {
        fours += 1
    }

    if sideMatch == 2 {
        part1 *= key
        corners.append(key)
    }
}

assert (threes == 40)
assert (fours == 100)

print ("part 1: \(part1)") //18411576553343

let tilesDim = Int(sqrt(Double(tileDic.count)))

var processed:Set<Int> = [corners[0]]
var q:[Int] = [corners[0]]
while q.count > 0 {
    let curTile = q.removeLast()
    // get next matching tile
    for match in tileDic[curTile]!.matchingTiles {
        if processed.contains(match) { continue }
        var oriented = false
        // find which directions match
        for i in 0..<4 {
            for side in 0..<4 {
                var matched = false
                if tileDic[match]!.sides[i] == tileDic[curTile]!.sides[side] ||
                   String(tileDic[match]!.sides[i].reversed()) == tileDic[curTile]!.sides[side] {
                    matched = true
                }

                if matched {
                    // look for orientation of tile that matches current tile's orientationn
                    for _ in 0...2 {
                        tileDic[match]!.flipH()
                        for _ in 0...2 {
                            tileDic[match]!.flipV()
                            for _ in 0...3 {
                                tileDic[match]!.rotateTile()
                                switch side {
                                    case Side.top.rawValue:
                                        if tileDic[match]!.sides[Side.bottom.rawValue] == tileDic[curTile]!.sides[Side.top.rawValue] {
                                            tileDic[curTile]!.top = match
                                            tileDic[match]!.bottom = curTile
                                            oriented = true
                                            break
                                        }
                                    case Side.bottom.rawValue:
                                        if tileDic[match]!.sides[Side.top.rawValue] == tileDic[curTile]!.sides[Side.bottom.rawValue] {
                                            tileDic[curTile]!.bottom = match
                                            tileDic[match]!.top = curTile
                                            oriented = true
                                            break
                                        }
                                    case Side.right.rawValue:
                                        if tileDic[match]!.sides[Side.left.rawValue] == tileDic[curTile]!.sides[Side.right.rawValue] {
                                            tileDic[curTile]!.right = match
                                            tileDic[match]!.left = curTile
                                            oriented = true
                                            break
                                        }
                                    case Side.left.rawValue:
                                        if tileDic[match]!.sides[Side.right.rawValue] == tileDic[curTile]!.sides[Side.left.rawValue] {
                                            tileDic[curTile]!.left = match
                                            tileDic[match]!.right = curTile
                                            oriented = true
                                            break
                                        }
                                    default:
                                        assert(false)
                                        break

                                } // switch
                                if oriented == true { break }
                            }
                            if oriented == true { 
                                //print ("match:")
                                //tileDic[curTile]!.printTile()
                                //tileDic[match]!.printTile()
                                break }
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

// find neighbors
processed = [corners[0]]
q = [corners[0]]
while q.count > 0 {
    let curTile = q.removeLast()
    // find next tile in every direction
    for match in tileDic[curTile]!.matchingTiles {
        if processed.contains(match) { continue }
        for i in 0..<4 {
            for side in 0..<4 {
                if tileDic[match]!.sides[i] == tileDic[curTile]!.sides[side] {
                    switch side {
                        case Side.top.rawValue:
                            if tileDic[match]!.sides[Side.bottom.rawValue] == tileDic[curTile]!.sides[Side.top.rawValue] {
                                tileDic[curTile]!.top = match
                                tileDic[match]!.bottom = curTile
                                break
                            }
                        case Side.bottom.rawValue:
                            if tileDic[match]!.sides[Side.top.rawValue] == tileDic[curTile]!.sides[Side.bottom.rawValue] {
                                tileDic[curTile]!.bottom = match
                                tileDic[match]!.top = curTile
                                break
                            }
                        case Side.right.rawValue:
                            if tileDic[match]!.sides[Side.left.rawValue] == tileDic[curTile]!.sides[Side.right.rawValue] {
                                tileDic[curTile]!.right = match
                                tileDic[match]!.left = curTile
                                break
                            }
                        case Side.left.rawValue:
                            if tileDic[match]!.sides[Side.right.rawValue] == tileDic[curTile]!.sides[Side.left.rawValue] {
                                tileDic[curTile]!.left = match
                                tileDic[match]!.right = curTile
                                break
                            }
                        default:
                            assert(false)
                            break
                    } // switch
                }
            }
        }
        q.append(match)
    }
    processed.insert(curTile)
}


// find and start at top left corner
var cur = corners[0]
for key in corners {
    if tileDic[key]!.top == 0 && tileDic[key]!.left == 0 {
        cur = key
    }
}

var leftTile = cur

var image:[String] = Array(repeating: "", count: (tileDic[cur]!.tileDataNoBorder.count) * tilesDim)

for y in 0..<tilesDim {
    for _ in 0..<tilesDim {
        for l in 0..<tileDic[cur]!.tileDataNoBorder.count {
            let line = y * tileDic[cur]!.tileDataNoBorder.count + l
            image[line] += tileDic[cur]!.tileDataNoBorder[l]
        }
        cur = tileDic[cur]!.right
    }
    leftTile = tileDic[leftTile]!.bottom
    cur = leftTile
}

// find dragon
func printImage() {
    for line in image {
        print (line)
    }
    print ("\n")
}

func flipImageV() {
    for i in 0..<image[0].count/2 {
        let tmp = image[i]
        image[i] = image[image.count - i - 1]
        image[image.count - i - 1] = tmp
    }
}

func flipImageH() {
    for i in 0..<image[0].count {
        image[i] = String(image[i].reversed())
    }    
}

func rotateImage() {
    var newTileData:[String] = Array(repeating: "", count: image[0].count)
    for i in 0..<image[0].count {
        for j in 0..<image[0].count {
            newTileData[j] += String(image[image[0].count - i - 1].prefix(j+1).suffix(1))
        }
    }
    image = newTileData
}

var monster:[String] = []
monster.append("                  # ")
monster.append("#    ##    ##    ###")
monster.append(" #  #  #  #  #  #   ")

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

func findDragon() -> Bool {
    var found = false
    for y in 0..<image.count - monster.count {
        for x in 0..<image[0].count - monster[0].count {
            var match = true
            for my in 0..<monster.count {
                for mx in 0..<monster[0].count {
                    if monster[my][mx] == "#" && image[y+my][x+mx] == "." {
                        match = false
                    }
                    if match == false { break }
                }
                if match == false { break }
            }
            if match == true {
                found = true
                break
            }
        }
        if found == true { break }
    }
    return found
}

var matchFound = false
for _ in 0...2 {
    for _ in 0...2 {
        for _ in 0...3 {

            matchFound = findDragon()

            if matchFound { break }
            rotateImage()
        }
        if matchFound { break }
        flipImageH()
    }
    if matchFound { break }
    flipImageV()
}

assert(matchFound)

func replaceDragons() -> Int {
    var monsters = 0
    for y in 0..<image.count - monster.count {
        for x in 0..<image[0].count - monster[0].count {
            var match = true
            for my in 0..<monster.count {
                for mx in 0..<monster[0].count {
                    if monster[my][mx] == "#" && image[y+my][x+mx] == "." {
                        match = false
                    }
                    if match == false { break }
                }
                
                if match == false {
                    break
                }
            }

            if match == true {
                monsters += 1
            }
        }
    }
    return monsters
}

var numDragons = replaceDragons()

var waves = 0
for line in image {
    waves += line.filter{$0 == "#"}.count
}

waves -= numDragons * 15

print ("part 2: \(waves)")