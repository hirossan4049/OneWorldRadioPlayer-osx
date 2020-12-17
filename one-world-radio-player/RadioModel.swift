//
//  RadioModel.swift
//  one-world-radio-player
//
//  Created by unkonow on 2020/12/17.
//

import Foundation


class RadioModel{
    
    
    func getM3u8(completion:@escaping ((String) -> ())) -> String{
        let url = URL(string: "https://playerservices.streamtheworld.com/api/livestream-redirect/OWR_INTERNATIONAL_ADP.m3u8")!  //URLを生成
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
        
    }
}
