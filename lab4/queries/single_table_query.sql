select * from assignments
  where expected_execution_date > now()
    and labour > 5;
