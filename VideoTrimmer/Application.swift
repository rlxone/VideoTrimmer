//
//  Application.swift
//  VideoTrimmer
//
//  Created by Dmitry Medyuho on 4/28/19.
//  Copyright © 2019 rlxone. All rights reserved.
//

import Foundation
import AVFoundation

class Application {
    
    fileprivate struct Animation {
        var number: Int
        var startFrame: Int
        var endFrame: Int
    }
    
    fileprivate struct Constants {
        static let chroma: (UInt8, UInt8, UInt8) = (0, 254, 0)
        static let xPixel = 256
        static let yPixel = 256
    }
    
    @discardableResult func run() -> Int {
        if CommandLine.arguments.count == 2 {
            let reader: AVAssetReader!
            var animations: [Animation] = []
            let filename = CommandLine.arguments[1]
            
            let url = URL(fileURLWithPath: filename)
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.requestedTimeToleranceBefore = CMTime.zero
            generator.requestedTimeToleranceAfter = CMTime.zero
            
            let framerate = asset.tracks.first!.nominalFrameRate
            let cutFrames = Int(framerate/2)
            
            do {
                reader = try AVAssetReader(asset: asset)
            } catch {
                print("\n   File not found!\n")
                return -1
            }
            
            let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
            
            let trackReaderOutput = AVAssetReaderTrackOutput(
                track: videoTrack,
                outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)]
            )
            
            reader.add(trackReaderOutput)
            reader.startReading()
            
            var frameCount = 1
            var frames: [Int] = []
            
            while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
                if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    if imageBuffer.pixelFrom(x: Constants.xPixel, y: Constants.yPixel) == Constants.chroma {
                        frames.append(frameCount)
                        print("Chroma found on \(frameCount) frame")
                    }
                }
                frameCount += 1
            }
            
            for i in 0..<frames.count-1 {
                if frames[i+1] - frames[i] > 1 {
                    let startFrame = frames[i] + 1
                    let endFrame = frames[i+1] - 1
                    let startTime = Float(startFrame)/framerate
                    let endTime = Float(endFrame)/framerate
//                    let thumbnailTime = startTime + (endTime - startTime) / 2
//                    let thumbnailSeconds = CMTimeMakeWithSeconds(Float64(thumbnailTime), preferredTimescale: 1000)
//                    do {
//                        try generator.thumbnail(at: thumbnailSeconds, to: URL(fileURLWithPath: "\(animations.count + 1).png"))
//                    } catch {
//                        print("Cant create thumbnail")
//                    }
                    animations.append(Animation(number: animations.count, startFrame: startFrame, endFrame: endFrame))
                    print("Animation: \(startFrame) - \(endFrame) | Start: \(startTime) - End: \(endTime) | Duration: \(endTime - startTime))")
                }
            }
            
            print("----------------")
            print("Total animations: ", animations.count)
            print("----------------")
            print("Compress animations: ", animations.count)
            
            handbrake(inputFilename: filename, animations: animations, cutFramesCount: cutFrames)
        } else {
            print("\n  Usage: VideoTrimmer file \n")
        }
        
        return 0
    }
    
    fileprivate func handbrake(inputFilename: String, animations: [Animation], cutFramesCount: Int) {
        for (index, animation) in animations.enumerated() {
            let startFrame = animation.startFrame
            let durationInFrames = animation.endFrame - cutFramesCount - animation.startFrame
            let outputFilename = "\(index+1).mp4"
            let thumbnailFilename = "\(index+1).png"
            "./HandBrakeCLI --encoder x264 --optimize --audio none --start-at frame:\(startFrame) --stop-at frame:\(durationInFrames) -i \(inputFilename) -o \(outputFilename)".shell()
//            print()
            "ffmpeg -i \(outputFilename) -vf select=\"gte(n\\,\(durationInFrames / 2))\" -vframes 1 \(thumbnailFilename) </dev/null".shell()
            
//            -vf select=\"gte(n\\,\(durationInFrames / 2))\"
        }
    }
}
