//
//  Assignment.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation
import SwiftData

@Model
final class Assignment: Identifiable, Decodable, Equatable, Hashable {
    
    // MARK: GET /api/v1/courses/:course_id/assignments
    
    // MARK: Properties
    var id: UUID
    var assignId: Int
    var assignName: String?
    var desc: String?
    var dueDate: Date?
    var timeDue: String?
    var courseID: Int
    var assignURL: URL?
    var pointsPossible: Float?
    //var urgency: Urgency?
    var isComplete: Bool?
    
    // MARK: Computed properties for URL and date adjustments
    var adjustedURL: URL? {
        guard let token = ProcessInfo.processInfo.environment["CANVAS_TOKEN"], !token.isEmpty else {
            return assignURL
        }
        return assignURL?.appendingPathComponent("?access_token=\(token)")
    }
    
    // MARK: Initializers
    init(assignId: Int, name: String?, description: String?, dueDate: Date?, courseID: Int, urlString: String?, pointsPossible: Float?, isComplete: Bool) {
        self.id = UUID()
        self.assignId = assignId
        self.assignName = name
        self.desc = description
        self.dueDate = dueDate
        self.courseID = courseID
        self.assignURL = URL(string: urlString ?? "")
        self.pointsPossible = pointsPossible
        //self.urgency = urgency
        self.isComplete = isComplete
        
        if let dueDate = dueDate {
            self.timeDue = Assignment.formatTime(from: dueDate)
        }
    }
    
    // MARK: Decoding
    required init(from decoder: Decoder) throws {
        self.id = UUID()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        assignId = try values.decode(Int.self, forKey: .id)
        assignName = try values.decodeIfPresent(String.self, forKey: .name)
        desc = try values.decodeIfPresent(String.self, forKey: .description)
        let dateString = try values.decodeIfPresent(String.self, forKey: .dueDate)
        dueDate = Assignment.dateFormatter.date(from: dateString ?? "")
        courseID = try values.decode(Int.self, forKey: .courseID)
        let urlString = try values.decodeIfPresent(String.self, forKey: .url)
        assignURL = URL(string: urlString ?? "")
        pointsPossible = try values.decodeIfPresent(Float.self, forKey: .pointsPossible)
        //urgency = try values.decodeIfPresent(Urgency.self, forKey: .urgency)
        isComplete = try values.decodeIfPresent(Bool.self, forKey: .isComplete) ?? false
        timeDue = dueDate.map { Assignment.formatTime(from: $0) }
    }
    
    // MARK: Equatable and Hashable
    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.assignId == rhs.assignId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Private Helpers
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private static func formatTime(from date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter.string(from: date)
    }
    
//    struct ID: Identifiable, Hashable {
//        var id = UUID()
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case dueDate = "due_at"
        case courseID = "course_id"
        case url = "html_url"
        case pointsPossible = "points_possible"
        case urgency
        case isComplete = "has_submitted_submissions"
    }
}
