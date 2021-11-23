#include "../lib/critical_section.pml"
#include "../lib/tas.pml"

bool lock = false; // 共有変数 <1>

inline spinlock_acquire(lock){
    do
    ::
        // <2>
        do
        ::
            if
            :: lock == true -> skip;
            :: else -> break;
            fi;
            freeze = true;
        od;
        bool result;
        test_and_set(lock, result);
        if
        :: result == false ->
            freeze = false;
            break;
        :: else -> skip;
        fi;
        freeze = true;
    od;
}

inline spinlock_release(lock){
    tas_release(lock);
}

// テスト
#include "./3_3_1_use_spinlock.pml"
