//
//  ViewController.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Cocoa
import AVKit

class ViewController: NSViewController {
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var artistTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var playerButton: NSButton!
    
    var isPlaying = false {
        didSet{
            if isPlaying{
                playerButton.image = NSImage(named: "pause")
            }else{
                playerButton.image = NSImage(named: "playing")
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.backgroundColor = .black
        self.view.window!.titlebarAppearsTransparent = true
        self.view.window?.backgroundColor = .black
        
        iconImageView.wantsLayer = true
        iconImageView.layer?.cornerRadius = 100
        
        isPlaying = false
        
        let radioModel = RadioModel()
        radioModel.getMedia(completion: fetchedMedia)

    }
    
    func fetchedMedia(_ medias:[MediaItem]){
        
    }
    
    @IBAction func playBtn(_ sender: Any) {
        isPlaying = !isPlaying
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

