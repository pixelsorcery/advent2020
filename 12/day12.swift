import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy: "\n")

let N: (x:Int, y:Int) = (0, 1)
let E: (x:Int, y:Int) = (1, 0)
let S: (x:Int, y:Int) = (0, -1)
let W: (x:Int, y:Int) = (-1, 0)

let dirs = [E, S, W, N]
let dirDic: [Substring:(x:Int, y:Int)] = ["E": E, "S": S, "W": W, "N": N]
var curDir = 0
var curPos: (x:Int, y:Int) = (0,0)


for line in lines {
    let amt = Int(line.filter("1234567890".contains))!
    let dir = line.prefix(1)
    switch(dir) {
        case "F":
            curPos.x += dirs[curDir].x * amt
            curPos.y += dirs[curDir].y * amt
        case "R":
            curDir = (curDir + (amt/90)) % 4
        case "L":
            curDir = ((curDir - (amt/90)) + 4) % 4
        default:
            curPos.x += dirDic[dir]!.x * amt
            curPos.y += dirDic[dir]!.y * amt
    }
}

print ("part 1: \(abs(curPos.x) + abs(curPos.y))")

curPos = (0, 0)
var wayPt: (x:Int, y:Int) = (10, 1)

for line in lines {
    let amt = Int(line.filter("1234567890".contains))!
    let dir = line.prefix(1)

    switch(dir) {
        case "F":
            curPos.x += wayPt.x * amt
            curPos.y += wayPt.y * amt
        case "R":
            let rot = amt/90
            for _ in 0..<rot {
                let tmp = wayPt.x * -1
                wayPt.x = wayPt.y
                wayPt.y = tmp
            }
        case "L":
            let rot = amt/90
            for _ in 0..<rot {
                let tmp = wayPt.y * -1
                wayPt.y = wayPt.x
                wayPt.x = tmp
            }
        default:
            wayPt.x += dirDic[dir]!.x * amt
            wayPt.y += dirDic[dir]!.y * amt
    }
}

print ("part 2: \(abs(curPos.x) + abs(curPos.y))")
