package com.example.model.comment;

import java.util.ArrayList;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Tolerate;

@Setter
@Getter
public class CommentListTO {
	private int cpage;
	private int recordPerPage;
	private int blockPerPage;
	private int totalPage;
	private int totalRecord;
	private int startBlock;
	private int endBlock;
	private int skip;
	private String keyWord;
	
	private ArrayList<CommentTO> commentList;
	
	public CommentListTO() {
		// TODO Auto-generated constructor stub
		this.cpage = 1;
		this.recordPerPage = 10;
		this.blockPerPage = 5;
		this.totalPage = 1;
		this.totalRecord = 0;
	}
	
	@Tolerate
	public void setSkip() {
		this.skip = (this.cpage - 1) * this.recordPerPage;
	}
	
	@Tolerate
	public void setTotalPage() {
		this.totalPage = (this.totalRecord - 1) / this.recordPerPage + 1;
	}
	
	@Tolerate
	public void setStartBlock() {
		this.startBlock = this.cpage - (this.cpage - 1) % this.blockPerPage;
	}
	
	@Tolerate
	public void setEndBlock() {
		this.endBlock = this.cpage - (this.cpage - 1) % this.blockPerPage + this.blockPerPage - 1;
		if(this.endBlock >= this.totalPage) {
			this.endBlock = this.totalPage;
		}
	}
}
