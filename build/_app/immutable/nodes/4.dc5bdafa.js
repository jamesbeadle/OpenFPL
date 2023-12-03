import{s as xe,f as y,l as q,a as O,g as w,h as $,m as R,d as g,c as F,j as v,A as tt,i as X,x as o,B as He,C as Z,D as we,E as Ee,o as Ie,F as Qe,G as at,y as Ze,n as le,H as st,I as ne,z as lt,J as rt,O as ot,e as Le}from"../chunks/scheduler.2037d42e.js";import{S as $e,i as Ce,a as H,g as ve,c as ge,t as P,b as ee,d as te,m as ae,e as se}from"../chunks/index.cd713282.js";import{e as re,t as Pe,f as Be,s as oe,a as et,b as je,A as nt,q as it,c as Ue,k as ut,L as ct}from"../chunks/Layout.b983af79.js";import{B as qe}from"../chunks/BadgeIcon.de5ce3c9.js";import{w as ft}from"../chunks/singletons.4e632dcd.js";import{M as dt}from"../chunks/Modal.0b5343e4.js";import{L as mt}from"../chunks/LoadingIcon.64dacd79.js";function Re(s,e,a){const t=s.slice();return t[17]=e[a][0],t[2]=e[a][1],t}function Ge(s,e,a){const t=s.slice();return t[20]=e[a].fixture,t[21]=e[a].homeTeam,t[22]=e[a].awayTeam,t}function Ke(s,e,a){const t=s.slice();return t[25]=e[a],t}function ze(s){let e,a,t=s[25]+"",l;return{c(){e=y("option"),a=q("Gameweek "),l=q(t),this.h()},l(n){e=w(n,"OPTION",{});var h=$(e);a=R(h,"Gameweek "),l=R(h,t),h.forEach(g),this.h()},h(){e.__value=s[25],at(e,e.__value)},m(n,h){X(n,e,h),o(e,a),o(e,l)},p:Ze,d(n){n&&g(e)}}}function Je(s){let e,a,t,l,n,h,C,b,i,c="v",S,r,d,m,T,D,V,N,p=je(Number(s[20].kickOff))+"",x,M,f,k,u,E=(s[21]?s[21].friendlyName:"")+"",_,L,j,U,J=(s[22]?s[22].friendlyName:"")+"",Y,Q,G,W,ie,ue=(s[20].status===0?"-":s[20].homeGoals)+"",de,ye,ce,fe=(s[20].status===0?"-":s[20].awayGoals)+"",me,he,B;return h=new qe({props:{primaryColour:s[21]?s[21].primaryColourHex:"",secondaryColour:s[21]?s[21].secondaryColourHex:"",thirdColour:s[21]?s[21].thirdColourHex:""}}),m=new qe({props:{primaryColour:s[22]?s[22].primaryColourHex:"",secondaryColour:s[22]?s[22].secondaryColourHex:"",thirdColour:s[22]?s[22].thirdColourHex:""}}),{c(){e=y("div"),a=y("div"),t=y("div"),l=y("div"),n=y("a"),ee(h.$$.fragment),b=O(),i=y("span"),i.textContent=c,S=O(),r=y("div"),d=y("a"),ee(m.$$.fragment),D=O(),V=y("div"),N=y("span"),x=q(p),M=O(),f=y("div"),k=y("div"),u=y("a"),_=q(E),j=O(),U=y("a"),Y=q(J),G=O(),W=y("div"),ie=y("span"),de=q(ue),ye=O(),ce=y("span"),me=q(fe),this.h()},l(I){e=w(I,"DIV",{class:!0});var A=$(e);a=w(A,"DIV",{class:!0});var z=$(a);t=w(z,"DIV",{class:!0});var K=$(t);l=w(K,"DIV",{class:!0});var ke=$(l);n=w(ke,"A",{href:!0});var Te=$(n);te(h.$$.fragment,Te),Te.forEach(g),ke.forEach(g),b=F(K),i=w(K,"SPAN",{class:!0,"data-svelte-h":!0}),ne(i)!=="svelte-t2hdpb"&&(i.textContent=c),S=F(K),r=w(K,"DIV",{class:!0});var Se=$(r);d=w(Se,"A",{href:!0});var De=$(d);te(m.$$.fragment,De),De.forEach(g),Se.forEach(g),K.forEach(g),D=F(z),V=w(z,"DIV",{class:!0});var Ne=$(V);N=w(Ne,"SPAN",{class:!0});var Ae=$(N);x=R(Ae,p),Ae.forEach(g),Ne.forEach(g),z.forEach(g),M=F(A),f=w(A,"DIV",{class:!0});var _e=$(f);k=w(_e,"DIV",{class:!0});var pe=$(k);u=w(pe,"A",{href:!0});var Me=$(u);_=R(Me,E),Me.forEach(g),j=F(pe),U=w(pe,"A",{href:!0});var Ve=$(U);Y=R(Ve,J),Ve.forEach(g),pe.forEach(g),G=F(_e),W=w(_e,"DIV",{class:!0});var be=$(W);ie=w(be,"SPAN",{});var Oe=$(ie);de=R(Oe,ue),Oe.forEach(g),ye=F(be),ce=w(be,"SPAN",{});var Fe=$(ce);me=R(Fe,fe),Fe.forEach(g),be.forEach(g),_e.forEach(g),A.forEach(g),this.h()},h(){v(n,"href",C=`/club?id=${s[20].homeTeamId}`),v(l,"class","w-10 items-center justify-center"),v(i,"class","font-bold text-lg"),v(d,"href",T=`/club?id=${s[20].awayTeamId}`),v(r,"class","w-10 items-center justify-center"),v(t,"class","flex w-1/2 space-x-4 justify-center"),v(N,"class","text-sm md:text-lg ml-4 md:ml-0 text-left"),v(V,"class","flex w-1/2 lg:justify-center"),v(a,"class","flex items-center w-1/2 ml-4"),v(u,"href",L=`/club?id=${s[20].homeTeamId}`),v(U,"href",Q=`/club?id=${s[20].awayTeamId}`),v(k,"class","flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"),v(W,"class","flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"),v(f,"class","flex items-center space-x-10 w-1/2 lg:justify-center"),v(e,"class",he=`flex items-center justify-between py-2 border-b border-gray-700  ${s[20].status===0?"text-gray-400":"text-white"}`)},m(I,A){X(I,e,A),o(e,a),o(a,t),o(t,l),o(l,n),ae(h,n,null),o(t,b),o(t,i),o(t,S),o(t,r),o(r,d),ae(m,d,null),o(a,D),o(a,V),o(V,N),o(N,x),o(e,M),o(e,f),o(f,k),o(k,u),o(u,_),o(k,j),o(k,U),o(U,Y),o(f,G),o(f,W),o(W,ie),o(ie,de),o(W,ye),o(W,ce),o(ce,me),B=!0},p(I,A){const z={};A&2&&(z.primaryColour=I[21]?I[21].primaryColourHex:""),A&2&&(z.secondaryColour=I[21]?I[21].secondaryColourHex:""),A&2&&(z.thirdColour=I[21]?I[21].thirdColourHex:""),h.$set(z),(!B||A&2&&C!==(C=`/club?id=${I[20].homeTeamId}`))&&v(n,"href",C);const K={};A&2&&(K.primaryColour=I[22]?I[22].primaryColourHex:""),A&2&&(K.secondaryColour=I[22]?I[22].secondaryColourHex:""),A&2&&(K.thirdColour=I[22]?I[22].thirdColourHex:""),m.$set(K),(!B||A&2&&T!==(T=`/club?id=${I[20].awayTeamId}`))&&v(d,"href",T),(!B||A&2)&&p!==(p=je(Number(I[20].kickOff))+"")&&le(x,p),(!B||A&2)&&E!==(E=(I[21]?I[21].friendlyName:"")+"")&&le(_,E),(!B||A&2&&L!==(L=`/club?id=${I[20].homeTeamId}`))&&v(u,"href",L),(!B||A&2)&&J!==(J=(I[22]?I[22].friendlyName:"")+"")&&le(Y,J),(!B||A&2&&Q!==(Q=`/club?id=${I[20].awayTeamId}`))&&v(U,"href",Q),(!B||A&2)&&ue!==(ue=(I[20].status===0?"-":I[20].homeGoals)+"")&&le(de,ue),(!B||A&2)&&fe!==(fe=(I[20].status===0?"-":I[20].awayGoals)+"")&&le(me,fe),(!B||A&2&&he!==(he=`flex items-center justify-between py-2 border-b border-gray-700  ${I[20].status===0?"text-gray-400":"text-white"}`))&&v(e,"class",he)},i(I){B||(H(h.$$.fragment,I),H(m.$$.fragment,I),B=!0)},o(I){P(h.$$.fragment,I),P(m.$$.fragment,I),B=!1},d(I){I&&g(e),se(h),se(m)}}}function We(s){let e,a,t,l=s[17]+"",n,h,C,b,i=re(s[2]),c=[];for(let r=0;r<i.length;r+=1)c[r]=Je(Ge(s,i,r));const S=r=>P(c[r],1,1,()=>{c[r]=null});return{c(){e=y("div"),a=y("div"),t=y("h2"),n=q(l),h=O();for(let r=0;r<c.length;r+=1)c[r].c();C=O(),this.h()},l(r){e=w(r,"DIV",{});var d=$(e);a=w(d,"DIV",{class:!0});var m=$(a);t=w(m,"H2",{class:!0});var T=$(t);n=R(T,l),T.forEach(g),m.forEach(g),h=F(d);for(let D=0;D<c.length;D+=1)c[D].l(d);C=F(d),d.forEach(g),this.h()},h(){v(t,"class","date-header ml-4 text-xs md:text-base"),v(a,"class","flex items-center justify-between border border-gray-700 py-4 bg-light-gray")},m(r,d){X(r,e,d),o(e,a),o(a,t),o(t,n),o(e,h);for(let m=0;m<c.length;m+=1)c[m]&&c[m].m(e,null);o(e,C),b=!0},p(r,d){if((!b||d&2)&&l!==(l=r[17]+"")&&le(n,l),d&2){i=re(r[2]);let m;for(m=0;m<i.length;m+=1){const T=Ge(r,i,m);c[m]?(c[m].p(T,d),H(c[m],1)):(c[m]=Je(T),c[m].c(),H(c[m],1),c[m].m(e,C))}for(ve(),m=i.length;m<c.length;m+=1)S(m);ge()}},i(r){if(!b){for(let d=0;d<i.length;d+=1)H(c[d]);b=!0}},o(r){c=c.filter(Boolean);for(let d=0;d<c.length;d+=1)P(c[d]);b=!1},d(r){r&&g(e),we(c,r)}}}function ht(s){let e,a,t,l,n,h,C,b,i,c,S,r,d,m,T,D,V,N,p=re(s[3]),x=[];for(let u=0;u<p.length;u+=1)x[u]=ze(Ke(s,p,u));let M=re(Object.entries(s[1])),f=[];for(let u=0;u<M.length;u+=1)f[u]=We(Re(s,M,u));const k=u=>P(f[u],1,1,()=>{f[u]=null});return{c(){e=y("div"),a=y("div"),t=y("div"),l=y("div"),n=y("button"),h=q("<"),b=O(),i=y("select");for(let u=0;u<x.length;u+=1)x[u].c();c=O(),S=y("button"),r=q(">"),m=O(),T=y("div");for(let u=0;u<f.length;u+=1)f[u].c();this.h()},l(u){e=w(u,"DIV",{class:!0});var E=$(e);a=w(E,"DIV",{class:!0});var _=$(a);t=w(_,"DIV",{class:!0});var L=$(t);l=w(L,"DIV",{class:!0});var j=$(l);n=w(j,"BUTTON",{class:!0});var U=$(n);h=R(U,"<"),U.forEach(g),b=F(j),i=w(j,"SELECT",{class:!0});var J=$(i);for(let G=0;G<x.length;G+=1)x[G].l(J);J.forEach(g),c=F(j),S=w(j,"BUTTON",{class:!0});var Y=$(S);r=R(Y,">"),Y.forEach(g),j.forEach(g),L.forEach(g),m=F(_),T=w(_,"DIV",{});var Q=$(T);for(let G=0;G<f.length;G+=1)f[G].l(Q);Q.forEach(g),_.forEach(g),E.forEach(g),this.h()},h(){v(n,"class","text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"),n.disabled=C=s[0]===1,v(i,"class","p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"),s[0]===void 0&&tt(()=>s[8].call(i)),v(S,"class","text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"),S.disabled=d=s[0]===38,v(l,"class","flex items-center space-x-2 ml-4"),v(t,"class","flex flex-col sm:flex-row gap-4 sm:gap-8"),v(a,"class","flex flex-col space-y-4"),v(e,"class","container-fluid mt-4 mb-4")},m(u,E){X(u,e,E),o(e,a),o(a,t),o(t,l),o(l,n),o(n,h),o(l,b),o(l,i);for(let _=0;_<x.length;_+=1)x[_]&&x[_].m(i,null);He(i,s[0],!0),o(l,c),o(l,S),o(S,r),o(a,m),o(a,T);for(let _=0;_<f.length;_+=1)f[_]&&f[_].m(T,null);D=!0,V||(N=[Z(n,"click",s[7]),Z(i,"change",s[8]),Z(S,"click",s[9])],V=!0)},p(u,[E]){if((!D||E&9&&C!==(C=u[0]===1))&&(n.disabled=C),E&8){p=re(u[3]);let _;for(_=0;_<p.length;_+=1){const L=Ke(u,p,_);x[_]?x[_].p(L,E):(x[_]=ze(L),x[_].c(),x[_].m(i,null))}for(;_<x.length;_+=1)x[_].d(1);x.length=p.length}if(E&9&&He(i,u[0]),(!D||E&9&&d!==(d=u[0]===38))&&(S.disabled=d),E&2){M=re(Object.entries(u[1]));let _;for(_=0;_<M.length;_+=1){const L=Re(u,M,_);f[_]?(f[_].p(L,E),H(f[_],1)):(f[_]=We(L),f[_].c(),H(f[_],1),f[_].m(T,null))}for(ve(),_=M.length;_<f.length;_+=1)k(_);ge()}},i(u){if(!D){for(let E=0;E<M.length;E+=1)H(f[E]);D=!0}},o(u){f=f.filter(Boolean);for(let E=0;E<f.length;E+=1)P(f[E]);D=!1},d(u){u&&g(e),we(x,u),we(f,u),V=!1,Ee(N)}}}function _t(s,e,a){let t,l,n=[],h=[],C=[],b,i,c,S,r=1,d=Array.from({length:38},(p,x)=>x+1);Ie(async()=>{try{await Pe.sync(),await Be.sync(),await oe.sync(),i=Pe.subscribe(p=>{n=p}),c=Be.subscribe(p=>{a(2,h=p),a(5,C=h.map(x=>({fixture:x,homeTeam:T(x.homeTeamId),awayTeam:T(x.awayTeamId)})))}),S=oe.subscribe(p=>{b=p})}catch(p){et({msg:{text:"Error fetching fixtures data."},err:p}),console.error("Error fetching fixtures data:",p)}finally{}}),Qe(()=>{i?.(),c?.(),S?.()});const m=p=>{a(0,r=Math.max(1,Math.min(38,r+p)))};function T(p){return n.find(x=>x.id===p)}const D=()=>m(-1);function V(){r=st(this),a(0,r),a(3,d)}const N=()=>m(1);return s.$$.update=()=>{s.$$.dirty&33&&a(6,t=C.filter(({fixture:p})=>p.gameweek===r)),s.$$.dirty&64&&a(1,l=t.reduce((p,x)=>{const M=new Date(Number(x.fixture.kickOff)/1e6),k=new Intl.DateTimeFormat("en-GB",{weekday:"long",day:"numeric",month:"long",year:"numeric"}).format(M);return p[k]||(p[k]=[]),p[k].push(x),p},{}))},[r,l,h,d,m,C,t,D,V,N]}class pt extends $e{constructor(e){super(),Ce(this,e,_t,ht,xe,{})}}function bt(){const{subscribe:s,set:e}=ft([]),a=nt.createActor(it,"bkyz2-fmaaa-aaaaa-qaaaq-cai");async function t(){const l=await a.getSeasons();e(l)}return{subscribe:s,sync:t}}const Xe=bt();function vt(s){let e,a,t="Update System State",l,n,h,C="",b,i,c,S="Cancel",r,d,m,T,D,V;return{c(){e=y("div"),a=y("h3"),a.textContent=t,l=O(),n=y("form"),h=y("div"),h.innerHTML=C,b=O(),i=y("div"),c=y("button"),c.textContent=S,r=O(),d=y("button"),m=q("Update"),this.h()},l(N){e=w(N,"DIV",{class:!0});var p=$(e);a=w(p,"H3",{class:!0,"data-svelte-h":!0}),ne(a)!=="svelte-86eypp"&&(a.textContent=t),l=F(p),n=w(p,"FORM",{});var x=$(n);h=w(x,"DIV",{class:!0,"data-svelte-h":!0}),ne(h)!=="svelte-nx1y50"&&(h.innerHTML=C),b=F(x),i=w(x,"DIV",{class:!0});var M=$(i);c=w(M,"BUTTON",{class:!0,"data-svelte-h":!0}),ne(c)!=="svelte-1wc3f18"&&(c.textContent=S),r=F(M),d=w(M,"BUTTON",{class:!0,type:!0});var f=$(d);m=R(f,"Update"),f.forEach(g),M.forEach(g),x.forEach(g),p.forEach(g),this.h()},h(){v(a,"class","text-lg leading-6 font-medium mb-2"),v(h,"class","mt-4"),v(c,"class","px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"),v(d,"class",T=`px-4 py-2 ${s[2]?"bg-gray-500":"fpl-purple-btn"} text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`),v(d,"type","submit"),d.disabled=s[2],v(i,"class","items-center py-3 flex space-x-4"),v(e,"class","mt-3 text-center")},m(N,p){X(N,e,p),o(e,a),o(e,l),o(e,n),o(n,h),o(n,b),o(n,i),o(i,c),o(i,r),o(i,d),o(d,m),D||(V=[Z(c,"click",function(){rt(s[1])&&s[1].apply(this,arguments)}),Z(n,"submit",ot(s[3]))],D=!0)},p(N,p){s=N,p&4&&T!==(T=`px-4 py-2 ${s[2]?"bg-gray-500":"fpl-purple-btn"} text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`)&&v(d,"class",T),p&4&&(d.disabled=s[2])},d(N){N&&g(e),D=!1,Ee(V)}}}function gt(s){let e,a;return e=new dt({props:{visible:s[0],$$slots:{default:[vt]},$$scope:{ctx:s}}}),e.$on("nnsClose",s[6]),{c(){ee(e.$$.fragment)},l(t){te(e.$$.fragment,t)},m(t,l){ae(e,t,l),a=!0},p(t,[l]){const n={};l&1&&(n.visible=t[0]),l&4102&&(n.$$scope={dirty:l,ctx:t}),e.$set(n)},i(t){a||(H(e.$$.fragment,t),a=!0)},o(t){P(e.$$.fragment,t),a=!1},d(t){se(e,t)}}}let yt=1,wt=1;function xt(s,e,a){let t,l;lt(s,Ue,r=>a(5,l=r));let{visible:n}=e,{closeModal:h}=e,{cancelModal:C}=e,b,i;Ie(async()=>{await Ue.sync(),await Xe.sync(),await oe.sync(),b=Xe.subscribe(r=>{}),i=oe.subscribe(r=>{})}),Qe(()=>{b?.(),i?.()});async function c(){try{let r={activeGameweek:yt,activeSeasonId:wt};await oe.updateSystemState(r),oe.sync(),await h(),ut({text:"System State Updated.",level:"success",duration:2e3})}catch(r){et({msg:{text:"Error updating system state."},err:r}),console.error("Error updating system state:",r),C()}finally{}}const S=()=>a(0,n=!1);return s.$$set=r=>{"visible"in r&&a(0,n=r.visible),"closeModal"in r&&a(4,h=r.closeModal),"cancelModal"in r&&a(1,C=r.cancelModal)},s.$$.update=()=>{s.$$.dirty&32&&a(2,t=(l.identity?.getPrincipal().toString()??"")!=="kydhj-2crf5-wwkao-msv4s-vbyvu-kkroq-apnyv-zykjk-r6oyk-ksodu-vqe")},[n,C,t,c,h,l,S]}class Et extends $e{constructor(e){super(),Ce(this,e,xt,gt,xe,{visible:0,closeModal:4,cancelModal:1})}}function It(s){let e,a,t,l,n,h='<h1 class="text-xl">OpenFPL Admin</h1> <p class="mt-2">This view is for testing purposes only.</p>',C,b,i,c="System Status",S,r,d,m,T,D,V,N,p,x,M;e=new Et({props:{showModal:s[0],closeModal:s[5],cancelModal:s[5]}});let f=s[1]==="fixtures"&&Ye();return{c(){ee(e.$$.fragment),a=O(),t=y("div"),l=y("div"),n=y("div"),n.innerHTML=h,C=O(),b=y("div"),i=y("button"),i.textContent=c,S=O(),r=y("ul"),d=y("li"),m=y("button"),T=q("Fixtures"),N=O(),f&&f.c(),this.h()},l(k){te(e.$$.fragment,k),a=F(k),t=w(k,"DIV",{class:!0});var u=$(t);l=w(u,"DIV",{class:!0});var E=$(l);n=w(E,"DIV",{class:!0,"data-svelte-h":!0}),ne(n)!=="svelte-it765"&&(n.innerHTML=h),C=F(E),b=w(E,"DIV",{class:!0});var _=$(b);i=w(_,"BUTTON",{class:!0,"data-svelte-h":!0}),ne(i)!=="svelte-1blozgx"&&(i.textContent=c),_.forEach(g),S=F(E),r=w(E,"UL",{class:!0});var L=$(r);d=w(L,"LI",{class:!0});var j=$(d);m=w(j,"BUTTON",{class:!0});var U=$(m);T=R(U,"Fixtures"),U.forEach(g),j.forEach(g),L.forEach(g),N=F(E),f&&f.l(E),E.forEach(g),u.forEach(g),this.h()},h(){v(n,"class","flex flex-col p-4"),v(i,"class","text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"),v(b,"class","flex flex-row p-4 space-x-4"),v(m,"class",D=`p-2 ${s[1]==="fixtures"?"text-white":"text-gray-400"}`),v(d,"class",V=`mr-4 text-xs md:text-base ${s[1]==="fixtures"?"active-tab":""}`),v(r,"class","flex rounded-t-lg bg-light-gray px-4 pt-2"),v(l,"class","bg-panel rounded-lg m-4"),v(t,"class","m-4")},m(k,u){ae(e,k,u),X(k,a,u),X(k,t,u),o(t,l),o(l,n),o(l,C),o(l,b),o(b,i),o(l,S),o(l,r),o(r,d),o(d,m),o(m,T),o(l,N),f&&f.m(l,null),p=!0,x||(M=[Z(i,"click",s[3]),Z(m,"click",s[6])],x=!0)},p(k,u){const E={};u&1&&(E.showModal=k[0]),e.$set(E),(!p||u&2&&D!==(D=`p-2 ${k[1]==="fixtures"?"text-white":"text-gray-400"}`))&&v(m,"class",D),(!p||u&2&&V!==(V=`mr-4 text-xs md:text-base ${k[1]==="fixtures"?"active-tab":""}`))&&v(d,"class",V),k[1]==="fixtures"?f?u&2&&H(f,1):(f=Ye(),f.c(),H(f,1),f.m(l,null)):f&&(ve(),P(f,1,1,()=>{f=null}),ge())},i(k){p||(H(e.$$.fragment,k),H(f),p=!0)},o(k){P(e.$$.fragment,k),P(f),p=!1},d(k){k&&(g(a),g(t)),se(e,k),f&&f.d(),x=!1,Ee(M)}}}function $t(s){let e,a;return e=new mt({}),{c(){ee(e.$$.fragment)},l(t){te(e.$$.fragment,t)},m(t,l){ae(e,t,l),a=!0},p:Ze,i(t){a||(H(e.$$.fragment,t),a=!0)},o(t){P(e.$$.fragment,t),a=!1},d(t){se(e,t)}}}function Ye(s){let e,a;return e=new pt({}),{c(){ee(e.$$.fragment)},l(t){te(e.$$.fragment,t)},m(t,l){ae(e,t,l),a=!0},i(t){a||(H(e.$$.fragment,t),a=!0)},o(t){P(e.$$.fragment,t),a=!1},d(t){se(e,t)}}}function Ct(s){let e,a,t,l;const n=[$t,It],h=[];function C(b,i){return b[2]?0:1}return e=C(s),a=h[e]=n[e](s),{c(){a.c(),t=Le()},l(b){a.l(b),t=Le()},m(b,i){h[e].m(b,i),X(b,t,i),l=!0},p(b,i){let c=e;e=C(b),e===c?h[e].p(b,i):(ve(),P(h[c],1,1,()=>{h[c]=null}),ge(),a=h[e],a?a.p(b,i):(a=h[e]=n[e](b),a.c()),H(a,1),a.m(t.parentNode,t))},i(b){l||(H(a),l=!0)},o(b){P(a),l=!1},d(b){b&&g(t),h[e].d(b)}}}function kt(s){let e,a;return e=new ct({props:{$$slots:{default:[Ct]},$$scope:{ctx:s}}}),{c(){ee(e.$$.fragment)},l(t){te(e.$$.fragment,t)},m(t,l){ae(e,t,l),a=!0},p(t,[l]){const n={};l&135&&(n.$$scope={dirty:l,ctx:t}),e.$set(n)},i(t){a||(H(e.$$.fragment,t),a=!0)},o(t){P(e.$$.fragment,t),a=!1},d(t){se(e,t)}}}function Tt(s,e,a){let{showModal:t=!1}=e,l="fixtures",n=!0;Ie(async()=>{a(2,n=!1)});function h(){a(0,t=!0)}function C(c){a(1,l=c)}function b(){a(0,t=!1)}const i=()=>C("fixtures");return s.$$set=c=>{"showModal"in c&&a(0,t=c.showModal)},[t,l,n,h,C,b,i]}class Ft extends $e{constructor(e){super(),Ce(this,e,Tt,kt,xe,{showModal:0})}}export{Ft as component};