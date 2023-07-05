package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberTO {
	private String seq;
	private String hintSeq;
	private String id;
	private String password;
	private String nickname;
	private String email;
	private String answer;
	private boolean certification;
	private int rate;
	private boolean isAdmin;
	private String uuid;
}
