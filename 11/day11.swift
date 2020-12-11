import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy: "\n")

let height = lines.count
let width = lines[0].count

var grid1 = Array(text.filter("L#.".contains))
var grid2 = Array(text.filter("L#.".contains))

let coords: [(x:Int, y:Int)] = [(-1,-1), (-1, 0), (-1, 1), (0, 1), (0, -1), (1, -1), (1, 0), (1, 1)]

var grids: [[String.Element]] = [grid1, grid2]

var gIdx = 0

while (true){
    let nextGrid: Int = (gIdx + 1) % 2

    for y in 0..<height {
        for x in 0..<width {
            let curPos = y * width + x
            if grids[gIdx][curPos] == "." { continue }

            var occupied = 0
            for c in coords {
                let nx = c.x + x
                let ny = c.y + y

                if (nx < 0 || nx == width || ny < 0 || ny == height) { continue }
                
                let checkPos = ny * width + nx
                if grids[gIdx][checkPos] == "#" { occupied += 1 }
            }

            if grids[gIdx][curPos] == "L" && occupied == 0 {
                grids[nextGrid][curPos] = "#"
            } else if grids[gIdx][curPos] == "#" && occupied >= 4 {
                grids[nextGrid][curPos] = "L"
            } else {
                grids[nextGrid][curPos] = grids[gIdx][curPos]
            }
        }
    }

    if (grids[gIdx] == grids[nextGrid]) { break }
    gIdx = nextGrid
}

let part1 = grids[0].filter{$0 == "#"}.count
print ("part 1: \(part1)")

grids = [grid1, grid2]
gIdx = 0

while (true){
    let nextGrid: Int = (gIdx + 1) % 2

    for y in 0..<height {
        for x in 0..<width {
            let curPos = y * width + x
            if grids[gIdx][curPos] == "." { continue }

            var occupied = 0
            for c in coords {
                var nx = c.x + x
                var ny = c.y + y
                while ((nx < 0 || nx == width || ny < 0 || ny == height) != true) {
                    let checkPos = ny * width + nx
                    if grids[gIdx][checkPos] == "#" { 
                        occupied += 1 
                        break;
                    } else if (grids[gIdx][checkPos] == "L") {
                        break;
                    }
                    nx += c.x
                    ny += c.y
                }
            }

            if grids[gIdx][curPos] == "L" && occupied == 0 {
                grids[nextGrid][curPos] = "#"
            } else if grids[gIdx][curPos] == "#" && occupied >= 5 {
                grids[nextGrid][curPos] = "L"
            } else {
                grids[nextGrid][curPos] = grids[gIdx][curPos]
            }
        }
    }

    if (grids[gIdx] == grids[nextGrid]) { break }
    gIdx = nextGrid
}

let part2 = grids[0].filter{$0 == "#"}.count
print ("part 2: \(part2)")