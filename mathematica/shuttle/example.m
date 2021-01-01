(* ::Package:: *)

(**
 ** Copyright 2018-2021 Lu <miroox@outlook.com>
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


(*load package*)
Get[NotebookDirectory[]<>"chirikov.m"]


(*load test image*)
origin=ExampleData[{"TestImage","Peppers"}]


(*encrypted image and key*)
encimage=encrypt[origin]

(*and then decrypt it*)
decrypt@@encimage

Clear["encimage"]


(*correlation coefficient*)
With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=encrypt[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        decrypt[encimg,{x,y,k,h+d}],DistanceFunction->CorrelationDistance],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,k, change h"]
]
]

With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=encrypt[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        decrypt[encimg,{x,y,k+d,h}],DistanceFunction->CorrelationDistance],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,h, change k"]
]
]


(*mean square error*)
With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=encrypt[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        decrypt[encimg,{x,y,k,h+d}],DistanceFunction->"MeanSquaredEuclideanDistance"],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,k, change h"]
]
]

With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=encrypt[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        decrypt[encimg,{x,y,k+d,h}],DistanceFunction->"MeanSquaredEuclideanDistance"],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,h, change k"]
]
]


(*histogram*)
ImageHistogram[origin]
ImageHistogram[encrypt[origin][[1]]]


Clear["origin"]
ClearAll["chirikov`*"]
