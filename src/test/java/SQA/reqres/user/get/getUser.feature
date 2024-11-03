Feature: Obtener informacion de usuarios
  Background: 
    * url "https://reqres.in/"
    
    Scenario: traer usuario
      * def user = 2
      Given path 'api/users', user
      When method Get
      Then status 200