//
//  TaskMasterViewModel.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation
import SwiftUI

@Observable
class TaskMasterViewModel {
    
    var courses: [Course]
    var selectedCourse: Course?
    var assignments: [Course.ID : [Assignment]]
    var todayAssign: [Course.ID: [Assignment]]
    var date: String
    var dateFormatter:DateFormatter
    
    private var testToken: String = "9802~hn0bPZZsSacQ1IclF8FCTodGFHXY4tg1CgS5f8j6TaZgshyNkJ2Ryudp7lMXctsC"
    private var apiURL: String = "https://canvas.instructure.com/api/v1/"
    private var dateFormat: String = "MMMM.dd.yyyy"
    
    init() {
        dateFormatter = DateFormatter()
        self.courses = []
        self.selectedCourse = nil
        self.assignments = [ : ]
        self.todayAssign = [ : ]
        self.date = ""
        self.dateFormat = dateFormat
        dateFormatter.dateFormat = dateFormat
        self.date = dateFormatter.string(from: Date())
        self.testToken = testToken
        self.apiURL = apiURL
        
    }
    
    // MARK: source = https://www.swiftwithvincent.com/blog/how-to-write-your-first-api-call-in-swift
    func fetchCourses() async throws {
        // TODO: use URLSession to get data, decode with JSONDecoder()
        // Use swift -> JSON decoding look online
        let url = URL(string: "\(apiURL)courses?access_token=\(testToken)")!
        
        print(url)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let localCourses: [Course] = try JSONDecoder().decode([Course].self, from: data)
        
        // check course IDs against existing, insert if DNE
        for course in localCourses {
            if !courses.contains(course) && course.courseName != nil {
                courses.append(course)
                print("INSERTED COURSE: \(course.courseName ?? course.originalName ?? "no name found")")
                print("COURSE ENDS AT: \(String(describing: course.endDate))")
                assignments[course.id] = []
                todayAssign[course.id] = []
            }
        }
    }
    
    func fetchAssignments() async throws {
        // TODO: use URLSession to get data, decode with JSONDecoder()
        // Use swift -> JSON decoding look online
        for course in courses {
            if course.courseName == nil {
                continue
            }
            let url = URL(string: "\(apiURL)courses/\(course.courseID)/assignments?access_token=\(testToken)")!
            
            print("Sending request to: \(url)")
            print("ASSIGNMENTS FOR \(course.courseName ?? "Empty name")")
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let localAssign: [Assignment] = try JSONDecoder().decode([Assignment].self, from: data)
            
            // check course IDs against existing, insert if DNE
            for assign in localAssign {
               if ((assignments[course.id]?.first(where: {$0.assignID == assign.assignID})) == nil) {
                    assignments[course.id]?.append(assign)
                    print("INSERTED ASSIGNMENT: \(String(describing: assignments[course.id]?.last?.assignName))) for course: \(String(describing: course.courseName))")
                }
                
            }
        }
    }
    
    func updateCourseHidden(course: Course?) {
        if let localCourse = course {
            if let targetCourse = courses.first(where: {$0.id == localCourse.id}) {
                var newCourse = targetCourse
                newCourse.hidden = !newCourse.hidden
                courses = courses.map{$0.id == localCourse.id ? newCourse : $0}
            }
            print("Course: \(String(describing: courses.first(where: {$0.id == localCourse.id})?.courseName))")
            print("HIDDEN: \(String(describing: courses.first(where: {$0.id == localCourse.id})?.hidden))")
        }
    }
    
    func updateCourseColor(course: Course?, color: Color) {
        
    }
    
    func updateTodayAssign() {
        for course in assignments.keys {
            for assign in assignments[course] ?? [] {
                if ((todayAssign[course]?.first(where: {$0.assignID == assign.assignID})) == nil) {
                    if let assignDate = assign.dueDate {
                        if dateFormatter.string(from: assignDate) == dateFormatter.string(from: Date()) {
                            todayAssign[course]?.append(assign)
                        }
                    }
                    
                }
            }
        }
    }
    
    func update() async throws {
        do {
            try await fetchCourses()
        }
        catch {
            print("ERROR - fetching courses: \(error)")
        }
        
        do {
            try await fetchAssignments()
        }
        catch {
            print("ERROR - fetching assignments: \(error)")
        }
        date = dateFormatter.string(from: Date())
        updateTodayAssign()
    }
}
