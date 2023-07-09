package com.example.model;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardgameMapperInter;

@Repository
@MapperScan( basePackages = { "com.example.config" } )
public class BoardgameDAO {
	@Autowired
	private BoardgameMapperInter gameMapper;
	
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
					gameTO.isModi = false;
					
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
	
	public ArrayList<BoardgameTO> gameList() {
		ArrayList<BoardgameTO> lists = new ArrayList<BoardgameTO>();
		lists = gameMapper.gameList();
		
		return lists;
	}
	
	public int gameModifyOk(BoardgameTO to) {
		int flag = 1;
		int result = gameMapper.gameInfoModify(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	public int gameRecInsert(String seq) {
		int flag = 1;
		int result = gameMapper.gameRecInsert(seq);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	public int gameRecClear() {
		int flag = 1;
		int result = gameMapper.gameRecClear();
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	public ArrayList<String> gameRecList() {
		ArrayList<String> lists = gameMapper.gameRecList();
		
		return lists;
	}
	
	public ArrayList<Map<String, String>> gameSearch(SearchFilterTO to){
		ArrayList<Map<String, String>> lists = new ArrayList<>();
		
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
			//Connection conn = Jsoup.connect("https://boardgamegeek.com/xmlapi/search?search=+");

			
			// Connect to the API and get the response document
			Document document = conn.get();

			// Extract the elements representing the board games
			Elements boardGames = document.select("boardgame");
			
			// Iterate over the board games and print out their information
			for (Element boardGame : boardGames) {		
				
				playersFilter = true; 
				genreFilter = true;
				
				Map<String, String> gameinfo = new HashMap<String, String>();
				
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
					} else { // DB에 게임이 없을 때 ( xml 에서 해당 게임 조회 해서 비교 )
						
						String gameCategories = Jsoup.connect("https://api.geekdo.com/xmlapi/boardgame/" + gameId).get().select("boardgamecategory").text();
						String gameCategory = "";
						
						for(String genre : genres) {
							switch(genre) {		// 장르를 BGG_XML_API에서 사용하는 카테고리로 대체
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
				
			    String thumbnail = gameTO.getImageUrl();

			    gameinfo.put("gameId", gameId);
			    gameinfo.put("thumbnail", thumbnail);

			    lists.add(gameinfo);
			    
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// 정렬
		
		
		return lists;
	}
}