@parabank_login
Feature: Login to Parabank

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Customer Login
    Given path 'login'
    And path 'john' //userName
    And path 'demo' //password
    When method GET
    Then status 200
    And match response ==
    """
    {
       "id": '#number',
       "firstName": '#string',
       "lastName": '#string',
       "address": {
            "street": '#string',
            "city": '#string',
            "state": '#string',
            "zipCode": '#string'
        },
       "phoneNumber": '#string',
       "ssn": '#string'
    }
    """
    * print responseHeaders
    And match responseHeaders contains {'CF-RAY': '#present'}

  Scenario: Customer Login with invalid credentials
    Given path 'login'
    And path 'invalidUserName'
    And path 'WrongPassword'
    When method GET
    Then status 400
    And match response == "Invalid username and/or password"

  Scenario: Customer Login with empty credentials
    Given path 'login'
    And path ''
    And path ''
    When method GET
    Then status 404
