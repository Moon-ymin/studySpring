-- 조인
use scott;

-- 각 개별 테이블 확인
SELECT * FROM emp; 	-- 14개의 행
SELECT * FROM dept; -- 4개의 행

-- 2개의 테이블 조회 (FROM절)
SELECT * FROM emp, dept;  -- 모든 가능한 행 14*4 = 56의 결과 조회 (카티션 프로덕트)

-- 두 개의 테이블에서 deptno가 같은 경우만 조회 (WHERE절 2개의 테이블 조건 명시)
SELECT * FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- => 암시적 조인

-- 두 개의 테이블을 결합하고, 결과 셋에서 필요한 속성들만 프로젝션(투영)
SELECT ename, job, sal, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 양 쪽 테이블 모두에 있는 필드 이름인 경우 테이블명을 명시하지 않으면 오류
SELECT ename, job, sal, dept.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 일반적으로 프로젝션하는 모든 필드의 이름에 테이블을 함께 명시
SELECT emp.ename, emp.job, emp.sal, dept.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 각 필드가 어떤 테이블에 속했는지 명확해졌지만, 너무 길어진다.
-- 각각의 테이블명에 별칭을 주어 간결화 시킴. (관례적으로 테이블 앞글자)
SELECT e.ename, e.job, e.sal, d.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- 명시적 조인
-- JOIN과 ON 키워드를 함께 사용
-- 1. Inner Join
SELECT *
FROM emp
INNER JOIN dept ON emp.deptno = dept.deptno;

-- 특정 컬럼만 프로젝션
SELECT ename, dname
FROM emp
INNER JOIN dept ON emp.deptno = dept.deptno;

-- 테이블명 약칭
SELECT e.ename, d.dname
FROM emp e
INNER JOIN dept d ON e.deptno = d.deptno;

-- LEFT, RIGHT JOIN

-- LEFT JOIN : 테이블1에 공통컬럼이 없는 경우도 포함하여 테이블2를 조회
-- [임시] deptno가 null인 행을 삽입
INSERT INTO emp
VALUES (9999, 'John', 'Doe', NULL, NULL, NULL, NULL, NULL);

-- INNER LEFT(테이블1)과 RIGHT(테이블2) 모두 존재하는 경우
-- LEFT (테이블1)에는 존재하고, RIGHT (테이블2)에는 존재하지 않는 행을 포함
-- RIGHT 테이블1에는 존재하지 않고, 테이블2에는 존재하는 행을 포함

-- LEFT JOIN : 9999번 행(deptno가 null)은 포함, 40번 부서는 포함하지 않음
SELECT *
FROM emp e
LEFT JOIN dept d ON e.deptno = d.deptno;

-- RIGHT JOIN : 9999번 행(deptno가 null)은 불포함, 40번 부서는 포함
SELECT *
FROM emp e
RIGHT JOIN dept d ON e.deptno = d.deptno;

-- 샘플 행 삭제 (원상복귀)
DELETE FROM emp WHERE empno = 9999;

-- SELF JOIN
SELECT e1.ename as "직원", e2.ename "매니저"
FROM emp e1
JOIN emp e2 ON e1.mgr = e2.empno;

-- 두 개의 테이블을 결합할 때 컬럼이 이퀄(=, 등호)가 아닌 비교, 범위 등의 조건으로
-- Join Condition 으로 결합한 경우
-- 직원 테이블의 급여(sal)가 급여등급 테이블(salgrade)의 losal, hisal 범위에 있는 경우로 join 
SELECT E.ENAME, E.SAL, S.GRADE 
FROM EMP E
JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

-- 3개 이상의 테이블을 결합하는 경우
SELECT e.ename, d.deptno, d.dname, s.grade
FROM EMP E
JOIN DEPT D ON e.deptno = d.deptno
JOIN SALGRADE S ON e.sal BETWEEN s.losal and s.hisal;

-- 그룹화 집계함수와 함께 사용
-- 부서별 급여평균 (부서의 번호 대신 부서명, 평균)
SELECT d.dname "부서명", round(avg(e.sal)) "부서별 급여평균"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
GROUP BY dname;

-- USING 키워드와 함께 사용
-- 두 테이블이 공통적으로 가지고 있는 열을 기준으로 JOIN 할때 사용
-- 두 테이블에서 열이름이 동일해야 사용 가능
-- ON d.deptno = e.deptno 간소화 한 형태
SELECT *
FROM emp e
JOIN dept d USING (deptno);

-- NATURAL JOIN
-- 두 테이블 간의 이름과 데이터타입이 같은 모든 열을 자동으로 찾아서 해당 열을 기준으로 JOIN
SELECT *
FROM emp e
NATURAL JOIN dept d;

-- CROSS JOIN
-- 양 테이블의 모든 행으 ㄹ조인, 결과는 두 테이블을 곱한 개수, 카티션 프로덕트
-- 많은 데이터 생성시 사용
SELECT * FROM EMP
CROSS JOIN DEPT;





