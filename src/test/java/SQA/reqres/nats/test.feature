Feature: Testeo Movistar Music

  Background:
    * def global_transactions = []


  Scenario Outline: Simular compra paquete y revizar en la DB estado Exitoso para el numero <SUBSCRIBER_NUMBER>
    Given url 'https://nebuladesa.telefonicawebsites.co/apigw/telefonica/v1/nebula-notifier/publish-message'
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "amountPackage": "<Recarga>",
      "purchaseDate": "2024-11-12T05:19:00Z",
      "referenceId": "9898",
      "requestId": "<ID>",
      "serviceNumber": "<SUBSCRIBER_NUMBER>"
    }
    """

    When method POST
    Then status 200
    * def transaction_id = response.transactionId
    * print "<=== transaction_id <transaction_id> ===>"

    # Query the PostgreSQL database
    * def dbConfig = { username: 'user_app_nebula', password: '$Umdk50$gkZ&1X>y', url: 'jdbc:postgresql://10.86.55.153:31168/proyectonebula2' }
    * def dbQuery = `SELECT response FROM logger.tbl_logger_subject where  logger.tbl_logger_subject.transaction_id = '${transaction_id}'`
    * def result = karate.call('classpath:SQA/reqres/nats/karate-postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print "========"
    * print result

    # Validar que el campo 'mensaje' contenga la palabra 'exitoso'
    * match result.result[0].response contains 'Exitoso'

    Examples:
      | ID        | SUBSCRIBER_NUMBER | Recarga |
      | 458699652 | 3184823023        | 18000   |
      | 284040642 | 3167253288        | 10000   |
      | 284040638 | 3152311339        | 6000    |
      | 284042602 | 3178429246        | 7000    |
















  Scenario Outline: Volver a cargar la información y validar que no se reprocese

    Given url 'https://nebuladesa.telefonicawebsites.co/apigw/telefonica/v1/nebula-nats-admin/messages'
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request

    """
    { "subject": "nebula.provisionMovistarMusic",
    "message": {
        "transactionId":<Reference_ID> ,
        "subscriberNumber": <SUBSCRIBER_NUMBER>,
        "offerCode": "5162",
        "allianceCode":"351",
        "dateApplied": "2024-10-31T05:22:00Z",
        "validDays": 30
      }
    }
    """

    When method POST
    Then status 200

  # Realizar una nueva consulta a la base de datos para verificar si la solicitud fue reprocesada
    * def dbConfig = { username: 'user_app_nebula', password: '$Umdk50$gkZ&1X>y', url: 'jdbc:postgresql://10.86.55.153:31168/proyectonebula2' }
    * def dbQuery = `SELECT response FROM logger.tbl_logger_subject where logger.tbl_logger_subject.transaction_id =  '${Reference_ID}'`
    * def result = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    * print result.result.length

  # Verificar que la cuenta de registros sea 1, indicando que no se reprocesó
    * assert result.result.length == 1


    Examples:
      | ID        | SUBSCRIBER_NUMBER | Recarga | index | Reference_ID                         |
      | 284040642 | 3167253288        | 10000    | 3     | cbeb6a4a-d430-463b-adbb-91edb71a9d29 |