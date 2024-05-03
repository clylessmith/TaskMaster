//
//  CalendarView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/9/24.
//

import SwiftUI
import MijickCalendarView

struct CalendarView: View {
    @State var viewModel: TaskMasterViewModel
    @State var dataModel: TaskMasterDataModel
    @Bindable var selectionManager: SelectionManager
    @State private var selectedRange: MDateRange? = .init(startDate: Date.distantPast, endDate: Date.distantFuture)

    var body: some View {
        MCalendarView(selectedDate: $selectionManager.selectedDate, selectedRange: $selectedRange, configBuilder: configureCalendar)
            .padding()
            .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
    }
}

private extension CalendarView {
    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .startMonth(Date() - 10000000)
            .daysVerticalSpacing(5)
            .daysHorizontalSpacing(5)
            .monthsTopPadding(36)
            .dayView(buildDayView)
            .monthLabel { ML.Leading(month: $0, horizontalPadding: 0) }
            //.onMonthChange(viewModel.endMonth.send)
    }
}

private extension CalendarView {
    func buildDayView(_ date: Date, _ isCurrentMonth: Bool, selectedDate: Binding<Date?>?, range: Binding<MDateRange?>?) -> DV.Assignments {
        return .init(date: date, isCurrentMonth: isCurrentMonth, selectedDate: $selectionManager.selectedDate, selectedRange: $selectedRange, dataModel: dataModel)
    }
}
private extension CalendarView {
    func onContinueButtonTap() { }
    func getDateColor(_ date: Date) -> Color? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let day = Int(dateFormatter.string(from: date)) ?? 0
        if day % 5 == 0 { return .redAccent }
        if day % 9 == 0 { return .orangeAccent }
        if day % 11 == 0  { return .greenAccent }
        return nil
    }
}

//#Preview {
//    CalendarView()
//}
