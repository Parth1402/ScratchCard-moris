//
//  ZHWaveformView.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit
import AVFoundation

public class ZHWaveformView: UIView {
    
    /** waves color */
    public var wavesColor: UIColor = .red {
        didSet {
            DispatchQueue.main.async {
                _ = self.trackLayer.map({ [unowned self] in
                    $0.strokeColor = self.wavesColor.cgColor
                })
            }
        }
    }
    
    /** Cut off the beginning part color */
    public var beginningPartColor: UIColor = .gray
    
    /** Cut out the end part color */
    public var endPartColor: UIColor = .gray

    public weak var croppedDelegate: ZHCroppedDelegate? {
        didSet { layoutIfNeeded() }
    }
    
    public weak var waveformDelegate: ZHWaveformViewDelegate?

    
    private var trackLayer: [CAShapeLayer] = []
    
    private var startCroppedView: UIView?
    
    
    private var leftCorppedCurrentX: CGFloat = 0
    
    private var rightCorppedCurrentX: CGFloat = 0
    
    private var trackWidth: CGFloat = 0
    
    private var startCorppedIndex: Int = 0
    
    private var endCorppedIndex: Int = 0
    
    private var trackProcessingCut: [CGFloat]?
    
    private var assetMutableData: NSMutableData?
    
  
    
