const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'remotedev.mughaltec.com',
  database: 'MTAS',
  password: 'super',
  port: 5432,
});

pool.connect()
  .then(() => {
    console.log('PostgreSQL Connected ✅');
  })
  .catch((err) => {
    console.log('DB ERROR ❌');
    console.log(err);
  });

module.exports = pool;