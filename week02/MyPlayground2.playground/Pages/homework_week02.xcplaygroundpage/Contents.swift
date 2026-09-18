import Foundation

// the character's lines, empty means that it stays silent
let conversation = [
    "hello, this is my first line.",
    "",
    "i am an ascii character.",
    "i am made of vertical bars,",
    "dots, and slashes.",
    ""
]
// blank columns between the face and the bubble
let blank = 2
// how far the bubble is from the top, aligned to face
let bubblePosition = 6

// reading the text files from resources
func load(_ file: String) -> String {
    let path = Bundle.main.path(forResource: file, ofType: nil)
    let text = try? String(contentsOfFile: path!, encoding: .utf8)
    return text!
}

// cutting long text into a list of separate lines
func splitLines(_ text: String) -> [String] {
    // omittingEmptySequences is at false to keep blank lines from the face itself
    let pieces = text.split(separator: "\n", omittingEmptySubsequences: false)
    return pieces.map {String($0)}
}

// two faces - one with mouth closed
let faceSilent = splitLines(load("face1.txt"))
// one with mouth open
let faceTalking = splitLines(load("face2.txt"))

// measuring the widest line in a block of ascii art
func widestLine(of block: [String]) -> Int {
    var widest = 0
    for line in block {
        if line.count > widest {
            widest = line.count
        }
    }
    
    return widest
}

// drawing a bubble to fit the given text
func bubble(saying text: String) -> [String] {
    // width is the text plus one space on each side
    let width = text.count + 2
    // formatting the bubble borders
    let top = " " + String(repeating: "_", count: width)
    let middle = "< " + text + " >"
    let bottom = " " + String(repeating: "-", count: width)
    // three lines handed back as a list
    return [top, middle, bottom]
}

// adding empty lines above to push the text block down and align to the face
func blankAbove(_ block: [String], rows: Int) -> [String] {
    var result: [String] = []
    
    // first empty lines are added
    for _ in 0..<rows {
        result.append("")
    }
    
    // then the text block
    for line in block {
        result.append(line)
    }
    
    return result
}

// two blocks of ascii are combines line by line
func combine(_ part1: [String], _ part2: [String], margin: Int) -> [String] {
    // column where the part2 block begins
    let edge = widestLine(of: part1) + margin
    var result: [String] = []
    
    // one turn per line of the part1 block
    for index in 0..<part1.count {
        var line = part1[index]
        // the line is topped with spaces so every row is at the same edge
        line += String(repeating: " ", count: edge - line.count)
        
        // part2 is usually shorter, adding a line if it exists
        if index < part2.count {
            line += part2[index]
        }
        result.append(line)
    }
    return result
}

// building the finished picture for each line
func panel(saying text: String) -> [String] {
    // if there is no text there is no bubble
    if text == "" {
        // and silent face is used
        return faceSilent
    }
    
    // building the bubble and pushing it down to align
    let speech = blankAbove(bubble(saying: text), rows: bubblePosition)
    // combining the bubble and the face
    return combine(faceTalking, speech, margin: blank)
}

// the ascii art block is printed line by line
func show(_ block: [String]) {
    for line in block {
        print(line)
    }
}

// printing the whole monologue
for line in conversation {
    show(panel(saying: line))
    // extra gap between panels
    print("")
}
