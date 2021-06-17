//
//  RadioModel.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Foundation

struct MediaItem {
    var duration:   Double?
    var title:      String?
    var urlString:  String?
    
    static func parseM3U(baseURL: String = "", contentsOfFile: String) -> [MediaItem]? {
        var mediaItems = [MediaItem]()
        var s = false
        var mediaItem = MediaItem()
        for item in contentsOfFile.components(separatedBy: "\n"){
            if item.hasPrefix("#EXTINF:"){
                s = true
                let sp = item.components(separatedBy: ",")
                mediaItem.duration = Double(sp[0].replacingOccurrences(of: "#EXTINF:", with: ""))!
                mediaItem.title = sp[1...].joined()
            }else{
                if s{
                    mediaItem.urlString = baseURL + item
                    mediaItems.append(mediaItem)
                    s = false
                }
            }
        }
        
        return mediaItems
    }
}

struct Music {
    var artist: String?
    var title: String?
    var imageRef: String?
}


class RadioModel{
    
    private var getMediaReturnFnCall: (([MediaItem]) -> ())!
    
    func getMedia(completion: @escaping ([MediaItem]) -> ()){
        getMediaReturnFnCall = completion
        getM3u8(completion: callback)
    }
    
    func getCurrentMusic(completion:@escaping (Music) -> ()){
        let url = URL(string: "https://pl-cache.weareone.world/minimal/nowplaying?stream=https://playerservices.streamtheworld.com/api/livestream-redirect/OWR_INTERNATIONAL_ADP.m3u8")!

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
//                let str = String(data: data, encoding: .utf8)!
                let items = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                var music = Music()
                music.artist = items["artist"] as! String
                music.title = items["title"] as! String
                music.imageRef = String(items["imageRef"] as! Int)
                completion(music)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    
    }
    
    
    func getM3u8(completion:@escaping ((String) -> ())) -> String{
        let url = URL(string: "https://playerservices.streamtheworld.com/api/livestream-redirect/OWR_INTERNATIONAL_ADP.m3u8")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let str = String(data: data, encoding: .utf8)!
                var arr:[String] = str.components(separatedBy: "\n")
                arr.reverse()
                completion(arr[1])
            } catch let error {
                print(error)
            }
        }
        task.resume()
        return ""
    }
    
    private func callback(_ urlString: String){
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let str = String(data: data, encoding: .utf8)!
                let mditm = MediaItem.parseM3U(baseURL: urlString.replacingOccurrences(of: "playlist.m3u8", with: ""), contentsOfFile: str)
                self.getMediaReturnFnCall(mditm!)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
