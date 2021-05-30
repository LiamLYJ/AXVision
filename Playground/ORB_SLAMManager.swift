//
//  ORB_SLAMManager.swift
//  Playground
//
//  Created by lyj on 2020/12/05.
//  Copyright © 2020 lyj. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AXVisionSDK

protocol ORB_SLAMManagerDelegate: class {
    func updateInfoDisplay()
    func startProfiler()
    func endProfiler()
    func trackCurFrame(image: UIImage)
    func showCurFrame(image: UIImage)
}

class ORB_SLAMManager : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var imageCount = 0
    private var isDone = true
    private var bufferImage: UIImage?
    private let feedWidth = 320
    private let feedHeight = 240
    
    private lazy var trackingQueue: DispatchQueue = {
        return DispatchQueue(label: "tracking Queue")
    }()

    private lazy var cameraSession: AVCaptureSession = {
      let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSession.Preset.vga640x480
      return s
    }()
    
    private lazy var videoDevice: AVCaptureDevice = {
        return AVCaptureDevice.default(for: AVMediaType.video)!
    }()
    
    public weak var delegate: ORB_SLAMManagerDelegate?
    
    override init () {
    }
    
    func runFromAVFoundation() {
        setupColorCamera()
        cameraSession.startRunning()
    }
    
    func setupColorCamera () {

        cameraSession.beginConfiguration()
        
        do {
            try videoDevice.lockForConfiguration()
            // set for best color/depth aligment
            if videoDevice.isExposureModeSupported(AVCaptureDevice.ExposureMode.continuousAutoExposure) {
                videoDevice.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            }
            if videoDevice.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.continuousAutoWhiteBalance) {
                videoDevice.whiteBalanceMode = AVCaptureDevice.WhiteBalanceMode.continuousAutoWhiteBalance
            }
            videoDevice.setFocusModeLocked(lensPosition: 1.0, completionHandler: nil)
            videoDevice.unlockForConfiguration()

            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)

            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }

            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: NSNumber(value: kCVPixelFormatType_32BGRA)]
            dataOutput.alwaysDiscardsLateVideoFrames = true

            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }

            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)

            cameraSession.commitConfiguration()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
            
    }
   
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard (isDone) else {
            return
        }
        isDone = false
        bufferImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        guard let tmpImage = bufferImage else {
            return
        }
        trackingQueue.async {
            let width = Float(tmpImage.size.width)
            let height = Float(tmpImage.size.height)
            guard let tmpImage = CommonUtils.resizeImage(with: tmpImage, xscale: Float(self.feedWidth)/width, yscale: Float(self.feedHeight)/height) else {
                return
            }
            self.delegate?.startProfiler()
            self.delegate?.trackCurFrame(image: tmpImage)
            self.delegate?.endProfiler()
            self.delegate?.updateInfoDisplay()
            self.delegate?.showCurFrame(image: tmpImage)
            self.isDone = true
        }
    }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly)
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!)
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage()
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly)
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!)
        
        return (image)
    }
}
