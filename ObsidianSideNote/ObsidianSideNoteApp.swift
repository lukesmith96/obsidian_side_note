//
//  ObsidianSideNoteApp.swift
//  ObsidianSideNote
//
//  Created by Luke Smith on 11/27/25.
//

import SwiftUI
import AppKit

@main
struct ObsidianSideNoteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var window: NSWindow?  // Changed from NSPanel? to NSWindow?
    var menu: NSMenu?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "note.text", accessibilityDescription: "Quick Notes")
        }
        
        // Create the menu
        menu = NSMenu()
        
        // Add menu items
        menu?.addItem(NSMenuItem(title: "Append to Daily Note", action: #selector(openAppendToDaily), keyEquivalent: "d"))
        menu?.addItem(NSMenuItem(title: "Create New Note", action: #selector(openNewNote), keyEquivalent: "n"))
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // Assign the menu to the status item
        statusItem?.menu = menu
        
        // Keep the app running as an accessory (no dock icon)
        NSApp.setActivationPolicy(.accessory)
        
        // Subscribe to space change notifications
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(activeSpaceDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
    }
    
    @objc func openAppendToDaily() {
        // Open window in "append to daily" mode
        _ = getOrBuildWindow(mode: .appendDaily)
        showWindow()
    }
    
    @objc func openNewNote() {
        // Open window in "new note" mode
        _ = getOrBuildWindow(mode: .newNote)
        showWindow()
    }
    
    @objc func openSettings() {
        // Open window in "settings" mode
        _ = getOrBuildWindow(mode: .settings)
        showWindow()
    }
    
    func getOrBuildWindow(mode: NoteMode) -> NSWindow {
        // If window exists, just update the content view with new mode
        if let existingWindow = window {
            existingWindow.contentView = NSHostingView(rootView: ContentView(mode: mode, closeWindow: { [weak self] in
                self?.window?.orderOut(nil)
            }))
            return existingWindow
        }
        
        // Get the screen dimensions
        guard let screen = NSScreen.main else {
            fatalError("No main screen found")
        }
        let screenFrame = screen.visibleFrame
        
        // Define window size
        let windowWidth: CGFloat = 350
        let windowHeight: CGFloat = 500
        
        // Calculate position for top right (with some padding from edge)
        let padding: CGFloat = 10
        let xPosition = screenFrame.maxX - windowWidth - padding
        let yPosition = screenFrame.maxY - windowHeight - padding
        
        // Create the SwiftUI view with the specified mode
        let contentView = ContentView(mode: mode, closeWindow: { [weak self] in
            self?.window?.orderOut(nil)
        })
        
        // Create a custom floating window - this allows it to become key and accept input
        let window = FloatingWindow(
            contentRect: NSRect(x: xPosition, y: yPosition, width: windowWidth, height: windowHeight),
            styleMask: [.borderless, .fullSizeContentView],  // Changed: added fullSizeContentView
            backing: .buffered,
            defer: false
        )
        
        // Set window properties for floating behavior
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isReleasedWhenClosed = false
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        
        // Enable transparency and vibrancy
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        // Create a container view with rounded corners
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.cornerRadius = 12
        hostingView.layer?.masksToBounds = true
        
        // Add shadow to the hosting view
        hostingView.layer?.shadowColor = NSColor.black.cgColor
        hostingView.layer?.shadowOpacity = 0.3
        hostingView.layer?.shadowOffset = CGSize(width: 0, height: -2)
        hostingView.layer?.shadowRadius = 10
        hostingView.layer?.masksToBounds = false
        
        window.contentView = hostingView
        
        // Store reference
        self.window = window
        
        return window
    }
    
    func showWindow() {
        guard let window = window else { return }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func activeSpaceDidChange(_ notification: Notification) {
        // Ensure window stays visible when switching spaces (only if it's currently shown)
        if let window = window, window.isVisible {
            window.orderFrontRegardless()
        }
    }
}

// Define the note mode enum
enum NoteMode {
    case appendDaily
    case newNote
    case settings
}

class FloatingWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
