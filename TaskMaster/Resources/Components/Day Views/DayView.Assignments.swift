//
//  DayView.Assignments.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 5/3/24.
//

import SwiftUI
import MijickCalendarView

extension DV { struct Assignments: DayView {
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MijickCalendarView.MDateRange?>?
    @State var dataModel: TaskMasterDataModel
}}

extension DV.Assignments {
    func createContent() -> AnyView {
        ZStack {
            createSelectionView()
            createDayLabel()
        }
        .erased()
    }
    func createDayLabel() -> AnyView {
        createDayText()
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .border(.backgroundTertiary, width: 1)
            .background(isPast() ? .backgroundTertiary.opacity(0.6) : .clear)
            .erased()
    }
    func createSelectionView() -> AnyView {
        Rectangle()
            .fill(Color.clear)
            .border(.onBackgroundPrimary, width: 3)
            .active(if: isSelected())
            .erased()
    }
}
private extension DV.Assignments {
    func createDayText() -> some View {
        VStack(spacing: 16) {
            createDateText()
            createAssignText()
        }
        .opacity(isPast() ? 0.6 : 1)
    }
}
private extension DV.Assignments {
    func createDateText() -> some View {
        Text(getStringFromDay(format: "d"))
            .font(.semiBold(15))
            .foregroundStyle(.onBackgroundPrimary)
    }
    func createAssignText() -> some View {
        Text("\(dataModel.findAssignmentsByDay(calendarDate: date)) tasks")
            .font(.regular(12))
            .foregroundStyle(.onBackgroundSecondary)
    }
}

// MARK: - On Selection Logic
extension DV.Assignments {
    func onSelection()  {
        selectedDate?.wrappedValue = date
    }
}
