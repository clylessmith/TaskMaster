//
//  TaskMasterApp.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 4/3/24.
//

import SwiftUI

@main
struct TaskMasterApp: App {
    @State var viewModel = TaskMasterViewModel()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                
        }
    }
}
