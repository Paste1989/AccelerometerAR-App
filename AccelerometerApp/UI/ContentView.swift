//
//  ContentView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @StateObject private var accelerationService = AccelerometerService()
    @State var distance: Float = 0.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ARViewContainer(distance: $distance)
                .edgesIgnoringSafeArea(.all)
                .background(distance >= Float(100.0) && distance <= Float(110.0) ? Color.green.edgesIgnoringSafeArea(.all) : Color.red.edgesIgnoringSafeArea(.all))
            
            VStack(spacing: 0) {
                Text("Distance:")
                Text(String(format: "%.2f meters", distance))
                    .font(.headline)
                    .padding(.bottom)
                
                Text("Acceleration:")
                Text("x: \(accelerationService.acceleration.x, specifier: "%.2f")")
                    .font(.headline)
                Text("y: \(accelerationService.acceleration.y, specifier: "%.2f")")
                    .font(.headline)
                Text("z: \(accelerationService.acceleration.z, specifier: "%.2f")")
                    .font(.headline)
                
                if accelerationService.isLandscape {
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
            .background(accelerationService.isLandscape && (accelerationService.acceleration.x >= -1.2 && accelerationService.acceleration.x <= -0.98 && distance >= 0.95 && distance <= 1.05) ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
            .cornerRadius(10)
            .padding()
        }
        .onChange(of: accelerationService.acceleration.x) { newValue in
            print("new VAlue: \(newValue)")
        }
    
    }
}

#Preview {
    ContentView()
}
