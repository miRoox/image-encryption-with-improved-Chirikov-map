(* ::Package:: *)

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
