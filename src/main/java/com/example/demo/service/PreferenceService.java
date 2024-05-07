package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.PreferenceRepository;

@Service
public class PreferenceService {
	@Autowired
	private PreferenceRepository preferenceRepository;

	public boolean isLikes(int loginedMemberId, int articleId) {
		// TODO Auto-generated method stub
		return preferenceRepository.isLikes(loginedMemberId, articleId);
	}
	
	public boolean isHates(int loginedMemberId, int articleId) {
		// TODO Auto-generated method stub
		return preferenceRepository.isHates(loginedMemberId, articleId);
	}

	public void deleteLikes(int loginedMemberId, int articleId) {
		preferenceRepository.deleteLikes(loginedMemberId, articleId);
		
	}

	public void deleteHates(int loginedMemberId, int articleId) {
		preferenceRepository.deleteHates(loginedMemberId, articleId);
		
	}

	public void insertLikes(int loginedMemberId, int articleId) {
		preferenceRepository.insertLikes(loginedMemberId, articleId);
		
	}
	
	public void insertHates(int loginedMemberId, int articleId) {
		preferenceRepository.insertHates(loginedMemberId, articleId);
	}

	public int getLikesCount(int articleId) {
		// TODO Auto-generated method stub
		return preferenceRepository.getLikesCount(articleId);
	}
}
