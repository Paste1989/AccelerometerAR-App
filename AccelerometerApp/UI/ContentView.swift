//
//  ContentView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    @State private var distance: Float = 0.0
    @StateObject private var accelerometerService = AccelerometerService()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(distance: $distance)
                .edgesIgnoringSafeArea(.all)
                .background(distance >= 100.0 && distance <= 110.0 ? Color.green.edgesIgnoringSafeArea(.all) : Color.red.edgesIgnoringSafeArea(.all))

            VStack(spacing: 0) {
                Text("Distance:")
                Text(String(format: "%.2f meters", distance))
                    .font(.headline)
                    .padding(.bottom)
                
                Text("Acceleration:")
                Text("x: \(accelerometerService.acceleration.x, specifier: "%.2f")")
                    .font(.headline)
                Text("y: \(accelerometerService.acceleration.y, specifier: "%.2f")")
                    .font(.headline)
                Text("z: \(accelerometerService.acceleration.z, specifier: "%.2f")")
                    .font(.headline)
                
                if accelerometerService.isLandscape {
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
//            .background(accelerometerService.isLandscape && (accelerometerService.acceleration.x >= -1.2 && accelerometerService.acceleration.x <= -0.98 && distance >= 0.95 && distance <= 1.05) ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
            .cornerRadius(10)
            //.padding()
            
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(100)
                    .opacity(accelerometerService.acceleration.x > 1.0 ? 1 : 0)
                
                Spacer()
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .top)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(100)
                    .offset(y: 20)
                    .opacity(accelerometerService.acceleration.x < 0.9 ? 1 : 0)
            }
            .padding(-20)
            
            HStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(maxWidth: 60, maxHeight: .infinity)
                    .cornerRadius(100)
                    .opacity(accelerometerService.acceleration.y > 0.1 ? 1 : 0)
                
                Spacer()
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .trailing, endPoint: .leading)
                    .frame(maxWidth: 60, maxHeight: .infinity)
                    .cornerRadius(100)
                    .opacity(accelerometerService.acceleration.y < -0.04 ? 1 : 0)
            }
            .padding(-65)
        }
    }
}

#Preview {
    ContentView()
}
