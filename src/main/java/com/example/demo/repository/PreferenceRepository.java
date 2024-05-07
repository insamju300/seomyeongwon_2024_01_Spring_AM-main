package com.example.demo.repository;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface PreferenceRepository {
	
	@Select("""
            SELECT IF(COUNT(1)>0, 1, 0) FROM LIKES WHERE articleId = #{articleId} AND memberId=#{memberId};
			""")
	public boolean isLikes(int memberId, int articleId);
	@Select("""
            SELECT IF(COUNT(1)>0, 1, 0) FROM HATES WHERE articleId = #{articleId} AND memberId=#{memberId};
			""")	
	public boolean isHates(int memberId, int articleId);
	@Insert("""
            INSERT INTO LIKES SET articleId = #{articleId}, memberId=#{memberId};
			""")
	public void insertLikes(int memberId, int articleId);
	@Insert("""
            DELETE FROM LIKES WHERE articleId = #{articleId} AND memberId=#{memberId};
			""")
	public void deleteLikes(int memberId, int articleId);
	@Insert("""
            INSERT INTO HATES SET articleId = #{articleId}, memberId=#{memberId};
			""")
	public void insertHates(int memberId, int articleId);
	@Insert("""
            DELETE FROM HATES WHERE articleId = #{articleId} AND memberId=#{memberId};
			""")
	public void deleteHates(int memberId, int articleId);
	
	@Select("""
			SELECT COUNT(id) FROM LIKES WHERE articleId = #{articleId}
			""")
	public int getLikesCount(int articleId);

}
