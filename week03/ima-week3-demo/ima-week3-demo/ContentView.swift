//
//  ContentView.swift
//  ima-week3-demo
//
//  Created by Amina Magomedova on 18.09.2026.
//

import SwiftUI

struct ContentView: View {
    @State var count = 0
    var body: some View {
        VStack {
            Text("count \(count)")
                .font(.system(size: 38))
            Spacer()
            
            switch count {
            case 0:
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case 1:
                Image(systemName: "eye")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case 2:
                Image(systemName: "dog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            default: Text("")
            }
            Spacer()
            HStack {
                Button("<") {
                    count = (count - 1) % 3
                    print("up count \(count)")
                }
                .buttonStyle(.bordered)
                .font(.system(size: 24))
                
                Button(">") {
                    count = (count + 1) % 3
                    print ("down count \(count)")
                }
                .buttonStyle(.bordered)
                .font(.system(size: 24))
            }
        }
    }
}

#Preview {
    ContentView()
}
