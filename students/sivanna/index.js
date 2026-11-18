
require('dotenv').config();

const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  user: process.env.POSTGRES_USER || 'postgres',
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB || 'devops_dashboard'
});

app.use(express.static('public'));

app.get('/api/status', async (req, res) => {
  let database = 'disconnected';

  try {
    await pool.query('SELECT 1');
    database = 'connected';
  } catch (error) {
    console.error('Database check failed:', error.message);
  }

  res.json({
    application: 'DevOps Deployment Dashboard',
    status: 'running',
    database,
    version: process.env.IMAGE_TAG || 'local',
    timestamp: new Date().toISOString()
  });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Dashboard running on port ${PORT}`);
  });
}

module.exports = app;
