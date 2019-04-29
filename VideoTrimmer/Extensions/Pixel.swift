//
//  Pixel.swift
//  VideoTrimmer
//
//  Created by Dmitry Medyuho on 4/28/19.
//  Copyright © 2019 rlxone. All rights reserved.
//

import Foundation
import AVFoundation

extension CVPixelBuffer {
    
    func pixelFrom(x: Int, y: Int) -> (UInt8, UInt8, UInt8) {
        CVPixelBufferLockBaseAddress(self, [])
        
        let baseAddress = CVPixelBufferGetBaseAddress(self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
        let buffer = baseAddress!.assumingMemoryBound(to: UInt8.self)
        
        let index = 4*x + y*bytesPerRow
        let b = buffer[index]
        let g = buffer[index+1]
        let r = buffer[index+2]
        
        CVPixelBufferUnlockBaseAddress(self, [])
        
        return (r, g, b)
    }
}
