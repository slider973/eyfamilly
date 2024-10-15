//
//  FirebaseAuthService.swift
//  EyFamily
//
//  Created by jonathan lemaine on 12/10/2024.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.fetchUserData(for: authResult.user.uid) { result in
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func fetchUserData(for uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let user = User(from: document) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirebaseAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user data"])))
                }
            } else {
                completion(.failure(NSError(domain: "FirebaseAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document does not exist"])))
            }
        }
    }
    
    // Ajoutez d'autres méthodes d'authentification selon vos besoins
}
