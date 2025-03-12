#!/bin/bash

# Nextcloud Health Check Script

echo "========================================"
echo "🔍 NEXTCLOUD DEVELOPMENT ENVIRONMENT HEALTH CHECK"
echo "========================================"

# Check if containers are running
echo -e "\n📊 CONTAINER STATUS:"
docker ps --filter "name=nextcloud" --filter "name=mcp_server"

# Check Nextcloud status
echo -e "\n📋 NEXTCLOUD SYSTEM STATUS:"
docker exec -u www-data nextcloud_app php occ status

# Check for any warnings or errors in Nextcloud logs
echo -e "\n📝 RECENT WARNINGS/ERRORS IN LOGS:"
docker exec nextcloud_app grep -i "warning\|error" /var/www/html/data/nextcloud.log 2>/dev/null | tail -n 10 || echo "No recent warnings or errors found."

# Check database status
echo -e "\n🔄 DATABASE STATUS:"
docker exec nextcloud_db mysqladmin ping -u root -psecretpassword | grep -q 'mysqld is alive' && echo "✅ Database connection successful" || echo "❌ Database connection failed"

# Check disk space
echo -e "\n💾 DISK USAGE:"
docker exec nextcloud_app df -h /var/www/html

# Check Nextcloud version
echo -e "\n📦 NEXTCLOUD VERSION:"
docker exec -u www-data nextcloud_app php occ -V

# Check MCP server health
echo -e "\n🛠️ MCP SERVER STATUS:"
curl -s http://localhost:9090/api/health | grep -q "OK" && echo "✅ MCP Server is healthy" || echo "❌ MCP Server health check failed"

# Check MCP server system resources
echo -e "\n📊 SYSTEM RESOURCES (via MCP Server):"
curl -s http://localhost:9090/api/system/resources | grep -E "cores|usedPercentage|platform" | sed 's/[{},"]//g' | sed 's/:/: /g'

# Check for any warnings or errors in MCP server logs
echo -e "\n📝 RECENT MCP SERVER LOGS:"
docker logs mcp_server 2>&1 | tail -n 5

# Tips
echo -e "\n💡 HELPFUL COMMANDS:"
echo "  - Restart all services:         docker compose down && docker compose up -d"
echo "  - Start with health check:      ./start-nextcloud.sh"
echo "  - Nextcloud maintenance mode:   docker exec -u www-data nextcloud_app php occ maintenance:mode --on/--off"
echo "  - Repair Nextcloud:             docker exec -u www-data nextcloud_app php occ maintenance:repair"
echo "  - View Nextcloud logs:          docker logs nextcloud_app"
echo "  - View database logs:           docker logs nextcloud_db"
echo "  - View MCP server logs:         docker logs mcp_server"
echo "  - MCP server health check:      curl http://localhost:9090/api/health"
echo "  - MCP server development tools: curl http://localhost:9090/api/dev/tools"

echo -e "\n========================================"
echo "✅ HEALTH CHECK COMPLETE"
echo "=========================================="