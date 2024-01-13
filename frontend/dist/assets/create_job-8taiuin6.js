import{_ as B,g as $}from"./JobCard.vue_vue_type_script_setup_true_lang-Ftok2Vm-.js";import{d as j,v as k,A as m,z as N,x as S,l as _,D as o,f as s,w as r,u as t,C as g,H as y,G as U,m as q,I as A,J as D,o as f,B as d}from"./index-NT2W6lgv.js";import{_ as F}from"./Input.vue_vue_type_script_setup_true_lang-8pZqWBuw.js";import{_ as I}from"./Label.vue_vue_type_script_setup_true_lang-Zb-S8PU5.js";import"./Badge.vue_vue_type_script_setup_true_lang-2C_g5hvK.js";const M={class:"space-y-3"},P={key:0,class:"text-destructive mt-1"},T={key:0,class:"text-destructive mt-1"},z={class:"flex gap-3"},E={class:"w-[120px]"},G={class:"space-y-3"},H={class:"grow space-y-3"},L={class:"flex items-center justify-center"},R={class:"w-[80%]"},ee=j({__name:"create_job",async setup(K){let c,v;const V=k(),b=()=>({title:"",description:"",tags:[],price:0,id:0,inProcess:!1,owner:"0x0000000000000000000000000000000000000000"}),e=m(b()),a=m({title:"",description:""}),n=m("");N(n,()=>{e.value.tags=n.value.trim().split(" ")});const x=([c,v]=S(()=>V.getJobFactory()),c=await c,v(),c);async function w(){if(a.value={title:"",description:""},e.value.title&&e.value.description){await x.addJob(e.value.title,e.value.description,e.value.price,e.value.tags),e.value=b(),n.value="";return}e.value.title||(a.value.title="title is required"),e.value.description||(a.value.description="description is required")}return(O,i)=>{const u=I,p=F,C=B,h=D,J=$;return f(),_("form",{class:"grid grid-cols-2 gap-10 py-10 items-center",onSubmit:A(w,["prevent"])},[o("div",M,[o("div",null,[s(u,{for:"title",class:"mb-3"},{default:r(()=>[d("title")]),_:1}),s(p,{id:"title",modelValue:t(e).title,"onUpdate:modelValue":i[0]||(i[0]=l=>t(e).title=l),type:"text"},null,8,["modelValue"]),t(a).title?(f(),_("p",P,g(t(a).title),1)):y("",!0)]),o("div",null,[s(u,{for:"description",class:"mb-3"},{default:r(()=>[d("description")]),_:1}),s(C,{id:"description",modelValue:t(e).description,"onUpdate:modelValue":i[1]||(i[1]=l=>t(e).description=l)},null,8,["modelValue"]),t(a).description?(f(),_("p",T,g(t(a).description),1)):y("",!0)]),o("div",z,[o("div",E,[o("div",G,[s(u,{for:"budget"},{default:r(()=>[d("budget")]),_:1}),s(p,{id:"budget",modelValue:t(e).price,"onUpdate:modelValue":i[2]||(i[2]=l=>t(e).price=l),modelModifiers:{number:!0},min:"0",step:"1",type:"number"},null,8,["modelValue"])])]),o("div",H,[s(u,{for:"badges"},{default:r(()=>[d("badges")]),_:1}),s(p,{id:"badges",modelValue:t(n),"onUpdate:modelValue":i[3]||(i[3]=l=>U(n)?n.value=l:null),type:"text"},null,8,["modelValue"])])]),s(h,{type:"submit",class:"w-full"},{default:r(()=>[d(" Create ")]),_:1})]),o("div",L,[o("div",R,[s(J,q(t(e),{class:"w-full border-primary"}),null,16)])])],32)}}});export{ee as default};