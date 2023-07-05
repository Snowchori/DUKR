package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.AlbumMapperInter;

@Repository
@MapperScan( basePackages = { "com.example.config" } )
public class AlbumDAO {

	@Autowired
	private AlbumMapperInter mapper;
	
	public ArrayList<AlbumTO> albumList() {
		ArrayList<AlbumTO> albumLists = (ArrayList)mapper.albumList();
		return albumLists;
	}
	
	public int albumWriteOk(AlbumTO to) {
		int flag = 1;
		
		int result = mapper.albumWriteOk( to );
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	
}
