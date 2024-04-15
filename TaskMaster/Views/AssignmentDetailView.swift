//
//  AssignmentDetailView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI
import WebKit

struct AssignmentDetailView: View {
    var viewModel: TaskMasterViewModel
    @Binding var assignment: Assignment?
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                assignment = nil
            } label: {
                Image(systemName: "chevron.left")
            }
            .frame(alignment: .leading)
            VStack {
                Text(assignment?.assignName ?? "Assignment name not found")
                    .bold()
                    .padding()
                HStack {
                    if let dueDate = assignment?.dueDate {
                        Text("DUE \(viewModel.dateFormatter.string(from: dueDate))")
                            .padding(.leading)
                    } else {
                        Text("No due date")
                    }
                    
                    if let points = assignment?.pointsPossible {
                        Text(String(format: "%.2f pts.", points))
                    }
                    
                }
                if let assignLink = assignment?.assignURL {
                    Link("View Assignment", destination: assignLink)
                }
                Text(assignment?.description ?? "")
                
            }
        }
        .padding()
        
    }
}

//#Preview {
//    AssignmentDetailView()
//}
