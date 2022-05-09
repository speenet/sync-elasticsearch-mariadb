SELECT j.journal_id, j.action_type, a.title, a.content, a.article_id
FROM test.article_journal j
LEFT JOIN test.article a ON a.article_id = j.article_id
WHERE j.journal_id > :sql_last_value AND j.action_time < NOW() ORDER BY j.journal_id
