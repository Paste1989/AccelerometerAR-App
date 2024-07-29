//
//  WebView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 29.07.2024..
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let fileName: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
