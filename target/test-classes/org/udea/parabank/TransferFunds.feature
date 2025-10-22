@parabank_transfer
Feature: Transfer Funds in Parabank

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def val_fromAccountId = '54321'
    * def val_toAccountId = '15675'
    * def fakeObj = new faker()
    * def val_amount = fakeObj.number().numberBetween(1, 100)

  Scenario: Successful Transfer
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId
    And param toAccountId = val_toAccountId
    And param amount = val_amount
    When method POST
    Then status 200
