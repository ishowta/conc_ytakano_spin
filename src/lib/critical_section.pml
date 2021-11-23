#include "./freeze.pml"

byte critical = 0;

inline critical_section(){
    critical++;
    // 取得したままフリーズする可能性がある
    do
    :: true ->
        freeze = 1;
        do
        :: true -> skip;
        od;
    :: true -> break;
    od;
    critical--;
}
