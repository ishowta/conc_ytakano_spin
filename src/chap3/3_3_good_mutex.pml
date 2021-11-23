#include "../lib/critical_section.pml"
#include "../lib/tas.pml"

bool lock = false; // 共有変数 <1>

proctype some_func(){
    bool result;
retry:
    test_and_set(lock, result); // 検査とロック獲得
    if
    :: result == false -> critical_section(); // クリティカルセクション
    :: else -> goto retry;
    fi;
    tas_release(lock); // ロック解放
}

init {
    run some_func();
    run some_func();
    run some_func();
}

#include "../test/lock.pml"
