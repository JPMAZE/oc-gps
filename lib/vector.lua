local vector = { }
vector.add = function( self, o )
	return vector.new(
		self.x + o.x,
		self.y + o.y,
		self.z + o.z
	)
end
vector.sub = function( self, o )
	return vector.new(
		self.x - o.x,
		self.y - o.y,
		self.z - o.z
	)
end
vector.mul = function( self, m )
	return vector.new(
		self.x * m,
		self.y * m,
		self.z * m
	)
end
vector.div = function( self, m )
	return vector.new(
		self.x / m,
		self.y / m,
		self.z / m
	)
end
vector.unm = function( self )
	return vector.new(
		-self.x,
		-self.y,
		-self.z
	)
end
vector.dot = function( self, o )
	return self.x*o.x + self.y*o.y + self.z*o.z
end
vector.cross = function( self, o )
	return vector.new(
		self.y*o.z - self.z*o.y,
		self.z*o.x - self.x*o.z,
		self.x*o.y - self.y*o.x
	)
end
vector.length = function( self )
	return math.sqrt( self.x*self.x + self.y*self.y + self.z*self.z )
end
vector.normalize = function( self )
	return self:mul( 1 / self:length() )
end
vector.round = function( self, nTolerance )
	nTolerance = nTolerance or 1.0
	return vector.new(
		math.floor( (self.x + (nTolerance * 0.5)) / nTolerance ) * nTolerance,
		math.floor( (self.y + (nTolerance * 0.5)) / nTolerance ) * nTolerance,
		math.floor( (self.z + (nTolerance * 0.5)) / nTolerance ) * nTolerance
	)
end
vector.tostring = function( self )
	return self.x..","..self.y..","..self.z
end

local vmetatable = {
	__index = vector,
	__add = vector.add,
	__sub = vector.sub,
	__mul = vector.mul,
	__div = vector.div,
	__unm = vector.unm,
	__tostring = vector.tostring,
}

function vector.new( x, y, z )
	local v = {
		x = tonumber(x) or 0,
		y = tonumber(y) or 0,
		z = tonumber(z) or 0
	}
	setmetatable( v, vmetatable )
	return v
end

return vector