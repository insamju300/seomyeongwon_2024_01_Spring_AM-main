<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="ARTICLE DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- <iframe src="http://localhost:8081/usr/article/doIncreaseHitCountRd?id=372" frameborder="0"></iframe> -->

<!-- todo 
댓글기능 로그인 체크
댓글기능 수정, 삭제 만들기
댓글기능 좋아요 만들기
삭제를 개념삭제로 이해하기.
-->

<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<div class="flex">
			<table class="table-box-1" border="1">
				<tbody>
					<tr>
						<th>번호</th>
						<td>${article.id }</td>
					</tr>
					<tr>
						<th>작성날짜</th>
						<td>${article.regDate }</td>
					</tr>
					<tr>
						<th>수정날짜</th>
						<td>${article.updateDate }</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>${article.extra__writer }</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${article.title }</td>
					</tr>


					<tr>
						<th>테스트</th>
						<td>
							<button onclick="test()">테스트</button>
						</td>
					</tr>


					<tr>
						<th>좋아요</th>
						<td>
							<button onclick="toggleLike()" class="like ${article.likes? 'text-red-600' : 'text-gray-400' }">
								<i class="fa-solid fa-heart"></i>
							</button>
							<p class="likesCount">${article.likesCount }</p>
						</td>
					</tr>
					<tr>
						<th>싫어요</th>
						<td>
							<button onclick="toggleHate()" class="hate ${article.hates? 'text-purple-700' : 'text-gray-400' }">
								<i class="fa-solid fa-hand-middle-finger"></i>
							</button>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>${article.body }</td>
					</tr>
					<tr>
						<th>조회수</th>
						<td><span class="article-detail__hit-count">${article.hitCount }</span></td>
					</tr>
				</tbody>
			</table>

			<table class="table-box-1" border="1">
				<tbody>
					<tr>
						<th>번호</th>
						<td>${article.id }</td>
					</tr>
					<tr>
						<th>작성날짜</th>
						<td>${article.regDate }</td>
					</tr>
					<tr>
						<th>수정날짜</th>
						<td>${article.updateDate }</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>${article.extra__writer }</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${article.title }</td>
					</tr>

					<tr>
						<th>좋아요</th>
						<td>
							<button onclick="toggleLikeOnly()" class="like ${article.likes? 'text-red-600' : 'text-gray-400' }">
								<i class="fa-solid fa-heart"></i>
							</button>
							<p class="likesCount">${article.likesCount }</p>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>${article.body }</td>
					</tr>
					<tr>
						<th>조회수</th>
						<td><span class="article-detail__hit-count">${article.hitCount }</span></td>
					</tr>
				</tbody>
			</table>

		</div>
		<div class="btns mt-5">
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
			<c:if test="${article.userCanModify }">
				<a class="btn btn-outline" href="../article/modify?id=${article.id }">수정</a>
			</c:if>
			<c:if test="${article.userCanDelete }">
				<a class="btn btn-outline" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;"
					href="../article/doDelete?id=${article.id }">삭제</a>
			</c:if>
		</div>
	</div>
</section>

<section>
	<c:if test="${rq.isLogined() }">
		<form class="doWriteForm";>
			<input type="hidden" name="articleId" value="${article.id }">
			<div class="bg-white p-4 rounded shadow">
				<div class="flex flex-col">

					<h3 class="font-semibold">${rq.loginedMemberNicname }</h3>
					<input type="text" name="body"
						class="mt-1 w-96 border-b-2 border-gray-300 border-solid focus:outline-none focus:border-black" />
					<div></div>
					<button type="button" onclick="doCommentWrite(this)" class="w-20 mt-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">댓글 달기</button>

				</div>
			</div>
		</form>
	</c:if>
	<div id="commentsGroup"></div>
</section>


<script>



const params = {};
params.id = parseInt('${param.id}');
let localStorageName = 'isAlreadyHit' + params.id;
let isAlradyToggle = [];

function ArticleDetail__doIncreaseHitCount() {
	$.get('../article/doIncreaseHitCountRd', {
		id : params.id,
		ajaxMode : 'Y'
	}, function(data) {
		$('.article-detail__hit-count').empty().html(data.data1);
	}, 'json');

	localStorage.setItem(localStorageName, true);
}

