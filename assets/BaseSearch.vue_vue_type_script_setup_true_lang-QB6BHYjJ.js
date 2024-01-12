import{c as s,d as n,s as m,t as u,l as i,f as e,w as p,o as f,D as _,u as h}from"./index-NT2W6lgv.js";import{_ as k}from"./Input.vue_vue_type_script_setup_true_lang-8pZqWBuw.js";import{_ as V}from"./Label.vue_vue_type_script_setup_true_lang-Zb-S8PU5.js";/**
 * @license lucide-vue-next v0.303.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const I=s("CheckIcon",[["path",{d:"M20 6 9 17l-5-5",key:"1gmf2c"}]]);/**
 * @license lucide-vue-next v0.303.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const q=s("SearchIcon",[["circle",{cx:"11",cy:"11",r:"8",key:"4ej97u"}],["path",{d:"m21 21-4.3-4.3",key:"1qie3q"}]]),x={class:"flex gap-2 items-center"},C={class:"w-10 h-10 border rounded-full flex-center shrink-0"},M=n({__name:"BaseSearch",props:m({placeholder:{default:"search for ..."}},{modelValue:{default:""},modelModifiers:{}}),emits:["update:modelValue"],setup(l){const o=u(l,"modelValue");return(c,a)=>{const t=V,r=k;return f(),i("div",x,[e(t,{for:"q"},{default:p(()=>[_("div",C,[e(h(q),{size:20})])]),_:1}),e(r,{id:"q",modelValue:o.value,"onUpdate:modelValue":a[0]||(a[0]=d=>o.value=d),placeholder:c.placeholder},null,8,["modelValue","placeholder"])])}}});export{I as C,M as _};
