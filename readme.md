# DOTS - Hyprland Dotfiles Collection

> **Note:** This project is still a work in progress. Features and documentation may change.

This repository contains a collection of dotfiles (configuration files) for a Hyprland-based Linux system. It incorporates configurations from [end-4's Hyprland dotfiles](https://github.com/end-4/dots-hyprland) and additional custom configurations to create a complete desktop environment setup.

## 🖼️ Overview

This dotfiles collection provides a modern, customizable Linux desktop experience using Hyprland as the window manager. It includes configurations for:

- **Window Manager**: Hyprland with custom keybindings and workspace management
- **Status Bar**: AGS (Aylur's GTK Shell) for system monitoring and notifications
- **System Tools**: Various scripts for power management, monitor configuration, and more
- **Aesthetic Customization**: Themes, colors, and visual effects

## 📁 Repository Structure

```
├── config/                 # Main configuration files
│   ├── hypr/              # Hyprland configurations
│   │   ├── custom/        # Custom configuration files
│   │   ├── hyprland/      # Core Hyprland settings
│   │   └── hyprlock/      # Lock screen configurations
│   ├── ags/               # Aylur's GTK Shell configurations
│   └── fastfetch/         # System information display tool
├── dots-hyprland/         # Submodule with end-4's dotfiles
├── scripts/               # Installation and utility scripts
├── assets/                # Additional resources like wallpapers
└── install.sh             # Main installation script
```

## 🚀 Features

- **Tiling Window Management**: Efficient window organization with Hyprland
- **Customizable Keybindings**: Intuitive shortcuts for window and workspace management
- **Dynamic Color Schemes**: Auto-generated color palettes based on wallpapers
- **Status Bar & Widgets**: System monitoring, notifications, and quick access tools
- **Power Management**: Scripts for battery optimization and power profiles
- **Multi-Monitor Support**: Tools for configuring and toggling monitor setups
- **AI Integration**: Support for Gemini and Ollama models (via end-4's configs)

## 🛠️ Installation

> ⚠️ **Warning**: This script is designed for Arch Linux and Arch-based distributions. Use at your own risk.

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/DOTS.git
   cd DOTS
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The installation script will:
1. Check for existing configurations and offer to back them up
2. Install end-4's Hyprland dotfiles
3. Copy custom configurations to their appropriate locations
4. Handle ASUS-specific configurations if detected

## ⚙️ Configuration

After installation, you can customize the following:

- **Keybindings**: Edit `~/.config/hypr/custom/keybinds.conf`
- **Monitor Setup**: Modify `~/.config/hypr/monitors.conf`
- **Workspaces**: Adjust `~/.config/hypr/workspaces.conf`
- **Power Profiles**: Update `~/.config/hypr/powerProfile.sh`

## 📸 Screenshots

![Desktop Screenshot 1](assets/github%20screenshots/1)
![Desktop Screenshot 2](assets/github%20screenshots/2)
![Desktop Screenshot 3](assets/github%20screenshots/3)

## 🤝 Acknowledgements

This project builds upon the excellent work of:
- [end-4's Hyprland dotfiles](https://github.com/end-4/dots-hyprland) - Main configuration base
- [Hyprland](https://github.com/hyprwm/Hyprland) - The tiling window manager
- [AGS](https://github.com/Aylur/ags) - GTK widget system for the status bar

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Note: This project incorporates code from [end-4's Hyprland dotfiles](https://github.com/end-4/dots-hyprland), which is licensed under the GNU General Public License v3.0. The LICENSE file in this repository applies to the original content created for this project, while the incorporated code retains its original GNU GPL v3.0 license as found in the `dots-hyprland/LICENSE` file.

### About the Licenses

**MIT License:**
- A permissive open-source license
- Allows use, copy, modification, distribution, and sublicense of the code
- Requires preservation of copyright and license notices
- Provides no warranty
- Short and straightforward

**GNU General Public License v3.0 (GPL-3.0):**
- A copyleft open-source license
- Requires derivative works to be licensed under the same license
- Ensures users have access to the source code
- Guarantees user freedoms to run, study, share, and modify the software
- More comprehensive and protective of user rights

---
*This project is actively being developed. Check back for updates and new features!*