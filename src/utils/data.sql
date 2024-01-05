-- 1. LEFT JOIN 문 구하기
SELECT books._id, title, category, form, isbn, img, summary, detail, author, pages, contents, price, likes, pub_date, books.updated_at, books.created_at 
FROM books
LEFT JOIN categories
ON books.category_id = categories._id
WHERE books._id = "2c644524-c692-4423-9db3-605ab2b5aacb";


-- 2. SQL 시간 범위 구하기
-- 시간 더하기 +
SELECT DATE_ADD(NOW(), INTERVAL 1 MONTH);
-- 시간 빼기 -
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);
-- 최근 한달 내의 최신 도서 정보만 받기
SELECT * FROM books 
WHERE pub_date BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND NOW();
-- 최근 한달 내의 특청 카테고리 도서 정보만 받기
SELECT * FROM books 
WHERE pub_date BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND NOW() 
AND books.category_id="bc73d103-5808-431a-a110-0d57c5143e2a";


-- 3. 도서 목록 페이징 하기
-- created_at 내림차순으로 정렬해서 1페이지 당 5개씩 뽀아오기
-- 1페이지 클릭 5개 뽑아오기
SELECT * FROM books 
ORDER BY created_at 
DESC LIMIT 5 OFFSET 0;
-- 2페이지 클릭 5개 뽑아오기
SELECT * FROM books 
ORDER BY created_at 
DESC LIMIT 5 OFFSET 5;
-- 3페이지 클릭 5개 뽑아오기
SELECT * FROM books 
ORDER BY created_at 
DESC LIMIT 5 OFFSET 10;
-- LIMIT : 출력할 행의 수
-- OFFSET : 시작 지점 ( 내가 지금 몇페이지더라? ) 

limit : page 당 도서 수        ex. 3
currentPage : 현재 몇 페이지   ex. 1, 2, 3 ...
offset : 시작 시점             ex. 0, 3, 6, 9, 12
offset = limit * (currentPage - 1)


-- 4. 좋아요, 싫어요
-- 좋아요
INSERT INTO user_likes_table (users_id, books_id) VALUE ("232331b6-c833-4754-a50c-6120774c622c", "13a61ae0-2ffd-4a71-8929-0adfa3c2a812");
INSERT INTO user_likes_table (users_id, books_id) VALUE ("3a1942d7-e1a2-4ab8-8bed-f8af49dcf173", "13a61ae0-2ffd-4a71-8929-0adfa3c2a812");
INSERT INTO user_likes_table (users_id, books_id) VALUE ("232331b6-c833-4754-a50c-6120774c622c", "1adeb3b2-65bd-436d-b6ce-bfa935bc667a");
INSERT INTO user_likes_table (users_id, books_id) VALUE ("3a1942d7-e1a2-4ab8-8bed-f8af49dcf173", "fa80071a-c660-465c-9a9d-f6e8e17abb2a");
INSERT INTO user_likes_table (users_id, books_id) VALUE ("72bf6b92-f678-432f-928d-0bbd62f440cc", "9348f644-8c47-49aa-be99-22b0f31c14b9");

-- 싫어요
DELETE FROM user_likes_table 
WHERE users_id = "232331b6-c833-4754-a50c-6120774c622c" AND books_id = "13a61ae0-2ffd-4a71-8929-0adfa3c2a812";

-- 좋아요 count 갯수
SELECT count(*) FROM user_likes_table WHERE books_id = "13a61ae0-2ffd-4a71-8929-0adfa3c2a812";


-- 5. books 테이블 서브쿼리 좋아요 likes 갯수 user_likes_table과 연동해서 추가
-- 서브(sub) 쿼리 : 쿼리 안에 쿼리 , count() : 행의 개수 , AS : 컬럼 별칭
SELECT *, (SELECT count(*) FROM user_likes_table WHERE user_likes_table.books_id = books._id) AS likes FROM books;


-- 6. 사용자가 좋아요를 했는지 안했는지 여부를 포함
-- SELECT EXISTS 결과 값이 존재하는지 유무를 판단함
SELECT EXISTS (SELECT * FROM user_likes_table WHERE user_likes_table.users_id = "232331b6-c833-4754-a50c-6120774c622c" AND user_likes_table.books_id = "13a61ae0-2ffd-4a71-8929-0adfa3c2a812");

-- 좋아요 했는지 안했는지 전체, 개별 도서 목록 조회
-- 전체 조회 
SELECT *, 
(SELECT count(*) FROM user_likes_table WHERE user_likes_table.books_id = books._id) AS likes,
(SELECT EXISTS (SELECT * FROM user_likes_table WHERE user_likes_table.users_id = "232331b6-c833-4754-a50c-6120774c622c" AND user_likes_table.books_id = books._id)) AS liked 
FROM books LEFT JOIN categories ON books.category_id = categories.category_id;

-- 개별 조회
SELECT *, 
(SELECT count(*) FROM user_likes_table WHERE user_likes_table.books_id = books._id) AS likes,
(SELECT EXISTS (SELECT * FROM user_likes_table WHERE user_likes_table.users_id = "232331b6-c833-4754-a50c-6120774c622c" AND user_likes_table.books_id = "13a61ae0-2ffd-4a71-8929-0adfa3c2a812")) AS liked 
FROM books LEFT JOIN categories ON books.category_id = categories.category_id 
WHERE books._id = "13a61ae0-2ffd-4a71-8929-0adfa3c2a812";
