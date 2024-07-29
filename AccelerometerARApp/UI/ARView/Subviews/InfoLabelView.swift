//
//  InfoLabelView.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import SwiftUI

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

#Preview {
    InfoLabelView(isDistanceInfo: true)
}
