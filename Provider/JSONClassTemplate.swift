//
//  JSONClassTemplate.swift
//  Provider
//
//  Created by imac on 17/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONDataPhraseDelegate{
    func JSONDataPhrase(data:JSON)
}
@objc(JSONDataTemplate)
class JSONDataTemplate : NSObject{
    var JSONDelegate: JSONDataPhraseDelegate!
    func JSONPhrase(data:JSON) {
        JSONDelegate.JSONDataPhrase(data)
    }
    
    override required init() {
        print("init")
    }
}
