Feature: Creacion y actualizacion de usuario
  
  Scenario: 
    * def createUser = call read('classpath:SQA/reqres/post/crearUsuario.feature')
    * def respuestaCreate = $createUser.response
    * print respuestaCreate

    * def requestToUserCreate = {"name":"bob","job":"leader"}
    * def upDateUser = call read('classpath:SQA/reqres/put/updateUser.feature') requestToUserCreate