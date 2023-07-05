package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.AlbumDAO;
import com.example.model.AlbumTO;
import com.example.model.ImageDAO;
import com.example.model.ImageTO;

@RestController
public class AlbumController {

	@Autowired
	private AlbumDAO albumDAO;
	@Autowired
	private ImageDAO imageDAO;
	
	@RequestMapping( "/" )
	public ModelAndView mail(HttpServletRequest request) {
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName( "board_index1" );
		return modelAndView;
	}
	
	@RequestMapping( "/list.do" )
	public ModelAndView list(HttpServletRequest request) {
		
		ArrayList<AlbumTO> albumLists = albumDAO.albumList();
		ArrayList<ImageTO> imageLists = imageDAO.imageLatestList();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName( "board_list1" );
		modelAndView.addObject( "albumLists", albumLists );
		modelAndView.addObject( "imageLists", imageLists );
		return modelAndView;
	}
	
	@RequestMapping( "/write.do" )
	public ModelAndView write(HttpServletRequest request) {
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName( "board_write1" );
		return modelAndView;
	}
	
	@RequestMapping( "/write_ok.do" )
	public ModelAndView write_ok(MultipartFile[] uploads, HttpServletRequest request) {
		
		AlbumTO albumTO = new AlbumTO();
		albumTO.setSubject( request.getParameter( "subject" ) );
		albumTO.setWriter( request.getParameter( "writer" ) );
		
		String mail = "";
		if( !request.getParameter( "mail1" ).equals("") && !request.getParameter( "mail2" ).equals("") ) {
			mail = request.getParameter( "mail1" ) + "@" + request.getParameter( "mail2" );	
		}
		albumTO.setMail( mail );
		albumTO.setPassword( request.getParameter( "password" ) );
		albumTO.setContent( request.getParameter( "content" ) );
		albumTO.setCmtMail( request.getParameter( "cmtmail" ) );
		albumTO.setWip( request.getRemoteAddr() );
		
		int flag1 = albumDAO.albumWriteOk( albumTO );
		
		for( MultipartFile upload : uploads ) {
			
			String extension = upload.getOriginalFilename().substring( upload.getOriginalFilename().lastIndexOf( "." ) );
			String filename = upload.getOriginalFilename().substring( 0, upload.getOriginalFilename().lastIndexOf( "." ) );
			
			String newfilename = filename + "-" + System.currentTimeMillis() + extension;
			
			try {
				upload.transferTo( new File( newfilename ) );
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				System.out.println( "[에러] " + e.getMessage() );
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.out.println( "[에러] " + e.getMessage() );
			}
			
			ImageTO imageTO = new ImageTO();
			imageTO.setPseq( albumTO.getSeq() );
			imageTO.setImageName( newfilename );
			imageTO.setImageSize( upload.getSize() );
			imageTO.setLatitude( request.getParameter( "latitude" ) );
			imageTO.setLongitude( request.getParameter( "longitude" ) );
			
			int flag2 = imageDAO.imageWriteOk( imageTO );
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName( "board_write1_ok" );
		modelAndView.addObject( "flag", flag1 );
		return modelAndView;
	}
}











