package com.choong.spr.service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.choong.spr.domain.BoardDto;
import com.choong.spr.mapper.BoardMapper;
import com.choong.spr.mapper.ReplyMapper;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
public class BoardService {

	@Autowired
	private BoardMapper mapper;
	
	@Autowired
	private ReplyMapper replyMapper;
	
	private S3Client s3;
	
	@Value("${aws.s3.bucketName}")
	private String bucketName;
	
	
	public List<BoardDto> listBoard(String type, String keyword) {
		// TODO Auto-generated method stub
		return mapper.selectBoardAll(type, "%" + keyword + "%");
	}
	
	// 객체가 생성되자마자 실행되는 메소드
	@PostConstruct
	public void init() {
		Region region = Region.AP_NORTHEAST_2;
		this.s3 = S3Client.builder().region(region).build();
	}
	
	@PreDestroy
	public void destroy() {
		this.s3.close();
	}
	
	@Transactional
	public boolean insertBoard(BoardDto board, MultipartFile[] files) {
//		board.setInserted(LocalDateTime.now());
		
		// 게시글 등록
		int cnt =  mapper.insertBoard(board);
		
		// 파일 등록 
		if(files != null) {
			for(MultipartFile file : files) {
				
				if(file.getSize() > 0) {
					mapper.insertFile(board.getId(), file.getOriginalFilename()); // db에 쓰는 일
					//saveFile(board.getId(), file); // 파일시스템에 저장
					//save 두개를 다 할순없음 
					saveFileAwsS3(board.getId(), file); // aws s3에 업로드 하는 일을 해줌

				}
			}
		}
		
		return cnt == 1;
	}

	private void saveFileAwsS3(int id, MultipartFile file) {
		
		String key = "board/" + id + "/" + file.getOriginalFilename();
		
		PutObjectRequest putObjectRequest = PutObjectRequest.builder()
				.acl(ObjectCannedACL.PUBLIC_READ)
				.bucket(bucketName)
				.key(key)
				.build();
		
		RequestBody requestBody;
		try {
			requestBody = RequestBody.fromInputStream(file.getInputStream(), file.getSize());
			s3.putObject(putObjectRequest, requestBody);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RuntimeException(e);
		}
		
	}

	private void saveFile(int id, MultipartFile file) {
		String pathStr = "C:/imgtmp/board/" + id + "/";
		File path = new File(pathStr);
		path.mkdirs();
		
		// 작성할 파일
		File des = new File(pathStr + file.getOriginalFilename());
		
		try {
			// file 저장
			file.transferTo(des);
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}

	public BoardDto getBoardById(int id) {
		BoardDto board = mapper.selectBoardById(id);
		List<String> fileNames = mapper.selectFileNameByBoard(id);
		
		board.setFileName(fileNames);
		return board;
	}

	public boolean updateBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		return mapper.updateBoard(dto) == 1;
	}

	@Transactional
	public boolean deleteBoard(int id) {
		// 파일 목록 읽기
		String fileName = mapper.selectFileByBoardId(id);
		
		// 실제 파일 삭제
		/*
		 * if(fileName != null && fileName.isEmpty()) { String folder =
		 * "C:/imgtmp/board/" + id + "/"; String path = folder + fileName;
		 * 
		 * File file = new File(path); file.delete();
		 * 
		 * File dir = new File(folder); dir.delete(); }
		 */
		
		// s3에서 파일 삭제
		deleteFromAwsS3(id, fileName);
		
		// 파일테이블 삭제
		mapper.deleteFileByBoardId(id);
		
		// 댓글 삭제
		replyMapper.deleteByBoardId(id);
		
		return mapper.deleteBoard(id) == 1;
	}

	private void deleteFromAwsS3(int id, String fileName) {
		
		String key = "board/" + id + "/" + fileName;
		
		DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
				.bucket(bucketName)
				.key(key)
				.build();
		s3.deleteObject(deleteObjectRequest);
		
	}

	/*public List<BoardDto> searchBoard(String keyword) {
		return mapper.searchBoardByKeword("%" + keyword + "%");
	}*/
}





