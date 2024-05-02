sudo apt update
sudo apt search dockerapt show docker
sudo apt install -y docker.io
sudo apt install -y docker-compose-v2
sudo apt install -y git
sudo usermod -a -G docker ubuntu
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker.service
sudo systemctl start docker.service
git clone "https://github.com/dockersamples/example-voting-app.git" voter-app
cd voter-app
docker compose up -d