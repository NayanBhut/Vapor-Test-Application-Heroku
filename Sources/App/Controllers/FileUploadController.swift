//
//  FileUploadController.swift
//  
//
//  Created by Nayan Bhut on 3/29/23.
//

import Vapor

struct FileUploadController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let protected = routes.grouped(UserAuthenticator())
        protected.post("upload",use: getUploadedFile)
        protected.post("uploads",use: getUploadedFiles)
    }
    
    func getUploadedFile(req: Request) async throws -> String {
        
        let input = try req.content.decode(Input.self)
        
        guard input.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d-HH-MM-SS-"
        let prefix = formatter.string(from: .init())
        let fileName = prefix + input.file.filename
        let path = req.application.directory.publicDirectory + fileName //Adding File To Path
        let isImage = ["png", "jpeg", "jpg", "gif", "txt"].contains(input.file.extension?.lowercased())
        
        if !isImage {
            return "Please upload valid file"
        }else {
            print("path is ",path)
            do {
                try await req.fileio.writeFile(input.file.data, at: path)
                return "Upload Success \(input.file.filename)"
            }catch {
                print("Error is :",error.localizedDescription)
                return "File upload Failed"
            }
        }
    }
    
    func getFileData(req: Request, file: File) async -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d-HH-MM-SS-"
        let prefix = formatter.string(from: .init())
        let fileName = prefix + file.filename
        let path = req.application.directory.publicDirectory + fileName //Adding File To Path
        let isImage = ["png", "jpeg", "jpg", "gif", "txt"].contains(file.extension?.lowercased())
        
//        if !isImage {
//            return ""
//        }else {
            print("path is ",path)
            do {
                try await req.fileio.writeFile(file.data, at: path)
                return path
            }catch {
                print("Error is :",error.localizedDescription)
                return ""
            }
//        }
    }
    
    func getUploadedFiles(req: Request) async throws -> String {
        
        let input = try req.content.decode(Inputs.self)
        
        print(input.files)
        let arrData = await input.files.filter({$0.data.readableBytes > 0 })
            .asyncMap { file in
                return await getFileData(req: req, file: file)
            }
    
        
        return arrData.contains(where: {$0 == ""}) ? "Image Not Uploaded Successfully" :"Image Uploaded Successfully"
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}


struct Input: Content {
    var file: File
}

struct Inputs: Content {
    var files: [File]
    var firstName: String
    var lastName: String
}
