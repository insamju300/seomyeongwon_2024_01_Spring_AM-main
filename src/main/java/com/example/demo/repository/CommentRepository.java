package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Comment;

@Mapper
public interface CommentRepository {

	// Create
	@Insert("INSERT INTO Comment (memberId, body, regDate, updateDate, articleId, parentId, originalParentId) "
			+ "VALUES (#{memberId}, #{body}, NOW(), NOW(), #{articleId}, #{parentId}, #{originalParentId})")
	@Options(useGeneratedKeys = true, keyProperty = "id")
	public int insertComment(Comment comment);

	// Read
	@Select("""
		   	   SELECT Comment.*, member.nickname AS extra__writer
 		       ,parentMember.id AS extra__parentMemberId
               ,parentMember.nickname AS extra__parentWriter
		       FROM Comment
	       	   INNER JOIN member
		       ON Comment.memberId = member.id
			   LEFT JOIN Comment as parentComment
			   ON Comment.parentId=parentComment.id
			   LEFT JOIN member as parentMember
			   ON parentComment.memberId = parentMember.id
		       WHERE Comment.id = #{id}
			""")
	public Comment getCommentById(int id);

	// Delete
	@Delete("DELETE FROM Comment WHERE id = #{id}")
	public int deleteComment(int id);

	@Select("""
					<script>
					   	   SELECT Comment.*, member.nickname AS extra__writer
					       <choose>
			 		       <when test="originalParentId == null">
			 		          ,Count(descendant.id) as descendantCommentCount
					          </when>
					          <otherwise>
			 		          ,parentMember.id AS extra__parentMemberId
			                   ,parentMember.nickname AS extra__parentWriter
			                  </otherwise>
			              </choose>

					       FROM Comment
			     	   INNER JOIN member
			      ON Comment.memberId = member.id
					       <choose>
			 		       <when test="originalParentId == null">
				       LEFT JOIN Comment as descendant
				       ON Comment.id = descendant.originalParentId
			          </when>
			          <otherwise>
				       INNER JOIN Comment as parentComment
				       ON Comment.parentId=parentComment.id
			       	   INNER JOIN member as parentMember
				       ON parentComment.memberId = parentMember.id
				   </otherwise>
			      </choose>
					       WHERE Comment.articleId = #{articleId}
					       <choose>
			 		       <when test="originalParentId == null">
			 		             AND Comment.originalParentId IS NULL
			 		       </when>
			 		       <otherwise>
			 		             AND Comment.originalParentId = #{originalParentId}
			 		       </otherwise>
					       </choose>
					       <if test="currentCommentId != null">
					             AND Comment.id &lt; #{currentCommentId}
					       </if>
					       GROUP BY Comment.id
					       ORDER BY Comment.id DESC LIMIT #{limit}
					</script>
			""")
	public List<Comment> getCommentList(int articleId, int limit, Integer currentCommentId, Integer originalParentId);

	@Update("UPDATE Comment SET body = #{body}, " + "updateDate = NOW() " + "WHERE id = #{id}")
	public int updateComment(int id, String body);

	@Select("""
					<script>
					   	   SELECT IF(IFNULL(COUNT(id),0) &gt; #{limit}, 1, 0) as hasMoreComment
					       FROM Comment
					       WHERE Comment.articleId = #{articleId}
					       <choose>
			 		       <when test="originalParentId == null">
			 		             AND Comment.originalParentId IS NULL
			 		       </when>
			 		       <otherwise>
			 		             AND Comment.originalParentId = #{originalParentId}
			 		       </otherwise>
					       </choose>
					       <if test="currentCommentId != null">
					             AND Comment.id &lt; #{currentCommentId}
					       </if>
					</script>
			""")
	public boolean hasMoreComment(int articleId, int limit, Integer currentCommentId, Integer originalParentId);

}