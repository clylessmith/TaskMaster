//
//  EditCourseView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI

struct EditCourseView: View {
    var viewModel: TaskMasterViewModel
    var course: Course?
    
    var body: some View {
        Button("\((viewModel.courses.first(where: {$0.id == course?.id}) ?? nil)?.hidden ?? false ? "Show" : "Hide") course") {
            viewModel.updateCourseHidden(course: course)
        }
    }
}

//#Preview {
//    EditCourseView()
//}
