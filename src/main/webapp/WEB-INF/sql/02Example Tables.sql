USE mydb6;
drop TABLE Member;
CREATE TABLE Member (
	id VARCHAR(20) PRIMARY KEY, 
    password VARCHAR(20) NOT NULL,
    email VARCHAR(20) NOT NULL UNIQUE,
    nickName VARCHAR(20) NOT NULL UNIQUE,
    inserted DATETIME NOT NULL DEFAULT NOW()
);

-- 권한 테이블
CREATE TABLE Auth(
	memberId VARCHAR(20) NOT NULL,
    role VARCHAR(20) NOT NULL,
	FOREIGN KEY (memberId) REFERENCES Member(id)
);

ALTER TABLE Member MODIFY COLUMN email  VARCHAR(50) NOT NULL UNIQUE;
DESC Member;
SELECT * FROM Member;
SELECT * FROM Auth;

INSERT INTO Auth
VALUES ('admin', 'ROLE_ADMIN');

INSERT INTO Auth (memberId, role)
(SELECT id, 'ROLE_USER' FROM Member WHERE id NOT IN 
(SELECT memberId FROM Auth));

-- Board 테이블에 Member의 id 참조하는 컬럼 추가
DESC Board;
ALTER TABLE Board
ADD COLUMN memberId VARCHAR(20) NOT NULL DEFAULT 'user' REFERENCES Member(id) AFTER body;

ALTER TABLE Board
MODIFY COLUMN memberId VARCHAR(20) NOT NULL;



SELECT * FROM Board;

DESC Reply;

-- reply에 memberId 컬럼 추가 (member테이블 id컬럼 참조키 제약사항, not null 제약사항 추가)
ALTER TABLE Reply
ADD COLUMN memberId VARCHAR(20) NOT NULL DEFAULT 'user' REFERENCES Member(id) AFTER content;

ALTER TABLE Reply
MODIFY COLUMN memberId VARCHAR(20) NOT NULL;

SELECT * FROM Reply ORDER BY 1 desc;

UPDATE Member
SET nickName = '유저'
WHERE id = '';

	SELECT r.id, 
	       r.board_id boardId,
	       r.content,
	       m.nickName writerNickName,
	       r.inserted,
           if(m.id = 'user', 'true', 'false') own
	FROM Reply r JOIN Member m	ON r.memberId = m.id
	WHERE r.board_id = 26
	ORDER BY r.id