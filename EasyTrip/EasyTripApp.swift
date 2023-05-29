//
//  EasyTripApp.swift
//  EasyTrip
//
//  Created by 이수민 on 2023/05/09.
//

import SwiftUI

@main
struct EasyTripApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
