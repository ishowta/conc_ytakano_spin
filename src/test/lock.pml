#include "./critical_section.pml"

// ロックが一度以上獲得出来るか
ltl aquire_lock_least_once { <> (lock == true) }

// クリティカルセクションの実行時には必ずロックが掛かっている
ltl must_lock_while_running_critical_section { [] (critical == true -> lock == true) }
