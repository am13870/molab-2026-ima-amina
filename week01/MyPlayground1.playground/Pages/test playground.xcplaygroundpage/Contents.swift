// example of a poem (written by me), stored as a list of separate lines
let poem = [
    "this is line one",
    "this is line two",
    "another line",
    "am i a poet?",
    "i am an artist indeed!"
]

// step size for the staircase effect
var stepWidth = 4
// width of the shape in the middle
var rhombusSize = 9

// building a string by repeating one symbol
func makeLine(of symbol: String, count: Int) -> String {
    // starting with empty
    var result = ""
    // if there is no poem return an empty string
    if count <= 0 {
        return result
    }
    // a new symbol is added with each iteration
    for _ in 1...count {
        result += symbol
    }
    return result
}

// printing the heading with empty lines for formatting
func title(_ text: String) {
    let border = makeLine(of: "─", count: 46)
    print("")
    print("")
    print(text)
    print("")
}

// the whole poem is combined as a list of letters with spaces dropped
func lettersCombined(of lines: [String]) -> [Character] {
    var letters: [Character] = []
 
    // go through each line and each letter in this line
    for line in lines {
        for character in line {
            // if the character is not a space add it
            if character != " " {
                letters.append(character)
            }
        }
    }
    return letters
}

// staircase effect - each line is printed with an indentation
func staircase(lines: [String], step: Int) {
    // counting the current line
    var rowNumber = 0
 
    for line in lines {
        let indent = makeLine(of: " ", count: rowNumber * step)
        print(indent + line)
        // each line is pushed one step further
        rowNumber += 1
    }
}

// rhombus effect, the poem fills the shape
func rhombus(lines: [String], size: Int) {
    let letters = lettersCombined(of: lines)
    // checking which letter to use next
    var position = 0
 
    // rhombus shape is two triangles stacked together, the widest line is in the middle - going top to bottom line
    for row in 0..<(size * 2 - 1) {
        //checking the distance from the middle row (size-1) as an absolute value
        let distance = abs(row - (size - 1))
 
        // in the middle the row is the widest, distance is 0 so is the indentation
        let indent = distance
        let width = (size - distance) * 2 - 1
 
        // pusing the row to the right
        var text = makeLine(of: " ", count: indent)
 
        // filling the row with letters
        for _ in 0..<width {
            // if the poem is too short we wrap back to the first letter
            text.append(letters[position % letters.count])
            position += 1
        }
        print(text)
    }
}

// printing the original poem
title("1. the poem")
for line in poem {
    print(line)
}

// printing the staircase version
title("""
         2. the
               p
                o
                 e
                  m
      """)
staircase(lines: poem, step: stepWidth)

// printing the rhombus version
title("""
    3. the    p
           m     o
              e
    """)
rhombus(lines: poem, size: rhombusSize)
