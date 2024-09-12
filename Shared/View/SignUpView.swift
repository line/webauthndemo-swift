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

struct SignUpView<PK: PublicKeyCredential>: View where PK.RP == WebAuthnRelyingParty {
    @State var attestation = AttestationConveyancePreference.none.rawValue
    @State var attachment = AuthenticatorAttachment.platform.rawValue
    @State var userVerification = UserVerificationRequirement.preferred.rawValue
    var credential: PK
    @Binding var username: String
    @Binding var displayname: String
    @Binding var signUpView: Bool
    @Binding var signUpSuccess: Bool
    @Binding var errorMessage: String

    var body: some View {
        RegistrationOptionView(attestation: $attestation,
                               attachment: $attachment,
                               userVerification: $userVerification)
        HStack {
            Button("Sign Up") {
                let options = WebAuthnRegistrationOptions(
                    username: username,
                    displayname: displayname,
                    attestation: AttestationConveyancePreference.ofString(attestation),
                    attachment: AuthenticatorAttachment.ofString(attachment),
                    userVerification: UserVerificationRequirement.ofString(userVerification))
                Task {
                    credential.performAsyncTask {
                        do {
                            signUpSuccess = try await credential.create(options).get()
                        } catch {
                            errorMessage = "\(error)"
                        }
                    }
                }
            }
            .buttonStyle(CustomButtonStyle())
            .navigationDestination(isPresented: $signUpSuccess) {
                HelloWorldView().onAppear {
                    signUpView = false
                    errorMessage = ""
                }
            }
            Button("Cancellation") {
                signUpView = false
                errorMessage = ""
            }
            .buttonStyle(CustomButtonStyle(backgroundColor: .red))
        }
    }
}
