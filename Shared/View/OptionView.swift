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

struct RegistrationOptionView: View {
    @Binding var attestation: String
    @Binding var attachment: String
    @Binding var userVerification: String

    var body: some View {
        ScrollView {
            OneSelectionView(settingName: "Attestation",
                             itemList: AttestationConveyancePreference.allCases.map { $0.rawValue },
                             selectedItem: $attestation
            )
            Divider().padding()
            OneSelectionView(settingName: "Authenticator Attachment",
                             itemList: AuthenticatorAttachment.allCases.map { $0.rawValue },
                             selectedItem: $attachment
            )
            Divider().padding()
            OneSelectionView(settingName: "User Verification",
                             itemList: UserVerificationRequirement.allCases.map { $0.rawValue },
                             selectedItem: $userVerification
            )
        }
    }
}

struct AuthenticationOptionView: View {
    @Binding var userVerification: String

    var body: some View {
        ScrollView {
            OneSelectionView(settingName: "User Verification",
                             itemList: UserVerificationRequirement.allCases.map { $0.rawValue },
                             selectedItem: $userVerification
            )
        }
    }
}
