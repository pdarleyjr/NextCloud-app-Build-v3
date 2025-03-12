const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const winston = require('winston');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Create logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'mcp-server.log' })
  ]
});

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 9090;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Log requests
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.url}`);
  next();
});

// Routes

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Nextcloud status endpoint
app.get('/api/nextcloud/status', async (req, res) => {
  try {
    const response = await axios.get('http://nextcloud_app/status.php', {
      timeout: 5000
    });
    res.status(200).json({
      status: 'UP',
      nextcloudStatus: response.data,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    logger.error('Failed to check Nextcloud status', error);
    res.status(500).json({
      status: 'DOWN',
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Get Nextcloud app list
app.get('/api/nextcloud/apps', async (req, res) => {
  try {
    // This would typically use Nextcloud's OCC command
    // For demo purposes, we're returning a mock response
    res.status(200).json({
      installedApps: [
        { name: 'files', enabled: true, version: '1.16.0' },
        { name: 'activity', enabled: true, version: '2.15.0' },
        { name: 'gallery', enabled: true, version: '1.5.0' }
      ],
      availableApps: [
        { name: 'calendar', category: 'organization' },
        { name: 'contacts', category: 'organization' },
        { name: 'tasks', category: 'organization' }
      ],
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    logger.error('Failed to get app list', error);
    res.status(500).json({ error: error.message });
  }
});

// System resources endpoint
app.get('/api/system/resources', (req, res) => {
  const os = require('os');
  
  res.status(200).json({
    cpu: {
      cores: os.cpus().length,
      load: os.loadavg(),
      model: os.cpus()[0].model
    },
    memory: {
      total: os.totalmem(),
      free: os.freemem(),
      usedPercentage: Math.round((1 - os.freemem() / os.totalmem()) * 100)
    },
    uptime: os.uptime(),
    platform: os.platform(),
    hostname: os.hostname(),
    timestamp: new Date().toISOString()
  });
});

// Development tools endpoint
app.get('/api/dev/tools', (req, res) => {
  res.status(200).json({
    availableTools: [
      { 
        name: 'cache-clear', 
        description: 'Clear Nextcloud cache',
        endpoint: '/api/dev/tools/cache-clear'
      },
      { 
        name: 'log-tail',
        description: 'Tail Nextcloud logs',
        endpoint: '/api/dev/tools/log-tail'
      },
      {
        name: 'app-scaffold',
        description: 'Generate scaffolding for a new Nextcloud app',
        endpoint: '/api/dev/tools/app-scaffold'
      }
    ],
    timestamp: new Date().toISOString()
  });
});

// Cache clear tool
app.post('/api/dev/tools/cache-clear', (req, res) => {
  // This would run the occ command to clear cache
  // For demo purposes, we'll just simulate it
  logger.info('Clearing Nextcloud cache');
  
  setTimeout(() => {
    res.status(200).json({ 
      status: 'success', 
      message: 'Cache cleared successfully',
      timestamp: new Date().toISOString()
    });
  }, 1000);
});

// Log tail tool
app.get('/api/dev/tools/log-tail', (req, res) => {
  // This would get the tail of the Nextcloud log
  // For demo purposes, we'll return mock logs
  const mockLogs = [
    { level: 'INFO', message: 'Login successful for user admin', timestamp: new Date().toISOString() },
    { level: 'WARNING', message: 'Potentially insecure reverse proxy configuration', timestamp: new Date().toISOString() },
    { level: 'INFO', message: 'Cache cleared via OCC command', timestamp: new Date().toISOString() },
    { level: 'INFO', message: 'App calendar enabled', timestamp: new Date().toISOString() },
    { level: 'INFO', message: 'Cron job started', timestamp: new Date().toISOString() }
  ];
  
  res.status(200).json({
    logs: mockLogs,
    timestamp: new Date().toISOString()
  });
});

// App scaffolding tool
app.post('/api/dev/tools/app-scaffold', (req, res) => {
  const { appName, author, description } = req.body;
  
  if (!appName) {
    return res.status(400).json({ error: 'App name is required' });
  }
  
  // In a real implementation, this would generate the app structure
  // For demo purposes, we'll just return the structure
  
  res.status(200).json({
    status: 'success',
    message: `App scaffold for ${appName} created successfully`,
    appStructure: {
      name: appName,
      author: author || 'Default Author',
      description: description || 'A Nextcloud app',
      files: [
        `${appName}/appinfo/info.xml`,
        `${appName}/appinfo/routes.php`,
        `${appName}/lib/Controller/PageController.php`,
        `${appName}/templates/index.php`,
        `${appName}/css/style.css`,
        `${appName}/js/script.js`
      ]
    },
    timestamp: new Date().toISOString()
  });
});

// Start the server
app.listen(PORT, () => {
  logger.info(`MCP Server running on port ${PORT}`);
});

// Export for testing
module.exports = app;