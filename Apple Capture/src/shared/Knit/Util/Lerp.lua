return function(start, goal, alpha)
	return start + (goal - start) * alpha;
end;