# Obsidian Side Note

<p align="center">
  <img src="icon.png" alt="Obsidian Side Note" width="128" height="128">
</p>

A beautiful, lightweight macOS notes app that floats above all windows and syncs instantly with your Obsidian vault. Perfect for capturing quick thoughts without leaving your current workspace.

### Features

- **🎈 Always Floating**: Stays visible over fullscreen apps, presentations, and all windows
- **📝 Markdown Support**: Write with markdown syntax and preview
- **🔄 Obsidian Integration**: One-click sync to your Obsidian vault via Advanced URI
- **⚡️ Quick Access**: Lives in your menu bar for instant access
- **🎨 Simple Design**: Modern macOS design with translucent effects and rounded corners
- **⌨️ Keyboard Shortcuts**: Fast workflows with keyboard commands
- **📍 Smart Positioning**: Anchors to the top-right of your screen

### Use Cases

- Take meeting notes during video calls
- Jot down ideas while coding
- Capture thoughts during presentations
- Quick task lists that stay visible
- Daily journaling without switching apps

### 📋 Requirements

- macOS 13.0 (Ventura) or later
- [Obsidian](https://obsidian.md/) with [Advanced URI plugin](https://github.com/Vinzent03/obsidian-advanced-uri)

## 🎮 Usage

### Quick Actions
- **⌘D** - Append to Daily Note
- **⌘N** - Create New Note
- **⌘,** - Open Settings
- **⌘Q** - Quit

### Taking Notes
1. Click the menu bar icon and choose your action
2. Write your note with markdown formatting
3. Click "Save to Obsidian" - your note syncs instantly!

### Markdown Toolbar
- **Bold** (`**text**`) - Make text bold
- **Italic** (`*text*`) - Italicize text
- **Strikethrough** (`~~text~~`) - Strike through text
- **Link** (`[text](url)`) - Create a link
- **Bullet List** (`-`) - Start a bullet list
- **Numbered List** (`1.`) - Start a numbered list
- **Task List** (`- [ ]`) - Create a checkbox

### Preview Mode
Toggle the eye icon to preview your rendered markdown before saving.


## 🚀 Installation


### From Release
{{ TBD! }} 
~~1. Download the latest release from the [Releases page](../../releases)~~
~~2. Drag `ObsidianSideNote.app` to your Applications folder~~
~~3. Open the app and configure your Obsidian vault name in Settings~~

### Build from Source
1. Clone this repository:
```bash
   git clone https://github.com/yourusername/obsidian-side-note.git
   cd obsidian-side-note
```
2. Open `ObsidianSideNote.xcodeproj` in Xcode
3. Build and run (⌘R)

## ⚙️ Setup

### 1. Install Obsidian Advanced URI Plugin

In Obsidian:
1. Go to Settings → Community Plugins
2. Browse and search for "Advanced URI"
3. Install and enable the plugin

### 2. Configure ObsidianSideNote

1. Click the note icon in your menu bar
2. Select "Settings"
3. Enter your Obsidian vault name (exactly as it appears in Obsidian)

## 🔧 Advanced URI Parameters

ObsidianSideNote uses the following URI schemes:

**Append to Daily Note:**
```
obsidian://adv-uri?vault=YOUR_VAULT&daily=true&mode=append&data=YOUR_TEXT
```

**Create New Note:**
```
obsidian://adv-uri?vault=YOUR_VAULT&filename=NOTE_TITLE&data=YOUR_TEXT
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Roadmap

- [ ] Release installer
- [ ] Global hotkey to show/hide window
- [ ] Custom sizing & positioning options
- [ ] Multiple vault support
- [ ] Template support
- [ ] Custom themes

## 🙏 Acknowledgments

- Built with [swift-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui)
- Obsidian integration via [Advanced URI](https://github.com/Vinzent03/obsidian-advanced-uri)

<p align="center">Made with ❤️ for the Obsidian community</p>
