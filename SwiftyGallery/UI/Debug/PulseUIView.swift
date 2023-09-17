//
//  PulseUIView.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 29/08/23.
//

#if DEBUG
import SwiftUI
import PulseUI

struct PulseUIView: View {
    @SwiftUI.State private var isSettingsPresented = false
    
    var body: some View {
        NavigationView {
            ConsoleView()
                .navigationBarItems(trailing: Button("Settings") {
                    isSettingsPresented = true
                }).sheet(isPresented: $isSettingsPresented, content: {
                    SettingsView()
                })
        }
    }
}
#endif
