-- 트랜잭션 고립 수준
use tcl;

-- 고립수준 확인하기
select @@transaction_isolation;

/* 1. READ UNCOMMITTED, 더티 리드 */
-- 고립수준 변경하기
set transaction isolation level read Uncommitted;
start transaction;
-- 읽기 (세션2에서 쓰기 전) => 홍길동 나이 30
select * from person;

-- 읽기 (세션2에서 쓰기 후) => 홍길동 나이 50
-- 세션2는 커밋을 하지 않았는데 변경한 내용이 반영되어 읽어짐 => READ UNCOMMITTED
-- 더티 리드(오손 읽기, dirty read)
-- 무효화 되는 데이터를 읽은 것이어서 결과적으로 잘못된 결과를 읽게 됨 
select * from person;

-- 읽기 (세션2에서 트랜잭션 롤백 후) => 홍길동 나이 30
-- 세션2에서 작업한 데이터가 원상복귀
select * from person;

commit;

/* 2. READ COMMITTED, 반복 불가능 읽기 */
set transaction isolation level read committed;
start transaction;

-- 읽기 : 세션 2 커밋 전 // 홍길동 -> 30;
select * from person where name = '홍길동';

-- 반복 읽기 : 세션 2 커밋 후 // 홍길동 -> 50;
select * from person where name = '홍길동';

-- 반복 읽기 시 다른 트랜잭션 작업 여부에 따라 이전의 결과와 다른 결과가 나오고
-- 동일한 이전 결과를 읽을 수 없는 현상 => 반복 불가능 읽기

/* 3. REPEATABLE READ, 반복 가능 읽기 */
set transaction isolation level repeatable read;
start transaction;

-- 읽기 : 처음 읽은 값 // 홍길동 -> 30
select * from person where name = '홍길동';

-- 반복 읽기 : 세션 2 커밋 후(홍길동 나이가 변경됨) => 그대로 30
-- 트랜잭션 시작했을 때 처음 읽을 값을 스냅샷으로 저장하여
-- 반복해서 읽더라도(트랜잭션 중에 다른 트랜잭션이 값을 변경하더라도) 처음 값을 읽어 옴. 
SELECT * FROM person WHERE name = '홍길동';

COMMIT;

/* 4. SERIALIZABLE 가장 높은 고립수준 */
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
-- 이 트랜잭션이 완료될 때까지 다른 트랜잭션은 데이터를 변경할 수 없음.

SELECT * FROM person WHERE name = '홍길동';

COMMIT;