$(function() {
	console.log('isAlreadyHit' + params.id);
	if (!localStorage.getItem(localStorageName)) {
		ArticleDetail__doIncreaseHitCount();
		// 		setTimeout(ArticleDetail__doIncreaseHitCount, 2000);
	}
})

function loginCheck() {
	var loginCheck = "${rq.isLogined() }";
	if (loginCheck == "false") {
		alert("로그인 후 이용할 수 있습니다.");
		return false;
	}
	return true;
}

//게시글 싫어요 눌렀을 때 처리(싫어요 없는 쪽. 좋아요 단독 버튼)
function toggleLikeOnly(){
	if (!loginCheck()) {
		return;
	}
	
	$.get('../preferance/toggleLikeOnly', {
		id : params.id
	}, function(data) {
		console.log(data);
		if (data.likes) {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-red-600'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-gray-400'));
		} else {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-gray-400'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-red-600'));
		}
		$('.likesCount').empty().html(data.likesCount);

	}, 'json');
}

//게시글 좋아요 눌렀을 때 처리
function toggleLike() {
	if (!loginCheck()) {
		return;
	}

	$.get('../preferance/toggleLike', {
		id : params.id
	}, function(data) {
		console.log(data);
		if (data.likes) {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-red-600'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-gray-400'));
		} else {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-gray-400'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-red-600'));
		}
		if (data.hates) {
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.add('text-purple-700'));
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.remove('text-gray-400'));
		} else {
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.add('text-gray-400'));
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.remove('text-purple-700'));
		}
		$('.likesCount').empty().html(data.likesCount);

	}, 'json');

}

//게시글 싫어요 눌렀을 때 처리
function toggleHate() {
	if (!loginCheck()) {
		return;
	}
	loginCheck();
	$.get('../preferance/toggleHate', {
		id : params.id
	}, function(data) {
		console.log(data);
		if (data.likes) {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-red-600'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-gray-400'));
		} else {
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.add('text-gray-400'));
			Array.from(document.getElementsByClassName("like")).forEach((element) =>element.classList.remove('text-red-600'));
		}
		if (data.hates) {
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.add('text-purple-700'));
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.remove('text-gray-400'));
		} else {
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.add('text-gray-400'));
			Array.from(document.getElementsByClassName("hate")).forEach((element) =>element.classList.remove('text-purple-700'));
		}
		$('.likesCount').empty().html(data.likesCount);
	}, 'json');

}



//게시글 목록 가져오기 아작스 통신
function loadMoreComment(articleId, currentCommentId) {
	$.get('../comment/list', {
		articleId : articleId,
		currentCommentId : currentCommentId
	}, function(data) {
		$.each(data.data1, function(index, comment) {
			appendComment(comment, false);
		});

	
	}, 'json');
}

//답글 목록 가져오기 아작스 통신
function loadMoreDescendantComment(articleId, currentCommentId, originalParentId, e, descendantCommentCount) {
	$.get('../comment/list', {
		articleId : articleId,
		currentCommentId : currentCommentId,
		originalParentId: originalParentId
	}, function(data) {
		$.each(data.data1, function(index, comment) {
			appendDescendantComment(comment,e, false);
		});
		
		console.log(data.data2);
		if(data.data2==true){
		    const tmp = document.createElement("button");
		    tmp.setAttribute("data-descendant-comment-count", descendantCommentCount);
		    
		    //마지막 자식의 id 가져오기.
		    let lastChild = $(e).siblings(".descendantComments").find(".descendantComment:last-child");
		    let lastChildId = lastChild.attr('data-id');
		    
		    tmp.setAttribute("onclick", `loadMoreDescendantCommentAndRemoveThisButton(${"${articleId}"},${"${lastChildId}"}, ${"${originalParentId}"}, this, ${"${descendantCommentCount}"})`);

			tmp.innerHTML="댓글 더보기";
			$(e).siblings(".descendantComments").append(tmp);
		}
		

	
	}, 'json');
}

