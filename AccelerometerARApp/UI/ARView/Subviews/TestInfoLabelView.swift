//
//  TestInfoLabelView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI

struct TestInfoLabelView: View {
    @ObservedObject var viewModel: ARViewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Distance:")
            Text(String(format: "%.2f meters", viewModel.distance))
                .font(.headline)
                .padding(.bottom)
            
            Text("Acceleration:")
            Text("x: \(viewModel.accelerometerService.acceleration.x, specifier: "%.2f")")
                .font(.headline)
            Text("y: \(viewModel.accelerometerService.acceleration.y, specifier: "%.2f")")
                .font(.headline)
            Text("z: \(viewModel.accelerometerService.acceleration.z, specifier: "%.2f")")
                .font(.headline)
            
            if viewModel.accelerometerService.isLandscape {
                Text("Landscape Mode")
                    .font(.headline)
                    .padding()
            } else {
                Text("Portrait Mode")
                    .font(.headline)
                    .padding()
            }
        }
        .frame(width: 200)
        .background(.green.opacity(0.6))
        .background(viewModel.accelerometerService.isLandscape && (viewModel.accelerometerService.acceleration.x >= -1.2 && viewModel.accelerometerService.acceleration.x <= -0.98 && viewModel.distance >= 0.95 && viewModel.distance <= 1.05) ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    TestInfoLabelView(viewModel: .init(accelerometerService: AccelerometerService()))
}
