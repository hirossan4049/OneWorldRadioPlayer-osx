//
//  Image+url.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/19.
//

import Foundation
import Cocoa


extension NSImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            let items = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
            let image = items["base64image"] as! String
            let imagedata = Data(base64Encoded: image)
            if imagedata == nil{
                self.init()
            }else{
                self.init(data: imagedata!)!
            }
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
