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
        
        let otp = routes.grouped("verifyOTP")
        otp.post(use: verifyOTP)
    }
    
    func createToken(req: Request, userId: String) -> String? {
        let payload = TokenPayload(subject: "JWTToken", expiration: .init(value: Date().addingTimeInterval(60 * 60 * 8)), isAdmin: false, userId: userId) //Valid for 8 hour
        return getToken(req: req, payload: payload)
    }
    
    func login(req: Request) async throws -> ResponseModel<UserResponseModel> {
        let userData = try req.content.decode(RequestLogin.self)
        print(userData)
        
        let getUser = try await UsersData.query(on: req.db).filter(\.$email == (userData.email)).filter(\.$password == (userData.password)).first()
        guard let user = getUser else {return ResponseModel(data: nil, status: false,message: "Please enter valid detail.") }
        guard let verify = user.isVerified, verify == true else { return ResponseModel(data: nil, status: false,message: "Please verify your account.") }
        guard let token = createToken(req: req, userId: user.id?.uuidString ?? "") else { return ResponseModel(data: nil, status: false,message: "Token not created") }
        
        let userResponse = UserResponseModel(id:user.id, email: user.email, token: token, loginType: user.loginType, otp: nil, first_Name: user.first_Name,last_Name: user.last_Name)
        return ResponseModel(data: userResponse, status: true,message: nil)
    }
    
    func register(req: Request) async throws -> ResponseModel<UserResponseModel> {
        try UsersData.validate(content: req)
        
        let userData = try req.content.decode(UsersData.self)
        
        let getUser = try await UsersData.query(on: req.db).filter(\.$email == (userData.email )).first()
        guard getUser == nil else { return ResponseModel(data: nil, status: false,message: "User is already registered. Please login") }
        
        userData.id = UUID()
        userData.token = ""
        userData.isVerified = false
        
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
        
        let payload = TokenPayload(subject: "JWTToken", expiration: .init(value: Date()), isAdmin: false, userId: user?.id?.uuidString ?? "")
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
    
}


//        let planets = try Planet.query(on: self.database)
//            .field(\.$name)
//            .join(Star.self, on: \Planet.$star.$id == \Star.$id)
//            .field(Star.self, \.$name)
//            .all().wait()
