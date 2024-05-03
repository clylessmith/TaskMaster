//
//  Submission.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/17/24.
//

import Foundation
import SwiftData

struct Submission: Identifiable {

    let id = Submission.ID()
    
    var assignID: Int

    struct ID: Identifiable, Hashable {
        var id = UUID()
    }
    
    init(assignID: Int) {
        self.assignID = assignID
    }
    
}

extension Submission: Decodable {
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.assignID = try values.decode(Int.self, forKey: .assignId)
    }
    
    enum CodingKeys: String, CodingKey {
        case assignId = "assignment_id"
    }
}

extension Submission: Equatable {
    static func == (lhs: Submission, rhs: Submission) -> Bool {
        return lhs.assignID == rhs.assignID
    }
}

extension Submission: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

