//
//  DataService.swift
//  Complex JSON
//
//  Created by Marko Nedeljkovic on 5/28/20.
//  Copyright © 2020 Marko Nedeljkovic. All rights reserved.
//

import Foundation

typealias JSONS = [String: Any]

class DataService {
    
    private init() {}
    static let shared = DataService()
    
    func getData(completion: (Data) -> Void) {
        guard let path = Bundle.main.path(forResource: "gradskelinije", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            completion(data)
        } catch {
            print(error)
        }
        
    }
    
}
