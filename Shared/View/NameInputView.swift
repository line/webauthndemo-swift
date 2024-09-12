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

struct NameInputView: View {
    @Binding var username: String
    @Binding var displayname: String
    @Binding var opt: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.system(size: 24, weight: .thin))
                TextField("Hong Gildong", text: $username)
                    .padding()
                    .border(.green)
            }
            if opt {
                VStack(alignment: .leading) {
                    Text("Display name")
                        .font(.system(size: 24, weight: .thin))
                    TextField("Hong", text: $displayname)
                        .padding()
                        .border(.green)
                }
            }
        }.padding()
    }
}
