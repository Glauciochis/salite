function _context.check(a, o)
	return table.contains(a.inv or {}, o.id)
end