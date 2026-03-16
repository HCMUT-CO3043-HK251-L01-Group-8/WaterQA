// services/accounts.service.js
const accountsRepo = require("../repositories/accounts.repo");

class AccountsService {
  getAllAccounts() {
    return accountsRepo.findAll(); // sync call
  }
  addAccount(phone, password, passwordAgain) {
    if (password != passwordAgain) {
      return 1;
    }
    else {
      const acc = accountsRepo.findByPhone(phone);
      if (acc.length > 0) { return 2; }
      else {
        accountsRepo.addAccount(phone, password);
        return 0;
      }
    }
  }
}

module.exports = new AccountsService();
