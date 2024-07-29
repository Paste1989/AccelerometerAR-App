//
//  DistanceItemView.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI

struct DistanceItemView: View {
    @ObservedObject var viewModel: ARViewViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: viewModel.isDistanceRangeOk() ? "checkmark.circle.fill" : "xmark.circle")
                .frame(width: 30, height:  30)
                .foregroundColor(.white)
                .padding(.leading)
            
            Text(viewModel.isDistanceRangeOk() ? "Good distance" : "Bad distance")
                .foregroundColor(.white)
                .padding(.trailing)
        }
        .frame(height: 40)
        .background(viewModel.isDistanceRangeOk() ? .green : .red)
        .cornerRadius(30)
        .padding(.leading)
        //.opacity(viewModel.isDistanceRangeOk() ? 1 : 0)
    }
}

#Preview {
    DistanceItemView(viewModel: .init(accelerometerService: AccelerometerService()))
}
