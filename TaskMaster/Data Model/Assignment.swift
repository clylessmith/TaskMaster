//
//  Assignment.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation

class Assignment: Identifiable, Decodable, Equatable {

    // MARK: GET /api/v1/courses/:course_id/assignments
    
    let id = Assignment.ID()
    
    var assignID: Int
    
    var assignName: String?
    
    var description: String?
    
    var dueDate: Date?
    
    let dateFormatter = DateFormatter()
    private var dateFormat = "YYYY-MM-DD'T'HH:mm:ss'Z'"
    
    var courseID: Int
    
    var assignURL: String?
        
    var pointsPossible: Float?
    
    init(assignID: Int, name: String? = nil, description: String? = nil, dueDate: Date? = nil, courseID: Int, assignURL: String? = nil, pointsPossible: Float? = nil) {
        self.assignID = assignID
        self.assignName = name
        self.description = description
        self.dueDate = dueDate
        self.courseID = courseID
        self.assignURL = assignURL
        self.pointsPossible = pointsPossible
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.assignID = try values.decode(Int.self, forKey: .assignId)
        self.assignName = try values.decodeIfPresent(String.self, forKey: .assignName)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        
        let dateString = try values.decodeIfPresent(String.self, forKey: .dueDate) ?? nil
        dateFormatter.dateFormat = dateFormat
        self.dueDate = dateFormatter.date(from: dateString ?? "")
        
        self.courseID = try values.decode(Int.self, forKey: .courseID)
        self.assignURL = try values.decodeIfPresent(String.self, forKey: .assignURL)
        self.pointsPossible = try values.decodeIfPresent(Float.self, forKey: .pointsPossible)
    }
    
    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.assignID == rhs.assignID
    }
    
    enum CodingKeys: String, CodingKey {
        case assignId = "id"
        case assignName = "name"
        case description
        case dueDate = "due_at"
        case courseID = "course_id"
        case assignURL = "html_url"
        case pointsPossible = "points_possible"
    }
    
    struct ID: Identifiable, Hashable {
        var id = UUID()
    }
}
