//
//  ContentView.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import SwiftUI
import RealityKit
import ARKit
import CoreMotion

struct ContentView: View {
    @StateObject private var accelerometerService = AccelerometerService()
    @State private var distance: Float = 0.0
    @State var isVerticalSurfaceDetected: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(distance: $distance, onVerticalSurfaceDetected: {
                if !isVerticalSurfaceDetected {
                    isVerticalSurfaceDetected.toggle()
                }
            })
                .edgesIgnoringSafeArea(.all)
                .background(distance >= 100.0 && distance <= 110.0 ? Color.green.edgesIgnoringSafeArea(.all) : Color.red.edgesIgnoringSafeArea(.all))
            
            //TestInfoLabelView(accelerometerService: accelerometerService, distance: distance)
            
            
            if isVerticalSurfaceDetected {
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(100)
                        .opacity(accelerometerService.acceleration.x > 1.0 ? 1 : 0)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            DistanceItemView(distance: distance)
                            InfoLabelView(isDistanceInfo: true)
                                .opacity(distance >= 0.2 && distance <= 0.3 ? 0 : 1)
                                .padding()
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            AngleItemView(acceleration: accelerometerService.acceleration)
                            InfoLabelView(isDistanceInfo: false)
                                .opacity(accelerometerService.acceleration.x < 1.0 &&
                                         accelerometerService.acceleration.x > 0.9 &&
                                         accelerometerService.acceleration.y < 0.1 &&
                                         accelerometerService.acceleration.y > -0.04 ? 0 : 1)
                                .padding()
                            
                            Spacer()
                        }
                    }
                    
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
}

#Preview {
    ContentView()
}


struct DistanceItemView: View {
    var distance: Float
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: distance >= 0.2 && distance <= 0.3 ? "checkmark.circle.fill" : "xmark.circle")
                .frame(width: 30, height:  30)
                .foregroundColor(.white)
                .padding(.leading)
            
            Text(distance >= 0.2 && distance <= 0.3 ? "Good distance" : "Bad distance")
                .foregroundColor(.white)
                .padding(.trailing)
        }
        .frame(height: 40)
        .background(distance >= 0.2 && distance <= 0.3 ? .green : .red)
        .cornerRadius(30)
        .padding(.leading)
        //.opacity(distance >= 0.2 && distance <= 0.3 ? 1 : 0)
    }
}

struct AngleItemView: View {
    var acceleration: CMAcceleration
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "angle")
                .frame(width: 30, height:  30)
                .foregroundColor(.white)
                .padding(.leading)
            
            Text(acceleration.x < 1.0 &&
                 acceleration.x > 0.9 &&
                 acceleration.y < 0.1 &&
                 acceleration.y > -0.04 ? "Good angle" : "Bad angle")
            .foregroundColor(.white)
            .padding(.trailing)
        }
        .frame(height: 40)
        .background(acceleration.x < 1.0 &&
                    acceleration.x > 0.9 &&
                    acceleration.y < 0.1 &&
                    acceleration.y > -0.04 ? .green : .red)
        .cornerRadius(30)
        .padding(.trailing)
        //        .opacity(acceleration.x < 1.0 &&
        //                 acceleration.x > 0.9 &&
        //                 acceleration.y < 0.1 &&
        //                 acceleration.y > -0.04 ? 1 : 0)
    }
}


struct InfoLabelView: View {
    var isDistanceInfo: Bool
    
    var body: some View {
        ZStack {
            Triangle()
                .frame(width: 24, height: 12)
                .foregroundColor(.black.opacity(0.4))
                .offset(x:isDistanceInfo ? -60 : 60, y: isDistanceInfo ? -63.5 : -76.5)
            
            VStack(spacing: 0) {
                Text(isDistanceInfo ? "Distance indicator" : "Angle indicator")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .padding(.top)
                
                Text(isDistanceInfo ? "20 to 30 centimeters is ideal distance from teh wall. If you move beyond that range the indicator will turn red." : "Keep your wrist straight and avoid flexing your hands. When you make a mistake, the indicator will turn red and a red line wll appear on the tilted side of the scren.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(width: 200)
            .background(.black.opacity(0.4))
            .cornerRadius(30)
        }
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}



struct TestInfoLabelView: View {
    var accelerometerService: AccelerometerService
    var distance: Float
    
    var body: some View {
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
        .background(accelerometerService.isLandscape && (accelerometerService.acceleration.x >= -1.2 && accelerometerService.acceleration.x <= -0.98 && distance >= 0.95 && distance <= 1.05) ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
        .cornerRadius(10)
        .padding()
    }
}
