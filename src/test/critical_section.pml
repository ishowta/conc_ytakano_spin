// クリティカルセクションに２つ以上のプロセスが同時にアクセスしてはいけない
ltl mutual_exclusion { [] (critical <= 1) }
