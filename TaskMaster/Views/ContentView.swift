//
//  ContentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Username")
                    Spacer()
                }
                .frame(alignment: .leading)
                .padding()
                
                Text("TODO: date label")
                Text("Today's assignment list")
                    .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
                    .cornerRadius(8)

                    .border(Color.gray)
                    .padding()
                
                Text("All assignments table")
                    //.frame(width: 450, height: 300, alignment: .center)
                    .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
                    .cornerRadius(8)
                    .border(Color.gray)
                    .padding()
                HStack {
                    Text("Fetch tasks button")
                        .frame(width: 100, alignment: .bottomTrailing)
                        .cornerRadius(8)
                        .border(Color.gray)
                        .padding()
                    Text("Manual tasks button")
                        .frame(width: 100, alignment: .bottomTrailing)
                        .cornerRadius(8)
                        .border(Color.gray)
                        .padding()
                }
            }
            .padding()
            Text("Calendar")
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                .cornerRadius(8)
                .border(Color.gray)
                .padding()
            }
        }
        
        
}

#Preview {
    ContentView()
}
