Feature: Validar acumulador con raise.level y validar DB

  Background:

    # Lista con telefono, uuid final y monto esperado de acumulado
    * def validaciones = read('classpath:m4p/raiselevel.json')


    * def natsAdmin =  baseUrls.natsAdmin
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url


  @EnviarRaseLevel
  Scenario Outline: RaiseLevel numero <SUBSCRIBER_NUMBER> con valor de  <Acumulado> para el UUID <UUID>

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.raiseLevel",
      "message": {
        "date": 1731619108.000000000,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "totalAmount": <Acumulado>,
        "transactionId": <UUID>
      }
    }
    """

    When method POST
    Then status 200


    # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `   select * from raise_level.offer_registration where service_number  like '${SUBSCRIBER_NUMBER}'`
    * def response = karate.call('classpath:org/example/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB <SUBSCRIBER_NUMBER> ======== "
    * print dbQuery
    * print response.result.length

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == <Bono>




    Examples:
      | validaciones |