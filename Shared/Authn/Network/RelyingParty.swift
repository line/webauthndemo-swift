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

import Foundation
import WebAuthn

struct WebAuthnRegistrationOptions: RegistrationOptions {
    let username: String
    let displayname: String
    let attestation: AttestationConveyancePreference
    let attachment: AuthenticatorAttachment
    let userVerification: UserVerificationRequirement
}

struct WebAuthnAuthenticationOptions: AuthenticationOptions {
    var username: String
    var userVerification: UserVerificationRequirement
}

class WebAuthnRelyingParty: RelyingParty {
    typealias RegOpts = WebAuthnRegistrationOptions
    typealias RegData = WebAuthnRegistrationData
    typealias AuthnOpts = WebAuthnAuthenticationOptions
    typealias AuthnData = WebAuthnAuthenticationData
    
    func getRegistrationData(_ options: WebAuthnRegistrationOptions) async -> Result<WebAuthnRegistrationData, Error> {
        let endpoint = Endpoint.getRegistrationChallenge
        let body: [String: Any] = [
            "attestation": options.attestation.rawValue,
            "authenticatorSelection": [
                "authenticatorAttachment": options.attachment.rawValue,
                "userVerification": options.userVerification.rawValue
            ] as [String: Any],
            "username": options.username,
            "displayName": options.displayname
        ]
        let request = RegistrationChallengeRequest(endpoint: endpoint, requestBody: body)
        do {
            let response = try await NetworkService.shared.request(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func verifyRegistration(_ result: PublicKeyCredentialCreateResult) async -> Result<Bool, Error> {
        let endpoint = Endpoint.getRegistrationResult
        let body: [String: Any] = [
            "rawId": result.id.toBase64Url(),
            "id": result.id.toBase64Url(),
            "response": [
                "attestationObject": result.attestation.toBase64Url(),
                "clientDataJSON": result.clientDataJson.toBase64Url()
            ] as [String: Any],
            "type": "public-key",
        ]
        let request = VerificationRequest(endpoint: endpoint, requestBody: body)
        do {
            let response = try await NetworkService.shared.request(request)
            return .success(response.status == "ok" ? true : false)
        } catch {
            return .failure(error)
        }
    }
    
    func getAuthenticationData(_ option: WebAuthnAuthenticationOptions) async -> Result<WebAuthnAuthenticationData, Error> {
        let endpoint = Endpoint.getAuthenticationChallenge
        let body: [String: Any] = [
            "username": option.username,
            "userVerification": option.userVerification.rawValue
        ]
        do {
            let request = AuthenticationChallengeRequest(endpoint: endpoint, requestBody: body)
            let response = try await NetworkService.shared.request(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func verifyAuthentication(_ result: WebAuthn.PublicKeyCredentialGetResult) async -> Result<Bool, Error> {
        let endpoint = Endpoint.getAuthenticationResult
        let body: [String: Any] = [
            "rawId": result.id.toBase64Url(),
            "id": result.id.toBase64Url(),
            "response": [
                "clientDataJSON": result.clientDataJson.toBase64Url(),
                "authenticatorData": result.authenticatorData.toBase64Url(),
                "signature": result.signature.toBase64Url(),
                "userHandle": result.userHandle!
            ],
            "type": "public-key"
        ]
        do {
            let request = VerificationRequest(endpoint: endpoint, requestBody: body)
            let response = try await NetworkService.shared.request(request)
            return .success(response.status == "ok" ? true : false)
        } catch {
            return .failure(error)
        }
    }
}
