sudo useradd mosipuser
echo -e "mosippwd\nmosippwd" | sudo passwd mosipuser
sudo usermod -aG wheel mosipuser
echo "mosipuser ALL=(ALL)  ALL" | sudo EDITOR='tee -a' visudo
echo "%mosipuser  ALL=(ALL)  NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo


sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ansible
sudo yum install -y git
sudo yum install -y nginx-mod-stream htop byobu
sudo useradd nfsnobody


