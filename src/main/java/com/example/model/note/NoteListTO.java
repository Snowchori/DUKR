package com.example.model.note;

import java.util.ArrayList;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Tolerate;

@Getter
@Setter
public class NoteListTO {
	private int cpage;
	private int recordPerPage;
	private int blockPerPage;
	private int totalPage;
	private int totalRecord;
	private int startBlock;
	private int endBlock;
	private int skip;
	private String seq;
	
	private ArrayList<NoteTO> noteList;
	
	public NoteListTO() {
		// TODO Auto-generated constructor stub
		this.cpage = 1;
		this.recordPerPage = 10;
		this.blockPerPage = 5;
		this.totalPage = 1;
		this.totalRecord = 0;
	}
	
	// 시작 인덱스
	@Tolerate
	public void setSkip() {
		this.skip = (this.cpage - 1) * this.recordPerPage;
	}
	
	// 전체 페이지수
	@Tolerate
	public void setTotalPage() {
		this.totalPage = (this.totalRecord - 1) / this.recordPerPage + 1;
	}
	
	// 시작 블럭
	@Tolerate
	public void setStartBlock() {
		this.startBlock = this.cpage - (this.cpage - 1) % this.blockPerPage;
	}
	
	// 끝 블럭
	@Tolerate
	public void setEndBlock() {
		this.endBlock = this.cpage - (this.cpage - 1) % this.blockPerPage + this.blockPerPage - 1;
		if(this.endBlock >= this.totalPage) {
			this.endBlock = this.totalPage;
		}
	}
}
