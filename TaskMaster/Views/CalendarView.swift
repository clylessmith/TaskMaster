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
    }
}

private extension CalendarView {
    func buildDayView(_ date: Date, _ isCurrentMonth: Bool, selectedDate: Binding<Date?>?, range: Binding<MDateRange?>?) -> DV.Assignments {
        return .init(date: date, isCurrentMonth: isCurrentMonth, selectedDate: $selectionManager.selectedDate, selectedRange: $selectedRange, color: getDateColor(date), dataModel: dataModel)
    }
}
private extension CalendarView {
    func onContinueButtonTap() { }
    func getDateColor(_ date: Date) -> Color? {
        let assignAmount = dataModel.findAssignmentsByDay(calendarDate: date)
        switch assignAmount {
        case 0:
            return .greenAccent
        case 1:
            return .yellow
        case 2:
            return .orangeAccent
        case _ where assignAmount >= 3:
            return .redAccent
        default:
            return nil
        }
    }
}

//#Preview {
//    CalendarView()
//}
