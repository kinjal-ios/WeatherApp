//
//  UIViewExtensions.swift
//  WeatherApp
//
//  Created by Kinjal Solanki on 23/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import UIKit

extension UIView {

    public func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constant.GradientColors.topColor, Constant.GradientColors.bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, above: self.layer)
    }
   
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func dropShadow(offset : CGSize, radius : CGFloat , color : UIColor , opacity : Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity // 0.5
        self.layer.shadowOffset = offset   // CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius   // 20
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /*public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }*/
    
    
    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
}