//답글 목록 안쪽의 더보기 버튼 처리
function loadMoreDescendantCommentAndRemoveThisButton(articleId, currentCommentId, originalParentId, e, descendantCommentCount){
	loadMoreDescendantComment(articleId, currentCommentId, originalParentId, $(e).parent().parent().find(".descendantCommentsButton"), descendantCommentCount);
	$(e).remove();
	
}

//댓글 화면 그리기
function appendComment(comment, isPre){
	   const tmp = document.createElement("div");
	   
	    tmp.setAttribute("class", "chat chat-start");
	    tmp.setAttribute("data-id", comment.id);
	    let tmpInnerHTML = `
	        <div class= "flex flex-col originCommentParentCotainner">
            <div class="chat-header">
	            ${"${comment.extra__writer}"}
	            <time class="text-xs opacity-50"> ${"${comment.regDate}"}</time>
	        </div>
	        <div class="chat-bubble ml-5 chat-bubble-view">
	                <p class="bubble-content">${"${comment.body}"}</p>
	        
	        </div>
	        `;
	      
         
         if("${rq.isLogined()}"=="true"){
        	 //벨류 보여줄때마다 수정으로 설정해줘야할듯...
        	 if(comment.accessible){
        		 
        		 tmpInnerHTML += `
        		 <div class="chat-bubble-form hidden">
        		     <form name="commentModifyForm">
        		         <input type="hidden" value=${"${comment.id}"} name="id">
        		         <div class="flex">
			        		 <div class="chat-bubble ml-5">
			        		 	<input type="text" name="body" value="${'${comment.body}'}" class="input input-bordered input-sm w-full max-w-xs text-gray-900"/>
			        		  </div>
			        		 <button type="button" onclick="doCommentModify(this);" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">전송하기</button>
		        		 </div>
	        		 </form>
        		 </div>
        		 <div class="flex">
        		   <button onclick='toggleChatBubble(this)' class="showModifyButton w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">수정</button>
        		   <button onclick='doCommentDelete(this, ${"${comment.id}"})' class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">삭제</button>
        		 </div>
        		 `;
        	 }
        	 
		     tmpInnerHTML += `
		        <button class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200" onclick="showNextDoWriteForm(this)"> 답글달기 </button>
		        <div class="hidden doWriteFormContainer">
					<form class="doWriteForm">
						<input type="hidden" name="articleId" value="${article.id }">
						<input type="hidden" name="originalParentId" value=${"${comment.id}" }>
						<input type="hidden" name="parentId" value=${"${comment.id}" }>
							<div class="bg-white p-4 rounded shadow">
								<div class="flex flex-col">
				
									<h3 class="font-semibold">${rq.loginedMemberNicname }</h3>
									<input type="text" name="body"
										class="mt-1 w-96 border-b-2 border-gray-300 border-solid focus:outline-none focus:border-black" />
									<div class="flex">
									    <button type="button" onclick="hiddenDoWriteForm(this)" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">취소</button>
									    <button type="button" onclick="doCommentWriteForDescendantLv1(this)" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">댓글 달기</button>
									</div>
				
									</div>
							</div>
					</form>
				</div>`
         }
       if(comment.descendantCommentCount!=0){
	        tmpInnerHTML += `<button
	        class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200 descendantCommentsButton"
	        onclick="toggleDescendantComment(${article.id}, null,${'${comment.id }'},this,${'${comment.descendantCommentCount }'})"> ▼답글 ${"${comment.descendantCommentCount}"}개</button>`;
	    }
		tmpInnerHTML += `
		<div class="appendedDescendantComments  pl-10">
	    </div>
		
		<div class="descendantComments pl-10 hidden">
	    </div>
	    </div>
	    `;
	    
	    tmp.innerHTML=tmpInnerHTML;

	    if(!isPre){
	        document.querySelector("#commentsGroup").append(tmp);
	    }else{
	    	document.querySelector("#commentsGroup").prepend(tmp);
	    }
	
}

