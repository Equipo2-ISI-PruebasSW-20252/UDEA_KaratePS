    @parabank_verify
Feature: verify transaction by amount

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: transaction by amount verified
    Given path 'accounts', accountId, 'transactions', 'amount', amount
    When method GET
    Then status 200

    * def expectedDescription = "Down Payment for Loan # " + loanAccountId
    * match response[*].description contains expectedDescription