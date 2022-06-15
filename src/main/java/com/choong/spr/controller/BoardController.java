package com.choong.spr.controller;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.choong.spr.domain.BoardDto;
import com.choong.spr.domain.ReplyDto;
import com.choong.spr.service.BoardService;
import com.choong.spr.service.ReplyService;



import org.springframework.web.multipart.*;
import org.slf4j.*;
import org.springframework.web.bind.annotation.*;
@Controller
@RequestMapping("board")
public class BoardController {
	
	private static final String FILE2 = "file";
	private static final Logger LOGGER = LoggerFactory.getLogger(BoardController.class);
	private static final String UPLOADIMG = "/static/uploadimg/";
	 @Autowired
	 ServletContext servletContext;
	
	@Autowired
	private BoardService service;
	
	@Autowired
	private ReplyService replyService;

	@RequestMapping("list")
	public void list(@RequestParam(name = "keyword", defaultValue = "") String keyword,
					@RequestParam(name = "type", defaultValue = "") String type,
					 Model model) {
		
		List<BoardDto> list = service.listBoard(type, keyword);
		model.addAttribute("boardList", list);
	}
	
	/*	@RequestMapping(path="list", params="keyword")
		public void search(String keyword, Model model) {
			List<BoardDto> list = service.searchBoard(keyword);
			model.addAttribute("boardList", list);
		}*/
	
	@GetMapping("insert")
	public void insert() {
		
	}
	
	@PostMapping("insert")
	public String insert(BoardDto board, 
			MultipartFile[] file, 
			Principal principal, 
			RedirectAttributes rttr) {
		
		//System.out.println(file);
		//System.out.println(file.getOriginalFilename());
		//System.out.println(file.getSize());
		
		//System.out.println(principal);
		//System.out.println(principal.getName()); // username
		
		/*
		 * if(file.getSize() > 0 ) { board.setFileName(file.getOriginalFilename()); }
		 */
		
		if(file != null) {
			List<String> fileList = new ArrayList<String>();
			for(MultipartFile f : file) {
				fileList.add(f.getOriginalFilename());
			}
			board.setFileName(fileList);
		}
		
		board.setMemberId(principal.getName());
		boolean success = service.insertBoard(board, file);
		
		if (success) {
			rttr.addFlashAttribute("message", "새 글이 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("message", "새 글이 등록되지 않았습니다.");
		}
		
		return "redirect:/board/list";
	}
	
	@GetMapping("get")
	public void get(int id, Model model) {
		BoardDto dto = service.getBoardById(id);
		List<ReplyDto> replyList = replyService.getReplyByBoardId(id);
		model.addAttribute("board", dto);
		
		
		/* 댓글 ajax로 가져오기 */
		/*model.addAttribute("replyList", replyList);*/
		
	}
	
	@PostMapping("modify")
	public String modify(BoardDto dto,
				@RequestParam(name="removeFileList", required = false) ArrayList<String> removeFileList,
				MultipartFile[] addFileList,
				Principal principal, 
				RedirectAttributes rttr) {
		BoardDto oldBoard = service.getBoardById(dto.getId());
		
		if(oldBoard.getMemberId().equals(principal.getName())) {
			
			boolean success = service.updateBoard(dto, removeFileList, addFileList);
			
			if (success) {
				rttr.addFlashAttribute("message", "글이 수정되었습니다.");
			} else {
				rttr.addFlashAttribute("message", "글이 수정되지 않았습니다.");
			}
			
		} else {
			rttr.addFlashAttribute("message", "권한이 없습니다");
		}
		
		rttr.addAttribute("id", dto.getId());
		return "redirect:/board/get";
	}
	
	@PostMapping("remove")
	public String remove(BoardDto dto, Principal principal, RedirectAttributes rttr) {
		
		// 게시물 정보 얻고
		BoardDto oldBoard = service.getBoardById(dto.getId());

		// 게시물 작성자 (memberId)와 principal의 name과 비교해서 같을 때만 진행
		if(oldBoard.getMemberId().equals(principal.getName())) {

			boolean success = service.deleteBoard(dto.getId());
			
			if (success) {
				rttr.addFlashAttribute("message", "글이 삭제 되었습니다.");
				
			} else {
				rttr.addFlashAttribute("message", "글이 삭제 되지않았습니다.");
			}
			
		} else {
			// 아니면 리턴.
			rttr.addFlashAttribute("message", "권한이 없습니다");
			rttr.addAttribute("id", dto.getId());
			return "redirect:/board/get";
		}
		return "redirect:/board/list";
	}
	
	
	// 썸머노트 에디터에서 받는 이미지 업로드 처리
	/* 
	@RequestMapping(value = "/imageupload", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String imageUpload(MultipartHttpServletRequest request) throws IOException {
		
		// 01. 리퀘스트에서 멀티파트파일을 받아서
		MultiValueMap<String, MultipartFile> multiFileMap = request.getMultiFileMap();
		List<MultipartFile> list = multiFileMap.get(FILE2);
		MultipartFile multipartFile = list.get(0);
		LOGGER.debug(multipartFile.getOriginalFilename());
	

		// 02. 파일을 전송하고
		String webappRoot = servletContext.getRealPath("/"); 
		String filename = UPLOADIMG + multipartFile.getOriginalFilename();
		File file = new File(webappRoot + filename);
		multipartFile.transferTo(file);

		// 03. 마지막에 최종 주소를 반환한다.
		// requet.getServername 을 하니, ajax에서 보내는 값이 리퀘스트 정보에 안떠서 InetAddress로
		// 받았다.
		String localIP = InetAddress.getLocalHost().getHostAddress();
		// http://를 붙여줘야 에디터 창에서 불러올 수가 있다. 음.. 자바스크립트내에서 붙일까? 일단 그냥 적자.
		return "http://" + localIP + ":" + request.getServerPort() + filename;
		
	}
	 */
}










