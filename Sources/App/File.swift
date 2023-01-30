//
//  File.swift
//  
//
//  Created by Nayan Bhut on 6/17/22.
//

/*
import Foundation
import SwiftJWT



struct ClientSecretPayload: Claims {
    // The issuer registered claim key, which has the value of your 10-character Team ID, obtained from your developer account.
    let iss: String
    
    // The issued at registered claim key, the value of which indicates the time at which the token was generated, in terms of the number of seconds since Epoch, in UTC.
    let iat: Date
    
    // The expiration time registered claim key, the value of which must not be greater than 15777000 (6 months in seconds) from the Current Unix Time on the server.
    let exp: Date
    
    // The audience registered claim key, the value of which identifies the recipient the JWT is intended for.
    // Since this token is meant for Apple, use https://appleid.apple.com.
    let aud: String
    
    // The subject registered claim key, the value of which identifies the principal that is the subject of the JWT. Use the same value as client_id as this token is meant for your application.
    let sub: String
}

struct AppleSignInCreds {
    func createClientSecret(config : ServerConfiguration.AppleSignIn) -> String? {
        let privateKey = config.privateKey.replacingOccurrences(of: "\\n", with: "\n")
        
        guard let privateKeyData = privateKey.data(using: .utf8) else {
            return nil
        }
        
        let jwtSigner:JWTSigner
        
        // Is this going to work on Linux?
        if #available(OSX 10.13, *) {
            jwtSigner = JWTSigner.es256(privateKey: privateKeyData)
        } else {
            return nil
        }
        
        // I think by `kid`, they mean key id.
        // For the fields in the header and payload, see
        // https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens
        let header = Header(kid: config.keyId)
        
        let expiryIntervalOneDay: TimeInterval = 60 * 60 * 24
        let exp = Date().addingTimeInterval(expiryIntervalOneDay)
        let payload = ClientSecretPayload(iss: config.teamId, iat: Date(), exp: exp, aud: "https://appleid.apple.com", sub: config.clientId)
        
        var jwt = JWT(header: header, claims: payload)
        let result = try? jwt.sign(using: jwtSigner)
        return result
    }
}


struct ServerConfiguration: Decodable {
    struct AppleSignIn: Decodable {
        // From creating a Service Id for your app.
        let redirectURI: String = ""
        
        // The reverse DNS style app identifier for your iOS app.
        let clientId: String = "com.bv.crew.crewApp"
        
        // MARK: For generating the client secret; See notes in AppleSignInCreds+ClientSecret.swift
        
        let keyId: String = "692P2827AY"
        
        let teamId: String = "HNH9T8AM76"
        
        // Once generated from the Apple developer's website, the key is converted
        // to a single line for the JSON using:
        //      awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' *.p8
        // Script from https://docs.vmware.com/en/Unified-Access-Gateway/3.0/com.vmware.access-point-30-deploy-config.doc/GUID-870AF51F-AB37-4D6C-B9F5-4BFEB18F11E9.html
        let privateKey: String = "-----BEGIN PRIVATE KEY-----\\nMIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgdkzrgx+3xw6E5M+l\\nD7c47FEi5gIFJY8wSqNcS5cEabmgCgYIKoZIzj0DAQehRANCAARXuxwwsXEHqUA5\\nENGfselphmNLWQ9H7uKtgCy8YQnA4oa0Ec22Y3E4BTU7vLuWh1yLyn6B3scUvlew\\nd0Rx+i3N\\n-----END PRIVATE KEY-----\\n"
    }
    let appleSignIn: AppleSignIn?
}
*/