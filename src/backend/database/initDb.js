// database/initDb.js
const db = require('./db');

db.exec(`
  CREATE TABLE IF NOT EXISTS Accounts (
    phone VARCHAR(12),
    hashedPass VARCHAR(255),
    PRIMARY KEY (phone)
  )
`);

console.log('Table Accounts is ready');