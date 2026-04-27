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
    func signOut() throws
}
