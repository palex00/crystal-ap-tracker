#!/bin/bash

# Function to check if wget is installed
check_and_install_wget() {
    if ! command -v wget &>/dev/null; then
        echo "wget is required to use this script."
        read -p "Do you want to install wget? (Y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Installing wget..."
            # Check if the system is based on Debian/Ubuntu
            if [ -f /etc/debian_version ]; then
                sudo apt-get update
                sudo apt-get install -y wget
            # Check if the system is based on RedHat/CentOS/Fedora
            elif [ -f /etc/redhat-release ]; then
                sudo yum install -y wget
            # Check if the system is based on Arch
            elif [ -f /etc/arch-release ]; then
                sudo pacman -S wget --noconfirm
            # Check if the system is macOS
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                brew install wget
            else
                echo "Unsupported package manager or system type. Please install wget manually."
                exit 1
            fi
        else
            echo "wget installation declined. Exiting script."
            exit 1
        fi
    else
        echo "wget is already installed."
    fi
}

# Ensure that the PopTracker directory exists
USER_DOCS="$HOME/PopTracker"
if [ ! -d "$USER_DOCS" ]; then
    echo "Creating directory User docs: $USER_DOCS"
    mkdir -p "$USER_DOCS"
fi

# Create the user-override directory if it doesn't exist
USER_OVERRIDE_DIR="$USER_DOCS/user-override/ap_crystal_palex00"
if [ ! -d "$USER_OVERRIDE_DIR" ]; then
    echo "Creating directory override: $USER_OVERRIDE_DIR"
    mkdir -p "$USER_OVERRIDE_DIR"
fi


# Helper function to handle downloading and extracting files
download_and_extract() {
    echo "Downloading from GitHub..."
    wget -q -O /tmp/crystal-ap-tracker.zip https://github.com/palex00/crystal-ap-tracker/archive/refs/heads/user-overrides.zip
    echo "Extracting files..."
    unzip -q /tmp/crystal-ap-tracker.zip -d /tmp
}

# Main menu
mainmenu() {
    clear
    echo "Welcome to the Pokemon Crystal AP Poptracker Pack Adjuster by palex00"
    echo
    echo "All this pack does is download files from https://github.com/palex00/crystal-ap-tracker/tree/user-overrides, move files and delete files inside your Document folder."
    echo
    echo "Please select what you want to adjust:"
    echo "1 - Badge Images"
    echo "2 - Map Overlays"
    echo "3 - Remove all modifications"
    echo
    echo "To exit, press Ctrl+C."
    read -p "Enter your choice (1/2/3): " option

    case "$option" in
        1) badges ;;
        2) mapoverlays ;;
        3) remove_modifications ;;
        *) mainmenu ;;
    esac
}

# Badge selection
badges() {
    clear
    echo "Which version of badges do you want to use?"
    echo "1 - Retro with no border"
    echo "2 - Retro with 1-pixel white border"
    echo "3 - Retro with 2-pixel white border"
    echo "4 - Modern"
    read -p "Enter your choice (1/2/3/4): " badge_choice

    case "$badge_choice" in
        1) folder="color_no_border" ;;
        2) folder="color_1_border" ;;
        3) folder="color_2_border" ;;
        4) folder="modern" ;;
        *) badges ;;
    esac

    if [ -z "$folder" ]; then
        badges
    fi

    # Create target directory if it doesn't exist
	TARGET_DIR="$USER_DOCS/user-override/ap_crystal_palex00"
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Creating directory target: $TARGET_DIR"
        mkdir -p "$TARGET_DIR"
    fi

    # Download and extract the files
    download_and_extract

    # Ensure the source directory exists before attempting to copy files
    if [ ! -d "/tmp/crystal-ap-tracker-user-overrides/badge_overrides/$folder" ]; then
        echo "Error: Source folder /tmp/crystal-ap-tracker-user-overrides/badge_overrides/$folder does not exist."
        exit 1
    fi

    # Create the folder within the target directory
    mkdir -p "$TARGET_DIR/images/items"

    # Copy the badge images to the target directory
    echo "Copying badge images from /tmp/crystal-ap-tracker-user-overrides/badge_overrides/$folder to $TARGET_DIR/images/items"
    cp -r "/tmp/crystal-ap-tracker-user-overrides/badge_overrides/$folder/"* "$TARGET_DIR/images/items"

    # Clean up downloaded files
    echo "Cleaning up temporary files..."
    rm -rf /tmp/crystal-ap-tracker-user-overrides
    rm -f /tmp/crystal-ap-tracker.zip

    echo "Files downloaded and moved to $TARGET_DIR/images/items"
    echo "Done! If you had poptracker open, restart it to apply changes."
    read -p "Press any key to return to the root menu." -n 1 -s
    mainmenu
}

# Map overlays (Coming soon)
mapoverlays() {
    clear
    echo "Coming soon!"
    read -p "Press any key to return to the root menu." -n 1 -s
    mainmenu
}

# Remove all modifications
remove_modifications() {
    read -p "Are you sure you want to remove all modifications? (Y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        mainmenu
    fi

    clear
    mod_dir="$USER_DOCS/user-override/ap_crystal_palex00"

    if [ -d "$mod_dir" ]; then
        echo "Deleting modifications in: $mod_dir"
        rm -rf "$mod_dir"
        echo "Modifications deleted."
    else
        echo "No modifications found to delete."
    fi
    read -p "Press any key to return to the root menu." -n 1 -s
    mainmenu
}

# Ensure wget is installed
check_and_install_wget

# Start the main menu
mainmenu