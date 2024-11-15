package m4p;

import com.intuit.karate.junit5.Karate;


public class RunnerTest {
    //    @Test
//    void testAcumulador() {
//        Results results = Runner.path("classpath:m4p/Acumulador.feature")
//                .tags("@CompraPaquete")  // Ejecuta solo los escenarios con la etiqueta @CompraPaquete
//                .parallel(1);
//
//    }
//    @Karate.Test
//    Karate testOutline() {
//        return Karate.run("classpath:m4p/Acumulador.feature");
//    }
//
    @Karate.Test
    public Karate execute() {
        return Karate.run("classpath:m4p/Acumulador.feature").tags("@CompraPaquete").relativeTo(getClass());
    }

    @Karate.Test
    public Karate executes() {
        return Karate.run("classpath:m4p/Acumulador.feature").tags("@validaCantidadRegistros").relativeTo(getClass());
    }
}
