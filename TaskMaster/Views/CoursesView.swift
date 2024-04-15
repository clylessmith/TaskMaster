//
//  CoursesView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/8/24.
//

import SwiftUI

struct CoursesView: View {
    var viewModel: TaskMasterViewModel
    @State var selectedCourse: Course?
    @State var showHiddenCourses: Bool = false
    
    var body: some View {
        VStack {
            if let _ = selectedCourse {
                CourseDetailView(viewModel: viewModel, course: $selectedCourse)
                
            } else {
                HStack {
                    Text("Courses")
                        .fontWeight(.bold)
                        .padding()
                        .frame(alignment: .leading)
                    Spacer()
                    Button {
                        showHiddenCourses = !showHiddenCourses
                    } label: {
                        showHiddenCourses ? Image(systemName: "eye") : Image(systemName: "eye.slash")
                    } .help(Text("\(showHiddenCourses ? "Hide" : "Show") hidden"))
                    .frame(alignment: .trailing)
                }
                
                List(showHiddenCourses ? viewModel.courses : viewModel.courses.filter({$0.hidden == false}), id: \.self, selection: $selectedCourse) {course in
                    Text(course.courseName ?? "No name")
                        .padding()
                        .background(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).fill(course.color))
                        
                }
                
            }
        }
        
    }
}

