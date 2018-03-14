(* ::Package:: *)

genList[k_Real,h_Real,n_Integer,{x_Real,y_Real}]:=NestList[
    Mod[#[[2]]+k Sin[#[[1]]]+{h #[[1]],0},2 \[Pi]]& (*improved chirikov map*)
    ,{x,y},n]


(*dynamic show the orbit of improved Chirikov map*)
Manipulate[
    ListPlot[
        genList[k,h,n,#]&/@pts,
        PlotRange->{{0,2\[Pi]},{0,2\[Pi]}},Axes->False
    ],
    {{k,2.,"map parameter k:"},0.,20.},
    {{h,2.,"map parameter h:"},0.,10.},
    {{n,4000,"number of iterators:"},{2000,4000,6000,8000}},
    {{hd,False,"hide locator"},{True,False}},
    {{pts,{{1.,1.},{2.,1.},{1.,2.},{2.,2.}}},
    Locator,LocatorAutoCreate->True,
    Appearance->Dynamic[If[hd,"",Style["\[CirclePlus]", Red, Bold, 18]]]}(*starting points*),
    SaveDefinitions->True
]


ClearAll[genList]
