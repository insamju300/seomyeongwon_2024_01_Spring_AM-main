package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.PreferenceService;
import com.example.demo.vo.Preference;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@RestController
public class UserPreferenceController {
	@Autowired
	private PreferenceService preferenceService;
	
	@RequestMapping("/usr/preferance/toggleLikeOnly")
	public Preference toggleLikeOnly(HttpServletRequest req, int id) {
		Rq rq = (Rq) req.getAttribute("rq");
		boolean isLikes = preferenceService.isLikes(rq.getLoginedMemberId(), id);
		
		if(isLikes) {
			preferenceService.deleteLikes(rq.getLoginedMemberId(), id);
			isLikes = false;
		}else{
			preferenceService.insertLikes(rq.getLoginedMemberId(), id);
			isLikes = true;
		}
		
		int likesCount = preferenceService.getLikesCount(id);
		
		Preference preference = new Preference(isLikes, likesCount);
		
		return preference;
	}
	
	@RequestMapping("/usr/preferance/toggleLike")
	public Preference toggleLike(HttpServletRequest req, int id) {
		Rq rq = (Rq) req.getAttribute("rq");
		boolean isLikes = preferenceService.isLikes(rq.getLoginedMemberId(), id);
		boolean isHates = preferenceService.isHates(rq.getLoginedMemberId(), id);
		
		//이미 좋아해요가 눌러져있다면, 좋아해요 삭제
		if(isLikes) {
			preferenceService.deleteLikes(rq.getLoginedMemberId(), id);
			isLikes = false;
		}else{
			//좋아해요가 눌려있지 않다면, 만약 싫어요 상태라면 싫어요 삭제. 좋아요 추가.
			if(isHates) {
				preferenceService.deleteHates(rq.getLoginedMemberId(), id);
			}
			preferenceService.insertLikes(rq.getLoginedMemberId(), id);
			isLikes = true;
			isHates = false;
			
		}
		
		int likesCount = preferenceService.getLikesCount(id);
		
		Preference preference = new Preference(isLikes, isHates, likesCount);
		
		return preference;
	}
	
	@RequestMapping("/usr/preferance/toggleHate")
	public Preference toggleHate(HttpServletRequest req, int id) {
		Rq rq = (Rq) req.getAttribute("rq");
		boolean isLikes = preferenceService.isLikes(rq.getLoginedMemberId(), id);
		boolean isHates = preferenceService.isHates(rq.getLoginedMemberId(), id);
		
		//이미 싫어요 눌러져있다면, 싫어요 삭제 
		if(isHates) {
			preferenceService.deleteHates(rq.getLoginedMemberId(), id);
			isHates = false;
		}else{
			//싫어요가 눌려있지 않다면, 만약 좋아요 상태라면 좋아요 삭제. 싫어요 추가. 
			if(isLikes) {
				preferenceService.deleteLikes(rq.getLoginedMemberId(), id);
			}
			preferenceService.insertHates(rq.getLoginedMemberId(), id);
			isHates = true;
			isLikes = false;
		}
		
		int likesCount = preferenceService.getLikesCount(id);
		
		Preference preference = new Preference(isLikes, isHates, likesCount);
		
		return preference;
	}
}
