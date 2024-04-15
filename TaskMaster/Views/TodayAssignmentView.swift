//
//  TodayAssignmentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI

struct TodayAssignmentView: View {
    var viewModel: TaskMasterViewModel
    @State var selectedAssignment: Assignment?
    
    var body: some View {
        VStack {
            if let _ = selectedAssignment {
                AssignmentDetailView(viewModel: viewModel, assignment: $selectedAssignment)
            }
            else {
                Text(viewModel.date)
                    .italic()
                    .font(.title3)
                    .padding()
                if viewModel.todayAssign.values.allSatisfy({$0 == []}) {
                    List {
                        Text("Nothing to do today!")
                            .padding()
                            .frame(alignment: .center)

                    }
                }
                else {
                    List(Array(viewModel.todayAssign.keys), id: \.self, selection: $selectedAssignment) {course in
                        if viewModel.todayAssign[course] != [] {
                            Text(viewModel.courses.first(where: {$0.id == course})?.courseName ?? "Name could not be found")
                                .bold()
                            ForEach( viewModel.todayAssign[course] ?? [], id: \.self) {assign in
                                HStack {
                                    if assign.isComplete ?? false {
                                        Text("\(assign.assignName ?? "no name") \n DUE \(assign.timeDue)")
                                            .strikethrough()
                                            .onTapGesture {
                                                viewModel.markComplete(assign: assign)
                                            }
                                            .padding()
                                    }
                                    else {
                                        Text("\(assign.assignName ?? "no name") \n DUE \(assign.timeDue)")
                                            .onTapGesture {
                                                viewModel.markComplete(assign: assign)
                                            }
                                            .padding()
                                    }
                                } .onTapGesture {
                                    if let assign = selectedAssignment {
                                        viewModel.markComplete(assign: assign)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    TodayAssignmentView()
//}
