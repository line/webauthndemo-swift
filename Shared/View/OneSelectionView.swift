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

struct CellView: View {

    let item: String
    @Binding var selectedItem: String

    var body: some View {
        HStack {
            Button(action: {}, label: {
                Image(systemName: selectedItem == item ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        selectedItem = item
                    }
            })
            Text(item)
                .fontWeight(.thin)
        }
    }
}

struct OneSelectionView: View {

    let settingName: String
    let itemList: [String]
    @Binding var selectedItem: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(settingName)
                    .padding(.bottom)
                    .font(.system(size: 24, weight: .thin))
                ForEach(itemList, id: \.self) { item in
                    CellView(item: item, selectedItem: $selectedItem)
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    let settingName = "Select One"
    let itemList = ["test1", "test2", "test3", "test4", "test5"]
    @State var selectedItem = "test1"
    return OneSelectionView(settingName: settingName, itemList: itemList, selectedItem: $selectedItem)
}
