//
//  TextOpacityAnimationLayer.swift
//  VideoLab
//
//  Created by Bear on 2020/8/11.
//  Copyright © 2020 Chocolate. All rights reserved.
//

import AVFoundation

enum TextAnimationType {
    case typewriter
    case falling
    case popup
    case none
}

class TextOpacityAnimationLayer: TextAnimationLayer {
    override func addAnimations(to layers: [CATextLayer], type: TextAnimationType) {
        switch type {
            case .typewriter:
                typewriterText(layers)
            case .falling:
                fallingText(layers)
            default:
                break
        }
    }
    
    
    func typewriterText(_ layers: [CATextLayer]) {
        var beginTime = AVCoreAnimationBeginTimeAtZero
        let beginTimeInterval = 0.125
        
        
        for layer in layers {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 15.0
            animationGroup.beginTime = AVCoreAnimationBeginTimeAtZero
            animationGroup.fillMode = .both
            animationGroup.isRemovedOnCompletion = false

            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
            opacityAnimation.duration = 0.125
            opacityAnimation.beginTime = beginTime
            opacityAnimation.fillMode = .both

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 1.0
            scaleAnimation.duration = 0.125
            scaleAnimation.beginTime = beginTime
            scaleAnimation.fillMode = .both
            
            animationGroup.animations = [opacityAnimation, scaleAnimation]
            layer.add(animationGroup, forKey: "animationGroup")

            beginTime += beginTimeInterval
        }
    }
    
    func fallingText(_ layers: [CATextLayer]) {
        var beginTime = AVCoreAnimationBeginTimeAtZero
        let beginTimeInterval = 0.125
        
        for layer in layers {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 15.0
            animationGroup.beginTime = AVCoreAnimationBeginTimeAtZero
            animationGroup.fillMode = .both
            animationGroup.isRemovedOnCompletion = false
            
            let positionAnimation = CABasicAnimation(keyPath: "position.x")
            positionAnimation.fromValue = -100
            positionAnimation.toValue = layer.frame.midX
            positionAnimation.duration = 1.0
            positionAnimation.beginTime = beginTime
            positionAnimation.fillMode = .both

            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
            opacityAnimation.duration = 0.125
            opacityAnimation.beginTime = beginTime
            opacityAnimation.fillMode = .both

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 1.0
            scaleAnimation.duration = 0.125
            scaleAnimation.beginTime = beginTime
            scaleAnimation.fillMode = .both
            
            animationGroup.animations = [positionAnimation, opacityAnimation, scaleAnimation]
            layer.add(animationGroup, forKey: "animationGroup")

            beginTime += beginTimeInterval
        }
    }
}
