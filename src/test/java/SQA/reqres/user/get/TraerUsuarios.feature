Feature: Traer todos los usuarios
  Background:
    * url "https://ca6a6b247fab4198200a.free.beeceptor.com"

  Scenario: traer usuario

    Given path 'api/users'
    When method Get
    Then status 200