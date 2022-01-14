chmod 600 ~/.ssh/id_rsa


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


sudo -i -u mosipuser bash << EOF
mkdir ~/.ssh
chmod 700 ~/.ssh
EOF
sudo cp /users/aoli/.ssh/id_rsa /home/mosipuser/.ssh/id_rsa && sudo chown mosipuser:mosipuser /home/mosipuser/.ssh/id_rsa
sudo cp /users/aoli/.ssh/authorized_keys /home/mosipuser/.ssh/authorized_keys && sudo chown mosipuser:mosipuser /home/mosipuser/.ssh/authorized_keys
sudo cp /users/aoli/hosts_root.ini /home/mosipuser/hosts.ini && sudo chown mosipuser:mosipuser /home/mosipuser/hosts.ini

git clone https://github.com/aoli-al/mosip-cloudlab
cd mosip-cloudlab
mv ~/hosts_aoli.ini hosts.ini
ansible-playbook -i hosts.ini update_root.yml

sudo -i -u mosipuser bash << EOF
chmod 600 .ssh/authorized_keys
chmod 600 .ssh/id_rsa
git clone https://github.com/aoli-al/mosip-infra
cd mosip-infra
git checkout 1.1.5.5
cd deployment/sandbox-v2
mv ~/hosts.ini ./
sed -i ''  "s/DOMAIN_NAME/$(hostname)/g" group_vars/all.yml
EOF
