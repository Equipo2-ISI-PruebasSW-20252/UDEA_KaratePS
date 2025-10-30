@parabank_billpay
Feature: Bill payment failed due to insufficient funds

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def val_accountId = '12345'
    * def val_amount = fakerObj.number().numberBetween(10000, 90000)
    * def negative_amount = fakerObj.number().numberBetween(-100, -1)

  Scenario: Payment with Insufficient Funds
    Given path 'billpay'
    And param accountId = val_accountId
    And param amount = val_amount
    And request
    """
    {
        "name": "John Doe test",
        "address": {
            "street": "NA",
            "city": "NA",
            "state": "NA",
            "zipCode": "NA"
        },
        "phoneNumber": "NA",
        "accountNumber": 12456
    }
    """
    When method POST
    Then match [400, 422] contains responseStatus
    And match response contains "insufficient funds"

  Scenario: Payment with negative funds
    Given path 'billpay'
    And param accountId = val_accountId
    And param amount = negative_amount
    And request
    """
    {
        "name": "John Doe test",
        "address": {
            "street": "NA",
            "city": "NA",
            "state": "NA",
            "zipCode": "NA"
        },
        "phoneNumber": "NA",
        "accountNumber": 12456
    }
    """
    When method POST
    Then status 400

  Scenario: Payment without accountNumber
    Given path 'billpay'
    And param accountId = val_accountId
    And param amount = val_amount
    And request
    """
    {
        "name": "John Doe test",
        "address": {
            "street": "NA",
            "city": "NA",
            "state": "NA",
            "zipCode": "NA"
        },
        "phoneNumber": "NA"
    }
    """
    When method POST
    Then status 500