//
//  NSView+backgroundColor.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Foundation
import Cocoa

extension NSView {

    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else {return nil}
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }

}
