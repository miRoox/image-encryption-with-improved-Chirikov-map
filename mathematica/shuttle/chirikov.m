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


BeginPackage["chirikov`"]

encrypt::usage =
"encrypt[img,{x,y,k,h}] encrypt image img with key {x,y,k,h}
encrypt[img] encrypt image img with a random key"

decrypt::usage =
"decrypt[img,{x,y,k,h}] decrypt image img with key {x,y,k,h}"

Begin["`Private`"]

(*shuffle list with improved chirikov map*)
(*parameters: k, h, x, y, source-data*)
encryptShuffle=Compile[{{k,_Real},{h,_Real},{x,_Real},{y,_Real},{source,_Integer,1}},
Block[{data,pos},data=source;
    pos=(NestList[ (*nest to generate a list of the position need to *)
             Mod[#[[2]]+k Sin[#[[1]]]+{h #[[1]],0},2. Pi]&, (*improved Chirikov map*)
             {x,y},2*Length[data]
        ]*Length[data]/(2 Pi)) (*normalize*)
            //Ceiling (*take integer part*);
    Scan[(data[[#]]=data[[Reverse@#]])&,pos,1]; (*shuffle data*)
    data] (*return value: shuffled data*)
];

(*parameters: k, h, x, y, source-data*)
decryptShuffle=Compile[{{k,_Real},{h,_Real},{x,_Real},{y,_Real},{source,_Integer,1}},
Block[{data,pos},data=source;
    pos=(NestList[ (*nest to generate a list of the position need to *)
             Mod[#[[2]]+k Sin[#[[1]]]+{h #[[1]],0},2. Pi]&, (*improved Chirikov map*)
             {x,y},2*Length[data]
        ]*Length[data]/(2 Pi)) (*normalize*)
            //Ceiling (*take integer part*)
                //Reverse (*decrypt*);
    Scan[(data[[#]]=data[[Reverse@#]])&,pos,1]; (*shuffle data*)
    data] (*return value: decryption shuffled data*)
];

(*parameters: image, key*)
encrypt[img_Image,{x_?NumberQ,y_?NumberQ,k_?NumberQ,h_?NumberQ}]:=
Block[{kk,hh,xx,yy},
(*make sure the params used in calculation are in the appropriate range*)
{kk,hh}=2+Exp@Mod[h+10 Sin[k]+{k,0},2. Pi];
{xx,yy}=Mod[x+hh Sin[y]+{kk y,0},2. Pi];
{Image[Map[FromDigits[#,2]& (*convert bit array to integer*),
    ArrayReshape[ (*to fit image data form*)
        encryptShuffle[kk,hh,xx,yy,
            ImageData[img,"Byte"] (*read image data*)
                //IntegerDigits[#,2,8]& (*convert integer to bit array*)
                    //Flatten],
        ImageDimensions[img]~Join~{3,8} (*reshaped data: colunm, row, rgb, bits*)
    ],{3}],
"Byte"],
{x,y,k,h}}(*return value: {encrypted image, key}*)
]

(*parameters: image, key*)
decrypt[img_Image,{x_?NumberQ,y_?NumberQ,k_?NumberQ,h_?NumberQ}]:=
Block[{kk,hh,xx,yy},
(*make sure the params used in calculation are in the appropriate range*)
{kk,hh}=2+Exp@Mod[h+10 Sin[k]+{k,0},2. Pi];
{xx,yy}=Mod[x+hh Sin[y]+{kk y,0},2. Pi];
Image[Map[FromDigits[#,2]& (*convert bit array to integer*),
    ArrayReshape[ (*to fit image data form*)
        decryptShuffle[kk,hh,xx,yy,
            ImageData[img,"Byte"] (*read image data*)
                //IntegerDigits[#,2,8]& (*convert integer to bit array*)
                    //Flatten],
        ImageDimensions[img]~Join~{3,8} (*reshaped data: colunm, row, rgb, bits*)
    ],{3}],
"Byte"](*return value: decrypted image*)
]

(*parament: image*)
encrypt[img_Image]:=encrypt[img,RandomVariate[NormalDistribution[\[Pi],\[Pi]],4]](*automatically generate key*)

End[ ]

EndPackage[ ]



