//
//  ContentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    //    @Environment(TaskMasterViewModel.self) private var viewModel
    //    @State var selectedCourse: Course?
    
    @Environment(AppController.self) private var appController: AppController
    
    @State private var visibility_CourseDetail: NavigationSplitViewVisibility = .all
    
    var body: some View {
        @Bindable var viewModel = appController.viewModel
        @Bindable var dataModel = appController.dataModel
        
        HStack {
            NavigationSplitView(columnVisibility: $visibility_CourseDetail) {
                if (!dataModel.courses.isEmpty) {
                    CoursesView(viewModel: viewModel,
                                dataModel: dataModel,
                                selectionManager: appController.selectionManager)
                }
            } detail: {
                if appController.selectionManager.selectedCourse != nil {
                    CourseDetailView(viewModel: viewModel,
                                     dataModel: dataModel,
                                     selectionManager: appController.selectionManager)
                    .frame(minWidth: 200)
                    
                }
            }
            
            //            CoursesView(viewModel: viewModel)
            //                .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
            //                .cornerRadius(8)
            //                //.border(Color.gray)
            //                .padding()
            //            .padding()
            CalendarView(viewModel: appController.viewModel,
                         dataModel: dataModel,
                         selectionManager: appController.selectionManager)
            .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .cornerRadius(8)
            
            //TODO: inspector with options for today assignments, assignment inspector, new event
            TodayAssignmentView(appController: appController)
                .frame(minWidth: 50, maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(8)
            //.border(Color.gray)
                .padding()
            
        }
        .toolbar() {
            ToolbarItem {
                Button {
                    Task {
                        try? await dataModel.update()
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
