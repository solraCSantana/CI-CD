package com.dockerforjavadevelopers.hello;


import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {
    
    @RequestMapping("/")
    public String index() {
        return "Hello World\n";
    }

    @RequestMapping("/healthcheck")
    public ResponseEntity healthcheck() {
        // Criar verificacoes para comprovar a saude da versao atual
        return ResponseEntity.ok().build();
    }
}
