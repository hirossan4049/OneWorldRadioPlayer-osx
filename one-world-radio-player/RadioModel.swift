//
//  RadioModel.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Foundation

struct MediaItem {
    var duration:   Int?
    var title:      String?
    var urlString:  String?
    
    static func parseM3U(contentsOfFile: String) -> [MediaItem]? {
        var mediaItems = [MediaItem]()
        var s = false
        var mediaItem = MediaItem()
        for item in contentsOfFile.components(separatedBy: "\n"){
            if item.hasPrefix("#EXTINF:"){
                s = true
                let sp = item.components(separatedBy: ",")
                mediaItem.duration = Int(Float(sp[0].replacingOccurrences(of: "#EXTINF:", with: ""))!)
                mediaItem.title = sp[1...].joined()
            }else{
                if s{
                    mediaItem.urlString = item
                    mediaItems.append(mediaItem)
                    s = false
                }
            }
        }
        
        return mediaItems
    }
}


class RadioModel{
    
    private var getMediaReturnFnCall: (([MediaItem]) -> ())!
    
    func getMedia(completion: @escaping ([MediaItem]) -> ()){
        getMediaReturnFnCall = completion
        getM3u8(completion: callback)
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
    
    private func callback(_ url: String){
        let url = URL(string: url)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let str = String(data: data, encoding: .utf8)!
                let mditm = MediaItem.parseM3U(contentsOfFile: str)
                self.getMediaReturnFnCall(mditm!)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
