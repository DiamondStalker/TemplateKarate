Feature: Crear nuevo usuario

  Background:
    * url 'https://ca6a6b247fab4198200a.free.beeceptor.com'

  Scenario Outline: Crear nuevo usuario Satisfactoriamente
    Given path 'api/users'
    And request {"id": "<id>", "Nombre": "<name>", "trabajo": "<job>"}
    When method Post
    Then status 200

    Examples:
      | id  | name   | job        |
      | 122 | carlos | manager qa |
