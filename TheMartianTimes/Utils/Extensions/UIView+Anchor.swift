//
//  UIView+Anchor.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/26/21.
//

import UIKit

enum ConstraintEdge {
    case right
    case left
    case top
    case bottom
}

extension  UIView {
    func anchor(top : NSLayoutYAxisAnchor? , paddingTop : CGFloat , bottom : NSLayoutYAxisAnchor? , paddingBottom : CGFloat , left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        
        }
    }
    
    func proportionalSize(width : NSLayoutDimension? , widthPercent : CGFloat,
                          height : NSLayoutDimension? , heightPercent : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  let width = width {
            widthAnchor.constraint(equalTo: width , multiplier: widthPercent).isActive = true
        }
        
        if  let height = height {
            heightAnchor.constraint(equalTo: height , multiplier: heightPercent).isActive = true
        }
    }
    
    func setSize( width : CGFloat ,  height : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(centerX : NSLayoutXAxisAnchor? , centerY : NSLayoutYAxisAnchor?)  {
        self.center(centerX: centerX, paddingX: 0, centerY: centerY, paddingY: 0)
    }
    
    func center(centerX : NSLayoutXAxisAnchor? , paddingX : CGFloat   , centerY : NSLayoutYAxisAnchor? , paddingY : CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
         centerXAnchor.constraint(equalTo: centerX , constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
         centerYAnchor.constraint(equalTo: centerY , constant: paddingY).isActive = true
        }
    }
    
    
    func addHConstraint(const: NSLayoutXAxisAnchor?, edgeConst : ConstraintEdge ,  padding: CGFloat = 0 ) -> NSLayoutConstraint? {
        
        if let edge = const , edgeConst == .right   {
            let actualConst =   trailingAnchor.constraint(equalTo: edge, constant: padding)
            actualConst.isActive = true
            return actualConst
            
        }
        
        else if let edge = const , edgeConst == .left   {
            let actualConst =  leadingAnchor.constraint(equalTo: edge, constant: padding)
            actualConst.isActive = true
            return actualConst
            
        }
        return nil
    }
    
    
    func addVConstraint(const: NSLayoutYAxisAnchor?, edgeConst : ConstraintEdge ,  padding: CGFloat = 0 ) -> NSLayoutConstraint? {
        
        if let edge = const , edgeConst == .top   {
            let actualConst =  topAnchor.constraint(equalTo: edge, constant: padding)
            actualConst.isActive = true
            return actualConst
            
        }
        
        else if let edge = const , edgeConst == .bottom   {
            let actualConst =  bottomAnchor.constraint(equalTo: edge, constant: padding)
            actualConst.isActive = true
            return actualConst
            
        }
        return nil
    }
}
