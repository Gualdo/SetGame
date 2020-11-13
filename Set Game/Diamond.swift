//
//  Diamond.swift
//  Diamond
//
//  Created by De La Cruz, Eduardo on 12/11/2020.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let midHeight = rect.height / 2
        let midWidth = rect.width / 2
        let start = CGPoint(
            x: center.x,
            y: center.y + midHeight
        )
        let vertexA = CGPoint(
            x: center.x + midWidth,
            y: center.y
        )
        let vertexB = CGPoint(
            x: center.x,
            y: center.y - midHeight
        )
        let vertexC = CGPoint(
            x: center.x - midWidth,
            y: center.y
        )
        var path = Path()
        
        path.move(to: start)
        path.addLine(to: vertexA)
        path.addLine(to: vertexB)
        path.addLine(to: vertexC)
        path.addLine(to: start)
        
        return path
    }
}
