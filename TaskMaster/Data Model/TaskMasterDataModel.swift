//
//  TaskMasterDataModel.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class TaskMasterDataModel {
    
    private var container: ModelContainer
    
    var modelContext: ModelContext
    
    var courses: [Course] = []
    
    var assignments: [Course.ID : [Assignment]] = [ : ]
    
    var todayAssign: [Course.ID : [Assignment]] = [ : ]
    
    var assignmentByDate: [Date : [Assignment]] = [ : ]
    
    var date: String
    var dateFormatter = DateFormatter()
    
    private let calendar = Calendar.current
    
    private var testToken = ProcessInfo.processInfo.environment["CANVAS_TOKEN"] ?? ""
    private var apiURL: String = "https://canvas.instructure.com/api/v1/"
    private var dateFormat: String = "MMMM.dd.yyyy"
    
    @Transient
    var selectedCourse:Course? = nil
    
    @Transient
    var selectedAssignment: Assignment? = nil
    
    @Transient
    var selectedDate: Date? = nil
    
    init() {
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([
                Course.self, Assignment.self
            ])
            
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            do {
                return try ModelContainer(for: schema, configurations:
                                            [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        container = sharedModelContainer
        
        modelContext = ModelContext(sharedModelContainer)
        
        let localDateFormatter = DateFormatter()
        let localDateFormat = "MMMM.dd.yyyy"
        localDateFormatter.dateFormat = localDateFormat
        
        date = localDateFormatter.string(from: Date())
        dateFormatter.dateFormat = localDateFormat
        
        fetchData()
    }
    
    func fetchData() {
        fetchCoursesFromModel()
        fetchAssignmentsFromModel()
    }
    
    func fetchCoursesFromModel() {
        do {
            // fetching courses
            let sortOrder = [SortDescriptor<Course>(\.courseName)]
            
            let predicate = #Predicate<Course>{$0.courseName != ""}
            
            let descriptor = FetchDescriptor(predicate: predicate, sortBy: sortOrder)
            
            courses = try modelContext.fetch(descriptor)
            for course in courses {
                assignments[course.id] = []
                todayAssign[course.id] = []
            }
        } catch {
            print("ERROR: Fetch courses from model failed")
        }
        
    }
    
    func fetchAssignmentsFromModel() {
        do {
            // fetching assignments
            let sortOrder = [SortDescriptor<Assignment>(\.dueDate)]
            
            let predicate = #Predicate<Assignment>{$0.assignName != ""}
            
            let descriptor = FetchDescriptor(predicate: predicate, sortBy: sortOrder)
            
            let localAssignments = try modelContext.fetch(descriptor)
            
            for assignment in localAssignments {
                if let thisCourse = courses.first(where: {$0.courseID == assignment.courseID}) {
                    if !assignments.keys.contains(thisCourse.id) {
                        assignments[thisCourse.id] = [assignment]
                    } else {
                        assignments[thisCourse.id]?.append(assignment)
                    }
                    updateTodayAssign(course: thisCourse)
                    updateAssignmentsByDate(assignment: assignment)
                }
            }
        } catch {
            print("ERROR: Fetch courses from model failed")
        }
        
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
                modelContext.insert(course)
            }
        }
    }
    
    func fetchAssignments(course:Course) async throws {
        
        let url = URL(string: "\(apiURL)courses/\(course.courseID)/assignments?access_token=\(testToken)&per_page=1000")!
        print("\(String(describing: course.courseName)) : \(String(describing: course.courseID))")
        
        print("Sending request to: \(url)")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let localAssign: [Assignment] = try JSONDecoder().decode([Assignment].self, from: data)
        
        // check assignment IDs against existing, insert if DNE
        for assign in localAssign {
            if let courseAssigns = assignments[course.id] {
                if ((courseAssigns.first(where: {$0.assignId == assign.assignId})) == nil) {
                    assignments[course.id]?.append(assign)
                    modelContext.insert(assign)
                    updateTodayAssign(course: course)
                    updateAssignmentsByDate(assignment: assign)
                }

            }
        }
    }
    
    func updateCourseHidden(course: Course?) {
        if let localCourse = course {
            if let targetCourse = courses.first(where: {$0.id == localCourse.id}) {
                let newCourse = targetCourse
                newCourse.hidden = !newCourse.hidden
                courses = courses.map{$0.id == localCourse.id ? newCourse : $0}
            }
        }
    }
    
    //    func updateCourseColor(course: Course?, color: Color) {
    //
    //    }
    
    func updateTodayAssign(course:Course) {
        for assign in assignments[course.id] ?? [] {
            if let courseAssign = todayAssign[course.id] {
                if ((courseAssign.first(where: {$0.assignId == assign.assignId})) == nil) {
                    if let assignDate = assign.dueDate {
                        if dateFormatter.string(from: assignDate) == dateFormatter.string(from: Date()) {
                            todayAssign[course.id]?.append(assign)
                        }
                    }
                    
                }
            }
        
        }
        
        print("NEW DATE \(date)")
        print("TODAYS ASSIGNMENTS - updateTodayAssign()")
        for course in todayAssign.keys {
            for assign in todayAssign[course] ?? [] {
                print("TODAY: \(String(describing: assign.assignName))")
            }
        }
        //        print("TODAY ASSIGN BY DATE")
        //        if let selectedDate {
        //            for assign in assignmentByDate[selectedDate] ?? [] {
        //                print("\(selectedDate) \(String(describing: assign.assignName))")
        //            }
        //        }
        
    }
    
    func updateAssignmentsByDate(assignment: Assignment) {
        if let assignDate = assignment.dueDate {
            let assignDateComponents = calendar.dateComponents([.day, .month, .year], from: assignDate)
            if assignmentByDate != [ : ] {
                for date in assignmentByDate.keys {
                    let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
                    if dateComponents == assignDateComponents {
                        if ((assignmentByDate[date]?.contains(assignment)) == nil) {
                            assignmentByDate[date]?.append(assignment)
                        }
                    }
                }
            } else {
                assignmentByDate[assignDate] = [assignment]
            }
        }
    }
    
    func markComplete(assign: Assignment) {
        if let targetCourse = courses.first(where: {$0.courseID == assign.courseID}) {
            if let courseId = assignments.keys.first(where: {$0 == targetCourse.id}) {
                if var newAssign = assignments[courseId]?.first(where: {$0 == assign}) {
                    newAssign.isComplete = !(assign.isComplete ?? false)
                    if let localAssign = assignments[courseId] {
                        assignments.updateValue(localAssign.map{$0 == assign ? newAssign : $0}, forKey: courseId)
                        if let assignDate = assign.dueDate {
                            assignmentByDate[assignDate]?.removeAll(where: {$0.id == assign.id})
                            updateAssignmentsByDate(assignment: newAssign)
                        }
                        
                    }
                    if let localTodayAssign = todayAssign[courseId] {
                        todayAssign.updateValue(localTodayAssign.map{$0 == assign ? newAssign : $0}, forKey: courseId)
                    }
                }
            }
        }
    }
    
    func updateDate(date: Date) {
        self.date = dateFormatter.string(from: date)
        for course in courses {
            todayAssign[course.id] = []
            updateTodayAssign(course: course)
        }
    }
    
    func findAssignmentsByDay(calendarDate: Date) -> Int {
        var numAssignmentsThisDay = 0
        let calendarDateComponents = calendar.dateComponents([.day, .month, .year], from: calendarDate)
        for course in courses {
            if let courseAssignments = assignments[course.id] {
                for assignment in courseAssignments {
                    if let assignDate = assignment.dueDate {
                        let assignDateComponents = calendar.dateComponents([.day, .month, .year], from: assignDate)
                        if calendarDateComponents == assignDateComponents {
                            numAssignmentsThisDay += 1
//                            if assignmentByDate[calendarDate] == nil {
//                                assignmentByDate[calendarDate] = [assign]
//                            }
                        }
                    }
                }
            }
            
        }
        return numAssignmentsThisDay
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
                print("ERROR - course name is null")
                continue
            }
            do {
                try await fetchAssignments(course: course)
                updateTodayAssign(course: course)
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
