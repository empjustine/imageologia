picopacs
========

Barebones simple DICOM compliant PACS server.

-----

Deploy picopacs
---------------


INSIDE A POSIX ENVIRONMENT:

Install Git (distributed version control and source code management) and a
system Ruby (will bootstrap other elements).

    # For Arch Linux
    $ sudo pacman -S git ruby
    
    # For Ubuntu/Debian
    $ sudo apt-get install git ruby

Install rbenv (isolated ruby enviroment for development and production deployment)

    $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    $ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    $ exec $SHELL -l

Install ruby-build (compiles and installs Ruby)

    $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

Install Ruby 2.0.0 (the one the server actually uses)

    $ rbenv install 2.0.0-p0

Install Bundler (Ruby "Gem" package manager)

    $ rbenv shell 2.0.0-p0
    $ gem install bundler

Pull this repository

    $ git clone https://github.com/empjustine/imageologia.git ~/imageologia

Install Ruby Gems dependencies

    $ cd ~/imageologia
    $ bundle install

Run server

    $ ~/imageologia/server.sh