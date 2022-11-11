//
//  ViewController.swift
//  LerningAndDemo
//
//  Created by Đinh Văn Trình on 26/07/2022.
//

import UIKit
import AVFoundation
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    
    var playerLayer: AVPlayerLayer?
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let path = Bundle.main.path(forResource: "29b4659b96c84ca793aa7680ab6ad981", ofType: "MP4") else {return}
        
        let url = URL(fileURLWithPath: path)
        playerItem = AVPlayerItem(url: url)
        let player =  AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: textContainerView.frame.width, height: textContainerView.frame.height)
        playerLayer?.videoGravity = .resizeAspect
        textContainerView.layer.addSublayer(playerLayer!)
        playerLayer?.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 5), queue: .main, using: { progress in
            self.lblCurrentTime.text = "\(progress.seconds)"
        })
        
        if let synchronizedLayer = makeSynchronizedLayer(playerItem: player) {
           playerLayer?.addSublayer(synchronizedLayer)
            
        }
    }
    
    func makeTextAnimationLayer() -> TextOpacityAnimationLayer {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 40),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
        ]
        let attributedString = NSAttributedString(string: "Think Big, Start Small, Learn Fast.", attributes: attributes)
        let layer = TextOpacityAnimationLayer()
        layer.typeAnimation = .falling
        layer.attributedText = attributedString
        layer.frame = CGRect(x: 0, y: textContainerView.bounds.midY/2, width: textContainerView.frame.size.width, height: textContainerView.frame.size.height/2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.yellow.cgColor
        return layer
    }
    
    func makeSynchronizedLayer(playerItem: AVPlayer) -> CALayer? {
        let synchronizedLayer = AVSynchronizedLayer(playerItem: playerItem.currentItem!)
        let textLayer = makeGifAnimation()
        synchronizedLayer.addSublayer(textLayer!)
        synchronizedLayer.zPosition = 999
        synchronizedLayer.frame = CGRect(x: 0, y: 0, width: textContainerView.frame.width, height: textContainerView.frame.height)
        synchronizedLayer.frame.origin = .zero
        return synchronizedLayer
    }
    
    func makeGifAnimation() -> CALayer? {
        let layers = CALayer()
        _ = 0
        for i in 0...20 {
            if let url = Bundle.main.url(forResource: "animation_500_la9fj7et", withExtension: "gif") {
                let gifLayer = CALayer()
                gifLayer.frame = CGRect(x: 0, y: 0, width: textContainerView.frame.width, height: textContainerView.frame.height)
                gifLayer.beginTime = 1
                gifLayer.duration = 10
    //            gifLayer.contentsScale = UIScreen.main.scale*6
                if let gifAnimation = animationForGif(with: url) {
                    gifLayer.add(gifAnimation, forKey: "contents")
                    layers.addSublayer(gifLayer)
                }
            }
        }
        
        return layers
    }
    
    func animationForGif(with url: URL) -> CAKeyframeAnimation? {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.contents))
        var frames:[CGImage] = []
        var delayTimes: [CGFloat] = []
        var totalTime: CGFloat = 0.0
        guard let gifSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            print("Can not get image source from the gif: \(url)")
            
            return nil
        }
        // get frame
        let frameCount = CGImageSourceGetCount(gifSource)
        
        for i in 0..<frameCount {
            guard let frame = CGImageSourceCreateImageAtIndex(gifSource, i, nil) else {
                continue
            }
            guard let dic = CGImageSourceCopyPropertiesAtIndex(gifSource, i, nil) as? [AnyHashable: Any] else { continue }
            
            guard let gifDic: [AnyHashable: Any] = dic[kCGImagePropertyGIFDictionary] as? [AnyHashable: Any] else { continue }
            let delayTime = gifDic[kCGImagePropertyGIFDelayTime] as? CGFloat ?? 0
            
            frames.append(frame)
            delayTimes.append(delayTime)
            
            totalTime += delayTime
        }
        if frames.count == 0 {
            return nil
        }
        assert(frames.count == delayTimes.count)
        var times: [NSNumber] = []
        var currentTime: CGFloat = 0
        
        for i in 0..<delayTimes.count {
            times.append(NSNumber(value: Double(currentTime / totalTime)))
            currentTime += delayTimes[i]
        }
        animation.keyTimes = times
        animation.values = frames
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = totalTime
        animation.repeatCount = .infinity
        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    @IBAction func actionAnimation(_ sender: Any) {
        playerLayer?.player?.seek(to: .zero)
        playerLayer?.player?.play()
        
    }
}


class GifEffect {
    var timeRage: CMTimeRange = .zero
    var contents: [CGImage] = []
}
