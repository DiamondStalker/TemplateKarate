Feature: Actualizar usuario existente

  Background:
    * url 'https://reqres.in/'
    * request '{"nombre": "<name>","trabajo": "<job>"}'

  Scenario Outline: Actualizar usuario
    Given path `api/users/`
    When method Put
    Then  status 200

    Examples:
      | name   | job        |
      | carlos | manager qa |