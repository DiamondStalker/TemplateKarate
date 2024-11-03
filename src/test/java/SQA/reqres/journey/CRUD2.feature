Feature: Creacion y actualizacion de usuario

  Scenario:
    * def createUser = call read('classpath:SQA/reqres/post/CrearNuevoUsuario.feature')
    * def respuestaCreate = $createUser.response


    * print respuestaCreate

    * def requestToUserCreate = {"Nombre":"Carlos","trabajo":"SQA POOLLLLLL","id":122}
    * def upDateUser = call read('classpath:SQA/reqres/put/ActualizarInformacion.feature') requestToUserCreate