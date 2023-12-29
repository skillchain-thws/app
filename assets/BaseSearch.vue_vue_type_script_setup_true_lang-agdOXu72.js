import{c as l,d as n,l as m,p as u,o as i,j as p,f as e,w as f,u as _,C as h}from"./index-oOlvovHs.js";import{_ as k}from"./Input.vue_vue_type_script_setup_true_lang-DgkPgiwG.js";import{_ as V}from"./Label.vue_vue_type_script_setup_true_lang-cjaacjvQ.js";/**
 * @license lucide-vue-next v0.297.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const I=l("CheckIcon",[["path",{d:"M20 6 9 17l-5-5",key:"1gmf2c"}]]);/**
 * @license lucide-vue-next v0.297.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const C=l("SearchIcon",[["circle",{cx:"11",cy:"11",r:"8",key:"4ej97u"}],["path",{d:"m21 21-4.3-4.3",key:"1qie3q"}]]),q={class:"flex gap-2 items-center"},x={class:"w-10 h-10 border rounded-full flex-center shrink-0"},M=n({__name:"BaseSearch",props:m({placeholder:{default:"search for ..."}},{modelValue:{default:""},modelModifiers:{}}),emits:["update:modelValue"],setup(s){const o=u(s,"modelValue");return(c,a)=>{const t=V,r=k;return i(),p("div",q,[e(t,{for:"q"},{default:f(()=>[h("div",x,[e(_(C),{size:20})])]),_:1}),e(r,{id:"q",modelValue:o.value,"onUpdate:modelValue":a[0]||(a[0]=d=>o.value=d),placeholder:c.placeholder},null,8,["modelValue","placeholder"])])}}});export{I as C,M as _};
