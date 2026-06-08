---@diagnostic disable: undefined-global

return {
	-- math modes
	s({ trig = "mk", snippetType = "autosnippet" }, fmta("$<>$<>", { i(1), i(2) })),
	s({ trig = "dm", snippetType = "autosnippet" }, fmta("$ <> $<>", { i(1), i(2) })),
	s({ trig = "i" }, fmt("==>", {})),
	s(
		{ trig = "([^%s]*)", regTrig = true },
		fmta([[$<>$<>]], {
			f(function(_, s)
				return s.captures[1]
			end),
			i(1),
		})
	),
	s({ trig = "cent" }, fmta("#align(center)[<>]", { i(1) })),
	s({ trig = "v" }, fmta("#let <> = <>", { i(1), i(2) })),
	s(
		{ trig = "f" },
		fmta(
			[[
#let <> = (<>) = {
	<>
}]],
			{ i(1), i(2), i(3) }
		)
	),
}
