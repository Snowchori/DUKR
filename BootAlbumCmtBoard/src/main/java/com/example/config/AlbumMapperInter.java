package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import com.example.model.AlbumTO;

public interface AlbumMapperInter {

	@Select( "select seq, subject, writer, cmtcnt, date_format(wdate, '%Y-%m-%d') wdate, hit, datediff(now(), wdate) wgap from album_cmt_board2 order by seq desc" )
	public ArrayList<AlbumTO> albumList();

	@Insert( "insert into album_cmt_board2 values (0, #{subject}, #{writer}, #{mail}, #{password}, #{content}, 0, #{cmtMail}, 0, #{wip}, now() )" )
	@Options( useGeneratedKeys=true, keyProperty="seq" )
	public int albumWriteOk(AlbumTO to);
	
}
