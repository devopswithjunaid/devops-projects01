#!/bin/bash

echo "🔧 Jenkins Pipeline Setup Script"
echo "================================"

# Jenkins URL and credentials
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"  # Replace with your Jenkins admin username
JENKINS_PASSWORD=""   # You'll need to provide this

echo "📋 Required Jenkins Configurations:"
echo ""
echo "1. 🔑 CREDENTIALS TO CREATE:"
echo "   - docker-hub-credentials (Username/Password)"
echo "   - deploy-server-ssh (SSH Username with private key)"
echo ""
echo "2. 🛠️ TOOLS TO CONFIGURE:"
echo "   - NodeJS 16 (name: 'node16')"
echo ""
echo "3. 🔌 PLUGINS TO INSTALL:"
echo "   - Docker Pipeline"
echo "   - SSH Agent"
echo "   - NodeJS"
echo "   - Credentials Binding"
echo ""

echo "🚀 Manual Setup Instructions:"
echo "=============================="
echo ""
echo "1. Go to Jenkins → Manage Jenkins → Manage Credentials"
echo "2. Click 'Global' → 'Add Credentials'"
echo ""
echo "For Docker Hub:"
echo "   - Kind: Username with password"
echo "   - ID: docker-hub-credentials"
echo "   - Username: devopswithjunaid"
echo "   - Password: [Your Docker Hub password]"
echo ""
echo "For SSH Deploy:"
echo "   - Kind: SSH Username with private key"
echo "   - ID: deploy-server-ssh"
echo "   - Username: azureuser"
echo "   - Private Key: [Your deployment server SSH key]"
echo ""
echo "3. Go to Jenkins → Manage Jenkins → Global Tool Configuration"
echo "4. Add NodeJS installation:"
echo "   - Name: node16"
echo "   - Version: NodeJS 16.x"
echo "   - Install automatically: ✓"
echo ""
echo "5. Install required plugins:"
echo "   - Go to Manage Jenkins → Manage Plugins"
echo "   - Install: Docker Pipeline, SSH Agent, NodeJS, Credentials Binding"
echo ""

# Create a simple credential creation script
cat > /tmp/create-docker-credentials.xml << 'EOF'
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>docker-hub-credentials</id>
  <description>Docker Hub Credentials</description>
  <username>devopswithjunaid</username>
  <password>{AQAAABAAAAAQxxxxxxxxxxxxxxxxxxxxx}</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
EOF

echo "📁 Files created:"
echo "   - /tmp/create-docker-credentials.xml (template)"
echo ""
echo "⚡ Quick Setup Commands (run on Jenkins server):"
echo "=================================="
echo ""
echo "# Install required plugins"
echo "java -jar jenkins-cli.jar -s $JENKINS_URL -auth admin:password install-plugin docker-workflow ssh-agent nodejs credentials-binding"
echo ""
echo "# Restart Jenkins"
echo "java -jar jenkins-cli.jar -s $JENKINS_URL -auth admin:password restart"
echo ""
echo "🎯 After setup, your pipeline will:"
echo "   ✅ Use secure credential storage"
echo "   ✅ Build Docker images efficiently"
echo "   ✅ Scan for security vulnerabilities"
echo "   ✅ Push to Docker Hub securely"
echo "   ✅ Deploy via SSH"
echo "   ✅ Perform health checks"
echo "   ✅ Clean up resources"
echo ""
echo "🔥 Pipeline Features:"
echo "   - Parallel builds"
echo "   - Security scanning with Trivy"
echo "   - Proper error handling"
echo "   - Resource cleanup"
echo "   - Health monitoring"
echo "   - Skip options for testing"
echo ""
