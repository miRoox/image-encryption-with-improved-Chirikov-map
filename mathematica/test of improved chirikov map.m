(* ::Package:: *)

(**
 ** Copyright 2018 Lu <miroox@outlook.com>
 **
 ** Licensed under the Apache License, Version 2.0 (the "License");
 ** you may not use this file except in compliance with the License.
 ** You may obtain a copy of the License at
 **
 **     http://www.apache.org/licenses/LICENSE-2.0
 **
 ** Unless required by applicable law or agreed to in writing, software
 ** distributed under the License is distributed on an "AS IS" BASIS,
 ** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ** See the License for the specific language governing permissions and
 ** limitations under the License.
 **)


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
