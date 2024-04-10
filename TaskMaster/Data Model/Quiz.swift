//
//  Quiz.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation

class Quiz: Identifiable {
    
    // MARK: GET /api/v1/courses/:course_id/quizzes
    
    let id = Quiz.ID()
    
    var quizID: Int
    
    var title: String
    
    var htmlURL: URL
    
    var description: String
    
    var assignmentGroupID: Int
    
    var pointsPossible: Float
    
    var dueDate: Date
    
    init(quizID: Int, title: String, htmlURL: URL, description: String, assignmentGroupID: Int, pointsPossible: Float, dueDate: Date) {
        self.quizID = quizID
        self.title = title
        self.htmlURL = htmlURL
        self.description = description
        self.assignmentGroupID = assignmentGroupID
        self.pointsPossible = pointsPossible
        self.dueDate = dueDate
    }
    
    
    struct ID: Identifiable, Hashable {
        var id = UUID()
    }
}
