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
      "purchaseDate": "2024-10-31T05:22:00Z",
      "referenceId": "9190",
      "requestId": "<ID>",
      "serviceNumber": "<SUBSCRIBER_NUMBER>"
    }
    """

    When method POST
    Then status 200
    * def transaction_id = response.transactionId
    # En el primer Scenario Outline
    # * karate.appendTo('global_transactions', transaction_id)
    # * print global_transactions


    # Query the PostgreSQL database
    * def dbConfig = { username: '', password: '', url: '' }
    * def dbQuery = `SELECT response FROM logger.tbl_logger_subject where  logger.tbl_logger_subject.transaction_id = '${transaction_id}'`
    * def result = karate.callSingle('classpath:SQA/reqres/nats/karate-postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })
    #Espesificar una columna en concreto para no traer toda la informacion y no tener tiempos de carga largos
     * def result = Java.type('org.example.DbUtils').executeQuery(dbConfig.url, dbConfig.username, dbConfig.password, dbQuery, 'response')


    # * print result
    * print result.result.response

    # Validar que el campo 'mensaje' contenga la palabra 'exitoso'
    * match result.result.response contains 'Exitoso'


    Examples:
      | ID         | SUBSCRIBER_NUMBER | Recarga |
      | 458721680  | 3150000019        | 6000    |
      | 2068800556 | 3168435409        | 12000   |


  Scenario Outline: Volver a cargar la información y validar que no se reprocese

    Given url 'https://nebuladesa.telefonicawebsites.co/apigw/telefonica/v1/nebula-nats-admin/messages'
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request { "subject": "nebula.provisionMovistarMusic","message": {"transactionId": "a38720d4-3030-4c42-9bd1-e55583776ebd","subscriberNumber": "3150000019","offerCode": "5162","dateApplied": "2024-10-31T05:22:00Z","validDays": 30}}
    When method POST
    Then status 200

  # Realizar una nueva consulta a la base de datos para verificar si la solicitud fue reprocesada
    * def dbConfig = { username: '', password: '', url: '' }
    * def dbQuery = `SELECT "content" FROM logger.tbl_multi_subject where logger.tbl_multi_subject.transaction_id = 'a38720d4-3030-4c42-9bd1-e55583776ebd'`
    * def result = Java.type('org.example.DbUtils').executeQuery(dbConfig.url, dbConfig.username, dbConfig.password, dbQuery, 'content')

    * print result

  # Verificar que la cuenta de registros sea 1, indicando que no se reprocesó
     * match result.count == 1


    Examples:
      | ID        | SUBSCRIBER_NUMBER | Recarga | index |
      | 458721680 | 3168354565        | 6000    | 0     |
