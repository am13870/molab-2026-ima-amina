import Foundation

let poem = """
this is line one
this is line two
another line
am i a poet?
i am an artist indeed!
"""

let poemLines = poem.split(separator: "\n").map { String($0) }
let longestLine = poemLines.map { $0.count }.max() ?? 0

class Canvas {
    let rows: Int
    let columns: Int
    var grid: [[Character]]

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: " ", count: columns), count: rows)
    }

    func stamp(_ text: String, row: Int, column: Int) {
        var currentColumn = column
        for character in text {
            if character != " ",
               row >= 0, row < rows,
               currentColumn >= 0, currentColumn < columns {
                grid[row][currentColumn] = character
            }
            currentColumn += 1
        }
    }

    
    func show() {
        for row in grid {
            print(String(row))
        }
    }
}

// staircase effect, each line is pushed to the right by the same step
func staircase(_ lines: [String], step: Int) -> Canvas {
    let canvas = Canvas(rows: lines.count, columns: longestLine + step * lines.count + 2)
    for (index, line) in lines.enumerated() {
        canvas.stamp(line, row: index, column: index * step)
    }
    return canvas
}


// mandala effect, one line stamped around in a circle
func mandala(_ line: String, copies: Int, radius: Double) -> Canvas {
    let size = Int(radius * 2) + line.count + 4
    let canvas = Canvas(rows: Int(radius * 2) + 4, columns: size)
    let centerRow = Double(canvas.rows) / 2
    let centerColumn = Double(canvas.columns) / 2
    for copy in 0..<copies {
        let angle = Double(copy) / Double(copies) * 2 * Double.pi
        let row = centerRow + sin(angle) * radius / 2.2
        let column = centerColumn + cos(angle) * radius - Double(line.count) / 2
        canvas.stamp(line, row: Int(row), column: Int(column))
    }
    return canvas
}

func title(_ text: String) {
    print("\n" + String(repeating: "─", count: 46))
    print(text)
    print(String(repeating: "─", count: 46))
}

title("1. the poem")
poemLines.forEach { print($0) }

title("""
         2. the
               p
                o
                 e
                  m
      """)
staircase(poemLines, step: 4).show()

title("""
    3. the    p
           m     o
              e
    """)
mandala(poemLines[0], copies: 15, radius: 20).show()
