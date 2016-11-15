SELECT titles.title_id AS ID, 
       titles.title_title AS Title, 
       authors.author_legalname AS Name, 
       (SELECT COUNT(DISTINCT title_relationships.review_id) 
         FROM title_relationships 
         WHERE title_relationships.title_id = titles.title_id)
  AS reviews 
FROM  titles,authors,canonical_author 
WHERE 
       (SELECT COUNT(DISTINCT title_relationships.review_id) 
         FROM title_relationships 
         WHERE title_relationships.title_id = titles.title_id) >= 10 
    AND canonical_author.author_id = authors.author_id 
    AND canonical_author.title_id=titles.title_id 
    AND titles.title_parent=0 ;
