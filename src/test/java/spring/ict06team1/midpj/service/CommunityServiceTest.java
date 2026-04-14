package spring.ict06team1.midpj.service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import spring.ict06team1.midpj.dao.CommunityDAO;
import spring.ict06team1.midpj.dto.CommunityDTO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:test-context.xml"})
public class CommunityServiceTest {

    @Autowired
    private CommunityDAO dao;

    @Test
    public void testFreeBoardCount() {
        // Given
        String category = "맛집수다";
        
        // When
        int count = dao.freeBoardCount(category);
        
        // Then
        System.out.println("맛집수다 카테고리 게시글 수: " + count);
        assertTrue(count >= 0);
    }

    @Test
    public void testPopularList() {
        // When
        List<CommunityDTO> popularList = dao.popularList();
        
        // Then
        assertNotNull(popularList);
        System.out.println("인기글 수: " + popularList.size());
        assertTrue(popularList.size() <= 3);
    }

    @Test
    @Transactional
    public void testInsertAndDeleteBoard() {
        // Given
        CommunityDTO dto = new CommunityDTO();
        dto.setUser_id("testuser");
        dto.setTitle("JUnit Test Title");
        dto.setContent("JUnit Test Content");
        dto.setCategory("정보공유");
        
        // When: Insert
        dao.insertBoard(dto);
        int postId = dto.getPost_id(); // MyBatis selectKey 또는 시퀀스로 생성된 ID 확인
        System.out.println("생성된 게시글 ID: " + postId);
        
        // Then: Check Insert
        CommunityDTO result = dao.boardDetail(postId);
        assertNotNull(result);
        assertEquals("JUnit Test Title", result.getTitle());
        
        // When: Delete
        dao.deleteBoard(postId);
        
        // Then: Check Delete
        CommunityDTO deletedResult = dao.boardDetail(postId);
        // 상태값 확인 (실제 삭제인지 STATUS='DELETED'인지 확인 필요)
        // CommunityServiceImpl.java의 getBoardDetail 로직에서는 
        // if (dto == null || "HIDDEN".equals(dto.getStatus()) || "BANNED".equals(dto.getStatus())) 로 체크함
        assertTrue(deletedResult == null || "HIDDEN".equals(deletedResult.getStatus()));
    }

    @Test
    @Transactional
    public void testUpdateBoard() {
        // Given
        int testPostId = 1; // 존재하는 ID거나 위에서 생성한 ID 사용
        CommunityDTO dto = new CommunityDTO();
        dto.setPost_id(testPostId);
        dto.setTitle("Updated Title");
        dto.setContent("Updated Content");
        dto.setCategory("숙소수다");
        
        // When
        dao.updateBoard(dto);
        
        // Then
        CommunityDTO result = dao.boardDetail(testPostId);
        if(result != null) {
            assertEquals("Updated Title", result.getTitle());
            assertEquals("Updated Content", result.getContent());
        }
    }

    @Test
    public void testSearchFreeBoard() {
        // Given
        Map<String, Object> map = new HashMap<>();
        map.put("category", null);
        map.put("searchType", "title");
        map.put("searchKeyword", "맛집");
        map.put("startRow", 1);
        map.put("endRow", 10);
        
        // When
        int count = dao.searchFreeBoardCount(map);
        List<CommunityDTO> list = dao.searchFreeBoardPage(map);
        
        // Then
        System.out.println("검색 키워드 '맛집' 결과 수: " + count);
        assertNotNull(list);
        assertTrue(list.size() <= 10);
    }
}
