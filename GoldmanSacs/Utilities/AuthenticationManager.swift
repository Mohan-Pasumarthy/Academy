//
//  AuthenticationManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthenticationError: Error {
    case emailAlreadyRegistered
    case metadataNotSaved
}

class AuthencationManager: AuthenticationProvider {

    func createUser(data: UserData) async throws -> AuthDataResultModel {
        if try await isEmailRegistered(data.email) {
            throw AuthenticationError.emailAlreadyRegistered
        }
        let authDataResult = try await Auth.auth().createUser(withEmail: data.email, password: data.password)
        try await saveUserMetadata(data, id: authDataResult.user.uid)
        return AuthDataResultModel(email: authDataResult.user.email ?? "", firstName: data.firstName, lastName: data.lastName ?? "")
    }

    func signIn(data: UserData) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: data.email, password: data.password)
        return AuthDataResultModel(email: authDataResult.user.email ?? "", firstName: data.firstName, lastName: data.lastName ?? "")
    }

    private func isEmailRegistered(_ email: String) async throws -> Bool {
        let normalizedEmail = email.lowercased()
        let usersCollection = Firestore.firestore().collection("users")
        let querySnapshot = try await usersCollection.whereField("email", isEqualTo: normalizedEmail).getDocuments()
        return !querySnapshot.documents.isEmpty
    }

    private func saveUserMetadata(_ data: UserData, id: String) async throws {
        let usersCollection = Firestore.firestore().collection("users")
        let metadata: [String: Any] = [
            "firstName": data.firstName,
            "lastName": data.lastName ?? "",
            "email": data.email,
            "password": data.password
        ]
        do {
            try await usersCollection.document(id).setData(metadata)
        } catch {
            throw AuthenticationError.metadataNotSaved
        }
    }

    func signOut() throws {
       //TODO: implement sign out logic
    }
}
