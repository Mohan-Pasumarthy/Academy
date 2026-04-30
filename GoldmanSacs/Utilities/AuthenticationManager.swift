//
//  AuthenticationManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

class AuthencationManager: AuthenticationProvider {

    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func isEmailRegistered(_ email: String) async throws -> Bool {
        let normalizedEmail = email.lowercased()
        let usersCollection = Firestore.firestore().collection("users")
        let querySnapshot = try await usersCollection.whereField("email", isEqualTo: normalizedEmail).getDocuments()
        return !querySnapshot.documents.isEmpty
    }

    func saveUserMetadata(_ metadata: UserMetadata) async throws {
        let usersCollection = Firestore.firestore().collection("users")
        let data: [String: Any] = [
            "username": metadata.firstName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            "email": metadata.email.lowercased(),
            "firstName": metadata.firstName,
            "lastName": metadata.lastName ?? "",
            "uid": metadata.uid
        ]
        try await usersCollection.document(metadata.uid).setData(data)
    }

    func signOut() throws {
       //TODO: implement sign out logic
    }
}
