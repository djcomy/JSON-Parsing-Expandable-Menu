//
//  Batters.swift
//  Complex JSON
//
//  Created by Marko Nedeljkovic on 5/28/20.
//  Copyright © 2020 Marko Nedeljkovic. All rights reserved.
//

import Foundation

struct Satnica {
    
    let satnicaRadniDan: [SatnicaModel]
    let satnicaSubota: [SatnicaModel]
    let satnicaNedelja: [SatnicaModel]
    
    init?(json: JSONS) {
        guard let satnicaJSONradni = json["danradni"] as? [JSONS] else { return nil }
        guard let satnicaJSONsubota = json["dansubota"] as? [JSONS] else { return nil }
        guard let satnicaJSONnedelja = json["dannedelja"] as? [JSONS] else { return nil }
        
        self.satnicaRadniDan = satnicaJSONradni.map({ SatnicaModel(json: $0)! })
        self.satnicaSubota = satnicaJSONsubota.map({ SatnicaModel(json: $0)! })
        self.satnicaNedelja = satnicaJSONnedelja.map({ SatnicaModel(json: $0)! })
        
//        self.satnicaRadniDan = satnica
//        self.satnicaSubota = satnica
//        self.satnicaNedelja = satnica
        
    }
}
