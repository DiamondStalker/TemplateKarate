Feature: Crear nuevo usuario

  Background:
    * url 'https://reqres.in/'
    * request read ('classpath:SQA/reqres/post/request/usuariosNuevos.json')

  Scenario Outline: Crear un usuario satisfactoriamente <name>
    Given path 'api/users/'
    When method Post
    Then status 201

    Examples:
      | name    | job       |
      | carlos  | leader    |
      | Yessica | Admin     |
      | Julian  | Operative |
      | Carla   | QA        |
