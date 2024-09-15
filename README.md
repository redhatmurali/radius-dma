curl -L -O https://github.com/redhatmurali/radius-dma/raw/main/1repoupdate.sh
chmod +x 1repoupdate.sh
sudo ./1repoupdate.sh

curl -L -O https://github.com/redhatmurali/radius-dma/raw/main/2macupdate.sh
chmod +x 2macupdate.sh
sudo ./2macupdate.sh

curl -L -O https://github.com/redhatmurali/radius-dma/raw/main/3install.sh
chmod +x 3install.sh
sudo ./3install.sh
