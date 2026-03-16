// database/db.js
const Database = require('better-sqlite3');

const db = new Database('./database/myapp.db', {
  verbose: console.log,
  // fileMustExist: true,        // optional: throw if db file missing
});

// Enable foreign keys
db.pragma('foreign_keys = ON');

module.exports = db;