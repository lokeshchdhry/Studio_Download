#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

download_studio(){
  echo -n -e '\xe2\x9c\x8f' "Enter the platform for the studio download (mac,windows,linux): "
  read platform
  echo
  
  case "$platform" in
    "mac") mac_url
    ;;
    "windows") windows_url
    ;;
    "linux") linux_url
    ;;
    *) echo -e '\xe2\x9d\x8c'" Please enter a valid platform."
    ;;
  esac
}

mac_url(){
  echo -n -e '\xe2\x9c\x8f' "Enter the Appcelerator Studio release version to download (e.g: 4.0.0): "
  read version
  echo
  echo -e '\xe2\x9c\x8f' "Fetching & downloading studio "$version" for "$platform" please wait ......."

  wget -o log.txt -S --spider http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.dmg
  work_dir=$(pwd)
  c=$(grep -o 'Remote file does not exist' $work_dir/log.txt)
  if [ "$c" == "Remote file does not exist" ]; then
    echo
    echo -e '\xe2\x9d\x8c' ' Specified version not found. Please enter valid studio release version.'
    rm log.txt
    echo
    echo 'Done'
  else
    rm log.txt
    echo
    wget http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.dmg
    echo -e '\xE2\x9C\x94' " File downloaded to :$work_dir/Appcelerator_Studio.dmg"
    echo
    echo "Done"
  fi
}

windows_url(){
  echo -n -e '\xe2\x9c\x8f' "Enter the Appcelerator Studio release version to download (e.g: 4.0.0): "
  read version
  echo
  echo -e '\xe2\x9c\x8f' "Fetching & downloading studio "$version" for "$platform" please wait ......."

  wget -o log.txt -S --spider http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.exe
  work_dir=$(pwd)
  c=$(grep -o 'Remote file does not exist' $work_dir/log.txt)
  if [ "$c" == "Remote file does not exist" ]; then
    echo
    echo -e '\xe2\x9d\x8c'' Specified version not found. Please enter valid studio release version.'
    rm log.txt
    echo
    echo 'Done'
  else
    rm log.txt
    echo
    wget http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.exe
    echo -e '\xE2\x9C\x94' " File downloaded to :$work_dir/Appcelerator_Studio.exe"
    echo
    echo "Done"
  fi
}

linux_url(){
  echo -n -e '\xe2\x9c\x8f' "Enter the Appcelerator Studio release version to download (e.g: 4.0.0): "
  read version
  echo
  echo -e '\xe2\x9c\x8f' "Fetching & downloading studio "$version" for "$platform" please wait ......."

  wget -o log.txt -S --spider "http://titanium-studio.s3.amazonaws.com/$version/appcelerator.studio.linux.gtk.x86_64.zip" 
  work_dir=$(pwd)
  c=$(grep -o 'Remote file does not exist' $work_dir/log.txt)
  if [ "$c" == "Remote file does not exist" ]; then
    echo
    echo -e '\xe2\x9d\x8c'' Specified version not found. Please enter valid studio release version.'
    rm log.txt
    echo
    echo 'Done'
  else
    rm log.txt
    echo
    wget "http://titanium-studio.s3.amazonaws.com/$version/appcelerator.studio.linux.gtk.x86_64.zip" 
    echo -e '\xE2\x9C\x94' " File downloaded to :$work_dir/appcelerator.studio.linux.gtk.x86_64.zip"
    echo
    echo "Done"
  fi
}

download_homebrew(){
  echo -e '\xe2\x9c\x8f' 'Installing homebrew .....'
  echo
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # $b
  echo -e '\xE2\x9C\x94' ' Homebrew installed successfully .....'
}

download_wget(){
  echo -e '\xe2\x9c\x8f' 'Installing wget (one time installation) .....'
  echo
  brew install wget
  echo
  echo -e '\xE2\x9C\x94' ' Wget installed successfully .....'
}

echo
echo -e '\xe2\x9c\x8f' 'First checking if wget is installed......'
b=$(wget -Version|grep -o 'Wget'|tail -1)

if [ "$b" == "Wget" ]; then
  echo
  echo -e '\xE2\x9C\x94' ' Wget already installed .....'
  echo
  download_studio
  echo
else
  echo -e '\xe2\x9d\x8c' 'Wget not installed .....'
  echo
  echo "Checking if homebrew is installed ...."
  a=$(brew -v|grep 'Homebrew'|cut -c1-8)
  echo $b
  if [ "$a" == "Homebrew" ]; then
    download_wget
    download_studio
  else
    echo -e '\xe2\x9d\x8c' 'Homebrew not installed. Installing homebrew (one time installation).....'
    echo
    download_homebrew
    echo -e '\xE2\x9C\x94' ' Homebrew installed successfully.....'
    echo
    download_wget
    echo 
    download_studio
  fi
fi


