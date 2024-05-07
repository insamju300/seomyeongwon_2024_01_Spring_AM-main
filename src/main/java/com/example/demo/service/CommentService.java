package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.CommentRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;

@Service
public class CommentService {

//	@Autowired
//	private ArticleRepository articleRepository;
	@Autowired
	private CommentRepository commentRepository;

	
//	public ResultData<Integer> writeArticle(int memberId, String title, String body) {
//		articleRepository.writeArticle(memberId, title, body);
//
//		int id = articleRepository.getLastInsertId();
//
//		return ResultData.from("S-1", Ut.f("%d번 글이 생성되었습니다", id), "id", id);
//	}


	public ResultData<Integer> writeComent(Comment comment) {
		commentRepository.insertComment(comment);
		return ResultData.from("S-1", Ut.f("%d번 댓글이 생성되었습니다", comment.getId()), "id", comment.getId());
	}


	public List<Comment> getRecentCommentsWithoutParentId(int articleId, int limit, Integer currentCommentId, Integer originalParentId, int memberId) {
		// TODO Auto-generated method stub
		List<Comment> result = commentRepository.getCommentList(articleId, limit, currentCommentId, originalParentId);
		
		result.forEach(comment->{
			if(memberId!=0 && memberId==comment.getMemberId()) {
				comment.setAccessible(true);
			}
		});
		return result; 
	}


	public int doModify(int id, String body) {
		// TODO Auto-generated method stub
		return commentRepository.updateComment(id,  body);
	}


	public Comment findCommentById(int id) {
		// TODO Auto-generated method stub
		return commentRepository.getCommentById(id);
	}


	public boolean hasMoreComment(int articleId, int limit, Integer currentCommentId, Integer originalParentId) {
		// TODO Auto-generated method stub
		return commentRepository.hasMoreComment(articleId, limit, currentCommentId, originalParentId);
	}


	public int doDelete(int id) {
		// TODO Auto-generated method stub
		return commentRepository.deleteComment(id);
	}






//	public CommentService(ArticleRepository articleRepository) {
//		this.articleRepository = articleRepository;
//	}
//
//	// 서비스 메서드
//	public Article getForPrintArticle(int loginedMemberId, int id) {
//		Article article = articleRepository.getForPrintArticle(loginedMemberId, id);
//
//		controlForPrintData(loginedMemberId, article);
//
//		return article;
//	}
//
//	private void controlForPrintData(int loginedMemberId, Article article) {
//		if (article == null) {
//			return;
//		}
//		ResultData userCanModifyRd = userCanModify(loginedMemberId, article);
//		article.setUserCanModify(userCanModifyRd.isSuccess());
//
//		ResultData userCanDeleteRd = userCanDelete(loginedMemberId, article);
//		article.setUserCanDelete(userCanDeleteRd.isSuccess());
//	}
//
//	public ResultData userCanDelete(int loginedMemberId, Article article) {
//
//		if (article.getMemberId() != loginedMemberId) {
//			return ResultData.from("F-2", Ut.f("%d번 글에 대한 삭제 권한이 없습니다", article.getId()));
//		}
//
//		return ResultData.from("S-1", Ut.f("%d번 글이 삭제 되었습니다", article.getId()));
//	}
//
//	public ResultData userCanModify(int loginedMemberId, Article article) {
//
//		if (article.getMemberId() != loginedMemberId) {
//			return ResultData.from("F-2", Ut.f("%d번 글에 대한 수정 권한이 없습니다", article.getId()));
//		}
//
//		return ResultData.from("S-1", Ut.f("%d번 글을 수정했습니다", article.getId()));
//	}
//
//
//
//	public void deleteArticle(int id) {
//		articleRepository.deleteArticle(id);
//	}
//
//	public void modifyArticle(int id, String title, String body) {
//		articleRepository.modifyArticle(id, title, body);
//	}
//
//	public Article getArticle(int id) {
//		return articleRepository.getArticle(id);
//	}
//
//	public List<Article> getArticles() {
//		return articleRepository.getArticles();
//	}
//
//	public int getArticlesCount(int boardId, String searchKeywordTypeCode, String searchKeyword) {
//		return articleRepository.getArticlesCount(boardId, searchKeywordTypeCode, searchKeyword);
//	}
////
////	public List<Article> getForPrintArticles(int boardId) {
////		return articleRepository.getForPrintArticles(boardId);
////	}
//
//	public ResultData increaseHitCount(int id) {
//		int affectedRow = articleRepository.increaseHitCount(id);
//
//		if (affectedRow == 0) {
//			return ResultData.from("F-1", "해당 게시물 없음", "id", id);
//		}
//
//		return ResultData.from("S-1", "해당 게시물 조회수 증가", "id", id);
//
//	}
//
//	public Object getArticleHitCount(int id) {
//		return articleRepository.getArticleHitCount(id);
//	}
//
//	public List<Article> getForPrintArticles(int boardId, int itemsInAPage, int page, String searchKeywordTypeCode,
//			String searchKeyword) {
//
////		SELECT * FROM article WHERE boardId = 1 ORDER BY id DESC LIMIT 0, 10; 1page
////		SELECT * FROM article WHERE boardId = 1 ORDER BY id DESC LIMIT 10, 10; 2page
//
//		int limitFrom = (page - 1) * itemsInAPage;
//		int limitTake = itemsInAPage;
//
//		return articleRepository.getForPrintArticles(boardId, limitFrom, limitTake, searchKeywordTypeCode,
//				searchKeyword);
//	}

}