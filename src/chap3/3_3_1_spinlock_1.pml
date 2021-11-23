#include "../lib/critical_section.pml"
#include "../lib/tas.pml"
#include "../lib/freeze.pml"

bool lock = false; // 共有変数 <1>

inline spinlock_acquire(lock){
    // <1>
    do
    :: true ->
        bool result;
        test_and_set(lock, result);
        if
        :: result == true -> skip;
        :: else ->
            freeze = false;
            break;
        fi;
        freeze = true;
    od;
}

inline spinlock_release(lock){
    tas_release(lock); // <2>
}

// テスト
#include "./3_3_1_use_spinlock.pml"
