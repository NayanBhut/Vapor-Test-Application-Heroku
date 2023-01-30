//
//  GraphQLTest.swift
//  
//
//  Created by Nayan Bhut on 5/9/22.
//

import Foundation
import Graphiti

struct Post: Codable {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
