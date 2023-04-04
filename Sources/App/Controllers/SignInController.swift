//
//  SignInController.swift
//  
//
//  Created by Nayan Bhut on 5/14/22.
//

import Fluent
import Vapor
import Foundation
import Crypto

class SignInController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let loginGroup = routes.grouped("login")
        loginGroup.post(use: login)
        
        let registerGroup = routes.grouped("register")
        registerGroup.post(use: register)
        
        let protected = routes.grouped(UserAuthenticator())
        protected.post("editProfile",use: editProfile)
        
        let otp = routes.grouped("verifyOTP")
        otp.post(use: verifyOTP)
    }
    
    func createToken(req: Request, userId: String) -> String? {
        let payload = TokenPayload(subject: "JWTToken", expiration: .init(value: Date().addingTimeInterval(60 * 60)), isAdmin: false, userId: userId) //Valid for hour
        return getToken(req: req, payload: payload)
    }
    
    func login(req: Request) async throws -> ResponseModel<UserResponseModel> {
        let userData = try req.content.decode(RequestLogin.self)
        print(userData)
        
        let getUser = try await UsersData.query(on: req.db).filter(\.$email == (userData.email)).filter(\.$password == (userData.password)).first()
        
        guard let user = getUser else {return ResponseModel(data: nil, status: false,message: "Please enter valid detail.") }
        guard let verify = user.isVerified, verify == true else { return ResponseModel(data: nil, status: false,message: "Please verify your account.") }
        guard let token = createToken(req: req, userId: user.id?.uuidString ?? "") else { return ResponseModel(data: nil, status: false,message: "Token not created") }
        
        let userResponse = UserResponseModel(id:user.id, email: user.email, token: token, loginType: user.loginType, otp: nil, first_Name: user.first_Name,last_Name: user.last_Name, profile_image: user.profile_image)
        return ResponseModel(data: userResponse, status: true,message: nil)
    }
    
    func register(req: Request) async throws -> ResponseModel<UserResponseModel> {
        try UserRegisterModel.validate(content: req)
        
        let userDataModel = try req.content.decode(UserRegisterModel.self)
        
        guard let userProfile = userDataModel.profile_image, userProfile.data.readableBytes > 0, let imageName = await getFile(req: req, file: userProfile) else { return ResponseModel(data: nil, status: false,message: "User profile image is not valid.") }
        let getUser = try await UsersData.query(on: req.db).filter(\.$email == (userDataModel.email ?? "" )).first()
        guard getUser == nil else { return ResponseModel(data: nil, status: false,message: "User is already registered. Please login") }
        
        
        let userData = UsersData(regRequestModel: userDataModel)
        userData.id = UUID()
        userData.profile_image = imageName
        
        print(userData)
        do {    try await userData.save(on: req.db) }
        catch {
            print(error.localizedDescription)
            return ResponseModel(data: nil, status: false,message: "User not Registered") }
        
        let randomGenerate = random(digits: 6)
        let otpData = OTPModel(id: UUID(), otp: randomGenerate, userID: userData.id ?? UUID())
        try await otpData.save(on: req.db)
        
        let userResponse = UserResponseModel(email: nil, token: nil, loginType: nil, otp: String(randomGenerate))
        return ResponseModel(data: userResponse, status: true,message: "OTP Sent Successfully")
    }
    
    func verifyOTP(req: Request) async throws -> ResponseModel<UserResponseModel> {
//        try UsersData.validate(content: req)
        
        let requestOTP = try req.content.decode(RequestOTPVerify.self)
        
        guard let email = requestOTP.email else { return ResponseModel(data: nil, status: false,message: "Please enter valid email.") }
        
        let user = try await UsersData.query(on: req.db)
            .filter(\.$email == email)
            .first()
        
        if user?.isVerified == true { return ResponseModel(data: nil, status: false,message: "User already Verified. Please Login.") }
        
        guard let savedUser = user , let userID = savedUser.id else { return ResponseModel(data: nil, status: false,message: "User not found. Please register.") }
        guard let token = createToken(req: req, userId: user?.id?.uuidString ?? "") else { return ResponseModel(data: nil, status: false,message: "Token not created") }
        
        let otp = try await OTPModel.query(on: req.db).filter(\.$userID == userID).first()
        guard let otpData = otp else { return ResponseModel(data: nil, status: false,message: "User not found. Please register again.") }
        
        print(savedUser)
        
        let savedOTP = String(otpData.otp)
        if savedOTP == requestOTP.otp {
            savedUser.token = token
            savedUser.isVerified = true
            do { try await savedUser.update(on: req.db) }
            catch { return ResponseModel(data: nil, status: false,message: "Can not able to register User.") }
        
        }else {
            return ResponseModel(data: nil, status: false,message: "Please enter valid otp.")
        }
        
        let customer = CustomerModel(id:user?.id ,name: (user?.first_Name ?? "") + " " + (user?.last_Name ?? ""))
        try await customer.save(on: req.db)
         
        let userResponse = UserResponseModel(email: savedUser.email, token: token, loginType: savedUser.loginType, otp: nil)
        return ResponseModel(data: userResponse, status: true,message: "User Registered Successfully")
    }
    
    func editProfile(req: Request) async throws -> ResponseModel<UserResponseModel> {
        try req.auth.require(UsersData.self)
        try UserRegisterModel.validate(content: req)
        
        let userDataModel = try req.content.decode(UserRegisterModel.self)
        
        guard let getUser = try await UsersData.query(on: req.db).filter(\.$email == (userDataModel.email ?? "" )).first() else { return
            ResponseModel(data: nil, status: false,message: "Not able to update Profile. Invalid User") }
        
        let oldImage = getUser.profile_image ?? ""
        
        getUser.updateCurrentObject(regRequestModel: userDataModel)
        getUser.updatedDate = Date()
        
        print(getUser)
        
        if !oldImage.isEmpty {
            if let userProfile = userDataModel.profile_image, userProfile.data.readableBytes > 0,
               let imageName = await getFile(req: req, file: userProfile){
                getUser.profile_image = imageName
                do {
                    try await getUser.save(on: req.db)
                } catch {
                    return ResponseModel(data: nil, status: false,message: "Not able to update profile. \(error.localizedDescription)")
                }
            }
            let path = req.application.directory.publicDirectory + oldImage //Adding File To Path
            do { try FileManager.default.removeItem(atPath: path) } catch {
                print(error.localizedDescription)
                return ResponseModel(data: nil, status: true,message: "Profile Updated Successfully")
            }
            return ResponseModel(data: nil, status: true,message: "Profile Updated With Image Successfully")
        }else {
            print("User has no image")
            return ResponseModel(data: nil, status: true,message: "Profile Updated Successfully")
        }
    }
}

