package com.example.playable.sechsnimmt;

import java.util.ArrayList;

public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		//SechsNimmtGameTO to = new SechsNimmtGameTO();
		
		//System.out.println(to.getCardPool());
		//System.out.println(to.getGameStatus());
		
		ArrayList<String> testarr = new ArrayList<>();
		
		testarr.add("a");
		testarr.add("b");
		testarr.add("c");
		testarr.add("d");
		testarr.add("e");
		
		String cursor1 = testarr.get(2);
		String cursor2 = testarr.get(4);
		
		testarr.set(2, cursor2);
		testarr.set(4, cursor1);
		
		for(String e : testarr) {
			System.out.println(e + "//" + testarr.indexOf(e));
		}
		
		
		ArrayList<String> testarr2 = new ArrayList<>();
		testarr2.add("1");
		testarr2.add("2");
		testarr2.add("3");
		testarr2.add("4");
		testarr2.add("5");
		
		String pick1 = testarr2.get(0);
		
		testarr2.set(0, "new string");
		
		System.out.println(pick1);
		System.out.println(testarr2.get(0));
	}

}
