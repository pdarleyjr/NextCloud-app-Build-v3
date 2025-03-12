# Nextcloud Development Environment in GitHub Codespaces

This repository contains a fully functional Nextcloud development environment running in GitHub Codespaces with Docker, including an MCP (Model Context Protocol) server for enhanced development capabilities.

## 🚀 Quick Access

- **Nextcloud HTTP Access**: [http://localhost:8080](http://localhost:8080)
- **Nextcloud HTTPS Access**: [https://localhost:8443](https://localhost:8443) (using self-signed certificate)
- **Admin Credentials**:
  - Username: `admin`
  - Password: `password`
- **MCP Server Access**: [http://localhost:9090](http://localhost:9090)

## 📋 Configuration Details

### Container Setup

The setup consists of three main containers:

1. **Nextcloud Container**:
   - Image: `nextcloud:apache`
   - Ports: 8080 (HTTP), 8443 (HTTPS)
   - Persistent storage with Docker volume

2. **Database Container**:
   - Image: `mariadb:10.11`
   - Configured for optimal Nextcloud performance
   - Persistent storage with Docker volume

3. **MCP Server Container**:
   - Custom Node.js application
   - Port: 9090
   - Development tools and APIs for Nextcloud

### Security Features

- HTTPS enabled with self-signed SSL certificate
- Secure database configuration
- Persistent data storage across container restarts
- Docker network isolation

## 🛠️ Management Commands

### Quick Start

For a one-command setup, use the provided startup script:

```bash
./start-nextcloud.sh
```

This script will:
1. Create necessary Docker volumes if they don't exist
2. Generate SSL certificates if needed
3. Start all containers
4. Verify services are running properly
5. Display access information

### Docker Management

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart all services
docker compose down && docker compose up -d

# View Nextcloud logs
docker logs nextcloud_app

# View database logs
docker logs nextcloud_db

# View MCP server logs
docker logs mcp_server
```

### Nextcloud CLI (occ)

The `occ` command is Nextcloud's command-line interface for administrative tasks:

```bash
# List all available commands
docker exec -u www-data nextcloud_app php occ list

# Check system status
docker exec -u www-data nextcloud_app php occ status

# Maintenance mode operations
docker exec -u www-data nextcloud_app php occ maintenance:mode --on
docker exec -u www-data nextcloud_app php occ maintenance:mode --off

# Clear cache and perform repairs
docker exec -u www-data nextcloud_app php occ maintenance:repair
```

### Health Check Script

A health check script is included to quickly assess the status of your Nextcloud environment:

```bash
./nextcloud-health.sh
```

## 🔄 Persistent Storage

Data persistence is managed through Docker volumes:

- `nextcloud_data`: Stores Nextcloud application files
- `db_data`: Stores MariaDB database files

These volumes ensure your data remains intact even when containers are restarted or rebuilt.

## 🔒 HTTPS Configuration

This setup includes HTTPS with a self-signed SSL certificate:

- Certificate and key located in the repository root
- HTTPS accessible on port 8443

When accessing via HTTPS, your browser will show a security warning due to the self-signed certificate. This is expected and can be safely bypassed for development purposes.

## 🚀 MCP Server for Development

The MCP (Model Context Protocol) server provides development tools and APIs to enhance your Nextcloud development experience:

### Features

- **Health Monitoring**: Monitor Nextcloud and database status
- **App Management**: View installed apps and available apps
- **Development Tools**: 
  - Cache clearing
  - Log viewing
  - App scaffolding
- **System Resource Monitoring**: Track CPU, memory usage, and more

### API Endpoints

- Health Check: `http://localhost:9090/api/health`
- Nextcloud Status: `http://localhost:9090/api/nextcloud/status`
- Nextcloud Apps: `http://localhost:9090/api/nextcloud/apps`
- System Resources: `http://localhost:9090/api/system/resources`
- Development Tools: `http://localhost:9090/api/dev/tools`

## 📱 GitHub Integration

GitHub authentication is configured with:

- Username: pdarleyjr
- Email: pdarleyjr@gmail.com
- Credential helper: store

## 🚀 Next Steps

1. **Install Apps**: Access the Nextcloud App Store through the web interface
2. **Custom Development**: Use the MCP server to scaffold and develop Nextcloud apps
3. **External Storage**: Connect to S3, WebDAV, or other storage services
4. **User Management**: Create additional users and groups
5. **Customization**: Personalize the theme and settings
6. **CI/CD Integration**: Use the GitHub workflows for continuous integration

## 🔍 Troubleshooting

If you encounter issues:

1. **Run Health Check**:
   ```bash
   ./nextcloud-health.sh
   ```

2. **Check Logs**:
   ```bash
   docker logs nextcloud_app
   docker logs mcp_server
   docker exec -u www-data nextcloud_app php occ log:tail
   ```

3. **Restart Containers**:
   ```bash
   docker compose down && docker compose up -d
   ```

4. **Repair Nextcloud**:
   ```bash
   docker exec -u www-data nextcloud_app php occ maintenance:repair
   ```

5. **Check MCP Server Status**:
   ```bash
   curl http://localhost:9090/api/health