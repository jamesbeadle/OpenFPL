import{S as pl,i as _l,s as gl,k as i,q as g,a as v,l as n,m as c,r as x,h as r,c as m,n as s,J as ua,b as Me,G as e,K as Wt,L as Xt,g as pe,v as Ht,f as St,d as ge,M as hl,H as da,x as Zl,y as Ve,z as He,A as Te,u as fe,B as Pe,O as va,o as ma,I as _a,e as ea,p as tt,N as ga}from"../chunks/index.878abf19.js";import{L as xa}from"../chunks/Layout.987d9cae.js";import{L as ba}from"../chunks/LoadingIcon.ca18fd8e.js";import{P as wa,b as kt,c as ta,d as la,F as ha,T as pa,a as aa,f as ra,B as Nt,S as ya,u as Ea}from"../chunks/BadgeIcon.15c5bab3.js";import{p as Ia}from"../chunks/stores.8fa21572.js";import{S as $a}from"../chunks/ShirtIcon.55a7ffc0.js";import{P as Da}from"../chunks/PlayerService.54ce1220.js";function sa(l,a,o){const t=l.slice();return t[5]=a[o],t}function oa(l,a,o){const t=l.slice();return t[8]=a[o],t}function ia(l){let a,o=kt(l[8])+"",t;return{c(){a=i("option"),t=g(o),this.h()},l(u){a=n(u,"OPTION",{});var h=c(a);t=x(h,o),h.forEach(r),this.h()},h(){a.__value=l[8],a.value=a.__value},m(u,h){Me(u,a,h),e(a,t)},p:da,d(u){u&&r(a)}}}function na(l){let a,o,t,u=(l[5].shirtNumber==0?"-":l[5].shirtNumber)+"",h,w,S,E=(l[5].firstName==""?"-":l[5].firstName)+"",d,P,X,I=l[5].lastName+"",k,L,J,Y=kt(l[5].position)+"",N,K,oe,G=ta(Number(l[5].dateOfBirth))+"",z,ie,Q,T,ne,Z,re=l[5].totalPoints+"",A,U,B,ee,te=(Number(l[5].value)/4).toFixed(2)+"",V,se,ae,me,M;var ce=la(l[5].nationality);function ue(_){return{props:{class:"w-10 h-10",size:"100"}}}return ce&&(T=Zl(ce,ue())),{c(){a=i("div"),o=i("a"),t=i("div"),h=g(u),w=v(),S=i("div"),d=g(E),P=v(),X=i("div"),k=g(I),L=v(),J=i("div"),N=g(Y),K=v(),oe=i("div"),z=g(G),ie=v(),Q=i("div"),T&&Ve(T.$$.fragment),ne=v(),Z=i("div"),A=g(re),U=v(),B=i("div"),ee=g("£"),V=g(te),se=g("m"),me=v(),this.h()},l(_){a=n(_,"DIV",{class:!0});var F=c(a);o=n(F,"A",{class:!0,href:!0});var f=c(o);t=n(f,"DIV",{class:!0});var j=c(t);h=x(j,u),j.forEach(r),w=m(f),S=n(f,"DIV",{class:!0});var b=c(S);d=x(b,E),b.forEach(r),P=m(f),X=n(f,"DIV",{class:!0});var q=c(X);k=x(q,I),q.forEach(r),L=m(f),J=n(f,"DIV",{class:!0});var y=c(J);N=x(y,Y),y.forEach(r),K=m(f),oe=n(f,"DIV",{class:!0});var O=c(oe);z=x(O,G),O.forEach(r),ie=m(f),Q=n(f,"DIV",{class:!0});var $=c(Q);T&&He(T.$$.fragment,$),$.forEach(r),ne=m(f),Z=n(f,"DIV",{class:!0});var le=c(Z);A=x(le,re),le.forEach(r),U=m(f),B=n(f,"DIV",{class:!0});var he=c(B);ee=x(he,"£"),V=x(he,te),se=x(he,"m"),he.forEach(r),f.forEach(r),me=m(F),F.forEach(r),this.h()},h(){s(t,"class","flex items-center w-1/2 px-3"),s(S,"class","flex items-center w-1/2 px-3"),s(X,"class","flex items-center w-1/2 px-3"),s(J,"class","flex items-center w-1/2 px-3"),s(oe,"class","flex items-center w-1/2 px-3"),s(Q,"class","flex items-center w-1/2 px-3"),s(Z,"class","flex items-center w-1/2 px-3"),s(B,"class","flex items-center w-1/2 px-3"),s(o,"class","flex-grow flex items-center justify-start space-x-2 px-4"),s(o,"href",ae=`/player?id=${l[5].id}`),s(a,"class","flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer")},m(_,F){Me(_,a,F),e(a,o),e(o,t),e(t,h),e(o,w),e(o,S),e(S,d),e(o,P),e(o,X),e(X,k),e(o,L),e(o,J),e(J,N),e(o,K),e(o,oe),e(oe,z),e(o,ie),e(o,Q),T&&Te(T,Q,null),e(o,ne),e(o,Z),e(Z,A),e(o,U),e(o,B),e(B,ee),e(B,V),e(B,se),e(a,me),M=!0},p(_,F){if((!M||F&2)&&u!==(u=(_[5].shirtNumber==0?"-":_[5].shirtNumber)+"")&&fe(h,u),(!M||F&2)&&E!==(E=(_[5].firstName==""?"-":_[5].firstName)+"")&&fe(d,E),(!M||F&2)&&I!==(I=_[5].lastName+"")&&fe(k,I),(!M||F&2)&&Y!==(Y=kt(_[5].position)+"")&&fe(N,Y),(!M||F&2)&&G!==(G=ta(Number(_[5].dateOfBirth))+"")&&fe(z,G),F&2&&ce!==(ce=la(_[5].nationality))){if(T){Ht();const f=T;ge(f.$$.fragment,1,0,()=>{Pe(f,1)}),St()}ce?(T=Zl(ce,ue()),Ve(T.$$.fragment),pe(T.$$.fragment,1),Te(T,Q,null)):T=null}(!M||F&2)&&re!==(re=_[5].totalPoints+"")&&fe(A,re),(!M||F&2)&&te!==(te=(Number(_[5].value)/4).toFixed(2)+"")&&fe(V,te),(!M||F&2&&ae!==(ae=`/player?id=${_[5].id}`))&&s(o,"href",ae)},i(_){M||(T&&pe(T.$$.fragment,_),M=!0)},o(_){T&&ge(T.$$.fragment,_),M=!1},d(_){_&&r(a),T&&Pe(T)}}}function Ca(l){let a,o,t,u,h,w,S,E,d,P,X,I,k,L,J,Y,N,K,oe,G,z,ie,Q,T,ne,Z,re,A,U,B,ee,te,V,se,ae,me,M,ce,ue,_,F=l[2],f=[];for(let y=0;y<F.length;y+=1)f[y]=ia(oa(l,F,y));let j=l[1],b=[];for(let y=0;y<j.length;y+=1)b[y]=na(sa(l,j,y));const q=y=>ge(b[y],1,1,()=>{b[y]=null});return{c(){a=i("div"),o=i("div"),t=i("div"),u=i("div"),h=i("div"),w=i("p"),S=g("Position:"),E=v(),d=i("select"),P=i("option"),X=g("All");for(let y=0;y<f.length;y+=1)f[y].c();I=v(),k=i("div"),L=i("div"),J=g("Number"),Y=v(),N=i("div"),K=g("First Name"),oe=v(),G=i("div"),z=g("Last Name"),ie=v(),Q=i("div"),T=g("Position"),ne=v(),Z=i("div"),re=g("Age"),A=v(),U=i("div"),B=g("Nationality"),ee=v(),te=i("div"),V=g("Season Points"),se=v(),ae=i("div"),me=g("Value"),M=v();for(let y=0;y<b.length;y+=1)b[y].c();this.h()},l(y){a=n(y,"DIV",{class:!0});var O=c(a);o=n(O,"DIV",{class:!0});var $=c(o);t=n($,"DIV",{});var le=c(t);u=n(le,"DIV",{class:!0});var he=c(u);h=n(he,"DIV",{class:!0});var W=c(h);w=n(W,"P",{class:!0});var C=c(w);S=x(C,"Position:"),C.forEach(r),E=m(W),d=n(W,"SELECT",{class:!0});var D=c(d);P=n(D,"OPTION",{});var _e=c(P);X=x(_e,"All"),_e.forEach(r);for(let de=0;de<f.length;de+=1)f[de].l(D);D.forEach(r),W.forEach(r),he.forEach(r),I=m(le),k=n(le,"DIV",{class:!0});var R=c(k);L=n(R,"DIV",{class:!0});var $e=c(L);J=x($e,"Number"),$e.forEach(r),Y=m(R),N=n(R,"DIV",{class:!0});var be=c(N);K=x(be,"First Name"),be.forEach(r),oe=m(R),G=n(R,"DIV",{class:!0});var De=c(G);z=x(De,"Last Name"),De.forEach(r),ie=m(R),Q=n(R,"DIV",{class:!0});var xe=c(Q);T=x(xe,"Position"),xe.forEach(r),ne=m(R),Z=n(R,"DIV",{class:!0});var we=c(Z);re=x(we,"Age"),we.forEach(r),A=m(R),U=n(R,"DIV",{class:!0});var Le=c(U);B=x(Le,"Nationality"),Le.forEach(r),ee=m(R),te=n(R,"DIV",{class:!0});var je=c(te);V=x(je,"Season Points"),je.forEach(r),se=m(R),ae=n(R,"DIV",{class:!0});var Ce=c(ae);me=x(Ce,"Value"),Ce.forEach(r),R.forEach(r),M=m(le);for(let de=0;de<b.length;de+=1)b[de].l(le);le.forEach(r),$.forEach(r),O.forEach(r),this.h()},h(){s(w,"class","text-sm md:text-xl mr-4"),P.__value=-1,P.value=P.__value,s(d,"class","p-2 fpl-dropdown text-sm md:text-xl"),l[0]===void 0&&ua(()=>l[4].call(d)),s(h,"class","flex items-center ml-4"),s(u,"class","flex p-4"),s(L,"class","flex-grow px-4 w-1/2"),s(N,"class","flex-grow px-4 w-1/2"),s(G,"class","flex-grow px-4 w-1/2"),s(Q,"class","flex-grow px-4 w-1/2"),s(Z,"class","flex-grow px-4 w-1/2"),s(U,"class","flex-grow px-4 w-1/2"),s(te,"class","flex-grow px-4 w-1/2"),s(ae,"class","flex-grow px-4 w-1/2"),s(k,"class","flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"),s(o,"class","flex flex-col space-y-4"),s(a,"class","container-fluid")},m(y,O){Me(y,a,O),e(a,o),e(o,t),e(t,u),e(u,h),e(h,w),e(w,S),e(h,E),e(h,d),e(d,P),e(P,X);for(let $=0;$<f.length;$+=1)f[$]&&f[$].m(d,null);Wt(d,l[0],!0),e(t,I),e(t,k),e(k,L),e(L,J),e(k,Y),e(k,N),e(N,K),e(k,oe),e(k,G),e(G,z),e(k,ie),e(k,Q),e(Q,T),e(k,ne),e(k,Z),e(Z,re),e(k,A),e(k,U),e(U,B),e(k,ee),e(k,te),e(te,V),e(k,se),e(k,ae),e(ae,me),e(t,M);for(let $=0;$<b.length;$+=1)b[$]&&b[$].m(t,null);ce=!0,ue||(_=Xt(d,"change",l[4]),ue=!0)},p(y,[O]){if(O&4){F=y[2];let $;for($=0;$<F.length;$+=1){const le=oa(y,F,$);f[$]?f[$].p(le,O):(f[$]=ia(le),f[$].c(),f[$].m(d,null))}for(;$<f.length;$+=1)f[$].d(1);f.length=F.length}if(O&5&&Wt(d,y[0]),O&2){j=y[1];let $;for($=0;$<j.length;$+=1){const le=sa(y,j,$);b[$]?(b[$].p(le,O),pe(b[$],1)):(b[$]=na(le),b[$].c(),pe(b[$],1),b[$].m(t,null))}for(Ht(),$=j.length;$<b.length;$+=1)q($);St()}},i(y){if(!ce){for(let O=0;O<j.length;O+=1)pe(b[O]);ce=!0}},o(y){b=b.filter(Boolean);for(let O=0;O<b.length;O+=1)ge(b[O]);ce=!1},d(y){y&&r(a),hl(f,y),hl(b,y),ue=!1,_()}}}function Va(l,a,o){let t,{players:u=[]}=a,h=-1,w=Object.values(wa).filter(E=>typeof E=="number");function S(){h=va(this),o(0,h),o(2,w)}return l.$$set=E=>{"players"in E&&o(3,u=E.players)},l.$$.update=()=>{l.$$.dirty&9&&o(1,t=h===-1?u:u.filter(E=>E.position===h))},[h,t,w,u,S]}class Ta extends pl{constructor(a){super(),_l(this,a,Va,Ca,gl,{players:3})}}function ca(l,a,o){const t=l.slice();return t[9]=a[o].fixture,t[10]=a[o].homeTeam,t[11]=a[o].awayTeam,t}function fa(l){let a,o,t=l[9].gameweek+"",u,h,w,S,E,d,P,X,I,k,L,J,Y,N,K,oe,G,z=aa(Number(l[9].kickOff))+"",ie,Q,T,ne=ra(Number(l[9].kickOff))+"",Z,re,A,U,B,ee=(l[10]?l[10].friendlyName:"")+"",te,V,se,ae,me=(l[11]?l[11].friendlyName:"")+"",M,ce,ue,_,F,f,j=(l[9].status===0?"-":l[9].homeGoals)+"",b,q,y,O=(l[9].status===0?"-":l[9].awayGoals)+"",$,le,he,W;return d=new Nt({props:{primaryColour:l[10]?l[10].primaryColourHex:"",secondaryColour:l[10]?l[10].secondaryColourHex:"",thirdColour:l[10]?l[10].thirdColourHex:""}}),N=new Nt({props:{primaryColour:l[11]?l[11].primaryColourHex:"",secondaryColour:l[11]?l[11].secondaryColourHex:"",thirdColour:l[11]?l[11].thirdColourHex:""}}),{c(){a=i("div"),o=i("div"),u=g(t),h=v(),w=i("div"),S=i("div"),E=i("a"),Ve(d.$$.fragment),X=v(),I=i("span"),k=g("v"),L=v(),J=i("div"),Y=i("a"),Ve(N.$$.fragment),oe=v(),G=i("div"),ie=g(z),Q=v(),T=i("div"),Z=g(ne),re=v(),A=i("div"),U=i("div"),B=i("a"),te=g(ee),se=v(),ae=i("a"),M=g(me),ue=v(),_=i("div"),F=i("div"),f=i("span"),b=g(j),q=v(),y=i("span"),$=g(O),le=v(),this.h()},l(C){a=n(C,"DIV",{class:!0});var D=c(a);o=n(D,"DIV",{class:!0});var _e=c(o);u=x(_e,t),_e.forEach(r),h=m(D),w=n(D,"DIV",{class:!0});var R=c(w);S=n(R,"DIV",{class:!0});var $e=c(S);E=n($e,"A",{href:!0});var be=c(E);He(d.$$.fragment,be),be.forEach(r),$e.forEach(r),X=m(R),I=n(R,"SPAN",{class:!0});var De=c(I);k=x(De,"v"),De.forEach(r),L=m(R),J=n(R,"DIV",{class:!0});var xe=c(J);Y=n(xe,"A",{href:!0});var we=c(Y);He(N.$$.fragment,we),we.forEach(r),xe.forEach(r),R.forEach(r),oe=m(D),G=n(D,"DIV",{class:!0});var Le=c(G);ie=x(Le,z),Le.forEach(r),Q=m(D),T=n(D,"DIV",{class:!0});var je=c(T);Z=x(je,ne),je.forEach(r),re=m(D),A=n(D,"DIV",{class:!0});var Ce=c(A);U=n(Ce,"DIV",{class:!0});var de=c(U);B=n(de,"A",{href:!0});var Ge=c(B);te=x(Ge,ee),Ge.forEach(r),se=m(de),ae=n(de,"A",{href:!0});var Se=c(ae);M=x(Se,me),Se.forEach(r),de.forEach(r),Ce.forEach(r),ue=m(D),_=n(D,"DIV",{class:!0});var Ne=c(_);F=n(Ne,"DIV",{class:!0});var Be=c(F);f=n(Be,"SPAN",{});var nt=c(f);b=x(nt,j),nt.forEach(r),q=m(Be),y=n(Be,"SPAN",{});var Ue=c(y);$=x(Ue,O),Ue.forEach(r),Be.forEach(r),Ne.forEach(r),le=m(D),D.forEach(r),this.h()},h(){s(o,"class","w-1/6 ml-4"),s(E,"href",P=`/club/${l[9].homeTeamId}`),s(S,"class","w-10 items-center justify-center mr-4"),s(I,"class","font-bold text-lg"),s(Y,"href",K=`/club/${l[9].awayTeamId}`),s(J,"class","w-10 items-center justify-center ml-4"),s(w,"class","w-1/3 flex justify-center"),s(G,"class","w-1/3"),s(T,"class","w-1/4 text-center"),s(B,"href",V=`/club/${l[9].homeTeamId}`),s(ae,"href",ce=`/club/${l[9].awayTeamId}`),s(U,"class","flex flex-col text-xs md:text-lg"),s(A,"class","w-1/3"),s(F,"class","flex flex-col text-xs md:text-lg"),s(_,"class","w-1/4 mr-4"),s(a,"class",he=`flex items-center justify-between border-b border-gray-700 p-2 px-4 ${l[9].status===0?"text-gray-400":"text-white"}`)},m(C,D){Me(C,a,D),e(a,o),e(o,u),e(a,h),e(a,w),e(w,S),e(S,E),Te(d,E,null),e(w,X),e(w,I),e(I,k),e(w,L),e(w,J),e(J,Y),Te(N,Y,null),e(a,oe),e(a,G),e(G,ie),e(a,Q),e(a,T),e(T,Z),e(a,re),e(a,A),e(A,U),e(U,B),e(B,te),e(U,se),e(U,ae),e(ae,M),e(a,ue),e(a,_),e(_,F),e(F,f),e(f,b),e(F,q),e(F,y),e(y,$),e(a,le),W=!0},p(C,D){(!W||D&2)&&t!==(t=C[9].gameweek+"")&&fe(u,t);const _e={};D&2&&(_e.primaryColour=C[10]?C[10].primaryColourHex:""),D&2&&(_e.secondaryColour=C[10]?C[10].secondaryColourHex:""),D&2&&(_e.thirdColour=C[10]?C[10].thirdColourHex:""),d.$set(_e),(!W||D&2&&P!==(P=`/club/${C[9].homeTeamId}`))&&s(E,"href",P);const R={};D&2&&(R.primaryColour=C[11]?C[11].primaryColourHex:""),D&2&&(R.secondaryColour=C[11]?C[11].secondaryColourHex:""),D&2&&(R.thirdColour=C[11]?C[11].thirdColourHex:""),N.$set(R),(!W||D&2&&K!==(K=`/club/${C[9].awayTeamId}`))&&s(Y,"href",K),(!W||D&2)&&z!==(z=aa(Number(C[9].kickOff))+"")&&fe(ie,z),(!W||D&2)&&ne!==(ne=ra(Number(C[9].kickOff))+"")&&fe(Z,ne),(!W||D&2)&&ee!==(ee=(C[10]?C[10].friendlyName:"")+"")&&fe(te,ee),(!W||D&2&&V!==(V=`/club/${C[9].homeTeamId}`))&&s(B,"href",V),(!W||D&2)&&me!==(me=(C[11]?C[11].friendlyName:"")+"")&&fe(M,me),(!W||D&2&&ce!==(ce=`/club/${C[9].awayTeamId}`))&&s(ae,"href",ce),(!W||D&2)&&j!==(j=(C[9].status===0?"-":C[9].homeGoals)+"")&&fe(b,j),(!W||D&2)&&O!==(O=(C[9].status===0?"-":C[9].awayGoals)+"")&&fe($,O),(!W||D&2&&he!==(he=`flex items-center justify-between border-b border-gray-700 p-2 px-4 ${C[9].status===0?"text-gray-400":"text-white"}`))&&s(a,"class",he)},i(C){W||(pe(d.$$.fragment,C),pe(N.$$.fragment,C),W=!0)},o(C){ge(d.$$.fragment,C),ge(N.$$.fragment,C),W=!1},d(C){C&&r(a),Pe(d),Pe(N)}}}function Pa(l){let a,o,t,u,h,w,S,E,d,P,X,I,k,L,J,Y,N,K,oe,G,z,ie,Q,T,ne,Z,re,A,U,B,ee,te,V,se,ae,me,M,ce,ue=l[1],_=[];for(let f=0;f<ue.length;f+=1)_[f]=fa(ca(l,ue,f));const F=f=>ge(_[f],1,1,()=>{_[f]=null});return{c(){a=i("div"),o=i("div"),t=i("div"),u=i("div"),h=i("div"),w=i("p"),S=g("Type:"),E=v(),d=i("select"),P=i("option"),X=g("All"),I=i("option"),k=g("Home"),L=i("option"),J=g("Away"),Y=v(),N=i("div"),K=i("div"),oe=g("Gameweek"),G=v(),z=i("div"),ie=g("Game"),Q=v(),T=i("div"),ne=g("Date"),Z=v(),re=i("div"),A=g("Time"),U=v(),B=i("div"),ee=g("Teams"),te=v(),V=i("div"),se=g("Result"),ae=v();for(let f=0;f<_.length;f+=1)_[f].c();this.h()},l(f){a=n(f,"DIV",{class:!0});var j=c(a);o=n(j,"DIV",{class:!0});var b=c(o);t=n(b,"DIV",{});var q=c(t);u=n(q,"DIV",{class:!0});var y=c(u);h=n(y,"DIV",{class:!0});var O=c(h);w=n(O,"P",{class:!0});var $=c(w);S=x($,"Type:"),$.forEach(r),E=m(O),d=n(O,"SELECT",{class:!0});var le=c(d);P=n(le,"OPTION",{});var he=c(P);X=x(he,"All"),he.forEach(r),I=n(le,"OPTION",{});var W=c(I);k=x(W,"Home"),W.forEach(r),L=n(le,"OPTION",{});var C=c(L);J=x(C,"Away"),C.forEach(r),le.forEach(r),O.forEach(r),y.forEach(r),Y=m(q),N=n(q,"DIV",{class:!0});var D=c(N);K=n(D,"DIV",{class:!0});var _e=c(K);oe=x(_e,"Gameweek"),_e.forEach(r),G=m(D),z=n(D,"DIV",{class:!0});var R=c(z);ie=x(R,"Game"),R.forEach(r),Q=m(D),T=n(D,"DIV",{class:!0});var $e=c(T);ne=x($e,"Date"),$e.forEach(r),Z=m(D),re=n(D,"DIV",{class:!0});var be=c(re);A=x(be,"Time"),be.forEach(r),U=m(D),B=n(D,"DIV",{class:!0});var De=c(B);ee=x(De,"Teams"),De.forEach(r),te=m(D),V=n(D,"DIV",{class:!0});var xe=c(V);se=x(xe,"Result"),xe.forEach(r),D.forEach(r),ae=m(q);for(let we=0;we<_.length;we+=1)_[we].l(q);q.forEach(r),b.forEach(r),j.forEach(r),this.h()},h(){s(w,"class","text-sm md:text-xl mr-4"),P.__value=-1,P.value=P.__value,I.__value=0,I.value=I.__value,L.__value=1,L.value=L.__value,s(d,"class","p-2 fpl-dropdown text-sm md:text-xl"),l[0]===void 0&&ua(()=>l[4].call(d)),s(h,"class","flex items-center ml-4"),s(u,"class","flex p-4"),s(K,"class","flex-grow w-1/6 ml-4"),s(z,"class","flex-grow w-1/3 text-center"),s(T,"class","flex-grow w-1/3"),s(re,"class","flex-grow w-1/4 text-center"),s(B,"class","flex-grow w-1/3"),s(V,"class","flex-grow w-1/4 mr-4"),s(N,"class","flex justify-between p-2 border border-gray-700 py-4 bg-light-gray px-4"),s(o,"class","flex flex-col space-y-4"),s(a,"class","container-fluid")},m(f,j){Me(f,a,j),e(a,o),e(o,t),e(t,u),e(u,h),e(h,w),e(w,S),e(h,E),e(h,d),e(d,P),e(P,X),e(d,I),e(I,k),e(d,L),e(L,J),Wt(d,l[0],!0),e(t,Y),e(t,N),e(N,K),e(K,oe),e(N,G),e(N,z),e(z,ie),e(N,Q),e(N,T),e(T,ne),e(N,Z),e(N,re),e(re,A),e(N,U),e(N,B),e(B,ee),e(N,te),e(N,V),e(V,se),e(t,ae);for(let b=0;b<_.length;b+=1)_[b]&&_[b].m(t,null);me=!0,M||(ce=Xt(d,"change",l[4]),M=!0)},p(f,[j]){if(j&1&&Wt(d,f[0]),j&2){ue=f[1];let b;for(b=0;b<ue.length;b+=1){const q=ca(f,ue,b);_[b]?(_[b].p(q,j),pe(_[b],1)):(_[b]=fa(q),_[b].c(),pe(_[b],1),_[b].m(t,null))}for(Ht(),b=ue.length;b<_.length;b+=1)F(b);St()}},i(f){if(!me){for(let j=0;j<ue.length;j+=1)pe(_[j]);me=!0}},o(f){_=_.filter(Boolean);for(let j=0;j<_.length;j+=1)ge(_[j]);me=!1},d(f){f&&r(a),hl(_,f),M=!1,ce()}}}function Na(l,a,o){let t;const u=new ha,h=new pa;let{clubId:w=null}=a,S=[],E=[],d=-1;ma(async()=>{try{await u.updateFixturesData(),await h.updateTeamsData();const I=await u.getFixtures();E=await h.getTeams(),o(3,S=I.map(L=>({fixture:L,homeTeam:P(L.homeTeamId),awayTeam:P(L.awayTeamId)})))}catch(I){console.error("Error fetching data:",I)}});function P(I){return E.find(k=>k.id===I)}function X(){d=va(this),o(0,d)}return l.$$set=I=>{"clubId"in I&&o(2,w=I.clubId)},l.$$.update=()=>{l.$$.dirty&13&&o(1,t=d===-1?S.filter(({fixture:I})=>w==null||I.homeTeamId===w||I.awayTeamId===w):d===0?S.filter(({fixture:I})=>w==null||I.homeTeamId===w):S.filter(({fixture:I})=>w==null||I.awayTeamId===w))},[d,t,w,S,X]}class ka extends pl{constructor(a){super(),_l(this,a,Na,Pa,gl,{clubId:2})}}function Ha(l){let a,o,t,u,h,w=l[1]?.friendlyName+"",S,E,d,P,X,I,k,L,J=l[1]?.abbreviatedName+"",Y,N,K,oe,G,z,ie,Q,T,ne=l[2].length+"",Z,re,A,U,B,ee,te,V,se,ae,me,M,ce=l[10](l[8])+"",ue,_,F,f=l[0].name+"",j,b,q,y,O,$,le,he,W=l[11](l[8])+"",C,D,_e,R,$e,be,De,xe,we,Le,je,Ce,de,Ge,Se,Ne,Be,nt,Ue,ct,Yt,Zt,ft,lt,Je,At,el,Ae,ut,dt,Ke,It=l[3]?.abbreviatedName+"",Ft,Ot,tl,$t,ll,vt,mt,Qe,Dt=l[4]?.abbreviatedName+"",Lt,jt,al,at,rl,Fe,ht,sl,ol,pt,Ct=l[5]?.lastName+"",Gt,il,Re,Vt=kt(l[5]?.position??0)+"",Bt,nl,Tt=l[5]?.totalPoints+"",Ut,cl,Rt,rt,qe,We,st,Xe,fl,qt,zt,ul,ot,Ye,dl,Mt,Jt,vl,ye,Ee,ve,ml,xl;P=new Nt({props:{className:"h-10",primaryColour:l[1]?.primaryColourHex,secondaryColour:l[1]?.secondaryColourHex,thirdColour:l[1]?.thirdColourHex}}),I=new $a({props:{className:"h-10",primaryColour:l[1]?.primaryColourHex,secondaryColour:l[1]?.secondaryColourHex,thirdColour:l[1]?.thirdColourHex}}),Ne=new Nt({props:{primaryColour:l[3]?.primaryColourHex,secondaryColour:l[3]?.secondaryColourHex,thirdColour:l[3]?.thirdColourHex}}),Je=new Nt({props:{primaryColour:l[4]?.primaryColourHex,secondaryColour:l[4]?.secondaryColourHex,thirdColour:l[4]?.thirdColourHex}});const bl=[Fa,Aa],Ze=[];function wl(p,H){return p[7]==="players"?0:p[7]==="fixtures"?1:-1}return~(ye=wl(l))&&(Ee=Ze[ye]=bl[ye](l)),{c(){a=i("div"),o=i("div"),t=i("div"),u=i("div"),h=i("p"),S=g(w),E=v(),d=i("div"),Ve(P.$$.fragment),X=v(),Ve(I.$$.fragment),k=v(),L=i("p"),Y=g(J),N=v(),K=i("div"),oe=v(),G=i("div"),z=i("p"),ie=g("Players"),Q=v(),T=i("p"),Z=g(ne),re=v(),A=i("p"),U=g("Total"),B=v(),ee=i("div"),te=v(),V=i("div"),se=i("p"),ae=g("League Position"),me=v(),M=i("p"),ue=g(ce),_=v(),F=i("p"),j=g(f),b=v(),q=i("div"),y=i("div"),O=i("p"),$=g("League Points"),le=v(),he=i("p"),C=g(W),D=v(),_e=i("p"),R=g("Total"),$e=v(),be=i("div"),De=v(),xe=i("div"),we=i("p"),Le=g("Next Game:"),je=v(),Ce=i("div"),de=i("div"),Ge=i("div"),Se=i("a"),Ve(Ne.$$.fragment),nt=v(),Ue=i("div"),ct=i("p"),Yt=g("v"),Zt=v(),ft=i("div"),lt=i("a"),Ve(Je.$$.fragment),el=v(),Ae=i("div"),ut=i("div"),dt=i("p"),Ke=i("a"),Ft=g(It),tl=v(),$t=i("div"),ll=v(),vt=i("div"),mt=i("p"),Qe=i("a"),Lt=g(Dt),al=v(),at=i("div"),rl=v(),Fe=i("div"),ht=i("p"),sl=g("Highest Scoring Player"),ol=v(),pt=i("p"),Gt=g(Ct),il=v(),Re=i("p"),Bt=g(Vt),nl=g(`
              (`),Ut=g(Tt),cl=g(")"),Rt=v(),rt=i("div"),qe=i("div"),We=i("ul"),st=i("li"),Xe=i("button"),fl=g("Players"),ul=v(),ot=i("li"),Ye=i("button"),dl=g("Fixtures"),vl=v(),Ee&&Ee.c(),this.h()},l(p){a=n(p,"DIV",{class:!0});var H=c(a);o=n(H,"DIV",{class:!0});var ze=c(o);t=n(ze,"DIV",{class:!0});var Ie=c(t);u=n(Ie,"DIV",{class:!0});var ke=c(u);h=n(ke,"P",{class:!0});var it=c(h);S=x(it,w),it.forEach(r),E=m(ke),d=n(ke,"DIV",{class:!0});var et=c(d);He(P.$$.fragment,et),X=m(et),He(I.$$.fragment,et),et.forEach(r),k=m(ke),L=n(ke,"P",{class:!0});var yl=c(L);Y=x(yl,J),yl.forEach(r),ke.forEach(r),N=m(Ie),K=n(Ie,"DIV",{class:!0,style:!0}),c(K).forEach(r),oe=m(Ie),G=n(Ie,"DIV",{class:!0});var _t=c(G);z=n(_t,"P",{class:!0});var El=c(z);ie=x(El,"Players"),El.forEach(r),Q=m(_t),T=n(_t,"P",{class:!0});var Il=c(T);Z=x(Il,ne),Il.forEach(r),re=m(_t),A=n(_t,"P",{class:!0});var $l=c(A);U=x($l,"Total"),$l.forEach(r),_t.forEach(r),B=m(Ie),ee=n(Ie,"DIV",{class:!0,style:!0}),c(ee).forEach(r),te=m(Ie),V=n(Ie,"DIV",{class:!0});var gt=c(V);se=n(gt,"P",{class:!0});var Dl=c(se);ae=x(Dl,"League Position"),Dl.forEach(r),me=m(gt),M=n(gt,"P",{class:!0});var Cl=c(M);ue=x(Cl,ce),Cl.forEach(r),_=m(gt),F=n(gt,"P",{class:!0});var Vl=c(F);j=x(Vl,f),Vl.forEach(r),gt.forEach(r),Ie.forEach(r),b=m(ze),q=n(ze,"DIV",{class:!0});var Oe=c(q);y=n(Oe,"DIV",{class:!0});var xt=c(y);O=n(xt,"P",{class:!0});var Tl=c(O);$=x(Tl,"League Points"),Tl.forEach(r),le=m(xt),he=n(xt,"P",{class:!0});var Pl=c(he);C=x(Pl,W),Pl.forEach(r),D=m(xt),_e=n(xt,"P",{class:!0});var Nl=c(_e);R=x(Nl,"Total"),Nl.forEach(r),xt.forEach(r),$e=m(Oe),be=n(Oe,"DIV",{class:!0,style:!0}),c(be).forEach(r),De=m(Oe),xe=n(Oe,"DIV",{class:!0});var bt=c(xe);we=n(bt,"P",{class:!0});var kl=c(we);Le=x(kl,"Next Game:"),kl.forEach(r),je=m(bt),Ce=n(bt,"DIV",{class:!0});var Hl=c(Ce);de=n(Hl,"DIV",{class:!0});var wt=c(de);Ge=n(wt,"DIV",{class:!0});var Sl=c(Ge);Se=n(Sl,"A",{href:!0});var Al=c(Se);He(Ne.$$.fragment,Al),Al.forEach(r),Sl.forEach(r),nt=m(wt),Ue=n(wt,"DIV",{class:!0});var Fl=c(Ue);ct=n(Fl,"P",{class:!0});var Ol=c(ct);Yt=x(Ol,"v"),Ol.forEach(r),Fl.forEach(r),Zt=m(wt),ft=n(wt,"DIV",{class:!0});var Ll=c(ft);lt=n(Ll,"A",{href:!0});var jl=c(lt);He(Je.$$.fragment,jl),jl.forEach(r),Ll.forEach(r),wt.forEach(r),Hl.forEach(r),el=m(bt),Ae=n(bt,"DIV",{class:!0});var yt=c(Ae);ut=n(yt,"DIV",{class:!0});var Gl=c(ut);dt=n(Gl,"P",{class:!0});var Bl=c(dt);Ke=n(Bl,"A",{class:!0,href:!0});var Ul=c(Ke);Ft=x(Ul,It),Ul.forEach(r),Bl.forEach(r),Gl.forEach(r),tl=m(yt),$t=n(yt,"DIV",{class:!0}),c($t).forEach(r),ll=m(yt),vt=n(yt,"DIV",{class:!0});var Rl=c(vt);mt=n(Rl,"P",{class:!0});var ql=c(mt);Qe=n(ql,"A",{class:!0,href:!0});var zl=c(Qe);Lt=x(zl,Dt),zl.forEach(r),ql.forEach(r),Rl.forEach(r),yt.forEach(r),bt.forEach(r),al=m(Oe),at=n(Oe,"DIV",{class:!0,style:!0}),c(at).forEach(r),rl=m(Oe),Fe=n(Oe,"DIV",{class:!0});var Et=c(Fe);ht=n(Et,"P",{class:!0});var Ml=c(ht);sl=x(Ml,"Highest Scoring Player"),Ml.forEach(r),ol=m(Et),pt=n(Et,"P",{class:!0});var Jl=c(pt);Gt=x(Jl,Ct),Jl.forEach(r),il=m(Et),Re=n(Et,"P",{class:!0});var Pt=c(Re);Bt=x(Pt,Vt),nl=x(Pt,`
              (`),Ut=x(Pt,Tt),cl=x(Pt,")"),Pt.forEach(r),Et.forEach(r),Oe.forEach(r),ze.forEach(r),H.forEach(r),Rt=m(p),rt=n(p,"DIV",{class:!0});var Kl=c(rt);qe=n(Kl,"DIV",{class:!0});var Kt=c(qe);We=n(Kt,"UL",{class:!0});var Qt=c(We);st=n(Qt,"LI",{class:!0});var Ql=c(st);Xe=n(Ql,"BUTTON",{class:!0});var Wl=c(Xe);fl=x(Wl,"Players"),Wl.forEach(r),Ql.forEach(r),ul=m(Qt),ot=n(Qt,"LI",{class:!0});var Xl=c(ot);Ye=n(Xl,"BUTTON",{class:!0});var Yl=c(Ye);dl=x(Yl,"Fixtures"),Yl.forEach(r),Xl.forEach(r),Qt.forEach(r),vl=m(Kt),Ee&&Ee.l(Kt),Kt.forEach(r),Kl.forEach(r),this.h()},h(){s(h,"class","text-gray-300 text-xs"),s(d,"class","py-2 flex space-x-4"),s(L,"class","text-gray-300 text-xs"),s(u,"class","flex-grow flex flex-col items-center"),s(K,"class","flex-shrink-0 w-px bg-gray-400 self-stretch"),tt(K,"min-width","2px"),tt(K,"min-height","50px"),s(z,"class","text-gray-300 text-xs"),s(T,"class","text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),s(A,"class","text-gray-300 text-xs"),s(G,"class","flex-grow"),s(ee,"class","flex-shrink-0 w-px bg-gray-400 self-stretch"),tt(ee,"min-width","2px"),tt(ee,"min-height","50px"),s(se,"class","text-gray-300 text-xs"),s(M,"class","text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),s(F,"class","text-gray-300 text-xs"),s(V,"class","flex-grow"),s(t,"class","flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"),s(O,"class","text-gray-300 text-xs"),s(he,"class","text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),s(_e,"class","text-gray-300 text-xs"),s(y,"class","flex-grow mb-4 md:mb-0"),s(be,"class","h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"),tt(be,"min-height","2px"),tt(be,"min-width","2px"),s(we,"class","text-gray-300 text-xs"),s(Se,"href",Be=`/club/${l[3]?.id}`),s(Ge,"class","w-10 ml-4 mr-4"),s(ct,"class","text-xs mt-2 mb-2 font-bold"),s(Ue,"class","w-v ml-1 mr-1 flex justify-center"),s(lt,"href",At=`/club/${l[4]?.id}`),s(ft,"class","w-10 ml-4"),s(de,"class","flex justify-center items-center"),s(Ce,"class","flex justify-center mb-2 mt-2"),s(Ke,"class","text-gray-300 text-xs text-center"),s(Ke,"href",Ot=`/club/${l[3]?.id}`),s(dt,"class","text-gray-300 text-xs text-center"),s(ut,"class","w-10 ml-4 mr-4"),s($t,"class","w-v ml-1 mr-1"),s(Qe,"class","text-gray-300 text-xs text-center"),s(Qe,"href",jt=`/club/${l[4]?.id}`),s(mt,"class","text-gray-300 text-xs text-center"),s(vt,"class","w-10 ml-4"),s(Ae,"class","flex justify-center"),s(xe,"class","flex-grow mb-4 md:mb-0"),s(at,"class","h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"),tt(at,"min-height","2px"),tt(at,"min-width","2px"),s(ht,"class","text-gray-300 text-xs mt-4 md:mt-0"),s(pt,"class","text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),s(Re,"class","text-gray-300 text-xs"),s(Fe,"class","flex-grow"),s(q,"class","flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"),s(o,"class","flex flex-col md:flex-row"),s(a,"class","m-4"),s(Xe,"class",qt=`p-2 ${l[7]==="players"?"text-white":"text-gray-400"}`),s(st,"class",zt=`mr-4 text-xs md:text-lg ${l[7]==="players"?"active-tab":""}`),s(Ye,"class",Mt=`p-2 ${l[7]==="fixtures"?"text-white":"text-gray-400"}`),s(ot,"class",Jt=`mr-4 text-xs md:text-lg ${l[7]==="fixtures"?"active-tab":""}`),s(We,"class","flex bg-light-gray px-4 pt-2"),s(qe,"class","bg-panel rounded-md m-4"),s(rt,"class","m-4")},m(p,H){Me(p,a,H),e(a,o),e(o,t),e(t,u),e(u,h),e(h,S),e(u,E),e(u,d),Te(P,d,null),e(d,X),Te(I,d,null),e(u,k),e(u,L),e(L,Y),e(t,N),e(t,K),e(t,oe),e(t,G),e(G,z),e(z,ie),e(G,Q),e(G,T),e(T,Z),e(G,re),e(G,A),e(A,U),e(t,B),e(t,ee),e(t,te),e(t,V),e(V,se),e(se,ae),e(V,me),e(V,M),e(M,ue),e(V,_),e(V,F),e(F,j),e(o,b),e(o,q),e(q,y),e(y,O),e(O,$),e(y,le),e(y,he),e(he,C),e(y,D),e(y,_e),e(_e,R),e(q,$e),e(q,be),e(q,De),e(q,xe),e(xe,we),e(we,Le),e(xe,je),e(xe,Ce),e(Ce,de),e(de,Ge),e(Ge,Se),Te(Ne,Se,null),e(de,nt),e(de,Ue),e(Ue,ct),e(ct,Yt),e(de,Zt),e(de,ft),e(ft,lt),Te(Je,lt,null),e(xe,el),e(xe,Ae),e(Ae,ut),e(ut,dt),e(dt,Ke),e(Ke,Ft),e(Ae,tl),e(Ae,$t),e(Ae,ll),e(Ae,vt),e(vt,mt),e(mt,Qe),e(Qe,Lt),e(q,al),e(q,at),e(q,rl),e(q,Fe),e(Fe,ht),e(ht,sl),e(Fe,ol),e(Fe,pt),e(pt,Gt),e(Fe,il),e(Fe,Re),e(Re,Bt),e(Re,nl),e(Re,Ut),e(Re,cl),Me(p,Rt,H),Me(p,rt,H),e(rt,qe),e(qe,We),e(We,st),e(st,Xe),e(Xe,fl),e(We,ul),e(We,ot),e(ot,Ye),e(Ye,dl),e(qe,vl),~ye&&Ze[ye].m(qe,null),ve=!0,ml||(xl=[Xt(Xe,"click",l[16]),Xt(Ye,"click",l[17])],ml=!0)},p(p,H){(!ve||H&2)&&w!==(w=p[1]?.friendlyName+"")&&fe(S,w);const ze={};H&2&&(ze.primaryColour=p[1]?.primaryColourHex),H&2&&(ze.secondaryColour=p[1]?.secondaryColourHex),H&2&&(ze.thirdColour=p[1]?.thirdColourHex),P.$set(ze);const Ie={};H&2&&(Ie.primaryColour=p[1]?.primaryColourHex),H&2&&(Ie.secondaryColour=p[1]?.secondaryColourHex),H&2&&(Ie.thirdColour=p[1]?.thirdColourHex),I.$set(Ie),(!ve||H&2)&&J!==(J=p[1]?.abbreviatedName+"")&&fe(Y,J),(!ve||H&4)&&ne!==(ne=p[2].length+"")&&fe(Z,ne),(!ve||H&256)&&ce!==(ce=p[10](p[8])+"")&&fe(ue,ce),(!ve||H&1)&&f!==(f=p[0].name+"")&&fe(j,f),(!ve||H&256)&&W!==(W=p[11](p[8])+"")&&fe(C,W);const ke={};H&8&&(ke.primaryColour=p[3]?.primaryColourHex),H&8&&(ke.secondaryColour=p[3]?.secondaryColourHex),H&8&&(ke.thirdColour=p[3]?.thirdColourHex),Ne.$set(ke),(!ve||H&8&&Be!==(Be=`/club/${p[3]?.id}`))&&s(Se,"href",Be);const it={};H&16&&(it.primaryColour=p[4]?.primaryColourHex),H&16&&(it.secondaryColour=p[4]?.secondaryColourHex),H&16&&(it.thirdColour=p[4]?.thirdColourHex),Je.$set(it),(!ve||H&16&&At!==(At=`/club/${p[4]?.id}`))&&s(lt,"href",At),(!ve||H&8)&&It!==(It=p[3]?.abbreviatedName+"")&&fe(Ft,It),(!ve||H&8&&Ot!==(Ot=`/club/${p[3]?.id}`))&&s(Ke,"href",Ot),(!ve||H&16)&&Dt!==(Dt=p[4]?.abbreviatedName+"")&&fe(Lt,Dt),(!ve||H&16&&jt!==(jt=`/club/${p[4]?.id}`))&&s(Qe,"href",jt),(!ve||H&32)&&Ct!==(Ct=p[5]?.lastName+"")&&fe(Gt,Ct),(!ve||H&32)&&Vt!==(Vt=kt(p[5]?.position??0)+"")&&fe(Bt,Vt),(!ve||H&32)&&Tt!==(Tt=p[5]?.totalPoints+"")&&fe(Ut,Tt),(!ve||H&128&&qt!==(qt=`p-2 ${p[7]==="players"?"text-white":"text-gray-400"}`))&&s(Xe,"class",qt),(!ve||H&128&&zt!==(zt=`mr-4 text-xs md:text-lg ${p[7]==="players"?"active-tab":""}`))&&s(st,"class",zt),(!ve||H&128&&Mt!==(Mt=`p-2 ${p[7]==="fixtures"?"text-white":"text-gray-400"}`))&&s(Ye,"class",Mt),(!ve||H&128&&Jt!==(Jt=`mr-4 text-xs md:text-lg ${p[7]==="fixtures"?"active-tab":""}`))&&s(ot,"class",Jt);let et=ye;ye=wl(p),ye===et?~ye&&Ze[ye].p(p,H):(Ee&&(Ht(),ge(Ze[et],1,1,()=>{Ze[et]=null}),St()),~ye?(Ee=Ze[ye],Ee?Ee.p(p,H):(Ee=Ze[ye]=bl[ye](p),Ee.c()),pe(Ee,1),Ee.m(qe,null)):Ee=null)},i(p){ve||(pe(P.$$.fragment,p),pe(I.$$.fragment,p),pe(Ne.$$.fragment,p),pe(Je.$$.fragment,p),pe(Ee),ve=!0)},o(p){ge(P.$$.fragment,p),ge(I.$$.fragment,p),ge(Ne.$$.fragment,p),ge(Je.$$.fragment,p),ge(Ee),ve=!1},d(p){p&&r(a),Pe(P),Pe(I),Pe(Ne),Pe(Je),p&&r(Rt),p&&r(rt),~ye&&Ze[ye].d(),ml=!1,ga(xl)}}}function Sa(l){let a,o;return a=new ba({props:{progress:ja}}),{c(){Ve(a.$$.fragment)},l(t){He(a.$$.fragment,t)},m(t,u){Te(a,t,u),o=!0},p:da,i(t){o||(pe(a.$$.fragment,t),o=!0)},o(t){ge(a.$$.fragment,t),o=!1},d(t){Pe(a,t)}}}function Aa(l){let a,o;return a=new ka({props:{clubId:l[8]}}),{c(){Ve(a.$$.fragment)},l(t){He(a.$$.fragment,t)},m(t,u){Te(a,t,u),o=!0},p(t,u){const h={};u&256&&(h.clubId=t[8]),a.$set(h)},i(t){o||(pe(a.$$.fragment,t),o=!0)},o(t){ge(a.$$.fragment,t),o=!1},d(t){Pe(a,t)}}}function Fa(l){let a,o;return a=new Ta({props:{players:l[2]}}),{c(){Ve(a.$$.fragment)},l(t){He(a.$$.fragment,t)},m(t,u){Te(a,t,u),o=!0},p(t,u){const h={};u&4&&(h.players=t[2]),a.$set(h)},i(t){o||(pe(a.$$.fragment,t),o=!0)},o(t){ge(a.$$.fragment,t),o=!1},d(t){Pe(a,t)}}}function Oa(l){let a,o,t,u;const h=[Sa,Ha],w=[];function S(E,d){return E[6]?0:1}return a=S(l),o=w[a]=h[a](l),{c(){o.c(),t=ea()},l(E){o.l(E),t=ea()},m(E,d){w[a].m(E,d),Me(E,t,d),u=!0},p(E,d){let P=a;a=S(E),a===P?w[a].p(E,d):(Ht(),ge(w[P],1,1,()=>{w[P]=null}),St(),o=w[a],o?o.p(E,d):(o=w[a]=h[a](E),o.c()),pe(o,1),o.m(t.parentNode,t))},i(E){u||(pe(o),u=!0)},o(E){ge(o),u=!1},d(E){w[a].d(E),E&&r(t)}}}function La(l){let a,o;return a=new xa({props:{$$slots:{default:[Oa]},$$scope:{ctx:l}}}),{c(){Ve(a.$$.fragment)},l(t){He(a.$$.fragment,t)},m(t,u){Te(a,t,u),o=!0},p(t,[u]){const h={};u&33554943&&(h.$$scope={dirty:u,ctx:t}),a.$set(h)},i(t){o||(pe(a.$$.fragment,t),o=!0)},o(t){ge(a.$$.fragment,t),o=!1},d(t){Pe(a,t)}}}let ja=0;function Ga(l,a,o){let t,u;_a(l,Ia,A=>o(15,u=A));const h=new ha,w=new pa,S=new ya,E=new Da;let d=1,P,X=[],I=[],k=null,L=[],J=null,Y=null,N=null,K=null,oe=!0,G="players";ma(async()=>{try{await S.updateSystemStateData(),await h.updateFixturesData(),await w.updateTeamsData(),await E.updatePlayersData(),await E.updatePlayerEventsData();const A=await h.getFixtures(),U=await w.getTeams(),B=await E.getPlayers();o(14,I=U),o(1,k=U.find(V=>V.id==t)??null);let ee=A.filter(V=>V.homeTeamId==t||V.awayTeamId==t);o(13,X=ee.map(V=>({fixture:V,homeTeam:ie(V.homeTeamId),awayTeam:ie(V.awayTeamId)}))),o(2,L=B.filter(V=>V.teamId==t)),o(5,K=L.sort((V,se)=>V.totalPoints-se.totalPoints).sort((V,se)=>Number(se.value)-Number(V.value))[0]);let te=await S.getSystemState();o(12,d=te?.activeGameweek??d),o(0,P=te?.activeSeason??P),J=ee.find(V=>V.gameweek==d)??null,o(3,Y=ie(J?.homeTeamId??0)??null),o(4,N=ie(J?.awayTeamId??0)??null),o(6,oe=!1)}catch(A){console.error("Error fetching data:",A)}});let z=[];function ie(A){return I.find(U=>U.id===A)}function Q(A){o(7,G=A)}const T=A=>{const U=z.findIndex(B=>B.id===A);return U!==-1?U+1:"Not found"},ne=A=>z.find(B=>B.id===A).points,Z=()=>Q("players"),re=()=>Q("fixtures");return l.$$.update=()=>{l.$$.dirty&32768&&o(8,t=Number(u.url.searchParams.get("id"))),l.$$.dirty&28672&&X.length>0&&I.length>0&&(z=Ea(X,I,d))},[P,k,L,Y,N,K,oe,G,t,Q,T,ne,d,X,I,u,Z,re]}class Ka extends pl{constructor(a){super(),_l(this,a,Ga,La,gl,{})}}export{Ka as component};