    public  override init(frame: CGRect) {
        super.init(frame: frame)
    }
    


    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let samples = trackProcessingCut {
            creatCroppedView()
            drawTrack(
                with: CGRect(x: 0,
                             y: 0,
                             width: frame.width ,
                             height: frame.height),
                filerSamples: samples
            )
        }
    }
   
    func generateRandomWaveformData(count: Int, scale: CGFloat) -> [CGFloat] {
        return (0..<count).map { _ in CGFloat.random(in: 0.3...0.8) * self.frame.height }
    }
   

   
    func loadRandomWaveform() {
//        self.trackScale = scale
       // let count = Int(self.frame.width *  CGFloat(45/230))
        let randomData = generateRandomWaveformData(count: 45, scale: 1.0)
        self.trackProcessingCut = randomData
        drawTrack(with: CGRect(origin: .zero, size: frame.size), filerSamples: randomData)
        self.waveformDelegate?.waveformViewDrawComplete?(waveformView: self)
    }
    
    
    private func drawTrack(with rect: CGRect, filerSamples: [CGFloat]) {
        _ = trackLayer.map{ $0.removeFromSuperlayer() }
        trackLayer.removeAll()
        startCroppedView?.removeFromSuperview()
        trackWidth = rect.width / (CGFloat(filerSamples.count - 1) + CGFloat(filerSamples.count))
        endCorppedIndex = filerSamples.count
        for t in 0..<filerSamples.count {
            let layer = CAShapeLayer()
            layer.frame = CGRect(
                x: CGFloat(t) * trackWidth * 2,
                y: 0,
                width: trackWidth,
                height: rect.height
            )
            layer.lineCap = CAShapeLayerLineCap.butt
            layer.lineJoin = CAShapeLayerLineJoin.round
            layer.lineWidth = trackWidth
            layer.strokeColor = wavesColor.cgColor
            self.layer.addSublayer(layer)
            self.trackLayer.append(layer)
        }
        
        for i in 0..<filerSamples.count {
            let itemLinePath = UIBezierPath()
            let y: CGFloat = (rect.height - filerSamples[i]) / 2
            let height: CGFloat = filerSamples[i] + y
            itemLinePath.move(to: CGPoint(x: 0, y: y))
            itemLinePath.addLine(to: CGPoint(x: 0, y: height))
            itemLinePath.close()
            itemLinePath.lineWidth = trackWidth
            let itemLayer = trackLayer[i]
            itemLayer.path = itemLinePath.cgPath
        }
        if let l = startCroppedView {
            addSubview(l)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZHWaveformView {
    
    private func croppedViewZero() {
        if let leftCropped = startCroppedView {
            leftCropped.frame = CGRect(x: 0, y: leftCropped.frame.origin.y, width: leftCropped.bounds.width, height: leftCropped.bounds.height)
        }
    }
    
    private func creatCroppedView() {
        if let leftCropped = croppedDelegate?.waveformView(startCropped: self) {
            leftCropped.frame = CGRect(x: 0, y: leftCropped.frame.origin.y, width: leftCropped.bounds.width, height: leftCropped.bounds.height)
            leftCorppedCurrentX = 0
            let leftPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.leftCroppedPanRecognizer(sender:)))
            leftCropped.addGestureRecognizer(leftPanRecognizer)
            leftCropped.isUserInteractionEnabled = true
            startCroppedView = leftCropped
        }
    }
    
    func updateWaveform(forPlaybackPosition position: CGFloat) {
        let newIndex = Int(position * CGFloat(trackProcessingCut?.count ?? 1))
        croppedWaveform(start: newIndex, end: endCorppedIndex)
    }
    
    @objc private func leftCroppedPanRecognizer(sender: UIPanGestureRecognizer) {
        let limitMinX: CGFloat = frame.minX
        let limitMaxX: CGFloat =  bounds.width
        if sender.state == .began {
            croppedDelegate?.waveformView?(croppedDragIn: startCroppedView ?? UIView())
        } else if sender.state == .changed {
            croppedDelegate?.waveformView?(croppedDragIn: startCroppedView ?? UIView())
            let newPoint = sender.translation(in: self)
            var center = startCroppedView?.center
            center?.x = leftCorppedCurrentX + newPoint.x
            guard (center?.x ?? 0) > limitMinX && (center?.x ?? 0) < limitMaxX else { return }
            startCroppedView?.center = center ?? .zero
        } else if sender.state == .ended || sender.state == .failed {
            croppedDelegate?.waveformView?(croppedDragFinish: startCroppedView ?? UIView())
            leftCorppedCurrentX = startCroppedView?.center.x ?? 0
        }
        if (startCroppedView?.frame.minX ?? 0) < 0 {
            var leftFrame = startCroppedView?.frame
            leftFrame?.origin.x = 0
            startCroppedView?.frame = leftFrame ?? .zero
        }
        
        if (startCroppedView?.frame.maxX ?? 0) > limitMaxX {
            var leftFrame = startCroppedView?.frame
            leftFrame?.origin.x = limitMaxX - (startCroppedView?.bounds.width ?? 0)
            startCroppedView?.frame = leftFrame ?? .zero
        } // floorf ceilf
        let lenght = ceilf(Float((((startCroppedView?.frame.maxX ?? 0) - (startCroppedView?.bounds.width ?? 0)) / trackWidth)))
        let bzrLenght = ceilf(lenght/2)
        startCorppedIndex = Int(bzrLenght) > trackLayer.count ? trackLayer.count : Int(bzrLenght)
        self.croppedWaveform(start: startCorppedIndex, end: endCorppedIndex)
        let bezierWidth = self.frame.width - (startCroppedView?.frame.width ?? 0)// - (endCroppedView?.frame.width ?? 0)
        croppedDelegate?.waveformView(startCropped: startCroppedView ?? UIView(), progress: ((startCroppedView?.frame.maxX ?? 0) - 20)/bezierWidth)
    }
    
   
    
    typealias TrackIndex = Int
    
    func croppedWaveform(
        start: TrackIndex,
        end: TrackIndex
        ) {
        let beginLayers = trackLayer[0..<start]
        let wavesLayers = trackLayer[start..<end]
        let endLayers = trackLayer[end..<trackLayer.count]
        DispatchQueue.main.async {
            _ = beginLayers.map({ [unowned self] in
                $0.strokeColor = self.beginningPartColor.cgColor
            })
            _ = wavesLayers.map({ [unowned self] in
                $0.strokeColor = self.wavesColor.cgColor
            })
            _ = endLayers.map({ [unowned self] in
                $0.strokeColor = self.endPartColor.cgColor
            })
        }
    }
    
}
