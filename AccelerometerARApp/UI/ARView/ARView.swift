//
//  ARView.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI
import RealityKit
import ARKit
import CoreMotion

struct ARView: View {
    @StateObject var viewModel: ARViewViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(distance: $viewModel.distance, onVerticalSurfaceDetected: {
                if !viewModel.isVerticalSurfaceDetected {
                    viewModel.isVerticalSurfaceDetected.toggle()
                }
            })
            .edgesIgnoringSafeArea(.all)
            
            //TestInfoLabelView(viewModel: viewModel)
            
            if viewModel.isVerticalSurfaceDetected {
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(100)
                        .opacity(viewModel.handleTopAngleBorder() ? 1 : 0)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            DistanceItemView(viewModel: viewModel)
                            InfoLabelView(isDistanceInfo: true)
                                .opacity(viewModel.isDistanceRangeOk() ? 0 : 1)
                                .padding()
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            AngleItemView(viewModel: viewModel)
                            InfoLabelView(isDistanceInfo: false)
                                .opacity(viewModel.isAngleOk() ? 0 : 1)
                                .padding()
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .top)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(100)
                        .offset(y: 20)
                        .opacity(viewModel.handleBottomAngleBorder() ? 1 : 0)
                }
                .padding(-20)
                
                HStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .leading, endPoint: .trailing)
                        .frame(maxWidth: 60, maxHeight: .infinity)
                        .cornerRadius(100)
                        .opacity(viewModel.handleLeadingAngleBorder() ? 1 : 0)
                    
                    Spacer()
                    
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.red.opacity(0.5), Color.clear]), startPoint: .trailing, endPoint: .leading)
                        .frame(maxWidth: 60, maxHeight: .infinity)
                        .cornerRadius(100)
                        .opacity(viewModel.handleTrailingAngleBorder() ? 1 : 0)
                }
                .padding(-65)
            }
            else {
                Text(Localizable.general_scan_instruction.local)
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding()
                    .background(.black.opacity(0.4))
                    .cornerRadius(30)
            }
        }
    }
}

#Preview {
    ARView(viewModel: .init(accelerometerService: AccelerometerService()))
}
