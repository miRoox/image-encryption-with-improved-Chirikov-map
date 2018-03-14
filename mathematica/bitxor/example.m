(* ::Package:: *)

(*load package*)
Get[NotebookDirectory[]<>"chirikov.m"]


(*load test image*)
origin=ExampleData[{"TestImage","Peppers"}]


(*encrypted image and key*)
encimage=process[origin]

(*and then decrypt it*)
process@@encimage

Clear["encimage"]


(*correlation coefficient*)
With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=process[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        process[encimg,{x,y,k,h+d}][[1]],DistanceFunction->CorrelationDistance],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,k, change h"]
]
]

With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=process[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        process[encimg,{x,y,k+d,h}][[1]],DistanceFunction->CorrelationDistance],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,h, change k"]
]
]


(*mean square error*)
With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=process[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        process[encimg,{x,y,k,h+d}][[1]],DistanceFunction->"MeanSquaredEuclideanDistance"],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,k, change h"]
]
]

With[{x=2,y=1,k=2,h=3},
Module[{encimg},encimg=process[origin,{x,y,k,h}][[1]];
    Plot[ImageDistance[origin,
        process[encimg,{x,y,k+d,h}][[1]],DistanceFunction->"MeanSquaredEuclideanDistance"],
        {d,-1*10^-14,1*10^-14},
        AxesOrigin->{0,0},PlotLabel->"fix x,y,h, change k"]
]
]


(*histogram*)
ImageHistogram[origin]
ImageHistogram[process[origin][[1]]]


Clear["origin"]
ClearAll["chirikov`*"]
