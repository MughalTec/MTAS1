const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// PostgreSQL connection
const pool = new Pool({
  user: 'postgres',
  host: 'remotedev.mughaltec.com',
  database: 'MTAS',
  password: 'super',
  port: 5432,
  options: '-c search_path=mtas'
});

// TEST
app.get('/', (req, res) => {
  res.send('API running');
});

// GET
app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM "tblUser"');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
});

// // INSERT
// app.post('/users', async (req, res) => {
//   const { name } = req.body;
//   await pool.query('INSERT INTO mtas."tblUser"(name) VALUES($1)', [name]);
//   res.send('Inserted');
// });

app.listen(3000, () => console.log('Server running'));