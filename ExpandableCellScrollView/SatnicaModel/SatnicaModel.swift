//
//  Batter.swift
//  Complex JSON
//
//  Created by Marko Nedeljkovic on 5/28/20.
//  Copyright © 2020 Marko Nedeljkovic. All rights reserved.
//

import Foundation

struct SatnicaModel {
    
    let sat: String?
    let minuti: String?
    
    init?(json: JSONS) {
        guard let sati = json["sat"] as? String,
            let minuti = json["minuti"] as? String
            else { return nil }
        
        self.sat = sati
        self.minuti = minuti
        
    }
}
