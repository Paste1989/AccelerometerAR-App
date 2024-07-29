//
//  ContentView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ARView(viewModel: ARViewViewModel(accelerometerService: AccelerometerService()))
    }
}

#Preview {
    ContentView()
}

