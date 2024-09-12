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

enum Endpoint {
    case getRegistrationChallenge
    case getRegistrationResult
    case getAuthenticationChallenge
    case getAuthenticationResult
}

extension Endpoint {

    var domain: String {
        return "example.com" // Change here!
    }

    var path: String {
        switch self {
        case .getRegistrationChallenge:
            return "attestation/options"
        case .getRegistrationResult:
            return "attestation/result"
        case .getAuthenticationChallenge:
            return "assertion/options"
        case .getAuthenticationResult:
            return "assertion/result"
        }
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = "/" + path
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }

    var headers: [String: String] {
        switch self {
        case .getRegistrationChallenge, .getAuthenticationChallenge:
            return ["Host": domain, "Content-Type": "application/json"]
        case .getRegistrationResult, .getAuthenticationResult:
            return ["Content-Type": "application/json"]
        }
    }

    var method: String {
        switch self {
        case .getRegistrationChallenge,
             .getRegistrationResult,
             .getAuthenticationChallenge,
             .getAuthenticationResult:
            return "POST"
        }
    }
}
