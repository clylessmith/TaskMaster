//
//  CoursesView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/8/24.
//

import SwiftUI

struct CoursesView: View {
    @State var viewModel: TaskMasterViewModel
    @State var dataModel: TaskMasterDataModel
    
    @Bindable var selectionManager: SelectionManager
    
    @State var showHiddenCourses: Bool = false
    
    var body: some View {
        /*
        VStack {
//            if let _ = selectedCourse {
//                CourseDetailView(viewModel: viewModel, course: $selectedCourse)
//                
//            } else {
//                HStack {
//                    Text("Courses")
//                        .fontWeight(.bold)
//                        .padding()
//                        .frame(alignment: .leading)
//                    Spacer()
//                    Button {
//                        showHiddenCourses = !showHiddenCourses
//                    } label: {
//                        showHiddenCourses ? Image(systemName: "eye.slash") : Image(systemName: "eye")
//                    } .help(Text("\(showHiddenCourses ? "Hide" : "Show") hidden"))
//                    .frame(alignment: .trailing)
//                }
                NavigationSplitView() {
                    List(showHiddenCourses ? viewModel.courses : viewModel.courses.filter({$0.hidden == false}), id: \.self, selection: $selectedCourse) {course in
                        Text(course.courseName ?? "No name")
                            .padding()
                            .background(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).fill(course.color))
                            
                    }
                } detail: {
                    CourseDetailView(viewModel: viewModel, course: $selectedCourse)
                }
                
                
            //}
        }
         */
        
        List(showHiddenCourses ? dataModel.courses : dataModel.courses.filter({$0.hidden == false}),
             id: \.self,
             selection: $selectionManager.selectedCourse) {course in
            Text(course.courseName ?? "No name")
                .padding()
                .background(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).fill(Color.gray))
                
                
        }
    }
}

