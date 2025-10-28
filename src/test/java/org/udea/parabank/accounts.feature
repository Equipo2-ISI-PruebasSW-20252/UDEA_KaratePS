@parabank_transfer
Feature: Get customer accounts

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def valid_customerId = '12212'
    * def invalid_customerId = fakerObj.number().randomNumber(5, true)

  Scenario: Valid Customer ID
    Given path 'customers', valid_customerId, 'accounts'
    When method GET
    Then status 200
    And match response == '#[]'         // valida que se devuelva un arreglo
    And match each response ==
    """
    {
      id: '#number',
      customerId: '#number',
      type: '#string',
      balance: '#number'
    }
    """
    And match response[0].customerId == parseInt(valid_customerId)      // Verifica que el customerId del primer elemento coincida
    * print 'Customer accounts retrieved successfully for customerId: ' + valid_customerId

  Scenario: Invalid Customer ID
    Given path 'customers', invalid_customerId, 'accounts'
    When method GET
    Then status 400
    And match response == "Could not find customer #" + invalid_customerId
    * print 'Invalid customer test passed'

  Scenario: Empty Customer ID
    Given path 'customers', '', 'accounts'
    When method GET
    Then status 404
    * print 'Empty customer test passed'