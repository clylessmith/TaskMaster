//
//  TodayAssignmentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI
import WebKit

struct TodayAssignmentView: View {
    var appController: AppController
    //var webView: WKWebView
    @State var selectedAssignment: Assignment?
    
    var body: some View {
        VStack {
            if let _ = selectedAssignment {
                AssignmentDetailView(dataModel: appController.dataModel, assignment: $selectedAssignment)
            }
            else {
                Text(appController.dataModel.date)
                    .italic()
                    .font(.title3)
                    .padding()
                if appController.dataModel.todayAssign.values.allSatisfy({$0 == []}) {
                    List {
                        Text("Nothing to do today!")
                            .padding()
                            .frame(alignment: .center)

                    }
                }
                else {
                    List(Array(appController.dataModel.todayAssign.keys), id: \.self, selection: $selectedAssignment) {course in
                        if appController.dataModel.todayAssign[course] != [] {
                            Text(appController.dataModel.courses.first(where: {$0.id == course})?.courseName ?? "Name could not be found")
                                .bold()
                            // MARK: problem - assignment does not update
                            ForEach( appController.dataModel.todayAssign[course] ?? [], id: \.self) {assign in
                                HStack {
                                    Text("\(assign.assignName ?? "no name") \n DUE \(assign.timeDue ?? "no due time")")
                                        .strikethrough(assign.isComplete ?? false)
                                        .onTapGesture {
                                            appController.dataModel.markComplete(assign: assign)
                                        }
                                        .padding()
                                        .frame(alignment: .leading)
                                    Image(systemName: "chevron.right")
                                        .frame(alignment: .trailing)
                                        .onTapGesture {
                                            if let assign = selectedAssignment {
                                                appController.dataModel.markComplete(assign: assign)
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
}

//#Preview {
//    TodayAssignmentView()
//}
