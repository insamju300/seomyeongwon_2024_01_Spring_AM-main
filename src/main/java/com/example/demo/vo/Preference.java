package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
public class Preference {
    private boolean likes;
    private boolean hates;
    private int likesCount;
	public Preference(boolean likes, boolean hates, int likesCount) {
		super();
		this.likes = likes;
		this.hates = hates;
		this.likesCount = likesCount;
	}
	public Preference(boolean likes, int likesCount) {
		this.likes = likes;
		this.likesCount = likesCount;
	}
  
}
