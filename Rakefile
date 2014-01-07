def install_dependecies
 #Gosu's dependencies for both C++ and Ruby
 sh "sudo apt-get install build-essential freeglut3-dev libfreeimage-dev libgl1-mesa-dev libopenal-dev libpango1.0-dev libsdl-ttf2.0-dev libsndfile-dev libxinerama-dev"
end

def install_bundle
 sh "gem install bundler"
end

def call_bundle
  sh "bundle install"
end

def osx_install_dependecies
 sh "gem install cocoapods"
end

task :default do
  install_dependecies
  install_bundle
  call_bundle
end

task :osx do
  osx_install_dependecies
  install_bundle
  call_bundle
end
