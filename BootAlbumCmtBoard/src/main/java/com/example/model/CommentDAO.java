package com.example.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.CommentMapperInter;

@Repository
public class CommentDAO {
	
	@Autowired
	private CommentMapperInter mapper;
}