extension SignInController {
    func getFile(req: Request, file: File) async -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d-HH-MM-SS-"
        let prefix = formatter.string(from: .init())
        let fileName = prefix + file.filename
        let path = req.application.directory.publicDirectory + fileName //Adding File To Path
        let isImage = ["png", "jpeg", "jpg", "gif", "txt"].contains(file.extension?.lowercased())
        
        if !isImage {
            return nil
        }else {
            print("path is ",path)
            do {
                try await req.fileio.writeFile(file.data, at: path)
                return fileName
            }catch {
                print("Error is :",error.localizedDescription)
                return nil
            }
        }
    }
}


//        let planets = try Planet.query(on: self.database)
//            .field(\.$name)
//            .join(Star.self, on: \Planet.$star.$id == \Star.$id)
//            .field(Star.self, \.$name)
//            .all().wait()


/*
 func addProfilePicturePostHandler(_ req: Request)
 throws -> Future<Response> {
 // 1
 return try flatMap(
 to: Response.self,
 req.parameters.next(User.self),
 req.content.decode(ImageUploadData.self)) {
 user, imageData in
 // 2
 let workPath =
 try req.make(DirectoryConfig.self).workDir
 // 3
 let name =
 try "\(user.requireID())-\(UUID().uuidString).jpg"
 // 4
 let path = workPath + self.imageFolder + name
 // 5
 FileManager().createFile(
 atPath: path,
 contents: imageData.picture,
 attributes: nil)
 // 6
 user.profilePicture = name
 // 7
 let redirect =
 try req.redirect(to: "/users/\(user.requireID())")
 return user.save(on: req).transform(to: redirect)
 }
 }

 */


/*
 let serverConfig = req.application.http.server.configuration
 let hostname = serverConfig.hostname
 let port = serverConfig.port
 */
