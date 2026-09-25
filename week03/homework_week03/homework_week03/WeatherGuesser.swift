//
//  SymbolsView.swift
//  homework_week03
//
//  Created by Amina Magomedova on 24.09.2026.
//

import SwiftUI

// 7 symbols - one for each day of the week
let nsymbol = 7
// symbol size is associated with this weather probability for the day
let minSymbol = 50.0
let maxSymbol = 100.0
// separate colour palette for the weather symbols
let weatherColors = [Color.blue, Color.cyan, Color.gray, Color.orange, Color.yellow]

// symbols used
let symbolSpecs = ["cloud.drizzle.fill", "sun.max.fill", "sun.min.fill", "cloud.fog.fill", "cloud.bolt.fill", "sun.rain.fill"]

// for each symbol - where it sits, size, and what to draw
struct SymbolSpec {
    var x: Double
    var y: Double
    var width: Double
    var name: String
    var color: Color
}

// scattering the symbols and rebuilding on button press
struct WeatherGuesser: View {
    
    // symbols currently on screen, changing redraws them
    @State private var symbols: [SymbolSpec] = []
    
    var body: some View {
        VStack(spacing: 20) {
            
            // a blank area within which the symbols are drawn
            Canvas { context, size in
                // drawing each symbol in the list
                for symbol in symbols {
                    
                    let image = Image(systemName: symbol.name)
                    // turning icons into drawable shapes
                    var resolved = context.resolve(image)
                    resolved.shading = .color(symbol.color)
                    
                    // calculating height from the width so symbols do not get stretched
                    let awidth = symbol.width
                    let aheight = awidth * resolved.size.height / resolved.size.width
                    // turning fractions into a canvas position, centering the icons on that position
                    let arect = CGRect(x: symbol.x * size.width - awidth / 2, y: symbol.y * size.height - aheight / 2, width: awidth, height: aheight)
                    
                    context.draw(resolved, in: arect)
                }
            }
            
            Button("New Guess") {
                // a new set of symbols
                symbols = makeSymbols()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Weather Guesser")
        .onAppear {
            // the first set after opening
            symbols = makeSymbols()
        }
    }
}
// building a list of symbols with random position, size, and color
func makeSymbols() -> [SymbolSpec] {
    // empty list to be filled
    var result: [SymbolSpec] = []

    for _ in 0..<nsymbol {
        // getting any number between two limits
        let x = Double.random(in: 0...1)
        let y = Double.random(in: 0...1)
        let width = Double.random(in: minSymbol...maxSymbol)
        // randon choice of symbol name and color
        let name = symbolSpecs.randomElement()!
        let color = weatherColors.randomElement()!
        // storing the symbol's position, size, name, and color
        result.append(SymbolSpec(x: x, y: y, width: width, name: name, color: color))
    }
    return result
}

#Preview {
    WeatherGuesser()
}
