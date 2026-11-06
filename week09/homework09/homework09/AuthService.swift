//
//  AuthService.swift
//  homework09
//
//  Created by Amina Magomedova on 05.11.2026.
//

import Foundation
import FirebaseAuth

// handling sign up and sign in/out
@Observable
class AuthService {

  // user who signed in, or nil
  var user: User?
  var errorMessage = ""

  static let single = AuthService()
    
  init() {
  }

  @ObservationIgnored
  var started = false

  // listener tracks when someone signs in or out, which makes the screen swap
  func start() {
    if started { return }
    started = true

    //
    Auth.auth().addStateDidChangeListener { _, user in
      Task { @MainActor in
        self.user = user
      }
    }
  }

  var signedIn: Bool {
    user != nil
  }

  var userID: String {
    user?.uid ?? ""
  }

  var email: String {
    user?.email ?? ""
  }

  // sign up/in/out logic taken from https://firebase.google.com/docs/auth/ios/password-auth
  // making a new account with this email and password
  func signUp(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
      Task { @MainActor in
        self.errorMessage = error?.localizedDescription ?? ""
      }
    }
  }

  // signing into an account that already exists
  func signIn(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { _, error in
      Task { @MainActor in
        self.errorMessage = error?.localizedDescription ?? ""
      }
    }
  }

  func signOut() {
    try? Auth.auth().signOut()
  }
}
