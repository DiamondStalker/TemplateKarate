Feature: Testeo Movistar Music

  Background:
    * def global_transactions = []
    * def data = read('classpath:winsport/nats/setDatos.json')

    * def nebulaNotifier =  baseUrls.nebulaNotifier
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url

  Scenario Outline: Simular compra paquete y revizar en la DB estado Exitoso para el numero <SUBSCRIBER_NUMBER>
    Given url nebulaNotifier
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
    # En el primer Scenario Outline
    # * karate.appendTo('global_transactions', transaction_id)
    # * print global_transactions


    # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${transaction_id}'`
    * def response = karate.callSingle('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB ======== "
    * print response

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length >= 3


    Examples:
      | data |