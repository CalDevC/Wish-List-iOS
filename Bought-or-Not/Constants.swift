//
//  Constants.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/23/22.
//

import Foundation

struct Constants{
    struct userSettings{
        static let signOut = "Sign Out"
        static let editAcct = "Edit Account"
        static let signOutErr = "The current user could not be signed out at this time. Please try again later."
    }
    
    struct segues{
        static let landingToSignin = "toSignIn"
        static let landingToRegistration = "toRegistration"
        static let registrationToHome = "toHome"
        static let signinToHome = "toHome"
        static let homeToUserSettings = "homeToUserSettings"
        static let friendToProfile = "toProfile"
    }
}
