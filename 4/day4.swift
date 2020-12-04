import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy: "\n")

var part1 = 0

enum Fields : UInt {
    case byr = 0x1
    case iyr = 0x2
    case eyr = 0x4
    case hgt = 0x8
    case hcl = 0x10
    case ecl = 0x20    
    case pid = 0x40    
    case cid = 0x80
}

var hasField : UInt = 0
for line in lines {
    if (line == "") {
        if hasField == 0x7f || hasField == 0xff {
            part1 += 1
        }
        // reset
        hasField = 0
    }
    else {
        let fields = line.components(separatedBy: " ")
        for field in fields {
            let pre = String(field.prefix(3))
            switch pre {
                case "byr":
                    hasField |= Fields.byr.rawValue
                case "iyr":
                    hasField |= Fields.iyr.rawValue
                case "eyr":
                    hasField |= Fields.eyr.rawValue
                case "hgt":
                    hasField |= Fields.hgt.rawValue
                case "hcl":
                    hasField |= Fields.hcl.rawValue
                case "ecl":
                    hasField |= Fields.ecl.rawValue
                case "pid":
                    hasField |= Fields.pid.rawValue
                case "cid":
                    hasField |= Fields.cid.rawValue                
                default:
                    break
            }
        }
    }
}

print ("part 1: \(part1)")

var part2 = 0
hasField = 0
for line in lines {
    if (line == "") {
        if hasField == 0x7f || hasField == 0xff {
            part2 += 1
        }
        // reset
        hasField = 0
    }
    else {
        let fields = line.components(separatedBy: " ")
        for field in fields {
            let pre = field.components(separatedBy: ":")[0]
            let val = field.components(separatedBy: ":")[1]
            switch pre {
                case "byr":
                    if 1920 <= Int(val) ?? 0 && Int(val) ?? 0 <= 2002 {
                        hasField |= Fields.byr.rawValue
                    }
                case "iyr":
                    if 2010 <= Int(val) ?? 0 && Int(val) ?? 0 <= 2020 {
                        hasField |= Fields.iyr.rawValue
                    }
                case "eyr":
                    if 2020 <= Int(val) ?? 0 && Int(val) ?? 0 <= 2030 {
                        hasField |= Fields.eyr.rawValue
                    }
                case "hgt":
                    if (val.hasSuffix("cm")) {
                        let numVal = val.filter("0123456789.".contains)
                        if 150 <= Int(numVal) ?? 0 && Int(numVal) ?? 0 <= 193 {
                            hasField |= Fields.hgt.rawValue
                        }
                    }
                    if (val.hasSuffix("in")) {
                        let numVal = val.filter("0123456789.".contains)
                        if 59 <= Int(numVal) ?? 0 && Int(numVal) ?? 0 <= 76 {
                            hasField |= Fields.hgt.rawValue
                        }
                    }
                case "hcl":
                    let range = NSRange(location: 0, length: val.utf8.count)
                    let regex = try! NSRegularExpression(pattern: "#[a-f|0-9]{6}")
                    if regex.firstMatch(in: val, options: [], range: range) != nil {
                        hasField |= Fields.hcl.rawValue
                    }
                case "ecl":
                    let vals = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                    if (vals.contains(where: val.contains)) {
                        hasField |= Fields.ecl.rawValue
                    }
                case "pid":
                    let range = NSRange(location: 0, length: val.utf8.count)
                    let regex = try! NSRegularExpression(pattern: "^[0-9]{9}$")
                    if regex.firstMatch(in: val, options: [], range: range) != nil {
                        hasField |= Fields.pid.rawValue
                    }
                case "cid":
                    hasField |= Fields.cid.rawValue                
                default:
                    break
            }
        }
    }
}

print ("part 2: \(part2)")
