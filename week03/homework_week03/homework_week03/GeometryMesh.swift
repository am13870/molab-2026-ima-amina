//
//  GeometryMesh.swift
//  homework_week03
//
//  Created by Amina Magomedova on 24.09.2026.
//

import SwiftUI

// cells across
let ncolumn = 5
// cells down
let nrow = 7
// thickness of the outline
let lineWidth = 6.0
// a gap so shapes do not overlap
let inset = 5.0

// colors and shapes each cell picks from
let colorSpecs = [Color.red, Color.green, Color.yellow, Color.blue, Color.purple]
let shapeSpecs = ["ellipse", "rect", "capsule"]

// storing cell's grid position, shape name, and color
struct CellSpec {
    var row: Int
    var column: Int
    var shape: String
    var color: Color
}

// drawing the grid and rebuilding it on a button press
struct GeometryMesh: View {
    // cells currently on screen, changing redraws the grid
    @State var cells: [CellSpec] = []
    
    var body: some View {
        VStack(spacing: 20) {
            
            // a blank area where the shapes are drawn
            Canvas { context, size in
                // dividing the canvas into equal cells
                let nsize = CGSize(width: size.width / Double(ncolumn), height: size.height / Double(nrow))
                
                // drawing every cell in the array
                for cell in cells {
                    
                    // where the cell is on canvas
                    let cellRect = CGRect(x: Double(cell.column) * nsize.width, y: Double(cell.row) * nsize.height, width: nsize.width, height: nsize.height)
                    // shrinking the cells so figures do not overlap
                    let arect = cellRect.insetBy(dx: inset, dy: inset)
                    // building outline for cell shape
                    let path = shapePath(cell.shape, arect)
                    // drawing the colored stroke only
                    context.stroke(path, with: .color(cell.color), lineWidth: lineWidth)
                }
            }
            
            Button("New Mesh") {
                // a new grid of cells
                cells = makeCells()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Geometry Mesh")
        .onAppear {
            // building the first grid of cells after opening
            cells = makeCells()
        }
    }
}
// building one random cell per grid square
func makeCells() -> [CellSpec] {
    // an empty list
    var result: [CellSpec] = []
    // for each row
    for row in 0..<nrow {
        // and for each cell in that row
        for column in 0..<ncolumn{
            
            // picking one item out of an array at random - shape and color
            let shape = shapeSpecs.randomElement()!
            let color = colorSpecs.randomElement()!
            // stroing the cell's position and two random choices
            result.append(CellSpec(row: row, column: column, shape: shape, color: color))
        }
    }
    return result
}
// turning the shape into a path that fills the giver rectangle
func shapePath(_ shape: String, _ arect: CGRect) -> Path {
    
    if shape == "ellipse" {
        return Path(ellipseIn: arect)
    }
    
    if shape == "capsule" {
        return Capsule().path(in: arect)
    }
    return Rectangle().path(in: arect)
}

#Preview {
    GeometryMesh()
}
