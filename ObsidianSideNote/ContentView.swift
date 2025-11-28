//
//  ContentView.swift
//  ObsidianSideNote
//
//  Created by Luke Smith on 11/27/25.
//

import SwiftUI
import AppKit
import MarkdownUI

struct ContentView: View {
    let mode: NoteMode
    let closeWindow: () -> Void
    
    @State private var noteText: String = ""
    @State private var noteTitle: String = ""
    @State private var vaultName: String = UserDefaults.standard.string(forKey: "obsidianVault") ?? ""
    @State private var showSaveSuccess: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if mode == .settings {
                SettingsView(vaultName: $vaultName, closeWindow: closeWindow)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Note taking interface
                VStack(spacing: 0) {
                    // Compact header with title
                    if mode == .newNote {
                        VStack(spacing: 0) {
                            TextField("Title", text: $noteTitle)
                                .textFieldStyle(.plain)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                            
                            Divider()
                        }
                        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                    }
                    
                    // Markdown editor
                    MarkdownEditorView(text: $noteText, isFocused: $isTextEditorFocused)
                    
                    // Bottom action bar
                    HStack(spacing: 12) {
                        Button(action: saveNote) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.down.circle.fill")
                                Text("Save to Obsidian")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor)
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                        .disabled(vaultName.isEmpty || noteText.isEmpty)
                        .opacity(vaultName.isEmpty || noteText.isEmpty ? 0.5 : 1.0)
                        
                        Spacer()
                        
                        if showSaveSuccess {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Saved!")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        Button(action: {
                            noteText = ""
                            noteTitle = ""
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("Clear")
                        
                        Button(action: closeWindow) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("Close")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                }
            }
        }
        .frame(minWidth: 350, minHeight: 400)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if mode != .settings {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isTextEditorFocused = true
                    }
            }
        }
    }
    
    private var titleText: String {
        switch mode {
        case .appendDaily:
            return "Append to Daily Note"
        case .newNote:
            return "Create New Note"
        case .settings:
            return "Settings"
        }
    }
    
    private func saveNote() {
        guard !vaultName.isEmpty else { return }
        
        var urlString = "obsidian://adv-uri?vault=\(vaultName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        switch mode {
        case .appendDaily:
            urlString += "&daily=true"
            urlString += "&mode=append"
            urlString += "&data=\(("\n\n" + noteText).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
        case .newNote:
            let filename = noteTitle.isEmpty ? "Quick Note \(dateString())" : noteTitle
            urlString += "&filename=\(filename.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            urlString += "&data=\(noteText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
        case .settings:
            return
        }
        
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
            
            withAnimation(.spring(response: 0.3)) {
                showSaveSuccess = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                noteText = ""
                noteTitle = ""
                showSaveSuccess = false
                closeWindow()
            }
        }
    }
    
    private func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm"
        return formatter.string(from: Date())
    }
}

struct SettingsView: View {
    @Binding var vaultName: String
    let closeWindow: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: closeWindow) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Obsidian Vault")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        TextField("vault-name", text: $vaultName)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: vaultName) { oldValue, newValue in
                                UserDefaults.standard.set(newValue, forKey: "obsidianVault")
                            }
                        
                        Text("Enter the exact name of your Obsidian vault")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Keyboard Shortcuts")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        KeyboardShortcutRow(key: "⌘D", description: "Append to Daily Note")
                        KeyboardShortcutRow(key: "⌘N", description: "Create New Note")
                        KeyboardShortcutRow(key: "⌘,", description: "Settings")
                    }
                }
                .padding(16)
            }
            .background(Color(NSColor.textBackgroundColor).opacity(0.5))
        }
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 12)) 
    }
}

struct KeyboardShortcutRow: View {
    let key: String
    let description: String
    
    var body: some View {
        HStack {
            Text(key)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct MarkdownEditorView: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    @State private var showPreview: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar with frosted glass effect
            HStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        MarkdownButton(symbol: "bold", action: { wrapSelection("**") }, tooltip: "Bold")
                        MarkdownButton(symbol: "italic", action: { wrapSelection("*") }, tooltip: "Italic")
                        MarkdownButton(symbol: "strikethrough", action: { wrapSelection("~~") }, tooltip: "Strikethrough")
                        
                        Divider()
                            .frame(height: 16)
                        
                        MarkdownButton(symbol: "link", action: { insertLink() }, tooltip: "Link")
                        MarkdownButton(symbol: "list.bullet", action: { insertPrefix("- ") }, tooltip: "Bullet List")
                        MarkdownButton(symbol: "list.number", action: { insertPrefix("1. ") }, tooltip: "Numbered List")
                        MarkdownButton(symbol: "checkmark.square", action: { insertPrefix("- [ ] ") }, tooltip: "Task List")
                    }
                    .padding(.vertical, 8)
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Toggle(isOn: $showPreview) {
                    Image(systemName: showPreview ? "pencil" : "eye")
                        .foregroundColor(.secondary)
                }
                .toggleStyle(.button)
                .buttonStyle(.plain)
                .help(showPreview ? "Edit" : "Preview")
                .padding(.trailing, 12)
                .padding(.vertical, 8)
            }
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            
            Divider()
            
            // Editor or Preview
            if showPreview {
                ScrollView {
                    Markdown(text)
                        .markdownTextStyle(\.text) {
                            FontSize(16)
                            ForegroundColor(.primary)
                        }
                        .markdownTextStyle(\.code) {
                            FontFamilyVariant(.monospaced)
                            FontSize(14)
                            BackgroundColor(Color(NSColor.controlBackgroundColor).opacity(0.5))
                        }
                        .markdownBlockStyle(\.codeBlock) { configuration in
                            configuration.label
                                .padding()
                                .markdownTextStyle {
                                    FontFamilyVariant(.monospaced)
                                    FontSize(14)
                                }
                                .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
                                .cornerRadius(8)
                        }
                        .markdownBlockStyle(\.taskListMarker) { configuration in
                            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(configuration.isCompleted ? .green : .secondary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(NSColor.textBackgroundColor).opacity(0.3))
            } else {
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .padding(14)
                    .background(Color(NSColor.textBackgroundColor).opacity(0.3))
            }
        }
    }
    
    private func wrapSelection(_ wrapper: String) {
        text += "\(wrapper)text\(wrapper)"
    }
    
    private func insertLink() {
        text += "[link text](url)"
    }
    
    private func insertPrefix(_ prefix: String) {
        if text.isEmpty || text.hasSuffix("\n") {
            text += prefix
        } else {
            text += "\n\(prefix)"
        }
    }
}

struct MarkdownButton: View {
    let symbol: String
    let action: () -> Void
    let tooltip: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .foregroundColor(.secondary)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        .help(tooltip)
    }
}

// Visual Effect View for frosted glass background
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    ContentView(mode: .newNote, closeWindow: {})
}
