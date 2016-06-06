#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

download_studio(){
  echo -n ${bold}"Enter the Appcelerator Studio release version to download (e.g: 4.0.0): "${normal}
  read version
  echo
  echo ${bold}"Fetching & downloading studio "$version" please wait ......."${normal} 
  echo 
  wget -o log.txt -S --spider http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.dmg
  work_dir=$(pwd)
  c=$(grep -o 'Remote file does not exist' $work_dir/log.txt)
  if [ "$c" == "Remote file does not exist" ]; then
    echo ${bold}'Specified version not found. Please enter valid studio release version.'${normal}
    rm log.txt
    echo
    echo 'Done'
  else
    rm log.txt
    echo
    wget http://titanium-studio.s3.amazonaws.com/$version/Appcelerator_Studio.dmg
    echo -e '\xE2\x9C\x94' ${bold}"File downloaded to :$work_dir/Appcelerator_Studio.dmg"${normal}
    echo
    echo "Done"
  fi
}

download_homebrew(){
  echo ${bold}'Installing homebrew .....'${normal}
  echo
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # $b
  echo -e '\xE2\x9C\x94' ${bold}'Homebrew installed successfully .....'${normal}
}

download_wget(){
  echo ${bold}'Installing wget .....'${normal}
  echo
  brew install wget
  echo
  echo -e '\xE2\x9C\x94' ${bold}'Wget installed successfully .....'${normal}
}

echo
echo ${bold}'First checking if wget is installed......'${normal}
b=$(wget -Version|grep -o 'Wget'|tail -1)

if [ "$b" == "Wget" ]; then
  echo
  echo -e '\xE2\x9C\x94' ${bold}'Wget already installed .....'${normal}
  echo
  download_studio
  echo
else
  echo ${bold}'Wget not installed .....'${normal}
  echo
  echo ${bold}"Checking if homebrew is installed ...."${normal}
  a=$(brew -v|grep 'Homebrew'|cut -c1-8)
  echo $b
  if [ "$a" == "Homebrew" ]; then
    download_wget
    download_studio
  else
    echo ${bold}'Homebrew not installed. Installing homebrew .....'${normal}
    echo
    download_homebrew
    echo -e '\xE2\x9C\x94' ${bold}'homebrew installed successfully.....'${normal}
    echo
    download_wget
    echo 
    download_studio
  fi
fi


