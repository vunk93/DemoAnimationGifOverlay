//
//  TextAnimation.swift
//  LerningAndDemo
//
//  Created by Đinh Văn Trình on 04/11/2022.
//

import UIKit
import Foundation
import AVFoundation

enum AnimationValue {
    case normal
    case opacity
    case scale
}



struct TextAnimation {
    static let opacti = TextAnimation(type: .opacity)
    static let scale = TextAnimation(type: .scale)
    
    
    var fromValue: Float = 0.0
    var toValue: Float = 1.0
    var duration: CFTimeInterval = 0.125
    var beginTime: CFTimeInterval = .zero
    var type: AnimationValue = .normal
    
    var rawValue: CAAnimation?
    
    init(fromValue: Float = 0, toValue: Float = 1, duration: CFTimeInterval = 0.125, ravalue: CAAnimation? = nil, beginTime: CFTimeInterval = .zero, type: AnimationValue) {
        self.beginTime = beginTime
        switch type {
            case .normal:
                return
            case .opacity:
                rawValue = opacity(from: fromValue, to: toValue, duration: duration)
            case .scale:
                rawValue = scale(from: fromValue, to: toValue, duration: duration)
        }
    }
    
    public func opacity(from fromValue: Float = 0.0,
                        to toValue: Float = 1.0,
                        duration: CFTimeInterval = 0.125) -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        opacityAnimation.duration = duration
        opacityAnimation.beginTime = beginTime
        opacityAnimation.fillMode = .both
        return opacityAnimation
    }
    
    public func scale(from fromValue: Float = 0.0,
                      to toValue: Float = 1.0,
                      duration: CFTimeInterval = 0.125) -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = fromValue
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration
        scaleAnimation.beginTime = beginTime
        scaleAnimation.fillMode = .both
        return scaleAnimation
    }
    
}

struct AnimationEnum {
    
}


struct AnimationBasic {
    
    func animationGroup(_ animations: [TextAnimation],
                        duration: CFTimeInterval = 15.0,
                        beginTime: CFTimeInterval = .zero) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.beginTime = AVCoreAnimationBeginTimeAtZero
        animationGroup.fillMode = .both
        animationGroup.isRemovedOnCompletion = false
        var arrays: [CAAnimation] = []
        animations.forEach { text in
           var anim = text.rawValue
            anim?.beginTime = beginTime
            arrays.append(anim!)
        }
        animationGroup.animations = arrays
        return animationGroup
    }
    
    
}
