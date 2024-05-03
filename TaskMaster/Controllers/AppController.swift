//
//  AppController.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/24/24.
//

import Foundation
import WebKit

@Observable
class AppController {
    var viewModel: TaskMasterViewModel
    
    var selectionManager: SelectionManager
    
    var dataModel: TaskMasterDataModel
        
    init() {
        viewModel = TaskMasterViewModel()
        selectionManager = SelectionManager()
        dataModel = TaskMasterDataModel()
        
        selectionManager.delegate = self
    }
}

extension AppController: SelectionManagerDelegate {
    func selectedDateDidChange(_ date: Date?) {
        if let localDate = date {
            dataModel.selectedDate = localDate
            dataModel.updateDate(date: localDate)
        }
        
    }
    
    func selectedCoursesDidChange(_ course: Course?) {
        dataModel.selectedCourse = course
    }
    
    func selectedAssignIDDidChange(_ assign: Assignment?) {
        dataModel.selectedAssignment = assign
    }
    
}
