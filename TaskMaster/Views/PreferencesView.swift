//
//  PreferencesView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 5/3/24.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(AppController.self) private var appController: AppController
    private var testToken = ProcessInfo.processInfo.environment["CANVAS_TOKEN"] ?? ""
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("CLEAR ALL DATA")
                        .fontWeight(.bold)
                        .font(.regular(25))
                    Text("This will remove all data stored in TaskMaster")
                }
                .padding()
                Button() {
                    appController.dataModel.clearData()
                } label:{
                    Image(systemName: "trash")
                }
                .scaleEffect(x: 2, y: 2)
                .padding()
            }
            //TextField("User token:", text: testToken)
            
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        
    }
}
