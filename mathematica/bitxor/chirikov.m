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

process::usage = 
"process[img,{x,y,k,h}] encrypt / decrypt image img with key {x,y,k,h}
process[img] encrypt / decrypt image img with a random key"

Begin["`Private`"]

(*parameters: image, key*)
process[img_Image,{x_?NumberQ,y_?NumberQ,k_?NumberQ,h_?NumberQ}]:=Module[
    {width,height,xx,yy,kk,hh,key}, (*local variables*)
    {width,height}=ImageDimensions[img]; (*get image size*)
    (*make sure the params used in calculation are in the appropriate range*)
    {kk,hh}=2+Exp@Nest[N@Mod[#[[2]]+10 Sin[#[[1]]]+{#[[1]],0},2 \[Pi]]&,{k,h},Abs@Ceiling[x*y]];
    {xx,yy}=Nest[N@Mod[#[[2]]+hh Sin[#[[1]]]+{kk #[[1]],0},2 \[Pi]]&,{x,y},Ceiling[kk+hh]];
    key=ArrayReshape[ (*reshape to fit image size*)
            NestList[ (*nest to create x,y list*)
                N@Mod[#[[2]]+kk Sin[#[[1]]]+{hh #[[1]],0},2 \[Pi]]& (*improved Chirikov map*) ,
                {xx,yy},width*height
            ]\[Transpose][[1]] (*transpose to take the list of x*)
                 /(2\[Pi]/255) (*normalize*)
                     //Floor (*take integer part*),
        {width,height}];
    {Image[ImageData[img,"Byte"]~BitXor~key (*bitxor for encryption / decryption*) ,"Byte"],
    {x,y,k,h}}(*return value: {encrypted/decrypted image, key}*)
]

(*parament: image*)
process[img_Image]:=process[img,RandomVariate[NormalDistribution[\[Pi],\[Pi]],4]](*automatically generate key*)

End[ ]

EndPackage[ ]



