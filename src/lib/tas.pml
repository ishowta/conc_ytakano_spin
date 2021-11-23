inline test_and_set(p, result){
    atomic {
        if
        :: p == true -> result = true;
        :: else ->
            p = true;
            result = false;
        fi;
    }
}

inline tas_release(p){
    atomic{
        p = 0;
    }
}
