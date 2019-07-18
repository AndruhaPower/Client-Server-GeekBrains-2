//
//  CustomViewExtensions.swift
//  L1_GBVk
//
//  Created by Andrew on 12/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    convenience init(heartHeight rectHeight: CGFloat) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rectHeight * 0.4
        let sideTwo = rectHeight * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rectHeight * 0.3, y: rectHeight * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rectHeight * 0.7, y: rectHeight * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rectHeight * 0.5, y: rectHeight * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension AvatarImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
