package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.CommentService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@RestController
public class UsrCommentController {
	
	@Autowired
	CommentService commentService;
	final int limit = 10;
	
	@PostMapping("/usr/comment/doWrite")
	@ResponseBody
	public ResultData<Comment> doWrite(HttpServletRequest req, String body, int articleId, @RequestParam(required = false) Integer parentId, @RequestParam(required = false)Integer originalParentId) {
		
//	    @Insert("INSERT INTO Comments (memberId, body, regDate, updateDate, articleId, parentId, originalParentId) " +
//	            "VALUES (#{memberId}, #{body}, NOW(), NOW(), #{articleId}, #{parentId}, #{originalParentId})")
//	    void insertComment(Comment comment);

		Rq rq = (Rq) req.getAttribute("rq");

//		if (Ut.isNullOrEmpty(body)) {
//			return Ut.jsHistoryBack("F-1", "내용을 입력해 주세요.");
//		}
		
		System.err.println(articleId+ " : " +  parentId + " : " + originalParentId);
		
		int memberId = rq.getLoginedMemberId();
		
		Comment comment = new Comment(memberId, body, articleId, parentId, originalParentId);

		ResultData<Integer> writeCommentRd = commentService.writeComent(comment);
		


		int id = (int) writeCommentRd.getData1();

		//todo 1. 없는 article id일 경우 튕겨내기.
		//todo 2. jsreplace가 아니라 현재 작성한 게시글 돌려주기 or 그냥 ok사인만 돌려주고 프론트에서 list 재요청 받기
		
		Comment createdComment = commentService.findCommentById(id);
		createdComment.setAccessible(true);
		
		return ResultData.from("S-1", String.format("%s번 게시물이이 생성되었습니다.", id), "comment", createdComment);
		

	}
	
	
	@RequestMapping("/usr/comment/list")
	public ResultData<List<Comment>> showList(HttpServletRequest req,
			int articleId,
			@RequestParam(required = false) Integer  currentCommentId,
			@RequestParam(required = false) Integer  originalParentId) {
		Rq rq = (Rq) req.getAttribute("rq");
		int memberId = rq.getLoginedMemberId();
		System.err.println("여기까진 잘 왔음" + articleId + "," + Ut.isEmpty(currentCommentId));
		//일단은 limit 10개만 받아서 그대로 return 하기
		
		List<Comment> comments =  commentService.getRecentCommentsWithoutParentId(articleId, limit, currentCommentId, originalParentId, memberId);
		boolean hasMoreComment =  commentService.hasMoreComment(articleId, limit, currentCommentId, originalParentId);
		
		return ResultData.from("S-1", "ok", "comments", comments, "hasMoreComment", hasMoreComment);
	}
	

	
	@RequestMapping("/usr/comment/doModify")
	public ResultData<Comment> doModify(HttpServletRequest req,int id, String body) {
		System.err.print("왜 안되냐 이거.");
		
		Rq rq = (Rq) req.getAttribute("rq");
		
		// 에러 체크. 해당 게시글이 있는지, 수정권한이 있는지.
		
		//일단 수정하고 돌려주기. 에러처리는 나중에
		int effactedRows = commentService.doModify(id, body);
		
		//갱신후 새 커멘트 받아와서 돌려주기
		Comment comment = commentService.findCommentById(id);	
		return ResultData.from("S-1", String.format("%s번 게시글이 수정되었습니다.", id), "comment", comment);
	}
	
	@RequestMapping("/usr/comment/doDelete")
	public ResultData<Integer> doDelete(HttpServletRequest req,int id) {
		
		Rq rq = (Rq) req.getAttribute("rq");
		
		// 에러 체크. 해당 게시글이 있는지, 삭제권한이 있는지, 자식 댓글이 있는지. 자식 댓글이 있으면 어케처리?
		
		//일단 삭제하고 돌려주기. 에러처리는 나중에
		int effactedRows = commentService.doDelete(id);
		
		//갱신후 새 커멘트 받아와서 돌려주기
		Comment comment = commentService.findCommentById(id);	
		return ResultData.from("S-1", String.format("%s번 게시글이 삭제 되었습니다.", id), "id", id);
	}

}
