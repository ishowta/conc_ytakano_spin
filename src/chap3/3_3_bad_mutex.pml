#include "../lib/critical_section.pml"

bool lock = false; // 共有変数 <1>

proctype some_func(){
retry:
    if
    :: lock == false -> // <2>
        lock = true; // ロック獲得
        critical_section(); // クリティカルセクション
    :: else -> goto retry;
    fi;
    lock = false; // ロック解放 <3>
}

init {
    run some_func();
    run some_func();
    run some_func();
}

#include "../test/lock.pml"
