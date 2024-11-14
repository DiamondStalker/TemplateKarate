Feature: Validar acumulador con raise.level y validar DB

  Background:

    #Contine la lista para realizar las compras
    * def compras = read('classpath:m4p/setDatos.json')

    # Lista con telefono, uuid final y monto esperado de acumulado
    * def validaciones = read('classpath:m4p/UUIDRiseLevel.json')

    * def transactionData = { transactions: [] }

    * def natsAdmin =  baseUrls.natsAdmin
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url

    * def date =
    """
    (()=>{
      const iso = Math.floor(Date.now() / 1000)
      const isoString = new Date().toISOString();
      const timestampSeconds = Math.floor(new Date(isoString).getTime() / 1000);
      return timestampSeconds
    })()
    """

  @CompraPaquete
  Scenario Outline: Realizando compra paquete de <Recarga> para el numero <SUBSCRIBER_NUMBER>

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.purchasePackage",
      "message": {
        "amount": <Recarga>,
        "date": #(date),
        "referenceId": <ID>,
        "requestId": 0,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "transactionId": <UUID>
      }
    }
    """
    When method POST
    Then status 200

    Examples:
      | compras |


  @validaCantidadRegistros
  Scenario Outline: Validacion  DB para el numero <SUBSCRIBER_NUMBER> para el transaction_id <UUID>

    # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `select * from acumulated_purcahses.monthly where service_number = '${SUBSCRIBER_NUMBER}'`
    * def response = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB <SUBSCRIBER_NUMBER> ======== "
    * print dbQuery
    * print response.result.length

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == <Registros>


    Examples:
      | validaciones |


  @validaMontoAcumulado
  Scenario Outline: Validacion DB MUltiSubject para el numero <SUBSCRIBER_NUMBER> para el transaction_id <UUID>

      # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.raiseLevel'`
    * def response = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB ======== "
    * print JSON.parse(response.result[0].content).totalAmount

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * match JSON.parse(response.result[0].content).totalAmount.toString() contains '<Acumulado>'


    Examples:
      | validaciones |