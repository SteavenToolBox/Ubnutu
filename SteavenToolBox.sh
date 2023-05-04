#!/bin/bash
RUN=1 # run flag
while [ $RUN = 1 ] # while run flag equals 1 - reopening menu after each action
do
  clear
  echo =================================================
  echo "SteavenToolbox | We care about your pc!" "Ubuntu"
  echo =================================================
  echo "1. Update Ubuntu"
  echo "2. Install Needed Ubuntu Apps"
  echo "3. Replace Snap Store with Gnome Software"
  echo "4. Install ZSH with Power10k and zsh autocomplete"
  echo "5. Install i3"
  echo "6. Purge Remove SNAP"
  echo "7. Install Stock Gnome + Stock Gnome Theme"
  echo "8. Remove Ubuntu Apt ADS"
  echo "9. Gnome Libadwaita Theme for GTK3"
  echo "0. Exit"
  read -p "Type the number." ANSWER

  if [ $ANSWER == "0" ]; then
  exit
  fi

  if [ $ANSWER == "1" ]; then
  clear
  echo "Updating Ubuntu cache"
  sudo apt update
  echo "Updating Ubuntu Apt Packages"
  sudo apt upgrade -y
  echo "Updating Ubuntu Snaps"
  sudo snap refresh
  echo "Updating Ubuntu Flatpaks"
  sudo flatpak update -y
  fi

  if [ $ANSWER == "2" ]; then
  clear
  echo "Installing Video Codecs and Vlc"
  sudo apt install ubuntu-restricted-extras vlc -y
  fi

  if [ $ANSWER == "3" ]; then
  echo "Removing Snap store"
  sudo snap remove snap-store
  echo "Installing and Configuring Flatpak"
  sudo apt install flatpak -y
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  echo "Installing Gnome Software"
  sudo apt install gnome-software gnome-software-plugin-snap gnome-software-plugin-flatpak -y
  fi
  if [ $ANSWER == "4" ]; then
  echo "Installing Fonts"
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
  sudo unzip FiraCode.zip -d "/usr/share/fonts"
  sudo unzip Meslo.zip -d "/usr/share/fonts"
  sudo fc-cache -vf
  rm ./FiraCode.zip ./Meslo.zip
  echo "Installing ZSH"
  sudo apt install zsh zsh-syntax-highlighting autojump zsh-autosuggestions git -y
  echo "Installing Powerlevel10k"
  mkdir ~/.zsh
  mkdir ~/.zsh/plugins/
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/plugins/powerlevel10k
  echo 'source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
  echo "Installing ZSH AutoComplete"
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/plugins/zsh-autocomplete
  echo 'source ~/.zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  echo "Making zsh Default Shell"
  chsh -s $(which zsh)
  fi
  if [ $ANSWER == "5" ]; then
  sudo apt update
  sudo apt install i3 -y
  if [ $ANSWER == "6" ]; then
  sudo snap remove firefox
  sudo snap remove snap-store
  sudo snap remove gtk-common-themes
  sudo snap remove gnome-42-2204
  sudo snap remove core22
  sudo snap remove core20
  sudo snap remove bare
  sudo snap remove snapd-desktop-integration
  sudo snap remove snapd
  sudo apt purge snapd -y
  fi
  if [ $ANSWER == "7" ]; then
  sudo apt install adwaita-icon-theme-full adwaita-icon-theme adwaita-qt6 adwaita-qt gnome-session -y
  rm -rf ~/.config/gtk-2.0
  rm -rf ~/.config/gtk-3.0
  rm -rf ~/.config/gtk-4.0
  gsettings set org.gnome.desktop.interface color-scheme default
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita
  gsettings set org.gnome.desktop.wm.preferences theme Adwaita
  gsettings set org.gnome.desktop.interface icon-theme Adwaita
  fi
  if [ $ANSWER == "8" ]; then
  sudo pro config set apt_news=false
  mkdir -p ~/relocated_apt
  sudo mv /etc/apt/apt.conf.d/20apt-esm-hook.conf ~/relocated_apt/.
  fi
  if [ $ANSWER == "9" ]; then
  wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.6/adw-gtk3v4-6.tar.xz
  sudo unzip adw-gtk3v4-6.tar.xz -d "/usr/share/themes"
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
  gsettings set org.gnome.desktop.interface color-scheme default
  sudo snap install adw-gtk3-theme
  for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do sudo snap connect $i adw-gtk3-theme:gtk-3-themes; done
  flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark -y
  fi
  else
    echo "Quitting..."
    RUN=1 # set run flag to 0 so program will end
  fi
done
