ok I should probably use ansible or something but here are the manual steps I used...

1. Create a new ubuntu image on ec2
2. Install postgres, ruby, python
```
sudo apt update
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libpq-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
source ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.6.5
gem install bundler

sudo apt install postgresql postgresql-contrib
sudo apt install redis-server

git clone https://github.com/parkeristyping/pktv.git
cd pktv

bundle install

nvm install v12
npm install -g yarn
source ~/.bashrc
yarn install

sudo -u postgres createuser -s $(whoami); createdb $(whoami)

bundle exec rails db:setup

sudo apt install python3-pip
sudo cp /usr/bin/python3 /usr/bin/python
sudo cp /usr/bin/python3 /usr/bin/pip
pip install -r requirements.txt

echo 'export PATH="~/.local/bin:$PATH"' >> ~/.bashrc
```
