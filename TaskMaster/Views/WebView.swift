//
//  WebView.swift
//  TaskMaster
//
//  Created by Camden Lyles-Smith on 5/3/24.
//

import SwiftUI
import WebKit

// MARK: source - https://gavinw.me/swift-macos/swiftui/webview.html
struct WebView: NSViewRepresentable {
    @State var content: String

    func makeNSView(context: Context) -> WKWebView {

        let webview = WKWebView()
        webview.loadHTMLString(self.content, baseURL: nil)
        return webview
    }

    func updateNSView(_ nsView: WKWebView, context: Context) { }
}
