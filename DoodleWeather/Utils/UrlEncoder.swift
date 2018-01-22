//
//  UrlEncoder.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 15.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import Foundation

class UrlEncoder {
    
//    https://gist.github.com/svenresch/b4bf443fb325385eec72
    func urlEncode(_ str: String) -> String {
        let unreserved = "-._~/?"
        var allowed: CharacterSet = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        return str.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
    
    /*
    func urlEncodeFailPlus(_ str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
 */
}
