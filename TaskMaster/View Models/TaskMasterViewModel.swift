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
    var todayAssign: [Course.ID : [Assignment]]
    var todayAssignArray: [Assignment]
    var date: String
    var dateFormatter:DateFormatter
    
    private var testToken: String
    private var apiURL: String = "https://canvas.instructure.com/api/v1/"
    private var dateFormat: String = "MMMM.dd.yyyy"
    
    init() {
        dateFormatter = DateFormatter()
        self.courses = []
        self.selectedCourse = nil
        self.assignments = [ : ]
        self.todayAssign = [ : ]
        self.todayAssignArray = []
        self.date = ""
        self.testToken = ProcessInfo.processInfo.environment["CANVAS_TOKEN"] ?? ""
        self.dateFormat = dateFormat
        dateFormatter.dateFormat = dateFormat
        self.date = dateFormatter.string(from: Date())
        self.apiURL = apiURL
        
    }
    
    // MARK: source = https://www.swiftwithvincent.com/blog/how-to-write-your-first-api-call-in-swift
    func fetchCourses() async throws {
        let url = URL(string: "\(apiURL)courses?access_token=\(testToken)&per_page=1000")!
        
        print(url)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let localCourses: [Course] = try JSONDecoder().decode([Course].self, from: data)
        
        // check course IDs against existing, insert if DNE
        for course in localCourses {
            if !courses.contains(course) && course.courseName != nil {
                courses.append(course)
//                print("INSERTED COURSE: \(course.courseName ?? course.originalName ?? "no name found")")
//                print("COURSE ENDS AT: \(String(describing: course.endDate))")
                assignments[course.id] = []
                todayAssign[course.id] = []
            }
        }
    }
    
    func fetchAssignments(course:Course) async throws {
    
        let url = URL(string: "\(apiURL)courses/\(course.courseID)/assignments?access_token=\(testToken)&per_page=1000")!
        
        print("Sending request to: \(url)")
//        print("ASSIGNMENTS FOR \(course.courseName ?? "Empty name")")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let localAssign: [Assignment] = try JSONDecoder().decode([Assignment].self, from: data)
        
        // check course IDs against existing, insert if DNE
        for assign in localAssign {
           if ((assignments[course.id]?.first(where: {$0.assignID == assign.assignID})) == nil) {
                assignments[course.id]?.append(assign)
               if ((todayAssign[course.id]?.first(where: {$0.assignID == assign.assignID})) == nil) {
                   if let assignDate = assign.dueDate {
                       if dateFormatter.string(from: assignDate) == dateFormatter.string(from: Date()) {
                           todayAssign[course.id]?.append(assign)
                           todayAssignArray.append(assign)
                       }
                   }
                   
               }
//                print("INSERTED ASSIGNMENT: \(String(describing: assignments[course.id]?.last?.assignName))) for course: \(String(describing: course.courseName))")
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
//            print("Course: \(String(describing: courses.first(where: {$0.id == localCourse.id})?.courseName))")
//            print("HIDDEN: \(String(describing: courses.first(where: {$0.id == localCourse.id})?.hidden))")
        }
    }
    
    func updateCourseColor(course: Course?, color: Color) {
        
    }
    
    func updateTodayAssign(course:Course) {
        for assign in assignments[course.id] ?? [] {
            if ((todayAssign[course.id]?.first(where: {$0.assignID == assign.assignID})) == nil) {
                if let assignDate = assign.dueDate {
                    if dateFormatter.string(from: assignDate) == dateFormatter.string(from: Date()) {
                        todayAssign[course.id]?.append(assign)
                    }
                }
                
            }
        }
        
    }
    
    func markComplete(assign: Assignment) {
        if let targetCourse = courses.first(where: {$0.courseID == assign.courseID}) {
            if let courseId = assignments.keys.first(where: {$0 == targetCourse.id}) {
                if var newAssign = assignments[courseId]?.first(where: {$0.id == assign.id}) {
                    newAssign.isComplete = !(assign.isComplete ?? false)
                    if let localAssign = assignments[courseId] {
                        assignments[courseId] = localAssign.map{$0.id == assign.id ? newAssign : $0}
                        print("RESET - new assign is \(assignments[courseId]?.first(where: {$0.id == assign.id})?.isComplete ?? false ? "complete" : "not complete")")
                    }
                }
            }
        }
    }
    
    func update() async throws {
        date = dateFormatter.string(from: Date())
        
        do {
            try await fetchCourses()
        }
        catch {
            print("ERROR - fetching courses: \(error)")
        }
        
        for course in courses {
            if course.courseName == nil {
                continue
            }
            do {
                try await fetchAssignments(course: course)
                //updateTodayAssign(course: course)
            }
            catch {
                print("ERROR - fetching assignments: \(error)")
            }
            
        }
        
        print("TODAYS ASSIGNMENTS")
        for course in todayAssign.keys {
            for assign in todayAssign[course] ?? [] {
                print("TODAY: \(String(describing: assign.assignName))")
            }
        }
    }
}
