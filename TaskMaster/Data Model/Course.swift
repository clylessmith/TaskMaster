//
//  Course.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation
import SwiftUI

struct Course: Identifiable {

    // MARK: GET /api/v1/courses
    
    var id: UUID
    
    var courseID: Int
    
    var courseName, courseCode: String?
    var originalName: String?
    var endDate: Date?
        
    var color: Color
    var hidden: Bool
        
    let dateFormatter = DateFormatter()
    private var dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
    //"2022-10-05T06:00:00Z"
    
    
    init(courseID: Int, name: String, courseCode: String, originalName: String? = nil) {
        self.id = UUID()
        self.courseName = name
        self.courseID = courseID
        self.courseCode = courseCode
        self.originalName = originalName
        self.color = Color.gray
        self.hidden = false
    }
}

extension Course: Decodable {
    init(from decoder: any Decoder) throws {
        self.id = UUID()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.courseID = try values.decode(Int.self, forKey: .courseID)
        self.courseName = try values.decodeIfPresent(String.self, forKey: .courseName) ?? nil
        self.courseCode = try values.decodeIfPresent(String.self, forKey: .courseCode) ?? nil
        self.originalName = try values.decodeIfPresent(String.self, forKey: .originalName) ?? nil
        
        let dateString = try values.decodeIfPresent(String.self, forKey: .endDate) ?? nil
        dateFormatter.dateFormat = dateFormat
        self.endDate = dateFormatter.date(from: dateString ?? "")
        
        
        if self.endDate ?? Date() < Date() {
            self.hidden = true
        }
        else {
            self.hidden = false
        }
        
        self.color = Color.gray
    }
    
    enum CodingKeys: String, CodingKey {
        case courseID = "id"
        case courseName = "name"
        case courseCode = "course_code"
        case originalName = "original_name"
        case endDate = "end_at"
    }
}

extension Course: Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.courseID == rhs.courseID
    }
    
}

extension Course:Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}


