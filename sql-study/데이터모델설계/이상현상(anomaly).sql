-- 이상현상

CREATE SCHEMA nomarlization;
use nomarlization;

-- 계절학기 테이블
CREATE TABLE summer (
	sid		INT, 	  	 -- 학번
	class	VARCHAR(30), -- 과정명
    price	INT			 -- 수강료
);

-- 초기값 삽입
INSERT INTO summer VALUES
	(100, 'Java', 20000),
    (150, 'Python', 15000),
    (200, 'C', 10000),
    (250, 'Java', 20000);

SELECT * FROM summer;

-- SELECT 문
-- 1. 계절학기를 듣는 학생의 학번과 과정명은?
select sid, class from summer;
-- 2. 'C' 강좌의 수강료는?
select price from summer where class = 'C';
-- 3. 수강료가 가장 비싼 과목은?
select distinct class from summer where price = (
	select max(price) from summer);
-- 4. 계절학기를 듣는 학생수와 수강료 총액은?
select count(distinct sid) as 총학생수 ,sum(price) AS 수강료총액 from summer;

-- 삭제 이상
-- 질의 : 200번 학생의 계절학기 수강신청을 취소하세요.
DELETE FROM summer WHERE sid=200;
-- 삭제 전에 조회할 수 있었던 'C' 과목의 수강료가 삭제됨 (의도하지 않은 삭제)
-- C 과목의 수강료가 조회되지 않음.
SELECT price FROM summer WHERE class LIKE 'C';

SELECT * from summer;

-- 테이블 초기화

-- 삽입 이상
-- 질의 : 계절학기에 새로운 강좌 C++(25000원)을 개설하세요
INSERT INTO SUMMER (CLASS, PRICE) VALUES ('C++', 25000);
-- 의도하지 않은 null 값이 포함.
SELECT * FROM summer;  -- 확인
-- 4번 질의를 수행했을 경우 일관성이 깨지고, 원하지 않는 결과가 수행
SELECT count(*), sum(price) FROM summer;

-- 원상복귀
DELETE FROM summer WHERE class LIKE 'c++';

-- 수정 이상
-- 질의 : JAVA 강좌의 가격을 15000원으로 수정하세요.
UPDATE summer SET price = 15000 WHERE class = 'Java' AND sid=100;
-- 고유값을 기반으로 조건부 수정하게 될 경우 최신값 일관성이 깨짐
SELECT * FROM summer;  -- 확인
-- Java 강의료를 조회하면 데이터 불일치가 발생하게 됨. (2개의 행)
SELECT price FROM summer WHERE class LIKE 'Java';

-- 이상현상을 발생시키지 않기 위해 테이블 구조 수정
-- 1. 과정명 정보와 가격 정보만 가지고 있는 테이블
CREATE TABLE summerPrice (
	class VARCHAR(30),
    price INT
);

INSERT INTO summerPrice VALUES
	('Java', 20000), ('Python', 15000), ('C', 10000);

SELECT * FROM summerPrice;
-- 2. 학생이 어떤 강의를 듣는지 정보를 가지고 있는 테이블
CREATE TABLE summerEnroll (
	sid INT,
	class VARCHAR(30)
);

INSERT INTO summerEnroll VALUES
	(100, 'Java'), (150, 'Python'), (200, 'C'), (250, 'Java');

SELECT * FROM summerEnroll;

-- SELECT 문
-- 1. 계절학기를 듣는 학생의 학번과 과정명은?
select * from summerEnroll;
-- 2. 'C' 강좌의 수강료는?
select price from summerprice where class='C';
-- 3. 수강료가 가장 비싼 과목은?
select distinct class from summerPrice where price = (select max(price) from summerPrice);
-- 4. 계절학기를 듣는 학생수와 수강료 총액은?
select count(distinct sid), sum(price) from summerEnroll join summerPrice USING(class);.

/* 이상현상을 발생시키지 않기 위해 테이블 구조 수정 */
-- 1. 과정명 정보와 가격 정보만 가지고 있는 테이블
CREATE TABLE summerPrice (
	class VARCHAR(30),
    price INT
);

INSERT INTO summerPrice VALUES
	('Java', 20000), ('Python', 15000), ('C', 10000);

SELECT * FROM summerPrice;

-- 2. 학생이 어떤 강의를 듣는지 정보를 가지고 있는 테이블
CREATE TABLE summerEnroll (
	sid INT,
	class VARCHAR(30)
);

INSERT INTO summerEnroll VALUES
	(100, 'Java'), (150, 'Python'), (200, 'C'), (250, 'Java');

SELECT * FROM summerEnroll;

SELECT * FROM summerEnroll;
SELECT * FROM summerPrice;
-- SELECT 문 (분해된 테이블)
-- 1. 계절학기를 듣는 학생의 학번과 과정명은?
SELECT sid, class FROM summerEnroll;
-- 2. 'C' 강좌의 수강료는?
SELECT price FROM summerPrice WHERE class LIKE 'C';
-- 3. 수강료가 가장 비싼 과목은?
SELECT DISTINCT class FROM summerPrice WHERE price = (SELECT max(price) FROM summerPrice);
-- 4. 계절학기를 듣는 학생수와 수강료 총액은?
SELECT count(*), sum(price) FROM summerPrice
  JOIN summerEnroll ON summerPrice.class = summerEnroll.class;

-- 삭제이상 확인 => 삭제이상 없음
-- 질의 : 200번 학생의 계절학기 수강신청을 취소하세요.
DELETE FROM summerEnroll WHERE sid=200;

-- 200번 학생의 수강신청은 취소되었지만, C강좌의 수강료 정보는 다른 테이블에 남아 있음.
SELECT * FROM summerEnroll;
SELECT * FROM summerPrice;

-- 2번 질의 다시 수행 => 성공적으로 수행
SELECT price FROM summerPrice WHERE class LIKE 'C';

-- 삽입 이상 => 삽입이상 없음
-- 질의 : 계절학기에 새로운 강좌 C++(25000원)을 개설하세요.
INSERT INTO summerPrice VALUES ('C++', 25000);

-- 의도하지 않은 null 값 삽입되지 않음.
-- 수강신청한 학생없이도 과정(수강료 포함)만 성공적으로 개설
SELECT * FROM summerEnroll;
SELECT * FROM summerPrice;

-- 4번질의(집계함수) 수행하여도 성공적으로 수행
SELECT count(*), sum(price) FROM summerPrice
  JOIN summerEnroll ON summerPrice.class = summerEnroll.class;

-- 수정 이상 => 수정이상 없음
-- 질의 : JAVA 강좌의 가격을 15000원으로 수정하세요.
UPDATE summerPrice SET price = 15000 WHERE class = 'Java';
-- 고유값을 기반으로 조건부 수정하게 될 경우 최신값 일관성이 깨짐
SELECT * FROM summerPrice;  -- 확인
SELECT * FROM summerEnroll;

-- 3번 질의 재수행
SELECT DISTINCT class FROM summerPrice WHERE price = (SELECT max(price) FROM summerPrice);
