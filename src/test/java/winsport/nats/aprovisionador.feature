Feature: Aprovisionamiento de winsport

  Background:
    * def data = read('classpath:winsport/nats/setDatos.json')
    * def information = read('file:C:/Users/mate9/Documents/SQA/TemplateKarate/target/output/informacion.json')

    * def transactionData = { transactions: [] }

    * def nebulaNotifier =  baseUrls.nebulaNotifier
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url

  Scenario Outline: Simular compra de paquete con aprovisionamiento de winsport <SUBSCRIBER_NUMBER>
    Given url nebulaNotifier
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
      {
        "amountPackage": "<Recarga>",
        "purchaseDate": "+56843-09-05T14:15:09Z",
        "referenceId": "112233445566778899",
        "requestId": "<ID>",
        "serviceNumber": "<SUBSCRIBER_NUMBER>"
      }
    """

    When method POST
    Then status 200
    * def transaction_id = response.transactionId

    # Agregar la transacción actual al array de transacciones
    * transactionData.transactions.push({transaction_id:transaction_id})

    # Guardar el array actualizado en el archivo JSON
    * karate.write(transactionData, 'output/informacion.json')


    # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${transaction_id}' and subject = 'nebula.sms'`
    * def response = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB ======== "
    * print response

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == 1
    # * match response.result[0].content contains 'Vig. <Dias>dias'

    Examples:
      | data |


  Scenario Outline: Validation token transaction_id => <transaction_id>

      # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `SELECT * FROM logger.tbl_logger_subject where transaction_id = '${transaction_id}'`
    * def response = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB ======== "
     * print response.result[0].response

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * match response.result[0].response contains '"additionalsNotes":"El procesamiento fue exitoso"'

    Examples:
      | information.transactions |


  Scenario Outline: Validacion token con cambio de URL para el  transaction_id => <transaction_id>

      # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = ` SELECT * FROM logger.tbl_logger_subject where transaction_id = '${transaction_id}' and response like '%status=OK%' `
    * def response = karate.callSingle('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB ======== "
    * print response.result[0].response

    * karate.write(response.result[0], 'output/resultadoPeticion.json')

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == 1

    Examples:
      | information.transactions |