//
//  Generator.swift
//  VideoTrimmer
//
//  Created by Dmitry Medyuho on 4/28/19.
//  Copyright © 2019 rlxone. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAssetImageGenerator {
    
    @discardableResult func thumbnail(at time: CMTime, to destinationURL: URL) throws -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else {
            return false
        }
        do {
            let image = try self.copyCGImage(at: time, actualTime: nil)
//            CGImageDestinationAddImage(destination, image, [
//                kCGImageDestinationLossyCompressionQuality as String: 1.0
//            ])
            return CGImageDestinationFinalize(destination)
        } catch {
            return false
        }
    }
}
