    @parabank_billpay

Feature: Bill payment failed due to insufficient funds

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def fakerObj = new faker()
    * def val_accountId = '12345'
    * def val_amount = fakerObj.number().numberBetween(10000, 90000)
    * def negative_amount = fakerObj.number()numberBetween(-100, -1)

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
        "accountNumber": 12345
    }
    """
    When method POST
    Then status responseState
    And match response == "Bill payment of $" + val_amount + " from account #" + val_accountId + " failed due to insufficient funds"
    
    Examples:
        | responseState |
        | 400           |
        | 422           |

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
        "accountNumber": 12345
    }
    """
    When method POST
    Then status responseState
    And match response == "Bill payment of $"+ negative_amount +" from account #" + val_accountId + " failed due to insufficient funds"

  Scenario: Payment with empty name at body
    Given path 'billpay'
    And param accountId = val_accountId
    And param amount = val_amount
    And request
    """
    {
        "name": ,
        "address": {
            "street": "NA",
            "city": "NA",
            "state": "NA",
            "zipCode": "NA"
        },
        "phoneNumber": "NA",
        "accountNumber": 12345
    }
    """
    When method POST
    Then status 500
    And match response == "Internal Server Error"