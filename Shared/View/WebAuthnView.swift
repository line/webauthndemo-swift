// Copyright 2024 LY Corporation
//
// LY Corporation licenses this file to you under the Apache License,
// version 2.0 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at:
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.

import SwiftUI
import WebAuthn

let rp = WebAuthnRelyingParty()
let db = WebAuthnCredentialSourceStorage()!

struct WebAuthnView<PK: PublicKeyCredential>: View where PK.RP == WebAuthnRelyingParty {
    var credential: PK {
        switch PK.self {
        case is Biometric<WebAuthnRelyingParty>.Type:
            return Biometric(rp, db) as! PK
        case is DeviceCredential<WebAuthnRelyingParty>.Type:
            return DeviceCredential(rp, db) as! PK
        default:
            return DeviceCredential(rp, db) as! PK
        }
    }
    // Sign Up
    @State var signUpView = false
    @State var signUpSuccess = false
    // Sign In
    @State var signInView = false
    @State var signInSuccess = false
    // credential related state
    @State var showAllAccounts = false
    // username and display
    @State var username: String = ""
    @State var displayname: String = ""
    let origin = "ios:test-origin"
    // Error message
    @State var errorMessage = ""

    var body: some View {
        TitleView()
        if !signUpView && !signInView {
            HStack {
                Button("Sign Up") { signUpView = true }
                Button("Sign In") { signInView = true }
            }
        }
        if signUpView || signInView {
            NameInputView(username: $username, displayname: $displayname, opt: $signUpView)
        }
        if signUpView {
            SignUpView(credential: credential,
                       username: $username,
                       displayname: $displayname,
                       signUpView: $signUpView,
                       signUpSuccess: $signUpSuccess,
                       errorMessage: $errorMessage)
        }
        if signInView {
            SignInView(credential: credential,
                       username: $username,
                       displayname: $displayname,
                       signInView: $signInView,
                       signInSuccess: $signInSuccess,
                       errorMessage: $errorMessage)
        }
        Spacer()
        ZStack {
            ErrorMessageView(error: $errorMessage)
            if showAllAccounts {
                VStack {
                    let result = credential.getAll() ?? []
                    CredentialSourceView(credSrcs: result)
                }
            }
            Spacer()
        }
        AccountManagerView(credential: credential, show: $showAllAccounts, errMsg: $errorMessage)
    }
}

#Preview {
    WebAuthnView<Biometric>()
}
