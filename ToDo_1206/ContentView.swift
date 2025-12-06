//
//  ContentView.swift
//  ToDo_1206
//
//  Created by 清水大喜 on 2025/12/06.
//

import SwiftUI
import Combine

struct Task: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isChecked: Bool = false
    // Per-task timer
    var targetDate: Date? = nil
    var isTimerRunning: Bool = false
}

struct ContentView: View {
    @State private var items: [Task] = []
    @State private var newItem: String = ""
    @State private var now: Date = Date()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Add new task...",text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit(addItem)
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    }
                .padding()
                
                List {
                    ForEach(items) { item in
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: {
                                if let index = items.firstIndex(of: item) {
                                    // Toggle check and stop timer if checked
                                    items[index].isChecked.toggle()
                                    if items[index].isChecked {
                                        items[index].targetDate = nil
                                        items[index].isTimerRunning = false
                                    }
                                }
                            }) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isChecked ? .green : .gray)
                            }
                            .buttonStyle(.plain)

                            Text(item.title)
                                .foregroundColor(item.isChecked ? .gray : .primary)
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Spacer(minLength: 8)

                            // Right-aligned timer controls
                            Group {
                                if let target = item.targetDate {
                                    let remaining = max(0, Int(target.timeIntervalSince(now)))
                                    HStack(spacing: 6) {
                                        Text(remaining > 0 ? formatSeconds(remaining) : "タイムアップ！")
                                            .font(.caption)
                                            .foregroundColor(remaining > 0 ? .secondary : .red)
                                            .lineLimit(1)

                                        if remaining > 0 {
                                            Button("キャンセル") {
                                                if let index = items.firstIndex(of: item) {
                                                    items[index].targetDate = nil
                                                    items[index].isTimerRunning = false
                                                }
                                            }
                                            .buttonStyle(.bordered)
                                            .font(.caption)
                                        } else {
                                            Button("リセット") {
                                                if let index = items.firstIndex(of: item) {
                                                    items[index].targetDate = nil
                                                    items[index].isTimerRunning = false
                                                }
                                            }
                                            .buttonStyle(.bordered)
                                            .font(.caption)
                                        }
                                    }
                                } else {
                                    HStack(spacing: 6) {
                                        // Preset buttons
                                        Button("5分") {
                                            if let index = items.firstIndex(of: item) {
                                                items[index].targetDate = now.addingTimeInterval(5 * 60)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .font(.caption)

                                        Button("10分") {
                                            if let index = items.firstIndex(of: item) {
                                                items[index].targetDate = now.addingTimeInterval(10 * 60)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .font(.caption)

                                        Button("25分") {
                                            if let index = items.firstIndex(of: item) {
                                                items[index].targetDate = now.addingTimeInterval(25 * 60)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .font(.caption)

                                        // Optional DatePicker for custom time
                                        DatePicker("タイマー", selection: Binding(
                                            get: { now.addingTimeInterval(60) },
                                            set: { newDate in
                                                if let index = items.firstIndex(of: item) {
                                                    items[index].targetDate = newDate
                                                }
                                            }
                                        ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()

                                        Button("開始") {
                                            if let index = items.firstIndex(of: item) {
                                                if items[index].targetDate == nil {
                                                    items[index].targetDate = now.addingTimeInterval(60)
                                                }
                                                items[index].isTimerRunning = true
                                            }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("ToDo List")
            .onReceive(ticker) { date in
                now = date
            }
        }
    }
    private func addItem() {
        guard !newItem.isEmpty else { return }
        items.append(Task(title: newItem))
        newItem = ""
    }
    private func deleteItems (at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
    private func formatSeconds(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%d:%02d", m, s)
        }
    }
}

#Preview{
    ContentView()
}
