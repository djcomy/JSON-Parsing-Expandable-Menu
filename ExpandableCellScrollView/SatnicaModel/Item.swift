//
//  Item.swift
//  Complex JSON
//
//  Created by Marko Nedeljkovic on 5/28/20.
//  Copyright © 2020 Marko Nedeljkovic. All rights reserved.
//

import Foundation

struct Item {
    
    let satnica: Satnica
    
    init?(json: JSONS) {
        guard let satnicaJSON = json["satnica"] as? JSONS else { return nil }
        self.satnica = Satnica(json: satnicaJSON)!
    }
}
