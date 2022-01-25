chmod 600 ~/.ssh/id_rsa
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub


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

sudo /usr/local/etc/emulab/mkextrafs.pl /srv

sudo -i -u mosipuser bash << EOF
mkdir ~/.ssh
chmod 700 ~/.ssh
EOF

home=$HOME

sudo cp $home/.ssh/id_rsa /home/mosipuser/.ssh/id_rsa && sudo chown mosipuser:mosipuser /home/mosipuser/.ssh/id_rsa
sudo cp $home/.ssh/id_rsa.pub /home/mosipuser/.ssh/authorized_keys && sudo chown mosipuser:mosipuser /home/mosipuser/.ssh/authorized_keys

cd mosip-cloudlab

sed -i "s/user/$(whoami)/g" hosts.ini 
sed -i "s/update_root/$(whoami)/g" hosts.ini 

ansible-playbook -i hosts.ini update_root.yml

sudo -i -u mosipuser bash << EOF
chmod 600 .ssh/authorized_keys
chmod 600 .ssh/id_rsa
git clone https://github.com/aoli-al/mosip-infra
cd mosip-infra
git checkout 1.1.5.5
cd deployment/sandbox-v2
mv ~/hosts.ini ./
sed -i "s/DOMAIN_NAME/$(hostname)/g" group_vars/all.yml
./preinstall.sh
source ~/.bashrc
echo "foo" > vaultpass.txt
ansible-playbook -i hosts.ini --vault-password-file vaultpass.txt -e @secrets.yml site.yml
EOF
