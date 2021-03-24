//
//  FCMRepository.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import Foundation
import FirebaseAuth
import shared

class FCMUserRepository: UserRepository {
    override func getUser(forceReload: Bool, completionHandler: @escaping (shared.User?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let firebaseUser = Auth.auth().currentUser {
                firebaseUser.getIDToken(completion: { (token, error) in
                    if let token = token, !token.isEmpty {
                        super.setToken(token: token)
                        super.getUser(forceReload: forceReload) { (user, error) in
                            DispatchQueue.main.async {
                                completionHandler(user, error)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(nil, error ?? "Not found")
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, "Not found" )
                }
            }
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                DispatchQueue.main.async {
                    completionHandler((error != nil), error)
                }
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (shared.User?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if error == nil {
                    self.getUser(forceReload: true, completionHandler: completionHandler)
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            })
        }
    }
    
    func signUp(email: String, password: String, role: Role, completionHandler: @escaping (shared.User?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let firebaseUser = result?.user {
                    firebaseUser.getIDToken(completion: { (token, error) in
                        if let token = token, !token.isEmpty {
                            super.setToken(token: token)
                            super.setRole(role: role) { (user, error) in
                                DispatchQueue.main.async {
                                    completionHandler(user, error)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                completionHandler(nil, error ?? "Not found")
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            })
        }
    }
}
