import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

var allergens:Set<String> = []
var foods:Set<String> = []
var possibilityMap:[String:[Set<String>]] = [:]

for line in lines {
    var lineFoods:Set<String> = []
    for f in line.components(separatedBy:" (")[0].split(separator:" ") {
        lineFoods.insert(String(f))
        foods.insert(String(f))
    }

    for a in line.components(separatedBy:" (contains ")[1]
        .replacingOccurrences(of:")", with:"")
        .replacingOccurrences(of:",", with:"")
        .split(separator:" ") {
        allergens.insert(String(a))
        if possibilityMap[String(a)] == nil {
            possibilityMap[String(a)] = [lineFoods]    
        } else {
            possibilityMap[String(a)]!.append(lineFoods)
        }
    }
}

var filtered:[String:Set<String>] = [:]
for a in allergens {
    var intersect:Set<String> = possibilityMap[a]![0]

    for i in 1..<possibilityMap[a]!.count {
        intersect = intersect.intersection(possibilityMap[a]![i])
    }
    filtered[a] = intersect
}

var processed:Set<String> = []

// find create allergen map
var foodMap:[String:String] = [:]
while processed.count < allergens.count {
    var current = ""
    for a in allergens {
        if filtered[a]!.count == 1 && processed.contains(filtered[a]!.first!) == false {
            processed.insert(filtered[a]!.first!)
            foodMap[a] = filtered[a]!.first!
            current = filtered[a]!.first!
            break
        }
    }

    assert(current != "")

    for a in allergens {
        if filtered[a]!.count > 1 {
            filtered[a]!.remove(current)
        }
    }
}

var nonAllergens:Set<String> = foods.subtracting(processed)

var part1 = 0
for food in nonAllergens {
    for line in lines {
        for tok in line.components(separatedBy:" (")[0].split(separator:" ") {
            if String(tok) == food {
                part1 += 1
            }
        }
    }
}

print ("part 1: \(part1)")

var allergenArray = Array(allergens)
allergenArray.sort()

var part2 = allergenArray.map{foodMap[$0]!}.joined(separator:",")

print ("part 1: \(part2)")
