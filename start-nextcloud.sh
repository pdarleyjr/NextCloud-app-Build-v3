#!/bin/bash

# Start Nextcloud Development Environment
echo "🚀 Starting Nextcloud Development Environment with MCP Server"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker is not running. Please start Docker and try again."
  exit 1
fi

# Check if volumes exist, create if not
if ! docker volume inspect nextcloud_data > /dev/null 2>&1; then
  echo "📦 Creating nextcloud_data volume..."
  docker volume create nextcloud_data
fi

if ! docker volume inspect db_data > /dev/null 2>&1; then
  echo "📦 Creating db_data volume..."
  docker volume create db_data
fi

# Check if SSL certificates exist, create if not
if [ ! -f "./ssl.crt" ] || [ ! -f "./ssl.key" ]; then
  echo "🔒 Generating SSL certificates..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl.key -out ssl.crt -subj "/CN=localhost"
fi

# Start Docker Compose environment
echo "🐳 Starting Docker Compose services..."
docker compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start (this may take a minute)..."
for i in {1..30}
do
  if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200\|302"; then
    echo "✅ Nextcloud is ready!"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "⚠️ Nextcloud did not start in the expected time, but might still be initializing."
    echo "   Please check the logs with: docker logs nextcloud_app"
  fi
  echo -n "."
  sleep 2
done

# Check if MCP server is running
if curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/api/health | grep -q "200"; then
  echo "✅ MCP Server is ready!"
else
  echo "⚠️ MCP Server did not start properly. Please check the logs with: docker logs mcp_server"
fi

# Display access information
echo ""
echo "======================================================================================"
echo "🌐 Nextcloud Access:"
echo "   - HTTP: http://localhost:8080"
echo "   - HTTPS: https://localhost:8443 (self-signed certificate, may show security warning)"
echo "   - Username: admin"
echo "   - Password: password"
echo ""
echo "🛠️ MCP Server Access:"
echo "   - API: http://localhost:9090/api/health"
echo "   - Development Tools: http://localhost:9090/api/dev/tools"
echo ""
echo "💻 Helpful Commands:"
echo "   - View Nextcloud logs: docker logs nextcloud_app"
echo "   - View MCP server logs: docker logs mcp_server"
echo "   - View Database logs: docker logs nextcloud_db"
echo "   - Run Nextcloud OCC commands: docker exec -u www-data nextcloud_app php occ [command]"
echo "   - Check Nextcloud health: ./nextcloud-health.sh"
echo "   - Stop all services: docker compose down"
echo "======================================================================================"