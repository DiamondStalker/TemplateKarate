Feature: Test API POST Request

  Scenario Outline: Send POST request to Nebula API
    Given url 'https://nebuladesa.telefonicawebsites.co/apigw/telefonica/v1/nebula-notifier/publish-message'
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "amountPackage": "<Recarga>",
      "purchaseDate": "2024-10-31T03:51:00Z",
      "referenceId": "1319",
      "requestId": "<ID>",
      "serviceNumber": "<SUBSCRIBER_NUMBER>"
    }
    """

    When method POST
    Then status 200
    * def transaction_id = response.transactionId


    # Query the PostgreSQL database
    * def dbConfig = { username: '', password: '', url: '' }
    * def dbQuery = `SELECT response FROM logger.tbl_logger_subject where  logger.tbl_logger_subject.transaction_id = '${transaction_id}'`
    * def result = karate.callSingle('classpath:SQA/reqres/nats/karate-postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print result.result.response

    # Validar que el campo 'mensaje' contenga la palabra 'exitoso'
    * match result.result.response contains 'Exitoso'

    Examples:
      | ID        | SUBSCRIBER_NUMBER | Recarga |
      | 458699662 | 3168354565        | 6000    |