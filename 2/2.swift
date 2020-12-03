import Foundation

var numValid = 0
var numValid2 = 0
while let pass = readLine() {
    let tok = pass.split(separator:" ")
    let minmaxStr = tok[0].split(separator:"-")
    let minmax = minmaxStr.map { Int($0)!}
    let letter = Array(tok[1])[0]

    var numTimes = 0;

    for char in tok[2] {
        if (char == letter) {
            numTimes += 1
        }
    }

    if (numTimes >= minmax[0] && numTimes <= minmax[1]){
        numValid += 1
    }

    let i1 = minmax[0] - 1
    let i2 = minmax[1] - 1
    let firstIdx = Array(tok[2])[i1]
    let secondIdx = Array(tok[2])[i2]

    if (firstIdx != secondIdx && 
        (firstIdx == letter || secondIdx == letter)) {
        numValid2 += 1
    }

}

print ("part 1: \(numValid)")
print ("part 2: \(numValid2)")
