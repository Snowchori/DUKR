package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SearchFilterTO {
	private String keyword;
	private String players;
	private String genre;
	private String sort;
	private String tutorial;
}
