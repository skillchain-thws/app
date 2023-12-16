import{c as ee,d as h,o as l,a as _,w as o,r as $,u as e,T as ce,b as de,e as ie,f as t,Z as ue,g as x,m as V,O as pe,X as _e,h as fe,i as se,n as I,D as me,j as w,k as he,t as be,l as ge,p as ve,q as oe,s as Q,v as U,x as ye,y as we,z as F,A as g,B as y,F as O,C as D,E as n,G as xe,H as M,I as X,_ as $e,J as Ce,K as te,L as ae,M as ne,N as Se,P as ke,$ as Be,Q as Ve,R as je,S as ze,U as Je,V as Oe,W as Ne,Y as Pe,a0 as De,a1 as Y,a2 as Ae,a3 as Fe,a4 as Me}from"./index-tRq5Nopp.js";import{_ as le}from"./ScrollArea.vue_vue_type_script_setup_true_lang-Q6kMADGo.js";import{_ as Te,a as qe,b as Le,c as Ue,d as Ie,e as Re,f as He,g as Ke,h as Ee}from"./Label.vue_vue_type_script_setup_true_lang-hRg0TWQT.js";import{_ as Ge,a as Ze}from"./Badge.vue_vue_type_script_setup_true_lang-huy-mP_W.js";import{C as We}from"./chevron-down-BUIsJgtE.js";import{r as Qe,_ as Xe}from"./Input.vue_vue_type_script_setup_true_lang-bS0nwmj7.js";/**
 * @license lucide-vue-next v0.297.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const Ye=ee("CheckIcon",[["path",{d:"M20 6 9 17l-5-5",key:"1gmf2c"}]]);/**
 * @license lucide-vue-next v0.297.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const et=ee("HeartIcon",[["path",{d:"M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z",key:"c3ymky"}]]);/**
 * @license lucide-vue-next v0.297.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const tt=ee("SearchIcon",[["circle",{cx:"11",cy:"11",r:"8",key:"4ej97u"}],["path",{d:"m21 21-4.3-4.3",key:"1qie3q"}]]),st=h({__name:"Sheet",setup(r){return(s,a)=>(l(),_(e(ce),null,{default:o(()=>[$(s.$slots,"default")]),_:3}))}}),ot=h({__name:"SheetContent",props:{side:{},class:{},forceMount:{type:Boolean},trapFocus:{type:Boolean},disableOutsidePointerEvents:{type:Boolean},asChild:{type:Boolean},as:{}},emits:["escapeKeyDown","pointerDownOutside","focusOutside","interactOutside","dismiss","openAutoFocus","closeAutoFocus"],setup(r,{emit:s}){const a=r,v=de(s),i=se("fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:duration-300 data-[state=open]:duration-500",{variants:{side:{top:"inset-x-0 top-0 border-b border-border data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",bottom:"inset-x-0 bottom-0 border-t border-border data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",left:"inset-y-0 left-0 h-full w-3/4 border-r border-border data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",right:"inset-y-0 right-0 h-full w-3/4  border-l border-border data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm"}},defaultVariants:{side:"right"}});return(p,S)=>(l(),_(e(fe),null,{default:o(()=>[t(e(ie),{class:"fixed inset-0 z-50 bg-background/80 backdrop-blur-sm data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"}),t(e(ue),V({class:e(x)(e(i)({side:a.side}),a.class)},{...a,...e(v)}),{default:o(()=>[$(p.$slots,"default"),t(e(pe),{class:"absolute top-4 right-4 p-0.5 transition-colors rounded-md hover:bg-secondary"},{default:o(()=>[t(e(_e),{class:"w-4 h-4 text-muted-foreground"})]),_:1})]),_:3},16,["class"])]),_:3}))}}),at=h({__name:"Separator",props:{orientation:{},decorative:{type:Boolean},asChild:{type:Boolean},as:{},class:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(me),{class:I([e(x)("shrink-0 bg-secondary",s.class),s.orientation==="vertical"?"w-px h-full":"h-px w-full"])},null,8,["class"]))}}),nt=h({__name:"SheetHeader",props:{class:{}},setup(r){const s=r;return(a,c)=>(l(),w("div",{class:I(e(x)("flex flex-col space-y-2 text-center sm:text-left",s.class))},[$(a.$slots,"default")],2))}}),lt=h({__name:"SheetDescription",props:{asChild:{type:Boolean},as:{},class:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(he),V({class:e(x)("text-muted-foreground",s.class)},s),{default:o(()=>[$(a.$slots,"default")]),_:3},16,["class"]))}}),rt=h({__name:"SheetTitle",props:{asChild:{type:Boolean},as:{},class:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(be),V({class:e(x)("text-2xl font-semibold text-foreground",s.class)},s),{default:o(()=>[$(a.$slots,"default")]),_:3},16,["class"]))}}),ct={class:"pt-5 pb-2 flex gap-2 flex-wrap"},dt={key:2},it={class:"space-y-2"},ut=n("h3",{class:"text-xl"}," info ",-1),pt={class:"grid grid-cols-3 gap-1"},_t=n("div",null,"username",-1),ft={class:"col-span-2"},mt=n("div",null,"address",-1),ht={class:"col-span-2"},bt=n("div",null,"is reviewer",-1),gt={class:"col-span-2"},vt=n("div",null,"buyer reviewed",-1),yt={class:"col-span-2"},wt=n("div",null,"seller reviewed",-1),xt={class:"col-span-2"},$t={class:"space-y-5"},Ct={class:"text-xl"},St={class:"flex flex-col gap-3"},kt={class:"space-y-2"},Bt={class:"space-y-2"},Vt={class:"-ml-2 flex gap-2"},jt=h({__name:"JobSheet",props:ge({job:{}},{modelValue:{default:!1}}),emits:["update:modelValue"],async setup(r){let s,a;const c=r,v=ve(r,"modelValue"),i=oe(),p=([s,a]=Q(()=>i.getUserFactory()),s=await s,a(),s),S=([s,a]=Q(()=>i.getJobFactory()),s=await s,a(),s),b=U(),j=U([]);ye(()=>c.job.owner,()=>{b.value=void 0,j.value=[],p.getUser(c.job.owner).then(u=>{b.value={owner:u[0],userName:u[1],isJudge:u[2],jobIds:u[3].map(Number),reviewsBuyerCount:Number(u[4]),reviewSellerCount:Number(u[5])}}),S.getAllJobsOfUser(c.job.owner).then(u=>{j.value=u.map(f=>({owner:f[0],id:Number(f[1]),title:f[2],description:f[3],price:Number(f[4]),inProcess:f[5],tags:f[6]})).filter(f=>f.id!==c.job.id)})},{immediate:!0});const J=we(),z=F("");async function R(){try{await S.sendBuyRequest(c.job.id,z.value),z.value=""}catch{J.push("/error")}}async function N(){try{await S.deleteJob(c.job.id)}catch{J.push("/error")}}return(u,f)=>{const k=rt,d=lt,P=nt,B=Ge,T=Ze,H=Te,q=$e,L=at,K=le,E=ot,G=st;return l(),_(G,{open:v.value,"onUpdate:open":f[1]||(f[1]=C=>v.value=C)},{default:o(()=>[t(E,{class:"sm:max-w-lg"},{default:o(()=>[t(P,null,{default:o(()=>[t(k,null,{default:o(()=>[y(g(u.job.title)+" #"+g(u.job.id),1)]),_:1}),t(d,null,{default:o(()=>[y(g(u.job.description),1)]),_:1})]),_:1}),n("div",ct,[(l(!0),w(O,null,D(u.job.tags,(C,A)=>(l(),_(B,{key:A,variant:"secondary"},{default:o(()=>[y(g(C),1)]),_:2},1024))),128))]),t(T,null,{default:o(()=>[y(g(u.job.price),1)]),_:1}),u.job.owner.toLowerCase()!==e(i).address.toLowerCase()?(l(),w("form",{key:0,class:"mt-3 space-y-3",onSubmit:xe(R,["prevent"])},[t(H,{modelValue:e(z),"onUpdate:modelValue":f[0]||(f[0]=C=>M(z)?z.value=C:null),placeholder:"leave a message"},null,8,["modelValue"]),t(q,{class:"w-full",type:"submit"},{default:o(()=>[y(" send ")]),_:1})],32)):(l(),_(q,{key:1,class:"w-full mt-3",variant:"destructive",onClick:N},{default:o(()=>[y(" delete ")]),_:1})),e(b)?(l(),w("div",dt,[t(L,{orientation:"horizontal",class:"my-5"}),n("div",it,[ut,n("div",pt,[_t,n("div",ft,[t(B,{variant:"outline"},{default:o(()=>[y(g(e(b).userName),1)]),_:1})]),mt,n("div",ht,[t(B,{variant:"outline"},{default:o(()=>[y(g(e(b).owner),1)]),_:1})]),bt,n("div",gt,[t(B,{variant:"outline"},{default:o(()=>[y(g(e(b).isJudge?"yes":"no"),1)]),_:1})]),vt,n("div",yt,[t(B,{variant:"outline"},{default:o(()=>[y(g(e(b).reviewsBuyerCount),1)]),_:1})]),wt,n("div",xt,[t(B,{variant:"outline"},{default:o(()=>[y(g(e(b).reviewSellerCount),1)]),_:1})])])]),e(j).length?(l(),w(O,{key:0},[t(L,{orientation:"horizontal",class:"mt-10 mb-5"}),n("div",$t,[n("h3",Ct," more from @"+g(e(b).userName),1),t(K,{class:"h-[400px]"},{default:o(()=>[n("ul",St,[(l(!0),w(O,null,D(e(j),(C,A)=>(l(),w("li",{key:A,class:"px-3 py-2 rounded-md border"},[n("div",kt,[n("div",Bt,[n("p",null,g(C.title),1),n("ul",Vt,[(l(!0),w(O,null,D(C.tags,(Z,W)=>(l(),w("li",{key:W},[t(B,{variant:"outline"},{default:o(()=>[y(g(Z),1)]),_:2},1024)]))),128))])]),t(T,null,{default:o(()=>[y(g(C.price),1)]),_:2},1024)])]))),128))])]),_:1})])],64)):X("",!0)])):X("",!0)]),_:1})]),_:1},8,["open"])}}}),zt=h({__name:"Skeleton",props:{class:{}},setup(r){const s=r;return(a,c)=>(l(),w("div",{class:I(e(x)("animate-pulse rounded-md bg-secondary",s.class))},null,2))}}),Jt={},Ot={class:"flex justify-between"},Nt={class:"flex gap-2 flex-wrap"};function Pt(r,s){const a=zt,c=qe,v=Le,i=Ue,p=Ie,S=Re,b=He;return l(),_(b,{class:"group-hover:border-primary transition-colors"},{default:o(()=>[t(i,null,{default:o(()=>[t(c,null,{default:o(()=>[n("div",Ot,[t(a,{class:"h-4 w-[200px]"})])]),_:1}),t(v,{class:"pt-2 flex gap-2"},{default:o(()=>[t(a,{class:"h-4 w-[80px]"}),t(a,{class:"h-4 w-[50px]"})]),_:1})]),_:1}),t(p,null,{default:o(()=>[n("div",Nt,[t(a,{class:"h-4 w-[60%]"}),t(a,{class:"h-4 w-[35%]"}),t(a,{class:"h-4 w-[45%]"}),t(a,{class:"h-4 w-[50%]"}),t(a,{class:"h-4 w-[70%]"})])]),_:1}),t(S,null,{default:o(()=>[t(a,{class:"h-4 w-[15%]"})]),_:1})]),_:1})}const Dt=Ce(Jt,[["render",Pt]]),At=h({__name:"Select",props:{open:{type:Boolean},defaultOpen:{type:Boolean},defaultValue:{},modelValue:{},orientation:{},dir:{},name:{},autocomplete:{},disabled:{type:Boolean},required:{type:Boolean}},emits:["update:modelValue","update:open"],setup(r,{emit:s}){const v=te(r,s);return(i,p)=>(l(),_(e(Se),ae(ne(e(v))),{default:o(()=>[$(i.$slots,"default")]),_:3},16))}}),Ft=h({__name:"SelectContent",props:{forceMount:{type:Boolean},position:{default:"popper"},side:{},sideOffset:{default:4},align:{},alignOffset:{},avoidCollisions:{type:Boolean},collisionBoundary:{},collisionPadding:{},arrowPadding:{},sticky:{},hideWhenDetached:{type:Boolean},updatePositionStrategy:{},onPlaced:{},prioritizePosition:{type:Boolean},asChild:{type:Boolean},as:{},class:{}},emits:["closeAutoFocus","escapeKeyDown","pointerDownOutside"],setup(r,{emit:s}){const a=r,v=te(a,s);return(i,p)=>(l(),_(e(Ve),null,{default:o(()=>[t(e(ke),V({...e(v),...i.$attrs},{class:e(x)("relative z-50 min-w-[10rem] overflow-hidden rounded-md bg-background border border-border text-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",i.position==="popper"&&"data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",a.class)}),{default:o(()=>[t(e(Be),{class:I(e(x)("p-1",i.position==="popper"&&"h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"))},{default:o(()=>[$(i.$slots,"default")]),_:3},8,["class"])]),_:3},16,["class"])]),_:3}))}}),Mt=h({__name:"SelectGroup",props:{asChild:{type:Boolean},as:{},class:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(je),V({class:e(x)("p-1 w-full",s.class)},s),{default:o(()=>[$(a.$slots,"default")]),_:3},16,["class"]))}}),Tt={class:"absolute left-2 flex h-3.5 w-3.5 items-center justify-center"},qt=h({__name:"SelectItem",props:{value:{},disabled:{type:Boolean},textValue:{},asChild:{type:Boolean},as:{},class:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(Oe),V(s,{class:e(x)("relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",s.class)}),{default:o(()=>[n("span",Tt,[t(e(ze),null,{default:o(()=>[t(e(Ye),{class:"h-4 w-4"})]),_:1})]),t(e(Je),null,{default:o(()=>[$(a.$slots,"default")]),_:3})]),_:3},16,["class"]))}}),Lt=h({__name:"SelectTrigger",props:{disabled:{type:Boolean},asChild:{type:Boolean},as:{},class:{default:""},invalid:{type:Boolean,default:!1}},setup(r){const s=r;return(a,c)=>(l(),_(e(Pe),V(s,{class:[e(x)("flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",s.class),s.invalid?"!ring-destructive ring-2 placeholder:!text-destructive":""]}),{default:o(()=>[$(a.$slots,"default"),t(e(Ne),{"as-child":""},{default:o(()=>[t(e(We),{class:"w-4 h-4 opacity-50"})]),_:1})]),_:3},16,["class"]))}}),Ut=h({__name:"SelectValue",props:{placeholder:{},asChild:{type:Boolean},as:{}},setup(r){const s=r;return(a,c)=>(l(),_(e(De),ae(ne(s)),{default:o(()=>[$(a.$slots,"default")]),_:3},16))}}),It=se("inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground",{variants:{variant:{default:"bg-transparent",outline:"border border-input bg-transparent hover:bg-accent hover:text-accent-foreground"},size:{default:"h-10 px-3",sm:"h-9 px-2.5",lg:"h-11 px-5"}},defaultVariants:{variant:"default",size:"default"}}),Rt=h({__name:"Toggle",props:{variant:{default:"default"},size:{default:"default"},disabled:{type:Boolean,default:!1},defaultValue:{type:Boolean},pressed:{type:Boolean},asChild:{type:Boolean},as:{}},emits:["update:pressed"],setup(r,{emit:s}){const a=r,c=s,v=Y(()=>{const{variant:p,size:S,disabled:b,...j}=a;return j}),i=te(v,c);return(p,S)=>(l(),_(e(Ae),V(e(i),{class:e(x)(e(It)({variant:p.variant,size:p.size,class:p.$attrs.class??""})),disabled:a.disabled}),{default:o(()=>[$(p.$slots,"default")]),_:3},16,["class","disabled"]))}}),Ht={class:"py-10"},Kt={class:"flex gap-2 items-center"},Et={class:"w-10 h-10 border rounded-full flex-center shrink-0"},Gt={class:"py-8 space-y-8"},Zt={class:"flex justify-between items-center"},Wt={class:"flex items-center gap-3"},Qt=n("h1",{class:"text-4xl"}," jobs ",-1),Xt={class:"flex items-center whitespace-nowrap gap-2"},Yt=n("span",{class:"text-muted-foreground"}," sort by: ",-1),es={class:"min-w-[200px]"},ts={class:"grid grid-cols-3 gap-8"},ds=h({__name:"index",async setup(r){let s,a;const c=F(""),v=Qe(c,500),i=F(!1),p=F("lth"),S=[{label:"price: low to high",value:"lth"},{label:"price: hight to low",value:"htl"}],b=oe(),j=([s,a]=Q(()=>b.getJobFactory()),s=await s,a(),s),J=U([]),z=Y(()=>i.value?J.value.filter(k=>k.owner.toLowerCase()===b.address.toLowerCase()):J.value),R=Y(()=>(v.value?z.value.filter(d=>JSON.stringify(d).toLowerCase().includes(c.value.toLowerCase())):z.value).sort((d,P)=>p.value==="lth"?d.price-P.price:P.price-d.price));Fe(()=>{j.getAllJobs().then(k=>{J.value=k.filter(d=>d[0]!=="0x0000000000000000000000000000000000000000").map(d=>({owner:d[0],id:Number(d[1]),title:d[2],description:d[3],price:Number(d[4]),inProcess:d[5],tags:d[6]}))})});const N=F(!1),u=U();function f(k){u.value=k,N.value=!0}return(k,d)=>{const P=Ke,B=Xe,T=Rt,H=Ut,q=Lt,L=qt,K=Mt,E=Ft,G=At,C=Ee,A=Dt,Z=le,W=jt;return l(),w("div",null,[n("div",Ht,[n("div",Kt,[t(P,{for:"q"},{default:o(()=>[n("div",Et,[t(e(tt),{size:20})])]),_:1}),t(B,{id:"q",modelValue:e(c),"onUpdate:modelValue":d[0]||(d[0]=m=>M(c)?c.value=m:null),placeholder:"search for job title or keyword"},null,8,["modelValue"])])]),n("div",Gt,[n("div",Zt,[n("div",Wt,[Qt,t(T,{pressed:e(i),"onUpdate:pressed":d[1]||(d[1]=m=>M(i)?i.value=m:null),"aria-label":"toggle my job only"},{default:o(()=>[t(e(et),{size:20})]),_:1},8,["pressed"])]),n("div",Xt,[Yt,n("div",es,[t(G,{modelValue:e(p),"onUpdate:modelValue":d[2]||(d[2]=m=>M(p)?p.value=m:null)},{default:o(()=>[t(q,null,{default:o(()=>[t(H)]),_:1}),t(E,null,{default:o(()=>[t(K,null,{default:o(()=>[(l(),w(O,null,D(S,m=>t(L,{key:m.value,value:m.value},{default:o(()=>[y(g(m.label),1)]),_:2},1032,["value"])),64))]),_:1})]),_:1})]),_:1},8,["modelValue"])])])]),t(Z,{class:"h-[800px]"},{default:o(()=>[n("div",ts,[e(J).length?(l(!0),w(O,{key:0},D(e(R),(m,re)=>(l(),_(C,V({key:re},m,{onClick:ss=>f(m)}),null,16,["onClick"]))),128)):(l(),w(O,{key:1},D(5,m=>t(A,{key:m})),64))])]),_:1})]),e(u)?(l(),_(Me,{key:0},[t(W,{open:e(N),"onUpdate:open":d[3]||(d[3]=m=>M(N)?N.value=m:null),job:e(u)},null,8,["open","job"])],1024)):X("",!0)])}}});export{ds as default};
