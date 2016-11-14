//
//  PromptModel.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PromptModel : BaseModel<Prompt> {
    
    func getAllPrompts() -> Array<Prompt> {
        return []
    }
    
    func getDailyPrompts() -> Array<Prompt> {
        return []
    }
    
    func respondToPrompt(text:String, mentions:Array<String>?) {
        
    }
    
    func getGroupJournal() -> Array<Prompt> {
        return []
    }
}
