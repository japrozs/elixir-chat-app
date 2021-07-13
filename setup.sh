# SSH into the computer
ssh -i <public_key> user@<ip>

# Clone the repo locallly on teh system
git clone <repo_url>
cd <repo>
# install the necessary software
# hex, elixir, mix, node, npm
sudo apt-get upgrade
sudo apt-get update
sudo apt-install elixir
sudo apt-install erlang
google nodejs nodesource
click on the first github link
copy the install commands for ubuntu

# install the node dependencies
cd assets
npm install

#install the phoneix dependencies
cd ..
mix deps.get
