//
//  CalendarView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI

struct CalendarView: View {
    @State var date = Date()
    
    
    var body: some View {
        // store selected date, update the right-hand menu with current date's assignments
        DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .transformEffect(.init(scaleX: 1.75 , y: 1.75))
            .padding()
    }
}

//#Preview {
//    CalendarView()
//}
