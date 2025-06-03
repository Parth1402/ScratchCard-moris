//
//  PushNotificationManager.swift
//  SendPushNotifications
//
//  Created by Irakli Chkhitunidze on 12/9/23.
//

import Foundation
import FirebaseCore
import SwiftyRSA

class PushNotificationManager {
    
    static func generateAccessToken(completion: @escaping (String?) -> Void) {
        
        let url = URL(string: "https://oauth2.googleapis.com/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Load the service account key
        guard let serviceAccountFilePath = Bundle.main.path(forResource: "ovulio-baby-f46ecc662d0b", ofType: "json"),
              let serviceAccountData = try? Data(contentsOf: URL(fileURLWithPath: serviceAccountFilePath)),
              let serviceAccount = try! JSONSerialization.jsonObject(with: serviceAccountData, options: []) as? [String: Any],
              let clientEmail = serviceAccount["client_email"] as? String,
              let privateKeyString = serviceAccount["private_key"] as? String else {
            completion(nil)
            return
        }
        
        let header: [String: Any] = ["alg": "RS256", "typ": "JWT"]
        let claimSet: [String: Any] = [
            "iss": clientEmail,
            "scope": "https://www.googleapis.com/auth/firebase.messaging",
            "aud": "https://oauth2.googleapis.com/token",
            "iat": Int(Date().timeIntervalSince1970),
            "exp": Int(Date().addingTimeInterval(3600).timeIntervalSince1970)
        ]
        
        guard let headerData = try? JSONSerialization.data(withJSONObject: header, options: []),
              let claimSetData = try? JSONSerialization.data(withJSONObject: claimSet, options: []),
              let headerBase64 = headerData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let claimSetBase64 = claimSetData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil)
            return
        }
        
        let toSign = "\(headerBase64).\(claimSetBase64)"
        
        do {
            let privateKey = try PrivateKey(pemEncoded: privateKeyString)
            let clear = try ClearMessage(string: toSign, using: .utf8)
            let signature = try clear.signed(with: privateKey, digestType: .sha256)
            let signedString = signature.base64String
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
                .replacingOccurrences(of: "=", with: "")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "+", with: "-") ?? ""
            
            let jwt = "\(toSign).\(signedString)"
            
            let body: [String: String] = [
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                "assertion": jwt
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    completion(accessToken)
                } else {
                    completion(nil)
                }
            }
            
            task.resume()
        } catch {
            print("Error signing JWT: \(error)")
            completion(nil)
        }
        
    }
    
    
    static func sendPushNotification(to receiverFCM: String, title: String, body: String ) {
        
        generateAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Failed to generate access token")
                return
            }
            
            let urlString = "https://fcm.googleapis.com/v1/projects/ovulio-baby/messages:send"
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let message: [String: Any] = [
                "message": [
                    "token": receiverFCM,
                    "notification": [
                        "title": title,
                        "body": body
                    ],
                    "apns" : [
                        "payload": [
                            "aps": [
                                "badge": 1,
                                "sound": "PushNotificationSound.m4a"
                            ]
                        ]
                    ]
                ]
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print("Error serializing JSON:", error)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending notification:", error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Successfully sent notification")
                } else {
                    print("Error sending notification, status code:", (response as? HTTPURLResponse)?.statusCode ?? 0)
                }
            }
            task.resume()
        }
    }
    
    
    /*
    static func sendPushNotification(to receiverFCM: String, title: String, body: String ) {
        
        let serverKey = "AAAADsfuOg0:APA91bHcpE2H3H1DUXJjM0EG5rHqSPpQo98MkuJRZa08LtRYuZ9kv1k_wSBV-mg0E8a4XPB0r2V60tvFW9Wk2UagtuEPDgJAY77pgYiwIXZIq4rIbr_q0vm3D6mZXIG1scSbEA3FdvzK"
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the request headers
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the request body data
        let requestBody: [String: Any] = [
            "to": receiverFCM,
            "notification": [
                "title": title,
                "sound":"PushNotificationSound.m4a",
                "badge" : 1,
                "body": body
            ]
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
            request.httpBody = jsonData
            
            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }
            }.resume()
            
        }
        
    }
    */
}
