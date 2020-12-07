import Foundation

func findBag(_ bag: String, _ bagDict: [String: [(num:Int, color:String)]]) -> Bool {    
    if (bag == "shiny gold") {
        return true
    } else if (bagDict[bag]!.count == 0) {
        return false
    } else {
        for b in bagDict[bag]! {
            if findBag(b.color, bagDict) == true {
                return true;
            }
        }
    }

    return false
}

func countBag(_ bag: String, _ bagDict: [String: [(num:Int, color:String)]]) -> Int64 {
    var sum: Int64 = 0
    for b in bagDict[bag]! {
        let n = countBag(b.color, bagDict)
        if (n > 0) {
            sum += Int64(b.num) + Int64(b.num) * n
        } else {
            sum += Int64(b.num)
        }
    }

    return sum
}

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy: "\n")

var bagDict: [String: [(num:Int, color:String)]] = [:]

// read in the bags into a dict
for line in lines {
    let key = line.components(separatedBy: " bag")[0]
    let bagsString = line.components(separatedBy: "contain")[1]
    var contents: [(num:Int, color:String)] = []
    if (bagsString != " no other bags.") {
        let bags = bagsString.components(separatedBy: ",")
        for bag in bags {
            let components = bag.components(separatedBy:" ")
            let n: Int = Int(components[1])!
            let bagName = components[2] + " " + components[3]
            contents.append((num:n, color:bagName))
        }
    }

    bagDict[key] = contents
}

var part1 = 0

for key in bagDict.keys {
    if (findBag(key, bagDict)) {
        if (key == "shiny gold") {
            continue
        }
        part1 += 1
    }
}

print ("part 1: \(part1)")

var part2 = countBag("shiny gold", bagDict)

print ("part 2: \(part2)")

