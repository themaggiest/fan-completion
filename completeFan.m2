completeFan = T -> (
	--returns a completed fan from a tropical variety

	--construct fan from tropical variety and get its rays
	F = fan(T);
	M = rays(F);

	--empty list of positive and negative cones
	--each codim-1 cone is in two codim-0 cones
	pcL = new MutableList;
	ncL = new MutableList;
	
	--lists of codim-1 and codim-2 faces of final fan
	L1 = faces(0, F);
	L2 = faces(1,F);
	m = length(L1)-1;
	
	for i from 0 to m do (
		--get rays of a cone from its indices, as well as the indices as a set
		A = M_(L1#i);
		s = set(L1#i);
	
		--find the ray perpendicular to the codim-1 cone and initiate the 
		--positive and negative cone fans
		u = generators(kernel(transpose(A)));
		pF = fan {coneFromVData(M_(L1#i))};
		nF = fan {coneFromVData(M_(L1#i))};
		
		for j from 0 to m do (
			if j!=i then (
				--get rays of a cone from its indices, as well as the indices as a set
				B = M_(L1#j);
				t = set(L1#j);	

				--two codim-1 cones should have a codim-2 intersection
				if isMember(sort(toList(intersect(s, t))), L2) == false then continue; 

				--check whether second cone is 'up' or 'down'
				sgn = sum flatten entries (transpose(u)*B);
				if sgn == 0 then continue;
				if sgn > 0 then (
					pF = addCone(coneFromVData(M_(L1#j)), pF);
				);
				if sgn < 0 then (
					nF = addCone(coneFromVData(M_(L1#j)), nF);
				);
			);
		);

		--lists of positive and negative cones
		pcL#i = coneFromVData matrix rays(pF);
		ncL#i = coneFromVData matrix rays(nF);
	); 
	
	-- pcL and ncL are MutableLists containing cones
	
	-- combine the two MutableLists into an ordinary List
	cL = {};
	
	for i from 0 to m do (
	cL = append(cL, pcL#i);
	cL = append(cL, ncL#i);
	);

	-- remove duplicate cones
	ucL = {};
	
	for c in cL do (
		if not any(ucL, d -> rays(c) == rays(d)) then (
			ucL = append(ucL, c);
		);
	);

	
	-- create the fan
	cF = fan ucL;
	return cF;
);
