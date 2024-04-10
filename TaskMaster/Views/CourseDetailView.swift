//
//  CourseDetailView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI

struct CourseDetailView: View {
    @State var viewModel: TaskMasterViewModel
    @Binding var course:Course?
    @State var showEdit:Bool = false

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    course = nil
                } label: {
                    Image(systemName: "chevron.left")
                }
                .frame(alignment: .leading)
                Text((viewModel.courses.first(where: {$0.id == course?.id}) ?? nil)?.courseName ?? "Current course")
                Button {
                    showEdit = !showEdit
                } label: {
                    Image(systemName: "pencil")
                }
                .frame(alignment: .trailing)
                .padding()
            }
            .padding()
            
            if showEdit {
                if let _ = course {
                    EditCourseView(viewModel: viewModel, course: course)
                }
            }
            
            if let existCourse = course {
                if let assignments = viewModel.assignments[existCourse.id] {
                    List(assignments) { assign in
                        Text("\(assign.assignName ?? "no name")")
                        Text("DUE \(viewModel.dateFormatter.string(from: assign.dueDate ?? Date()))")
                            .padding(.leading)
                    }
                } else {
                    List() {
                        Text("No assignments found")
                    }
                }
            }
            
            
        }
    }
}

//#Preview {
//    CourseDetailView()
//}