//답글 화면 그리기
function appendDescendantComment(comment,e, isPre){
	   const tmp = document.createElement("div");
	    tmp.setAttribute("class", "chat chat-start descendantComment");
	    tmp.setAttribute("data-id", comment.id);
	    let tmpInnerHTML = `
	        <div class= "flex flex-col">
           <div class="chat-header">
	            ${"${comment.extra__writer}"}
	            <time class="text-xs opacity-50"> ${"${comment.regDate}"}</time>
		        </div>
		        <div class="chat-bubble ml-5 chat-bubble-view">`;
	     if(comment.parentId!=comment.originalParentId){
	    	 tmpInnerHTML += `<p class="text-blue-500"> @${"${comment.extra__parentWriter}"} </p>`;   
		         
		 }
	     
	     tmpInnerHTML += `<p class="bubble-content">${"${comment.body}"}</p></div> `;
         if("${rq.isLogined()}"=="true"){   
        	 
        	 if(comment.accessible){
        		 
        		 tmpInnerHTML += `
        		 <div class="chat-bubble-form hidden">
        		     <form name="commentModifyForm">
        		         <input type="hidden" value=${"${comment.id}"} name="id">

        	                 <div class="flex">
			        		     <div class="chat-bubble ml-5">`
            	if(comment.parentId!=comment.originalParentId){
           		      tmpInnerHTML += `<p class="text-blue-500"> @${"${comment.extra__parentWriter}"} </p>`;   
           			         
           		}
           		   tmpInnerHTML += `<input type="text" name="body" value="${'${comment.body}'}" class="input input-bordered input-sm w-full max-w-xs text-gray-900"/>
			        		  </div>
			        		 <button type="button" onclick="doCommentModify(this);" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">전송하기</button>
		        		 </div>
	        		 </form>
        		 </div>
        		 <div class="flex">
      		       <button onclick='toggleChatBubble(this)' class="showModifyButton w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">수정</button>
      		       <button onclick='doCommentDelete(this, ${"${comment.id}"})' class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">삭제</button>
      		     </div>
        		 `;
        	 }
        	 
		     tmpInnerHTML += `
		    	<button class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200" onclick="showNextDoWriteForm(this)"> 답글달기 </button>
		        <div class="hidden doWriteFormContainer">
					<form class="doWriteForm">
						<input type="hidden" name="articleId" value="${article.id }">
						<input type="hidden" name="originalParentId" value=${"${comment.originalParentId}" }>
						<input type="hidden" name="parentId" value=${"${comment.id}" }>
							<div class="bg-white p-4 rounded shadow">
								<div class="flex flex-col">
				
									<h3 class="font-semibold">${rq.loginedMemberNicname }</h3>
									<input type="text" name="body"
										class="mt-1 w-96 border-b-2 border-gray-300 border-solid focus:outline-none focus:border-black" />
									<div class="flex">
									    <button type="button" onclick="hiddenDoWriteForm(this)" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">취소</button>
									    <button type="button" onclick="doCommentWriteForDescendantLv2(this)" class="w-20 m-1 hover:shadow hover:bg-gray-600 hover:text-gray-200">댓글 달기</button>
									</div>
				
									</div>
							</div>
					</form>
				</div>
				</div>
		    `;
         }

	    
	    tmp.innerHTML=tmpInnerHTML;
	    
	    if(!isPre){
	    	$(e).siblings(".descendantComments").append(tmp);
	    }else{
	    	$(e).siblings(".appendedDescendantComments").prepend(tmp);
	    }
	    
	    
	    
}




function toggleDescendantComment(articleId, currentCommentId, originalParentId, e, descendantCommentCount){
    console.log(isAlradyToggle);
    console.log(isAlradyToggle.includes(originalParentId));
	if(!isAlradyToggle.includes(originalParentId)){
	    loadMoreDescendantComment(articleId, currentCommentId, originalParentId, e, descendantCommentCount);
	    isFirstToggle = false;
	    isAlradyToggle.push(originalParentId);
	}
	
	$(e).siblings(".descendantComments").toggle();
}





function doCommentWrite(e){
	let articleId = $(e).parents(".doWriteForm").find("input[name=articleId]").val();
	let body = $(e).parents(".doWriteForm").find("input[name=body]").val();
	
	$.post('../comment/doWrite', {
		articleId : articleId,
		body : body
	}, function(data) {
		if(data.success==true){
			appendComment(data.data1, true);
			alert(data.msg);
			$(e).parents(".doWriteForm").find("input[name=body]").val("");
		}else{
			alert(data.msg);
		}
	}, 'json');
}

