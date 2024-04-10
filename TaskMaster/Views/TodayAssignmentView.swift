//
//  TodayAssignmentView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI

struct TodayAssignmentView: View {
    var viewModel: TaskMasterViewModel
    
    var body: some View {
        VStack {
            Text("Todo: \(viewModel.date)")
//            List(viewModel.assignments) {assign in
//                Text("\(assign.assignName ?? "no name") DUE \(viewModel.dateFormatter.string(from: assign.dueDate ?? Date()))")
//            }
        }
    }
}

//#Preview {
//    TodayAssignmentView()
//}
