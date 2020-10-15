//
//  ItemResponse.swift
//  Complex JSON
//
//  Created by Marko Nedeljkovic on 5/28/20.
//  Copyright © 2020 Marko Nedeljkovic. All rights reserved.
//

import Foundation

struct ItemResponse {
    
    let items: [Item]?
    
    init?(json: JSONS) {
        guard let items = json["gradskelinije"] as? [JSONS] else { return nil }
        //guard let itemArray = items["linije"] as? [JSON] else { return nil }
        let itemObjects = items.map({ Item(json: $0)! })
        self.items = itemObjects
    }
}
