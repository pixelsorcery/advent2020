
import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let grid = text.split(separator: "\n")

let width = grid[0].count
var x = 0;
var part1 = 0
for line in grid {
    if line[x] == "#" {
        part1 += 1
    }
    x = (x + 3) % width
}

print ("Part 1: \(part1)")

let height = grid.count

let slopes : [(x: Int, y : Int)] = [(1,1), (3, 1), (5, 1), (7, 1), (1, 2)]

var part2 = 1

for slope in slopes {
    var y = 0
    var x = 0
    var temp = 0
    while (y < height)
    {
        assert(x < width)
        if grid[y][x] == "#" {
            temp += 1
        }
        x = (x + slope.x) % width
        y += slope.y
    }
    part2 *= temp
}

print ("Part 2: \(part2)")