-- 데이터 삽입, 추가, 삭제 연습문제 
-- LibraryManagement 스키마에서 진행해주세요.
use librarymanagement;
select * from borrowrecords;

-- 문제 1: 'Books' 테이블에 새로운 도서 추가하기
-- 제목: "Learning SQL", 저자: "Alan Beaulieu", 출판 연도: 2020, 장르: "Educational"
insert into books (title, author, publishedYear, genre)
values ('Learning SQL', 'Alan Beaulieu', 2020, 'Educational');

-- 문제 2: 'Members' 테이블에 새로운 회원 추가하기
-- 이름: "Lucy", 성: "Heartfilia", 이메일: "lucy.heart@example.com", 회원가입 날짜: 오늘 날짜
insert into members (firstname, lastname, email, membershipdate)
values ('Lucy', 'Heartfilia', 'lucy.heart@example.com', current_date());

-- 문제 3: 'BorrowRecords' 테이블에 대출 기록 추가하기
-- 회원 ID: 1, 도서 ID: 1, 대출 날짜: "2023-03-15", 반납 예정 날짜: "2023-04-14"
insert into borrowrecords (memberId, bookId, borrowDate, returnDate)
values (1, 1, '2023-03-15', '2023-04-14');

-- 문제 4: 'Books' 테이블에서 제목이 "Learning SQL"인 도서의 장르를 "Technical"로 변경하기
update books set genre = 'Technimal' where title = 'Learning SQL'; 

-- 문제 5: 'Members' 테이블에서 회원 ID가 1인 회원의 이메일 주소를 "lucy.h@example.com"으로 변경하기
update members set email = 'lucy.h@example.com' where memberID = 1;

-- 문제 6: 'BorrowRecords' 테이블에서 회원 ID가 1이고 도서 ID가 1인 대출 기록의 반납 예정 날짜를 "2023-04-30"으로 변경하기
update borrowrecords set returnDate = '2023-04-30' where memberID = 1 and bookID = 1;

-- 문제 7: 'Books' 테이블에서 출판 연도가 2020년인 모든 도서의 출판 연도를 2021로 변경하기
update books set publishedYear = 2021 where publishedYear = 2020;

-- 문제 8: 'Members' 테이블에서 이메일 주소가 "lucy.h@example.com"인 회원을 삭제하기
delete from borrowrecords where memberID = 1;
delete from members where email = 'lucy.h@example.com';

-- 문제 9: 'BorrowRecords' 테이블에서 반납 예정 날짜가 "2023-04-30"인 모든 대출 기록을 삭제하기
DELETE from borrowrecords where returnDate = '2023-04-30';