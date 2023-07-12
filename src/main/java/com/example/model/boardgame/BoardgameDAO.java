package com.example.model.boardgame;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.colorThief.ColorThief;
import com.example.config.BoardgameMapperInter;

@Repository
public class BoardgameDAO {
	@Autowired
	private BoardgameMapperInter gameMapper;
	
	// 보드게임 정보 가져오기
	public BoardgameTO gameInfo(String gameId) {
		BoardgameTO gameTO = new BoardgameTO();
		gameTO.setSeq(gameId);
		
		gameTO = gameMapper.gameInfo(gameTO);
		
		// bgg xml api2 이용하여 보드게임 데이터 가져와서 DB에 추가
		if(gameTO == null) {
			try {
				gameTO = new BoardgameTO();
				gameTO.setSeq(gameId);
				
				Connection conn = Jsoup.connect("https://api.geekdo.com/xmlapi/boardgame/" + gameId).parser(Parser.xmlParser());
				
				Document doc = conn.get();
				
				Elements infos = doc.select("boardgame");
				
				for(Element e: infos) {
					String imageUrl = e.select("image").text();
					String yearpublished = e.select("yearpublished").text();
					String minplayers = e.select("minplayers").text();
					String maxplayers = e.select("maxplayers").text();
					String minplaytime = e.select("minplaytime").text();
					String maxplaytime = e.select("maxplaytime").text();
					String minage = e.select("age").text();
					
					if(imageUrl == "" || yearpublished == "" || minplayers == "" || maxplayers == "" || minplaytime == "" || maxplaytime == "" || minage == "") {
						return null;
					}
					
					gameTO.setImageUrl(imageUrl);
					gameTO.setYearpublished(yearpublished);
					gameTO.setMinPlayer(minplayers);
					gameTO.setMaxPlayer(maxplayers);
					gameTO.setMinPlaytime(minplaytime);
					gameTO.setMaxPlaytime(maxplaytime);
					gameTO.setMinAge(minage);

					StringBuilder genre = new StringBuilder("");
					StringBuilder theme = new StringBuilder("");
					
					for(Element genres: e.select("boardgamecategory")) {
						genre.append(genres.text() + "/");
					}
					
					if(genre.lastIndexOf("/") > -1) {
						genre.deleteCharAt(genre.lastIndexOf("/"));
					}
					
					gameTO.setGenre(genre.toString());
					
					for(Element themes: e.select("boardgamemechanic")) {
						theme.append(themes.text() + "/");
					}
					
					if(theme.lastIndexOf("/") > -1) {
						theme.deleteCharAt(theme.lastIndexOf("/"));
					}
					
					gameTO.setTheme(theme.toString());
					
					// 한글제목 가져오기 없으면 원제목
					boolean isFirst = true;
					for(Element names: e.select("name")) {
						if(isFirst) {
							gameTO.setTitle(names.text());
							isFirst = false;
						}
						String name = names.text();
						if(name.matches(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
							gameTO.setTitle(name);
							break;
						}
					}
					gameTO.setBrief(gameTO.getTitle() + "입니다.");
					gameTO.setIsinDB(false);
					gameTO.setHit("0");
					gameTO.setRecCnt("0");
					gameTO.setEvalCnt("0");
					
				    // DB에 추가
					gameMapper.gameInsert(gameTO);
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			gameMapper.hitUp(gameTO);
			gameTO.setIsinDB(true);
		}
		
		return gameTO;
	}
	
	// 보드게임 배경색 계산
	public BoardgameTO getBgColor(BoardgameTO gameTO) {
		if(gameTO.getBgColor() == null) {
			// 이미지에서 가장 많은 색 구하기
			try {
				BufferedImage image;
				URL url = new URL(gameTO.getImageUrl());
				image = ImageIO.read(url);
				
				int[] rgb = ColorThief.getColor(image);
				
				int r = (int)((rgb[0] + 60) * 0.5);
				int g = (int)((rgb[1] + 60) * 0.5);
				int b = (int)((rgb[2] + 60) * 0.5);
				String bgColor = r + "/" + g + "/" + b;
				
				gameTO.setBgColor(bgColor);
				
				gameMapper.gameBgColorInsert(gameTO);
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return gameTO;
	}
	
	// 보드게임 추천 추가
	public int gameFavoriteInsertOk(String memSeq, String gameSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("gameSeq", gameSeq);
		
		int flag = 1;
		int result = gameMapper.gameFavoriteInsert(map);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 보드게임 즐겨찾기 추가
	public int gameFavoriteDeleteOk(String memSeq, String gameSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("gameSeq", gameSeq);
		
		int flag = 1;
		int result = gameMapper.gameFavoriteDelete(map);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 보드게임 추천 추가
	public int gameRecommendInsertOk(String memSeq, String gameSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("gameSeq", gameSeq);
		
		int flag = 1;
		int result = gameMapper.gameRecommendInsert(map);
		
		if(result == 1) {
			flag = 0;
			gameMapper.gameRecCntUp(gameSeq);
		}
		
		return flag;
	}
	
	// 보드게임 추천 삭제
	public int gameRecommendDeleteOk(String memSeq, String gameSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("gameSeq", gameSeq);
		
		int flag = 1;
		int result = gameMapper.gameRecommendDelete(map);
		
		if(result == 1) {
			flag = 0;
			gameMapper.gameRecCntDown(gameSeq);
		}
		
		return flag;
	}
	
	// 보드게임 목록
	public ArrayList<BoardgameTO> gameList(String sort) {
		ArrayList<BoardgameTO> lists = new ArrayList<BoardgameTO>();
		lists = gameMapper.gameList(sort);
		
		return lists;
	}
	
	// 보드게임 수정
	public int gameModifyOk(BoardgameTO to) {
		int flag = 1;
		int result = gameMapper.gameInfoModify(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 추천 보드게임 추가
	public int gameRecInsert(String seq) {
		int flag = 1;
		int result = gameMapper.gameRecInsert(seq);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 추천 보드게임 초기화
	public int gameRecClear() {
		int flag = 0;
		int result = gameMapper.gameRecClear();
		
		if(result == 0) {
			flag = 1;
		}
		
		return flag;
	}
	
	// 추천 보드게임 목록
	public ArrayList<String> gameRecList() {
		ArrayList<String> lists = gameMapper.gameRecList();
		
		return lists;
	}
	
	// 메인페이지 즐겨찾기한 보드게임 목록
	public ArrayList<String> gameMainFavList(String userSeq){
		ArrayList<String> lists = gameMapper.gameMainFavList(userSeq);
		
		return lists;
	}
	
	// 메인페이지 보드게임 목록
	public ArrayList<BoardgameTO> gameMainList(){
		ArrayList<BoardgameTO> lists = gameMapper.gameMainList();
		
		return lists;
	}
	
	// 게임 검색
	public ArrayList<BoardgameTO> gameSearch(SearchFilterTO to){
		ArrayList<BoardgameTO> lists = new ArrayList<>();
		
		if(to.getKeyword().equals("")) {	// 게임 이름을 검색 안했을 때 ( 첫 게임검색 페이지에 들어왔을 때, 혹은 정렬만 바꿨을 때 )			
			lists = gameList(to.getSort());
			
			return lists;
		}
		
		boolean playersCheck = false; // 인원 조건 유무
		boolean playersFilter; // 인원 조건 검사 결과 ( True: 비정상, False: 정상 )
		
		boolean genreCheck = false;	  // 장르 조건 유무
		boolean genreFilter; // 장르 조건 검사 결과 ( True: 비정상, False: 정상 )
		
		if( !(to.getPlayers().equals("")) ) {
			playersCheck = true; 
		}
		if( !(to.getGenre().equals("")) ) {
			genreCheck = true; 
		}
				
		
		try {				
			// Create a URL object for the BoardGameGeek
			Connection conn = Jsoup.connect("https://api.geekdo.com/xmlapi/search?search=" + to.getKeyword()).parser(Parser.xmlParser());

			// Connect to the API and get the response document
			Document document = conn.get();

			// Extract the elements representing the board games
			Elements boardGames = document.select("boardgame");
			
			// Iterate over the board games and print out their information
			for (Element boardGame : boardGames) {		
				
				playersFilter = true; 
				genreFilter = true;
								
				String gameId = boardGame.attr("objectid");
				
				BoardgameTO gameTO = gameInfo(gameId);

				// 인원 조건 검사
				if( playersCheck ) {	
					
					String[] players = to.getPlayers().split(",");
					int minPlayers = Integer.parseInt(gameTO.getMinPlayer());
					int maxPlayers = Integer.parseInt(gameTO.getMaxPlayer());

					for(String i : players) {
						
						// 조건 중 에 넣은 플레이 인원에 하나라도 해당하는 게임은 filter = false
						if( minPlayers <= Integer.parseInt(i) && Integer.parseInt(i) <= maxPlayers ) {
							playersFilter = false;
						}
					}
				} else {
					playersFilter = false;
				}
				
				// 장르 조건 검사
				if( genreCheck ) {
					String[] genres = to.getGenre().split(",");
					
					// DB 에 해당 gameId의 게임이 있으면 그 게임의 장르 반환
					String gameGenre = gameMapper.genreSearch(gameId);
					
					// DB 에 게임이 있을 때
					if(gameGenre != null) {
						
						for(String genre : genres) {
							if(gameGenre.indexOf(genre) != -1) {
								genreFilter = false;
								break;
							}
						}
					} else { 
						// DB에 게임이 없을 때 ( xml 에서 해당 게임 조회 해서 비교 )
						String gameCategories = Jsoup.connect("https://api.geekdo.com/xmlapi/boardgame/" + gameId).get().select("boardgamecategory").text();
						String gameCategory = "";
						
						for(String genre : genres) {
							switch(genre) {	
								// 장르를 BGG_XML_API에서 사용하는 카테고리로 대체
								case "전략":
									gameCategory = "Strategy";
									break;
									
								case "두뇌":
									gameCategory = "Puzzle";
									break;
									
								case "순발력":
									gameCategory = "Action";
									break;
									
								case "가족":
									gameCategory = "Children";
									break;
									
								case "카드":
									gameCategory = "Card";
									break;
							}
							
							if(gameCategories.indexOf(gameCategory) != -1) {
								genreFilter = false;
								break;
							}
						}
					}
				} else {
					genreFilter = false;
				}
				
				// 검색 조건에 해당하지 않는 게임이므로 gameInfo에 저장하지 않고 continue
				if(playersFilter || genreFilter) {
					continue;
				}

			    lists.add(gameTO);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		switch(to.getSort()) {
		case "yearpublished":
			Collections.sort(lists, new YearpublishedComparator().reversed());
			break;
			
		case "hit":
			Collections.sort(lists, new HitComparator().reversed());
			break;
			
		case "recCtn":
			Collections.sort(lists, new RecCntComparator().reversed());
			break;
			
		case "difficulty":
			Collections.sort(lists, new DiffComparator().reversed());		
			break;
			
		
		}
		
		return lists;
	}
	
	// 출시년도 내림차순 정렬
	class YearpublishedComparator implements Comparator<BoardgameTO>{

		@Override
		public int compare(BoardgameTO o1, BoardgameTO o2) {	
			// TODO Auto-generated method stub
			return o1.getYearpublished().compareTo(o2.getYearpublished());
		}
		
	}

	// 조회수 내림차순 정렬
	class HitComparator implements Comparator<BoardgameTO>{

		@Override
		public int compare(BoardgameTO o1, BoardgameTO o2) {	
			// TODO Auto-generated method stub
			return o1.getHit().compareTo(o2.getHit());

		}
		
	}

	// 추천수 내림차순 정렬
	class RecCntComparator implements Comparator<BoardgameTO>{

		@Override
		public int compare(BoardgameTO o1, BoardgameTO o2) {	
			// TODO Auto-generated method stub
			return o1.getRecCnt().compareTo(o2.getRecCnt());

		}
		
	}

	// 난이도 내림차순 정렬
	class DiffComparator implements Comparator<BoardgameTO>{

		@Override
		public int compare(BoardgameTO o1, BoardgameTO o2) {	
			// TODO Auto-generated method stub
			return o1.getDifficulty().compareTo(o2.getDifficulty());

		}
	}
}