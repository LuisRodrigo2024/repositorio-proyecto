package pe.edu.uni.ProyectoColegio;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Prueba {
	
	@GetMapping
    public String Mensaje() {
        return "Comenzando con el proyecto";
    }

}
