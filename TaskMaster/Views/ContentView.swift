//
//  ContentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(TaskMasterViewModel.self) private var viewModel
    
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
            
                CoursesView(viewModel: viewModel)
                    .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                    //.border(Color.gray)
                    .padding()
            }
            .padding()
            CalendarView()
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                .cornerRadius(8)
            VStack {
                
                TodayAssignmentView(viewModel: viewModel)
                    .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                
                    //.border(Color.gray)
                    .padding()
                
                
//                Text("Manual task")
//                    .padding()
            }
        }
        .toolbar() {
            ToolbarItem {
                Button {
                    Task {
                        try? await viewModel.update()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help(Text("Refresh assignments"))
                .padding()
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
