//
//  AngleItemView.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI

struct AngleItemView: View {
    @ObservedObject var viewModel: ARViewViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "\(Images.angle.rawValue)")
                .frame(width: 30, height:  30)
                .foregroundColor(.white)
                .padding(.leading)
            
            Text(viewModel.isAngleOk() ? "\(Localizable.good_angle_title.local)" : "\(Localizable.bad_angle_title.local)")
            .foregroundColor(.white)
            .padding(.trailing)
        }
        .frame(height: 40)
        .background(viewModel.isAngleOk() ? .green : .red)
        .cornerRadius(30)
        .padding(.trailing)
        //        .opacity(viewModel.isAngleok() ? 1 : 0)
    }
}


#Preview {
    AngleItemView(viewModel: .init(accelerometerService: AccelerometerService()))
}
