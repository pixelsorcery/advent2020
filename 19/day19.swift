import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

var rules:[Int:[String]] = [:]

var idx = 0
for line in lines {
    if line == "" { break }

    let tok = line.components(separatedBy:": ")
    let key = Int(tok[0])!
    let vals = tok[1].components(separatedBy:" | ").map{$0.replacingOccurrences(of:"\"", with:"")}
    rules[key] = vals
    idx += 1
}

// generate regex
func generateRegex(_ key: Int) -> String {
    var string = ""
    let vals = rules[key]!

    string += "("
    for val in vals {
        let separateVal = val.split(separator:" ").map{ Int($0)!}
        
        for num in separateVal {
            if rules[num]![0] == "a" || rules[num]![0] == "b" {
                string += rules[num]![0]
            } else { 
                string += generateRegex(num)
            }
        }
        string += "|"
    }
    string.removeLast()
    string += ")"

    return string
}
var pattern = "^" + generateRegex(0) + "$"

var regex = try! NSRegularExpression(pattern: pattern)

idx += 1

var part1 = 0
for i in 0..<lines.count{
    let range = NSRange(location: 0, length: lines[i].utf16.count)
    if regex.firstMatch(in: lines[i], options: [], range: range) != nil {
        part1 += 1
    }
}

print ("part 1: \(part1)")

path = Bundle.main.path(forResource: "input2", ofType: "txt")!
text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
lines = text.components(separatedBy:"\n")

rules = [:]

idx = 0
for line in lines {
    if line == "" { break }

    let tok = line.components(separatedBy:": ")
    let key = Int(tok[0])!
    let vals = tok[1].components(separatedBy:" | ").map{$0.replacingOccurrences(of:"\"", with:"")}
    rules[key] = vals
    idx += 1
}

// generate regex
func generateRegex(_ key: Int, _ depth: Int) -> String {
    
    if depth > 20 {
        return ""
    }
    
    var string = ""
    let vals = rules[key]!

    string += "("
    for val in vals {
        let separateVal = val.split(separator:" ").map{ Int($0)!}
        
        for num in separateVal {
            if rules[num]![0] == "a" || rules[num]![0] == "b" {
                string += rules[num]![0]
            } else { 
                string += generateRegex(num, depth+1)
            }
        }
        string += "|"
    }
    string.removeLast()
    string += ")"

    return string
}

pattern = "^" + generateRegex(0, 0) + "$"

regex = try! NSRegularExpression(pattern: pattern)

idx += 1

var part2 = 0
for i in 0..<lines.count{
    let range = NSRange(location: 0, length: lines[i].utf16.count)
    if regex.firstMatch(in: lines[i], options: [], range: range) != nil {
        part2 += 1
    }
}

print ("part 2: \(part2)")