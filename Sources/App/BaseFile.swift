//
//  File.swift
//  
//
//  Created by Nayan Bhut on 5/15/22.
//

import Foundation
import Vapor


func getToken(req: Request, payload: TokenPayload) -> String? {
    do {
        return try req.jwt.sign(payload)
    }catch {
        return nil
    }
}

func random(digits:Int) -> Int {
    var number = String()
    for _ in 1...digits {
        number += "\(Int.random(in: 1...9))"
    }
    return Int(number) ?? 0
}
