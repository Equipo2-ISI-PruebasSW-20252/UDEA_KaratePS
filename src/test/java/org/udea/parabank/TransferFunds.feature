@parabank_transfer
Feature: Transfer Funds in Parabank

# Se usa el karate.fail() para marcar las pruebas que tienen errores de validación en el sistema, marcandolas como fallidas.
 
  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def val_fromAccountId = '12456'
    * def val_toAccountId = '12345'
    * def val_amount = fakerObj.number().numberBetween(1, 200)
    * def val_fromAccountId_error = fakerObj.number().randomNumber(5, true)
    * def val_toAccountId_error = fakerObj.number().randomNumber(5, true)
    * def high_amount = 9999999
    * def negative_amount = -50
  
  Scenario: Successful Transfer
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId
    And param toAccountId = val_toAccountId
    And param amount = val_amount
    When method POST
    Then status 200
    And match response == "Successfully transferred $"+ val_amount+" from account #"+val_fromAccountId+" to account #"+val_toAccountId
    
  Scenario: Invalid Accounts
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId_error
    And param toAccountId = val_toAccountId_error
    And param amount = val_amount
    When method POST
    Then status 400
    And match response == "Could not find account number " + val_fromAccountId_error + " and/or " + val_toAccountId_error

  # La siguiente prueba tiene error de validación, ya que asi no se tengas fondos, el sistema permite hacer transferencias.
  Scenario: Insufficient Funds
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId
    And param toAccountId = val_toAccountId
    And param amount = high_amount
    When method POST
    Then status 200
    And match response == "Successfully transferred $"+ high_amount+" from account #"+val_fromAccountId+" to account #"+val_toAccountId
    * print 'BUG DETECTED: The system allows transfers with insufficient funds, expected validation error'
    * karate.fail('BUG DETECTED: The system allows transfers with insufficient funds, expected validation error')

  # La siguiente prueba tiene un error de validación, ya que el sistema permite transferencias con montos negativos.
  Scenario: Negative Amount
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId
    And param toAccountId = val_toAccountId
    And param amount = negative_amount
    When method POST
    Then status 200
    And match response == "Successfully transferred $"+ negative_amount+" from account #"+val_fromAccountId+" to account #"+val_toAccountId
    * print 'BUG DETECTED: The system allows negative transfers, expected validation error'
    * karate.fail('BUG DETECTED: The system allows negative transfers, expected validation error')

  # La siguiente prueba tiene un error de validación, ya que el sistema permite transferencias entre la misma cuenta.
  Scenario: Same Account Transfer
    Given path 'transfer'
    And param fromAccountId = val_fromAccountId
    And param toAccountId = val_fromAccountId
    And param amount = val_amount
    When method POST
    Then status 200
    And match response == "Successfully transferred $"+ val_amount+" from account #"+val_fromAccountId+" to account #"+val_fromAccountId
    * print 'BUG DETECTED: The system allows transfers between the same account, expected validation error'
    * karate.fail('BUG DETECTED: The system allows transfers between the same account, expected validation error')