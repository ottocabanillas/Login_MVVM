//
//  APIClient.swift
//  Login_MVVM
//
//  Created by Oscar A. Rafael Cabanillas on 04/07/2024.
//

import Foundation

enum BackendError: String, Error {
    case invalidEmail = "Comprueba el Email"
    case invalidPassword = "Comprueba tu Password"
}

final class APIClient {
    func login (withEmail email: String, password: String) async throws -> User {
        // Simulate HTTP request and wait 2 seconds
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackEndLogic(email: email, password: password)
    }
}

func simulateBackEndLogic(email: String, password: String) throws -> User {
    guard email == "otto.cabanillas@gmail.com" else {
        print("User no encontrado")
        throw BackendError.invalidEmail
    }
    guard password == "qwerty" else {
        print("Contraseña incorrecta")
        throw BackendError.invalidPassword
    }
    print("Succes")
    return .init(name: "Otto", token: "token_4fs5gdfg2", sessionStrat: .now)
}
