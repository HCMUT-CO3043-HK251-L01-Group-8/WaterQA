// repositories/accounts.repository.js
const db = require("../database/db");

class AccountsRepository {
  findAll() {
    return db
      .prepare("SELECT phone, hashedPass FROM Accounts ORDER BY phone")
      .all();
  }
  findByPhone(phone) {
    return db
      .prepare("SELECT phone, hashedPass FROM Accounts WHERE phone=?")
      .all([phone]);
  }
  addAccount(phone, password) {
    return db
      .prepare("INSERT INTO Accounts VALUES (?, ?)")
      .run([phone, password]);
  }
}

module.exports = new AccountsRepository();