function doCommentWriteForDescendantLv1(e){
	let articleId = $(e).parents(".doWriteForm").find("input[name=articleId]").val();
	let body = $(e).parents(".doWriteForm").find("input[name=body]").val();
	let originalParentId = $(e).parents(".doWriteForm").find("input[name=originalParentId]").val();
	let parentId = $(e).parents(".doWriteForm").find("input[name=parentId]").val();
	doCommentWriteForDescendant(e, articleId, body, originalParentId, parentId);
	
	$(e).parents(".doWriteForm").find("input[name=body]").val("");
}

function doCommentWriteForDescendantLv2(e){
	let articleId = $(e).parents(".doWriteForm").find("input[name=articleId]").val();
	let body = $(e).parents(".doWriteForm").find("input[name=body]").val();
	let originalParentId = $(e).parents(".doWriteForm").find("input[name=originalParentId]").val();
	let parentId = $(e).parents(".doWriteForm").find("input[name=parentId]").val();
	console.log($(e).parents(".chat").first().parent().attr("class"));
	doCommentWriteForDescendant($(e).parents(".chat").first().parent().siblings(".doWriteFormContainer").find("button").first(), articleId, body, originalParentId, parentId);
	
	$(e).parents(".doWriteForm").find("input[name=body]").val("");
}

function doCommentWriteForDescendant(e,articleId, body, originalParentId, parentId){

	
	$.post('../comment/doWrite', {
		articleId : articleId,
		body : body,
		originalParentId : originalParentId,
		parentId : parentId
	}, function(data) {
		if(data.success==true){
			appendDescendantComment(data.data1, $(e).parents(".doWriteFormContainer").first(), true);
			alert(data.msg);
			//$(e).parents(".doWriteForm").find("input[name=body]").val("");
		}else{
			alert(data.msg);
		}
	}, 'json');
}

//답글의 답글 작성 로직


function doCommentModify(e){
	let id = $(e).parents(".chat-bubble-form").find("input[name=id]").val();
	let body = $(e).parents(".chat-bubble-form").find("input[name=body]").val();
	
	$.post('../comment/doModify', {
		id : id,
		body : body
	}, function(data) {
		if(data.success==true){
		    $(e).parents(".chat-bubble-form").siblings(".chat-bubble-view").find(".bubble-content").text(data.data1.body);
		    $(e).parents(".chat-bubble-form").siblings(".chat-bubble-view").show();
		    $(e).parents(".chat").find(".showModifyButton").text("수정");
		    $(e).parents(".chat-bubble-form").hide();
		}else{
			alert(data.msg);
		}
	}, 'json');
}

function doCommentDelete(e, id){
	
	$.post('../comment/doDelete', {
		id : id
	}, function(data) {
		if(data.success==true){
			$(e).parents(".chat")[0].remove();
		}else{
			alert(data.msg);
		}
	}, 'json');
	
}




//수정버튼 눌렀을 때 처리.
function toggleChatBubble(e){
	$(e).parent().siblings(".chat-bubble-view").toggle();
	$(e).parent().siblings(".chat-bubble-form").toggle();
	$(e).parent().siblings(".chat-bubble-form").find("input[name=body]").val($(e).parent().siblings(".chat-bubble-view").find(".bubble-content").text());
	if($(e).text()=="수정"){
	    $(e).text("취소");
	}else{
		$(e).text("수정");
	}
}


function showNextDoWriteForm(e){

   $(e).siblings(".doWriteFormContainer").show();

}

function hiddenDoWriteForm(e){

	   $(e).closest('.doWriteFormContainer').hide();

	}


loadMoreComment("${article.id }", null);

//스크롤 이벤트 처리
// Event listener for the scroll event
window.addEventListener('scroll', () => {
  if (isScrollAtBottom()) {
		const lastComment = $("#commentsGroup>div:last-child");
				if(lastComment!=null){
					let id = lastComment.attr('data-id');
					loadMoreComment("${article.id }", id);
				}
		}

});

function isScrollAtBottom() {
	  const totalPageHeight = document.body.scrollHeight;
	  const scrollPoint = window.scrollY + window.innerHeight;
	  return scrollPoint >= totalPageHeight;
}
</script>

<%@ include file="../common/foot.jspf"%>