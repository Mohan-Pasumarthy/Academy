//
//  AuthenticationProvider.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 27/04/26.
//

import Foundation


protocol AuthenticationProvider {
    func createUser(data: UserData) async throws -> AuthDataResultModel
    func signIn(data: UserData) async throws -> AuthDataResultModel
    func signOut() throws
}
