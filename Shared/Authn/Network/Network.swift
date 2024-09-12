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
import OSLog

enum NetworkError: Error {
    case invalidData // Error when given data is invalid format
    case invalidResponse(cause: String) // Error when HTTP status code is not 2XX
    case unknownError // Unknown error
}

struct NetworkService {

    static let shared = NetworkService()

    func request<Req: Request>(_ request: Req) async throws -> Req.Response {
        var req = URLRequest(url: request.endpoint.url)
        req.httpMethod = request.endpoint.method
        req.allHTTPHeaderFields = request.endpoint.headers
        if let jsonData = try? JSONSerialization.data(withJSONObject: request.requestBody, options: []) {
            req.httpBody = jsonData
        }
        guard let (data, response) = try? await URLSession.shared.data(for: req) else {
            throw NetworkError.unknownError
        }
        let statusCode = (response as! HTTPURLResponse).statusCode
        os_log("HTTP status code: %@", log: .default, String(statusCode))
        os_log("data: %@", log: .default, String(decoding: data, as: UTF8.self))
        guard 200..<300 ~= statusCode else {
            throw NetworkError.invalidResponse(cause: String(decoding: data, as: UTF8.self))
        }
        guard let decodedData = try? request.getResponse(for: data) else {
            throw NetworkError.invalidData
        }
        return decodedData
    }
}
