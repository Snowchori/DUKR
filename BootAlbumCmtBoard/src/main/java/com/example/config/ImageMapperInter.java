package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.model.ImageTO;

public interface ImageMapperInter {

	@Select( "select seq, pseq, imagename, imagesize from album_cmt_image2 where seq in ( select max(seq) from album_cmt_image2 group by pseq )" )
	public ArrayList<ImageTO> imageLatestList();
	
	@Select( "select imagename, imagesize from album_cmt_image2 where pseq=#{pseq}" )
	public ArrayList<ImageTO> imageAllList();

	@Insert( "insert into album_cmt_image2 values (0, #{pseq}, #{imageName}, #{imageSize}, #{latitude}, #{longitude}, now() )" )
	public int imageWriteOk(ImageTO to);
}
