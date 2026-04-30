//
//  AuthenticationProvider.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 27/04/26.
//

import Foundation

protocol AuthenticationProvider {
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func isEmailRegistered(_ email: String) async throws -> Bool
    func saveUserMetadata(_ metadata: UserMetadata) async throws
    func signOut() throws
}
