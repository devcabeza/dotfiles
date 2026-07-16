; inherits: html

; Directivas de control de flujo
[
  "@if"
  "@elseif"
  "@else"
  "@endif"
  "@unless"
  "@endunless"
  "@for"
  "@endfor"
  "@foreach"
  "@endforeach"
  "@while"
  "@endwhile"
  "@isset"
  "@endisset"
  "@empty"
  "@endempty"
  "@switch"
  "@endswitch"
  "@case"
  "@break"
  "@default"
  "@auth"
  "@endauth"
  "@guest"
  "@endguest"
  "@env"
  "@endenv"
  "@production"
  "@endproduction"
  "@once"
  "@endonce"
] @keyword.control

; Directivas de estructura/sección
[
  "@section"
  "@endsection"
  "@show"
  "@yield"
  "@extends"
  "@parent"
  "@include"
  "@includeIf"
  "@includeWhen"
  "@includeUnless"
  "@each"
  "@component"
  "@endcomponent"
  "@slot"
  "@endslot"
  "@props"
  "@push"
  "@endpush"
  "@prepend"
  "@endprepend"
  "@stack"
  "@verbatim"
  "@endverbatim"
  "@fragment"
  "@endfragment"
] @keyword

; Directivas de depuración y utilidades
[
  "@dump"
  "@dd"
  "@debug"
  "@vite"
  "@viteReactRefresh"
  "@style"
  "@endstyle"
  "@script"
  "@endscript"
  "@error"
  "@enderror"
] @keyword.debug

; Directiva php
[
  "@php"
  "@endphp"
  "@csrf"
  "@method"
  "@lang"
  "@choice"
] @keyword.directive

; Echo Blade
[
  "{{"
  "}}"
  "{{--"
  "--}}"
  "{!!"
  "!!}"
] @punctuation.special

; PHP tags dentro de Blade
(php_tag) @keyword
(php_end_tag) @keyword

; Paréntesis de directivas
"(" @punctuation.bracket
")" @punctuation.bracket

; Comentarios Blade
(comment) @comment

; Atributos de componentes Blade
(component_attribute
  (attribute_name) @attribute)

; Nombres de componentes (x-)
(tag_name) @tag

; Contenido de texto plano (nodo hoja)
(text) @none
