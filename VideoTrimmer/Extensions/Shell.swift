//
//  Shell.swift
//  VideoTrimmer
//
//  Created by Dmitry Medyuho on 4/28/19.
//  Copyright © 2019 rlxone. All rights reserved.
//

import Foundation

extension String {
    
    @discardableResult func shell() -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", self]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        return output
    }
}
