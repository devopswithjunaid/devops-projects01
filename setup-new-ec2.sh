#!/bin/bash

echo "🚀 Setting up new EC2 instance for Wanderlust deployment"
echo "========================================================"

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker ubuntu
newgrp docker

# Install Docker Compose
echo "🔧 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install other utilities
echo "🛠️ Installing utilities..."
sudo apt install -y curl wget git htop

# Configure firewall (if ufw is enabled)
echo "🔥 Configuring firewall..."
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 3000/tcp  # Frontend
sudo ufw allow 5000/tcp  # Backend
sudo ufw allow 8080/tcp  # Jenkins (if needed)

# Create deployment directory
echo "📁 Creating deployment directory..."
mkdir -p /home/ubuntu/wanderlust-app

# Test Docker installation
echo "✅ Testing Docker installation..."
docker --version
docker-compose --version

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Make sure your security group allows inbound traffic on ports 3000 and 5000"
echo "2. Run the Jenkins pipeline with deployment enabled"
echo "3. Access your application at:"
echo "   - Frontend: http://35.93.157.96:3000"
echo "   - Backend API: http://35.93.157.96:5000"
echo ""
echo "🔑 Security Group Rules needed:"
echo "   - Port 22 (SSH) - Your IP"
echo "   - Port 3000 (Frontend) - 0.0.0.0/0"
echo "   - Port 5000 (Backend API) - 0.0.0.0/0"
echo ""
