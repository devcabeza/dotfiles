-- Snippets para Blade (Laravel)
-- Formato: LuaSnip (lua)
-- Cargados via ls.add_snippets("blade", ...)

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- =============================================================================
	-- Expresiones básicas
	-- =============================================================================
	s("echo", fmt("{{ {} }}", { i(1, "variable"), i(0) })),
	s("echo_raw", fmt("{!! {} !!}", { i(1, "variable"), i(0) })),
	s("comment", fmt("{{-- {} --}}", { i(1, "comment"), i(0) })),
	s("php", fmt("@php\n\t{}\n@endphp", { i(1, "// code..."), i(0) })),
	s("verbatim", fmt("@verbatim\n\t{}\n@endverbatim", { i(1, "template code"), i(0) })),

	-- =============================================================================
	-- Conditionals
	-- =============================================================================
	s("if", fmt("@if ({})\n\t{}\n@endif", { i(1, "condition"), i(0) })),
	s("ifelse", fmt("@if ({})\n\t{}\n@else\n\t{}\n@endif", { i(1, "condition"), i(2, "if body"), i(0, "else body") })),
	s("elseif", fmt("@elseif ({})\n\t{}", { i(1, "condition"), i(0) })),
	s("else", t({ "@else", "" }), { snippetType = "autosnippet" }),
	s("unless", fmt("@unless ({})\n\t{}\n@endunless", { i(1, "condition"), i(0) })),
	s("isset", fmt("@isset (${})\n\t{}\n@endisset", { i(1, "variable"), i(0) })),
	s("empty", fmt("@empty ({})\n\t{}\n@endempty", { i(1, "expression"), i(0) })),
	s("auth", fmt("@auth\n\t{}\n@endauth", { i(1, "auth content"), i(0) })),
	s("guest", fmt("@guest\n\t{}\n@endguest", { i(1, "guest content"), i(0) })),
	s("production", fmt("@production\n\t{}\n@endproduction", { i(1, "prod content"), i(0) })),
	s("env", fmt("@env ('{}')\n\t{}\n@endenv", { i(1, "production"), i(0) })),
	s("error", fmt("@error ('{}')\n\t{}\n@enderror", { i(1, "field_name"), i(0) })),

	-- =============================================================================
	-- Loops
	-- =============================================================================
	s("for", fmt("@for (${1} = {2}; ${1} < {3}; ${1}++)\n\t{0}\n@endfor", {
		i(1, "i"), i(2, "0"), i(3, "count"), i(0, "content")
	})),
	s("foreach", fmt("@foreach (${} as ${})\n\t{}\n@endforeach", {
		i(1, "items"), i(2, "item"), i(0, "content")
	})),
	s("foreach_kv", fmt("@foreach (${} as ${} => ${})\n\t{}\n@endforeach", {
		i(1, "items"), i(2, "key"), i(3, "item"), i(0, "content")
	})),
	s("forelse", fmt("@forelse (${} as ${})\n\t{}\n@empty\n\t{}\n@endforelse", {
		i(1, "items"), i(2, "item"), i(3, "content when exists"), i(0, "content when empty")
	})),
	s("while", fmt("@while (${})\n\t{}\n@endwhile", { i(1, "condition"), i(0) })),
	s("continue", t("@continue")),

	-- =============================================================================
	-- Sections & Layouts
	-- =============================================================================
	s("extends", fmt("@extends ('{}')", { i(1, "layouts.app") })),
	s("section", fmt("@section ('{}')\n\t{}\n@endsection", { i(1, "content"), i(0) })),
	s("section_show", fmt("@section ('{}')\n\t{}\n@show", { i(1, "content"), i(0) })),
	s("yield", fmt("@yield ('{}')", { i(1, "section") })),
	s("parent", t("@parent")),
	s("include", fmt("@include ('{}')", { i(1, "partials.header") })),
	s("include_if", fmt("@includeIf ('{}')", { i(1, "partials.header") })),
	s("include_when", fmt("@includeWhen ({}, '{}')", { i(1, "boolean"), i(2, "partials.header") })),
	s("include_unless", fmt("@includeUnless ({}, '{}')", { i(1, "boolean"), i(2, "partials.header") })),
	s("each", fmt("@each ('{}', ${}, ${})", { i(1, "partials.item"), i(2, "items"), i(3, "item") })),

	-- =============================================================================
	-- Components & Slots
	-- =============================================================================
	s("component", fmt("@component ('{}', ['{}' => ${}])\n\t{}\n@endcomponent", {
		i(1, "components.alert"), i(2, "type"), i(3, "type"), i(0, "slot content")
	})),
	s("component_x", fmt("<x-{} />", { i(1, "component-name") })),
	s("component_x_slot", fmt("<x-{1}>\n\t{2}\n</x-{1}>", { i(1, "component-name"), i(0, "slot content") })),
	s("slot", fmt("@slot ('{}')\n\t{}\n@endslot", { i(1, "name"), i(0) })),
	s("props", fmt("@props ([\n\t'{}' => '{}',\n])", { i(1, "property"), i(2, "default") })),
	s("aware", fmt("@aware (['{}' => '{}'])", { i(1, "property"), i(2, "default") })),

	-- =============================================================================
	-- Stacks & Pushes
	-- =============================================================================
	s("push", fmt("@push ('{}')\n\t{}\n@endpush", { i(1, "scripts"), i(0) })),
	s("prepend", fmt("@prepend ('{}')\n\t{}\n@endprepend", { i(1, "scripts"), i(0) })),
	s("stack", fmt("@stack ('{}')", { i(1, "scripts") })),
	s("once", fmt("@once\n\t{}\n@endonce", { i(1, "content"), i(0) })),

	-- =============================================================================
	-- CSRF & Forms
	-- =============================================================================
	s("csrf", t("@csrf")),
	s("method", fmt("@method ('{}')", { i(1, "PUT") })),

	-- =============================================================================
	-- Switch
	-- =============================================================================
	s("switch", fmt("@switch (${})\n\t@case ({})\n\t\t{}\n\t@break\n\t@default\n\t\t{}\n@endswitch", {
		i(1, "variable"), i(2, "value1"), i(3, "case content"), i(0, "default content")
	})),
	s("case", fmt("@case ({})\n\t{}\n@break", { i(1, "value"), i(0) })),
	s("default", t("@default")),
	s("break", t("@break")),

	-- =============================================================================
	-- Debugging
	-- =============================================================================
	s("dump", fmt("@dump (${})", { i(1, "variable"), i(0) })),
	s("dd", fmt("@dd (${})", { i(1, "variable"), i(0) })),

	-- =============================================================================
	-- Translations
	-- =============================================================================
	s("lang", fmt("@lang ('{}')", { i(1, "messages.key") })),
	s("choice", fmt("@choice ('{}', ${})", { i(1, "messages.key"), i(2, "count") })),

	-- =============================================================================
	-- Checks & Miscellaneous
	-- =============================================================================
	s("class", fmt("@class (['{}' => {}])", { i(1, "class-name"), i(2, "true") })),
}
