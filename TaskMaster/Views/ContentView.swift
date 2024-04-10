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
                //.frame(width: 450, height: 300, alignment: .center)
                    .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                    .border(Color.gray)
                    .padding()
            }
            .padding()
            CalendarView()
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .cornerRadius(8)
                .border(Color.gray)
                .padding()
            VStack {
                
                TodayAssignmentView(viewModel: viewModel)
                    .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                
                    .border(Color.gray)
                    .padding()
                Button("Refresh assignments") {
                    Task {
                        try? await viewModel.update()
                        for course in viewModel.courses {
                            print(course.courseName ?? "no name")
                        }
                    }
                }
                .padding()
                
                Text("Manual task")
                    .padding()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
