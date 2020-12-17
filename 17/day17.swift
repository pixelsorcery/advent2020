import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let rawText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let text = Array(rawText).filter("#.".contains)
let width = rawText.components(separatedBy:"\n")[0].count

let numSteps = 6

let dim = width + numSteps * 2 + 3
var grids: [[Int]] = [[Int](repeating: 0, count: dim*dim*dim), [Int](repeating: 0, count: dim*dim*dim)]

var curGrid = 0
var nextGrid = 1
func calcXYZ(_ x:Int, _ y:Int, _ z:Int) -> Int {
    return (z * dim * dim) + (y * dim) + x
}

func checkNeighbors(_ xIn:Int, _ yIn:Int, _ zIn:Int) -> Int {
    var activeNeighbors = 0
    for z in zIn-1...zIn+1 {
        for y in yIn-1...yIn+1 {
            for x in xIn-1...xIn+1 {
                if z == zIn && y == yIn && x == xIn { continue }
                if grids[curGrid][calcXYZ(x,y,z)] == 1 {
                    activeNeighbors += 1
                }
            }
        }
    }
    return activeNeighbors
}

// initialize
var startx = (dim / 2) - (width / 2)
var starty = (dim / 2) - (width / 2)
var range = width
var startz = (dim / 2) - (width / 2)
var textIdx = 0
for y in starty..<starty+range {
    for x in startx..<startx+range {
        if text[textIdx] == "." {
            grids[curGrid][calcXYZ(x, y, startz)] = 0
        } else {
            assert (text[textIdx] == "#")
            grids[curGrid][calcXYZ(x, y, startz)] = 1
        }
        textIdx += 1
    }
}

startx -= 1
starty -= 1
startz -= 1
var rangeXY = range + 2
var rangeZ = range + 2

var printString = ""
for _ in 0..<numSteps {
    for z in startz..<startz+rangeZ{
        for y in starty..<starty+rangeXY {
            for x in startx..<startx+rangeXY {
                let numActive = checkNeighbors(x, y, z)
                if (grids[curGrid][calcXYZ(x,y,z)] == 1) {

                    if numActive == 2 || numActive == 3 {
                        grids[nextGrid][calcXYZ(x,y,z)] = 1
                    } else {
                        grids[nextGrid][calcXYZ(x,y,z)] = 0
                    }
                } else {
                    assert(grids[curGrid][calcXYZ(x,y,z)] == 0)

                    if numActive == 3 {
                        grids[nextGrid][calcXYZ(x,y,z)] = 1
                    } else {
                        grids[nextGrid][calcXYZ(x,y,z)] = 0
                    }
                }
                printString += String(grids[nextGrid][calcXYZ(x,y,z)])
            }
            printString += "\n"
        }
        printString += "\n\n"
    }
    rangeXY += 4
    rangeZ += 2
    startx -= 1
    starty -= 1
    startz -= 1
    curGrid = nextGrid
    nextGrid = (curGrid + 1) % 2
    //print (printString)
    //printString = ""
    //print ("******")
}

var part1 = 0

for z in startz..<startz+rangeZ{
    for y in starty..<starty+rangeXY {
        for x in startx..<startx+rangeXY {
            if grids[curGrid][calcXYZ(x,y,z)] == 1 {
                part1 += 1
            }
        }
    }
}
print ("part 1: \(part1)")

grids = [[Int](repeating: 0, count: dim*dim*dim*dim), [Int](repeating: 0, count: dim*dim*dim*dim)]

curGrid = 0
nextGrid = 1
func calcXYZW(_ x:Int, _ y:Int, _ z:Int, _ w:Int) -> Int {
    return (w * dim * dim * dim) + (z * dim * dim) + (y * dim) + x
}

func checkNeighborsXYZW(_ xIn:Int, _ yIn:Int, _ zIn:Int, _ wIn:Int) -> Int {
    var activeNeighbors = 0
    for w in wIn-1...wIn+1{
        for z in zIn-1...zIn+1 {
            for y in yIn-1...yIn+1 {
                for x in xIn-1...xIn+1 {
                    if z == zIn && y == yIn && x == xIn && w == wIn { continue }
                    if grids[curGrid][calcXYZW(x,y,z,w)] == 1 {
                        activeNeighbors += 1
                    }
                }
            }
        }
    }
    return activeNeighbors
}

// initialize
startx = (dim / 2) - (width / 2)
starty = (dim / 2) - (width / 2)
range = width
startz = (dim / 2) - (width / 2)
var startw = (dim / 2) - (width / 2)
textIdx = 0
for y in starty..<starty+range {
    for x in startx..<startx+range {
        if text[textIdx] == "." {
            grids[curGrid][calcXYZW(x, y, startz, startw)] = 0
        } else {
            assert (text[textIdx] == "#")
            grids[curGrid][calcXYZW(x, y, startz, startw)] = 1
        }
        textIdx += 1
    }
}

startx -= 1
starty -= 1
startz -= 1
startw -= 1
rangeXY = range + 2
rangeZ = range + 2
var rangeW = range + 2

for _ in 0..<numSteps {
    for w in startw..<startw+rangeW {
        for z in startz..<startz+rangeZ {
            for y in starty..<starty+rangeXY {
                for x in startx..<startx+rangeXY {
                    let numActive = checkNeighborsXYZW(x, y, z, w)
                    if (grids[curGrid][calcXYZW(x,y,z,w)] == 1) {

                        if numActive == 2 || numActive == 3 {
                            grids[nextGrid][calcXYZW(x,y,z,w)] = 1
                        } else {
                            grids[nextGrid][calcXYZW(x,y,z,w)] = 0
                        }
                    } else {
                        assert(grids[curGrid][calcXYZW(x,y,z,w)] == 0)

                        if numActive == 3 {
                            grids[nextGrid][calcXYZW(x,y,z,w)] = 1
                        } else {
                            grids[nextGrid][calcXYZW(x,y,z,w)] = 0
                        }
                    }
                }
            }
        }
    }
    rangeXY += 2
    rangeZ += 2
    rangeW += 2
    startx -= 1
    starty -= 1
    startz -= 1
    startw -= 1
    curGrid = nextGrid
    nextGrid = (curGrid + 1) % 2
}

var part2 = 0

for w in startw..<startw+rangeW{
    for z in startz..<startz+rangeZ{
        for y in starty..<starty+rangeXY {
            for x in startx..<startx+rangeXY {
                if grids[curGrid][calcXYZW(x,y,z,w)] == 1 {
                    part2 += 1
                }
            }
        }
    }
}
print ("part 2: \(part2)")