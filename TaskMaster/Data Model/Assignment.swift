//
//  Assignment.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation

struct Assignment: Identifiable {

    // MARK: GET /api/v1/courses/:course_id/assignments
    
    let id = Assignment.ID()
    
    var assignID: Int
    
    var assignName: String?
    
    var description: String?
    
    var dueDate: Date?
    
    let dateFormatter = DateFormatter()
    
    // MARK: source - https://www.agnosticdev.com/content/how-convert-swift-dates-timezone
    private var dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
    // 2024-02-03T06:59:59Z
    let timezoneOffset =  TimeZone.current.secondsFromGMT()
    private var timeFormat = "HH:mm:ss"
    
    var timeDue: String
    
    var courseID: Int
    
    var assignURLString: String?
    
    var assignURL: URL?
        
    var pointsPossible: Float?
    
    var urgency: Urgency?
    
    var isComplete: Bool?
    
    init(assignID: Int, name: String? = nil, description: String? = nil, dueDate: Date? = nil, courseID: Int, assignURL: String? = nil, pointsPossible: Float? = nil, timeDue: String) {
        self.assignID = assignID
        self.assignName = name
        self.description = description
        self.dueDate = dueDate
        self.courseID = courseID
        self.assignURLString = assignURL
        self.assignURL = URL(string: assignURL ?? "")
        self.pointsPossible = pointsPossible
        self.urgency = nil
        self.timeDue = timeDue
        self.isComplete = false
    }
    
    struct ID: Identifiable, Hashable {
        var id = UUID()
    }
    
    enum Urgency {
        case urgent
        case medium
        case low
    }
}

extension Assignment: Decodable {
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.assignID = try values.decode(Int.self, forKey: .assignId)
        self.assignName = try values.decodeIfPresent(String.self, forKey: .assignName)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
//        if let desc = self.description {
//            self.description = desc.
//        }
        
        let dateString = try values.decodeIfPresent(String.self, forKey: .dueDate) ?? nil
        print("Assign: \(self.assignName ?? ""), due date: \(dateString ?? "")")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = .current
        self.dueDate = dateFormatter.date(from: dateString ?? "")
        if let due = self.dueDate {
            self.dueDate = due + Double(timezoneOffset)
        }
        
        dateFormatter.dateFormat = timeFormat
        if let dateDue = self.dueDate {
            self.timeDue = dateFormatter.string(from: dateDue)
        } else {
            self.timeDue = ""
        }
        
        self.courseID = try values.decode(Int.self, forKey: .courseID)
        self.assignURLString = try values.decodeIfPresent(String.self, forKey: .assignURL)
        self.assignURL = URL(string: self.assignURLString ?? "")
        self.pointsPossible = try values.decodeIfPresent(Float.self, forKey: .pointsPossible)
        self.urgency = nil
        self.isComplete = try values.decodeIfPresent(Bool.self, forKey: .submitted) ?? false
    }
    
    enum CodingKeys: String, CodingKey {
        case assignId = "id"
        case assignName = "name"
        case description
        case dueDate = "due_at"
        case courseID = "course_id"
        case assignURL = "html_url"
        case pointsPossible = "points_possible"
        case submitted = "has_submitted_submissions"
    }
}

extension Assignment: Equatable {
    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.assignID == rhs.assignID
    }
}

extension Assignment: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

