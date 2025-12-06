//
//  ContentView.swift
//  ToDo_1206
//
//  Created by 清水大喜 on 2025/12/06.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [String] = []
    @State private var newItem: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Add new task...",text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    }
                .padding()
                
                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("ToDo List")
        }
    }
    private func addItem() {
        guard !newItem.isEmpty else { return }
        items.append(newItem)
        newItem = ""
    }
    private func deleteItems (at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
}
#Preview{
    ContentView()
}
