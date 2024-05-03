//
//  Course.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Course: Identifiable, Decodable, Equatable, Hashable {
    
    // MARK: GET /api/v1/courses
    
    // MARK: Properties
    var id: UUID
    var courseID: Int
    var courseName: String?
    var code: String?
    var originalName: String?
    var endDate: Date?
    var hidden: Bool

    // MARK: Initializers
    init(courseID: Int, name: String?, code: String?, originalName: String? = nil, endDate: Date? = nil) {
        self.id = UUID()
        self.courseID = courseID
        self.courseName = name
        self.code = code
        self.originalName = originalName
        self.endDate = endDate
        self.hidden = endDate.map { $0 < Date() } ?? false
    }

    // MARK: Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        courseID = try values.decode(Int.self, forKey: .courseID)
        courseName = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        let dateString = try values.decodeIfPresent(String.self, forKey: .endDate)
        hidden = false
        endDate = Course.dateFormatter.date(from: dateString ?? "")
        if self.endDate ?? Date() < Date() {
            self.hidden = true
        }
        else {
            self.hidden = false
        }
    }

    // MARK: Equatable and Hashable
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.courseID == rhs.courseID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(courseID)
    }

    // MARK: Private Helpers
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    enum CodingKeys: String, CodingKey {
        case courseID = "id"
        case name = "name"
        case code = "course_code"
        case originalName = "original_name"
        case endDate = "end_at"
    }
}



