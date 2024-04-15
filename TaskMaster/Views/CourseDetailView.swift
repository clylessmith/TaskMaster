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
    @State var selectedAssignment: Assignment?

    var body: some View {
        VStack {
            if let _ = selectedAssignment {
                AssignmentDetailView(viewModel: viewModel, assignment: $selectedAssignment)
            } else {
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
                        List(assignments,id: \.self ,selection: $selectedAssignment) { assign in
                            Text("\(assign.assignName ?? "no name")")
                                .strikethrough(assign.isComplete ?? false)
                            if let dueDate = assign.dueDate {
                                Text("DUE \(viewModel.dateFormatter.string(from: dueDate))")
                                    .padding(.leading)
                                    .strikethrough(assign.isComplete ?? false)
                            }
                            else {
                                Text("NO DUE DATE")
                                    .padding(.leading)
                                    .strikethrough(assign.isComplete ?? false)
                            }
                            
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
}

//#Preview {
//    CourseDetailView()
//}
