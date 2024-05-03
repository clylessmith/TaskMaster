//
//  CourseDetailView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI
import WebKit

struct CourseDetailView: View {
    @State var viewModel: TaskMasterViewModel
    @State var dataModel: TaskMasterDataModel
    
    @Bindable var selectionManager: SelectionManager
    
    @State var showEdit:Bool = false
    @State var selectedAssignment: Assignment?

    var body: some View {
        VStack {
            if let _ = selectedAssignment {
                AssignmentDetailView(dataModel: dataModel,
                                     assignment: $selectedAssignment)
            } else {
                HStack(alignment: .top) {
                    Text(selectionManager.selectedCourse?.courseName ?? "Current course")
                    Spacer()
                    Button {
                        showEdit = !showEdit
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .frame(alignment: .trailing)
                    .padding()
                    Button {
                        selectionManager.selectedCourse = nil
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .frame(alignment: .trailing)
                    .padding()
                }
                .padding()
                .background(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).fill(Color.gray))
                
                if showEdit {
                    if let _ = selectionManager.selectedCourse {
                        EditCourseView(viewModel: viewModel, 
                                       dataModel: dataModel,
                                       course: selectionManager.selectedCourse)
                    }
                }
                
                if let existCourse = selectionManager.selectedCourse {
                    if let assignments = dataModel.assignments[existCourse.id] {
                        List(assignments,id: \.self ,selection: $selectedAssignment) { assign in
                            Group {
                                Text("\(assign.assignName ?? "no name")")
                                    .strikethrough(assign.isComplete ?? false)
                                if let dueDate = assign.dueDate {
                                    Text("DUE \(dataModel.dateFormatter.string(from: dueDate))")
                                        .padding(.leading)
                                        .strikethrough(assign.isComplete ?? false)
                                }
                                else {
                                    Text("NO DUE DATE")
                                        .padding(.leading)
                                        .strikethrough(assign.isComplete ?? false)
                                }
                            }
                            .onTapGesture {
                                dataModel.markComplete(assign: assign)
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
