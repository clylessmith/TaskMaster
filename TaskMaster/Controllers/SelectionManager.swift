//
//  SelectionManager.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/24/24.
//

import Foundation

@Observable
class SelectionManager {
    
    @ObservationIgnored var delegate: SelectionManagerDelegate?
    
    var selectedCourse: Course? {
        didSet {
            delegate?.selectedCoursesDidChange(selectedCourse)
        }
    }
    
    var selectedAssignID: Assignment? {
        didSet {
            delegate?.selectedAssignIDDidChange(selectedAssignID)
        }
    }
    
    var selectedDate: Date? {
        didSet {
            delegate?.selectedDateDidChange(selectedDate)
        }
    }
    
}

protocol SelectionManagerDelegate {
    func selectedCoursesDidChange(_ course: Course?)
    
    func selectedAssignIDDidChange(_ assign: Assignment?)
    
    func selectedDateDidChange(_ date: Date?)
}
