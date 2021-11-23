bool lock = false;

proctype some_func(){
    do
    :: true ->
        spinlock_acquire(lock); // ロック獲得 <1>
        critical_section(); // クリティカルセクション <2>
        spinlock_release(lock); // ロック解放 <3>
    od;
}

init {
    run some_func();
    run some_func();
    run some_func();
}

#include "../test/lock.pml"

// フリーズしない限りクリティカルセクションを動かし続けられるか
ltl working_or_freeze { [] (<> FREEZED || (<> (critical == true) && <> (critical == false))) }
