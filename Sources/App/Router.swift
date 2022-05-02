//
//  File.swift
//  
//
//  Created by Nayan Bhut on 5/2/22.
//

import Foundation
import Vapor

struct Router: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
//        routes.add(rebuild())
    }
    
    
    
    
//    func rebuild(req: Request) throws -> EventLoopFuture<[String]> {
//        let mysql = req.db
//
//        // Clear database tables
//        let tables = ["rubrics", "rubrics_tree"]
//        var truncateResults = [EventLoopFuture<Void>]()
//        for table in tables {
//            let future = mysql!.simpleQuery("TRUNCATE TABLE `\(table)`").transform(to: ())
//            truncateResults.append(future)
//        }
//        // … and wait for all Futures to finish
//        return truncateResults.flatten(on: req.eventLoop).flatMap {
//
//            // Copy contents from imported `import` into table `rubrics`
//            return mysql!.simpleQuery("INSERT INTO `rubrics` SELECT * FROM `import`").flatMap { _ in
//
//                // Iterate over all Rubrics and build the Tree by inserting each as a Node into the Nested Set
//                let nestedSet = NestedSet(database: mysql!, table: "rubrics_tree")
//                var nestedSetRootId = 1;
//                let rubrics = Rubric.query(on: mysql as! Database)
//                    .filter(\.$level == 0)
//                    .sort(\.$level)
//                    .sort(\.$parentId)
//                    .sort(\.$sorting)
//                    .sort(\.$id)
//                    .all()
//                    .flatMapEachThrowing { rubric -> Rubric in
//                        try? nestedSet.newRoot(rootId: UInt16(nestedSetRootId), foreignId: UInt64(rubric.id!))
//                        nestedSetRootId += 1
//                        return rubric
//                    }
//                return rubrics
//            }
//        }
//    }
}
