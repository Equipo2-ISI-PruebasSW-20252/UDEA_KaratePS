    @parabank_loans
Feature: Loan request simulation

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def val_customerId = '12212'
    * def val_amount = fakerObj.number().numberBetween(50, 200)
    * def val_downPayment = fakerObj.number().numberBetween(10, 75)
    * def val_fromAccountId = '13344'

  Scenario: Loan with affordable down Payment
    Given path 'requestLoan'
    And param customerId = val_customerId
    And param amount = val_amount
    And param downPayment = val_downPayment
    And param fromAccountId = val_fromAccountId
    When method POST
    Then status 200
    And match response.approved == true

    * def loan_accountId = response.accountId

    * def result = call read('verifyDebit.feature') {
        accountId: val_fromAccountId,
        loanAccountId: loan_accountId,
        amount: val_downPayment
    } 
    * match result.responseStatus == 200
    * match result.response != null