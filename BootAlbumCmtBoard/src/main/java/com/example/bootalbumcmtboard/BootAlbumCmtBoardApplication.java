package com.example.bootalbumcmtboard;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = { "com.example.controller",  "com.example.model" } )
public class BootAlbumCmtBoardApplication {

	public static void main(String[] args) {
		SpringApplication.run(BootAlbumCmtBoardApplication.class, args);
	}

}
