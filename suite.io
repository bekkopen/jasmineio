Suite := Object clone
Suite run := method(
	specs foreach(spec, 
		spec run
		yield
	)
)