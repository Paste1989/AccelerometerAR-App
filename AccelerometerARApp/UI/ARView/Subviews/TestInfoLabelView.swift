//
//  TestInfoLabelView.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI

struct TestInfoLabelView: View {
    @ObservedObject var viewModel: ARViewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(Localizable.distance_title.local):")
            Text(String(format: "%.2f \(Localizable.meters_string.local)", viewModel.distance))
                .font(.headline)
                .padding(.bottom)
            
            Text("\(Localizable.acceleration_title.local):")
            Text("x: \(viewModel.accelerometerService.acceleration.x, specifier: "%.2f")")
                .font(.headline)
            Text("y: \(viewModel.accelerometerService.acceleration.y, specifier: "%.2f")")
                .font(.headline)
            Text("z: \(viewModel.accelerometerService.acceleration.z, specifier: "%.2f")")
                .font(.headline)
            
            if viewModel.accelerometerService.isLandscape {
                Text(Localizable.lanscape_title.local)
                    .font(.headline)
                    .padding()
            } else {
                Text(Localizable.portrait_title.local)
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
