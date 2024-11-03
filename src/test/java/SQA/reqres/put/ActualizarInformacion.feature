Feature: Crear nuevo usuario

  Background:
    * url 'https://ca6a6b247fab4198200a.free.beeceptor.com'

  Scenario: Actualizar Informacion del Usuario
    Given path 'api/users/122'
    And request {"id": 122, "Nombre": Carlos, "trabajo": "SQA POOL"}
    When method Put
    Then status 200
