//
//  ViewController.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Cocoa
import AVKit

class ViewController: NSViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var artistTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var playerButton: NSButton!
    private var player1:AVAudioPlayer!
    private var player2:AVAudioPlayer!
    private var isPlayWatcher = true
    private var medias: [MediaItem] = []
    private var isFirstPlay = true
    
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
//        self.playerButton.isEnabled = false
        
//        fetchMedia()

    }
    
    
    
    func fetchMedia(){
        let radioModel = RadioModel()
        radioModel.getMedia(completion: fetchedMedia)
        radioModel.getCurrentMusic(completion: fetchedMusic)
    }
    
    func fetchedMedia(_ medias:[MediaItem]){
//        self.playerButton.isEnabled = true
        self.medias += medias
        print("fetching")
//        if isFirstPlay{
//            playObserver()
//            isFirstPlay = false
//        }
        if !isPlaying{
            playObserver()
            self.player1?.play()
        }
    }
    
    func fetchedMusic(_ music: Music){
        artistTextField.stringValue = music.artist ?? "artist not found"
        titleTextField.stringValue = music.title ?? "title not found"
        iconImageView.image = NSImage(url: "https://pl-cache.weareone.world/minimal/image/" + music.imageRef!)
        
    }
    
    func playObserver(){
        if !isPlaying{
            return
        }
        if medias.count <= 1{
            do{
                try fetchMedia()
            }catch{
                print("取得失敗")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.playObserver()

                }
            }
        }
        if medias.count == 0{
            print("media not found")
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.playerUpdate), userInfo: nil, repeats: false)
            return
        }
        let url = URL(string: self.medias.first!.urlString!)
        print(self.medias.first!.duration!)
        print("TIMER")
        Timer.scheduledTimer(timeInterval: self.medias.first!.duration! - 1, target: self, selector: #selector(self.playerUpdate), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: self.medias.first!.duration! - 0.5, target: self, selector: #selector(self.playerPlay), userInfo: nil, repeats: false)
        print("TIMER SETTED")

        
        do {
            let data = try Data(contentsOf: url!)
            print(self.isPlayWatcher)
            if isPlayWatcher{
                print("PLAYER1")
                self.player1 = try AVAudioPlayer(data: data)
                self.player1.prepareToPlay()
//                self.player1.delegate = self
//                self.player1.play()
//                self.player2?.stop()
            }else{
                print("PLAYER2")
                self.player2 = try AVAudioPlayer(data: data)
                self.player2.prepareToPlay()
//                self.player2.delegate = self
//                self.player2.play()
//                self.player1?.stop()
            }
            self.medias.remove(at: 0)
        } catch {
            NSLog("cannot play audio")
        }
        print("PLAY OBSERVER")
    }
    
    
    
    @objc func playerUpdate(){
        if !isPlaying{
            return
        }
        self.isPlayWatcher = !self.isPlayWatcher
        print("playerUPdate")
        playObserver()
    }
    
    @objc func playerPlay(){
        if isPlayWatcher{
            self.player2.play()
        }else{
            self.player1.play()
        }
    }

    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if self.isPlayWatcher{
//            self.player2.play()
//        }else{
//            self.player1.play()
//        }
        if flag {
            print("ended")
            

            
//            self.playObserver()
            // After successfully finish song playing will stop audio player and remove from memory
//            print("Audio player finished playing")
//            self.player?.stop()
//            self.player = nil
            // Write code to play next audio.
        }
    }
    
    @IBAction func playBtn(_ sender: Any) {
        isPlaying = !isPlaying
        
        if isPlaying{
            self.medias = []
            playObserver()
//            self.player1?.play()
        }else{
            self.player1?.stop()
            self.player2?.stop()
            self.medias = []
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

