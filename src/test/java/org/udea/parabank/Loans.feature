@parabank_loans
Feature: Loan request simulation

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def val_customerId = '12212'
    * def random_id = fakerObj.number().randomNumber(5, true)
    * def val_amount = fakerObj.number().numberBetween(10, 30)
    * def val_downPayment = fakerObj.number().numberBetween(5, 10)
    * def unaffordable_downPayment = 100000
    * def val_negative = -15
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
    * def result = call read('verifyDebit.feature') { accountId: '#(val_fromAccountId)', loanAccountId: '#(loan_accountId)', amount: '#(val_downPayment)'}   
    * match result.responseStatus == 200
    * match result.response != null

  Scenario: Loan with unaffordable down Payment
    Given path 'requestLoan'
    And param customerId = val_customerId
    And param amount = val_amount
    And param downPayment = unaffordable_downPayment
    And param fromAccountId = val_fromAccountId
    When method POST
    Then match response.approved == false
    And match response.accountId == null
    And match response.message == "error.insufficient.funds.for.down.payment"

  Scenario: Loan with negative amount
    Given path 'requestLoan'
    And param customerId = val_customerId
    And param amount = val_negative
    And param downPayment = val_downPayment
    And param fromAccountId = val_fromAccountId
    When method POST
    Then match response.approved == false
    And match response.accountId == null

  Scenario: Loan with negative down Payment
    Given path 'requestLoan'
    And param customerId = val_customerId
    And param amount = val_amount
    And param downPayment = val_negative
    And param fromAccountId = val_fromAccountId
    When method POST
    Then match response.approved == false
    And match response.accountId == null

  Scenario: Loan with invalid customerId
    Given path 'requestLoan'
    And param customerId = random_id
    And param amount = val_amount
    And param downPayment = val_downPayment
    And param fromAccountId = val_fromAccountId
    When method POST
    Then status 400
    And match response contains 'Could not find'

  Scenario: Loan with invalid fromAccountId
    Given path 'requestLoan'
    And param customerId = val_customerId
    And param amount = val_amount
    And param downPayment = val_downPayment
    And param fromAccountId = random_id
    When method POST
    Then status 400
    And match response == "Could not find account #" + random_id

