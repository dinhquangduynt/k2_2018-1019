var MouseDown=false;var MyVar;$(document).mousedown(function(){MouseDown=true;});$(document).mouseup(function(){MouseDown=false;});$(document).ready(function(){$("table:first").find("tr:first").click(function(){MyVar="red";});$("table:first").find("tr:eq(1)").click(function(){MyVar="green";});$("table:first").find("tr:eq(2)").click(function(){MyVar="blue";});$("table:eq(1)").find("td").mousedown(function(){var col=$(this).parent().children().index($(this));if(MyVar=="red")$(this).toggleClass("On");else if(MyVar=="green")$(this).toggleClass("On1");else if(MyVar=="blue")$(this).toggleClass("On2");});$("table:eq(1)").find("td").mouseenter(function(){if(MouseDown){if(MyVar=="red")$(this).addClass("On");else if(MyVar=="green")$(this).addClass("On1");else if(MyVar=="blue")$(this).addClass("On2");}});$("input#Fill").click(function(){$("table:eq(1)").find("td").each(function(){if(MyVar=="red")$(this).addClass("On");else if(MyVar=="green")$(this).addClass("On1");else if(MyVar=="blue")$(this).
addClass("On2");});});$("input#Clear").click(function(){$("table:eq(1)").find("td").each(function(){$(this).removeClass("On");$(this).removeClass("On1");$(this).removeClass("On2");});});$("input#Random").click(function(){$("table:eq(1)").find("td").each(function(){if(Math.random()<Math.random()){if(MyVar=="red")$(this).toggleClass("On");else if(MyVar=="green")$(this).toggleClass("On1");else if(MyVar=="blue")$(this).toggleClass("On2");}else{if(MyVar=="red")$(this).toggleClass("On");else if(MyVar=="green")$(this).toggleClass("On1");else if(MyVar=="blue")$(this).toggleClass("On2");}});});$("input#Toggle").click(function(){$("table:eq(1)").find("td").each(function(){if(MyVar=="red")$(this).toggleClass("On");else if(MyVar=="green")$(this).toggleClass("On1");else if(MyVar=="blue")$(this).toggleClass("On2");});});$("input#Output").click(function(){var Output="const static int image[] = {\n";var Grid=[];var i=0;var j=0;$("table:eq(1)").find("tr").each(function(){Grid[i]=[];{Grid[i]=[];j=0;$(
this).find("td").each(function(){Grid[i][j]=$(this).hasClass("On")?1:0;j++;});}i++;});var GridRed=[];GridRed[0]=[];{for(var i=0;i<36;i++)GridRed[0][i]=Grid[0][i]|Grid[1][i]|Grid[2][i]|Grid[3][i]|Grid[4][i]|Grid[5][i]|Grid[6][i]|Grid[7][i];}var Grid=[];var i=0;var j=0;$("table:eq(1)").find("tr").each(function(){Grid[i]=[];{Grid[i]=[];j=0;$(this).find("td").each(function(){Grid[i][j]=$(this).hasClass("On1")?1:0;j++;});}i++;});var GridGreen=[];GridGreen[0]=[];{for(var i=0;i<36;i++)GridGreen[0][i]=Grid[0][i]|Grid[1][i]|Grid[2][i]|Grid[3][i]|Grid[4][i]|Grid[5][i]|Grid[6][i]|Grid[7][i];}var Grid=[];var i=0;var j=0;$("table:eq(1)").find("tr").each(function(){Grid[i]=[];{Grid[i]=[];j=0;$(this).find("td").each(function(){Grid[i][j]=$(this).hasClass("On2")?1:0;j++;});}i++;});var GridBlue=[];GridBlue[0]=[];{for(var i=0;i<36;i++)GridBlue[0][i]=Grid[0][i]|Grid[1][i]|Grid[2][i]|Grid[3][i]|Grid[4][i]|Grid[5][i]|Grid[6][i]|Grid[7][i];}var Grid=[];Grid[0]=GridRed[0];Grid[1]=GridGreen[0];Grid[2]=
GridBlue[0];var i=0;i=i+3;var j=0;$("table:eq(1)").find("tr").each(function(){j=0;Grid[i]=[];$(this).find("td").each(function(){Grid[i][j]=$(this).hasClass("On")||$(this).hasClass("On1")||$(this).hasClass("On2")?1:0;j++;});i++;});for(var k=j-1;k>=0;k--){Output+="0b";for(var l=i-1;l>=0;l--){Output+=Grid[l][k];}var bitpattern=Output.slice(-11);Output=Output.substring(0,Output.length-11);var rgb=bitpattern.slice(-3);rgb=rgb.split("").reverse().join("");bitpattern=bitpattern.substring(0,bitpattern.length-3);bitpattern=bitpattern.split("").reverse().join("");bitpattern="0000"+rgb+"0"+bitpattern;Output+=bitpattern;Output+=", ";}Output=Output.slice(0,-2);Output+="};";$("div#Output").html(Output);});});mw.loader.state({"site":"ready"});
/* cache key: wiki_sep18-wiki_:resourceloader:filter:minify-js:7:d39c4d03afc87f281c6a5e141bdebd49 */