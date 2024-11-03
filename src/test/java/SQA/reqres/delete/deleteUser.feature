Feature: Eliminar usuario existente

  Background:
    * url 'https://reqres.in/'

  Scenario: Eliminar usuario
    * def user = 2

    Given path `api/users/`,user
    When method Delete
    Then  status 204